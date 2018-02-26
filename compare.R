library(dplyr)
library(tibble)

contribUrl <- function(repo) {
  paste0(repo, '/src/contrib/')
}


compare <- function(baseline, new, pkgsToChk) {
  
# --- First compare available packages
    avail1 <- available.packages(contribUrl(baseline))
    avail2 <- available.packages(contribUrl(new))
    avail1_t <- as_tibble(avail1) %>% 
      select(-Repository)
    avail2_t <- as_tibble(avail2) %>% 
      select(-Repository)
    diff <- anti_join(avail2_t, avail1_t)
    if (nrow(diff) > 0 ) {
      print('Packages from repo2 different from repo1 based on available packages: ')
      print(diff)
    }
    
# ---  Second check graph for each package 
    for (p in pkgsToChk) {
      graph1 <- tools::package_dependencies(
        p,
        db = avail1,
        which = 'most',
        recursive = TRUE
      )
      names(graph1) <- 'pkg'
      graph2 <- tools::package_dependencies(
        p,
        db = avail2,
        which = 'most',
        recursive = TRUE
      )
      names(graph2) <- 'pkg'
      
      print(sprintf('Missing the following packages from %s in the graph for %s', new, p))
      print(graph2$pkg[!(graph2$pkg %in% graph1$pkg)])
      
    }
    
    
# --- Third check package install from new
    dir.create('./testlib')
    options(repos = c(CRAN = new))
    for (p in pkgsToChk) {
      install.packages(p, type = 'source', lib = './testlib') 
    }
    system2('rm','-rf ./testlib')
  
}