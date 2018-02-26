# mock-cran

Mock CRAN snapshots for 2 different days and R code to test 2 repo representations. 

## day0 and day1

Day0 and Day1 each contain `/src/contrib/` for a subset of R packages. The days were picked to reflect 
as many changes as possible:

- packages were updated
- a new package was added
- there are two current versions of 1 package, one served at a path
- a handful of packages were updated twice 
- a package was archived 
- packages include a reasonable set of dependencies including `Suggests`, `LinkingTo`, `Imports`, and `Depends`


## compare.R

The function is designed to test if two repos are identical. 

**Usage:**

```r
 source('compare.R')
 compare(
   baseline = '<baseline.repo.com>',
   new = '<new.repo.com>',
   pkgsToChk = c('<packages>', '<to>', '<check>')
 )
 
```

For example, to test the CRANifest:

1. Run the CRANifest sync between day0 and day1
2. Ingest the checkpoint.json file into RSPM (which should already have day0 loaded)
3. `baseline` would refer to the source of truth, the day 1 repo (see `serve.sh` for a simple http server to host the folder)
   `new` would be RSPM's representation of day
   `pkgsToChk` would be any packages that were installed or updated from day0 to day1


**Details:**

The function runs 3 tests:

1. Checks `available.packages` from each repo and returns the difference between them. 
   Specifically, the function prints any entries in the `new` repo that were not in the `baseline` repo.
2. Checks the recursive dependencies of each package in `pkgsToChk` to ensure they are the same for both repos.
   Prints any packages that are missing in the graph generated from the `new` repo.
3. Checks to see if the packages in `pkgsToChk` can be installed from the `new` repo.

