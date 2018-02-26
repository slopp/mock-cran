pkgs <- c(
  'zoo',
  'survival',
  'strucchange',
  'SparseM',
#  'scatterplot',
  'sandwich',
  'RcppEigen',
  'Rcpp',
  'quantreg',
  'pscl',
  'plm',
#  'psce',
  'pbkrtest',
  'nnet',
  'nloptr',
  'nlme',
  'multiwayvcov',
  'miscTools',
  'minqa',
  'mgcv',
  'maxLik',
  'MatrixModels',
  'Matrix',
#  'Mass',
  'lmtest',
  'lme4',
  'lattice',
  'geepack',
  'Formula',
  'car',
  'boot',
  'bdsmatrix',
  'AER'
)

for (p in pkgs) {
  dir.create(p)
  setwd(p)
  html <- rvest::html(paste0('https://cran.microsoft.com/snapshot/2017-10-18/src/contrib/00Archive/', p))
  #t <- html %>% rvest::html_table()
  t <- html %>% rvest::html_nodes(css = 'a') %>% rvest::html_attr(name = 'href')
  #files <- t[[1]]$Name[!is.na(stringr::str_match(t[[1]]$Name, p))]
  files <- t[!is.na(stringr::str_match(t, p))]
  paths <- paste0('https://cran.microsoft.com/snapshot/2017-10-18/src/contrib/00Archive/', p, '/', files)
  for (f in 1:length(paths)) {
    download.file(paths[f], paste0('./',files[f]))
  }
  setwd('..')
}