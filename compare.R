suppressMessages({
  library(dplyr)
  library(tibble)
})


compare <- function(baseline, new, pkgsToChk) {
  
# --- First compare available packages
    avail1 <- available.packages(contrib.url(baseline, 'source'))
    avail2 <- available.packages(contrib.url(new, 'source'))
    avail1_t <- as_tibble(avail1) %>% 
      select(Package, Version, Imports, Suggests, Depends, LinkingTo)
    avail2_t <- as_tibble(avail2) %>% 
      select(Package, Version, Imports, Suggests, Depends, LinkingTo)
    diff <- suppressMessages({anti_join(avail2_t, avail1_t)})
    if (nrow(diff) > 0 ) {
      print('repo2 different from repo1. The following repo2 packages are different (based on available packages): ')
      print(diff)
    }
    
# ---  Second check graph for each package 
    for (p in pkgsToChk) {
      graph1 <- tools::package_dependencies(
        p, db = avail1, which = 'most', recursive = TRUE
      )
      names(graph1) <- 'pkg'
      
      graph2 <- tools::package_dependencies(
        p, db = avail2, which = 'most',recursive = TRUE
      )
      names(graph2) <- 'pkg'
      
      graph2_added <- graph2$pkg[!(graph2$pkg %in% graph1$pkg)]
      graph2_missing <- graph1$pkg[!(graph1$pkg %in% graph2$pkg)]
      
      if (length(graph2_added) > 0) {
        print(sprintf('%s dependency graph for %s has the following packages that should not be there:', new, p))
        print(graph2_added)
      }
      if (length(graph2_missing) > 0 ) {
        print(sprintf('%s dependency graph for %s is missing the following packages compared to the baseline: ', new, p))
        print(graph2_missing)
      }    
      
    }
    
    
# --- Third check package install from new
    dir.create('./testlib')
    print('Attempting to install packages!')
    options(repos = c(CRAN = new))
    for (p in pkgsToChk) {
      print(sprintf('Installing %s', p))
      suppressWarnings({install.packages(p, type = 'source', lib = './testlib', verbose = FALSE, quiet = TRUE)})
    }
    system2('rm','-rf ./testlib')
  
}