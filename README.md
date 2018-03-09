
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

> Disclaimer: this package is still at an experimental level, and should
> only be used for testing, bug reports, and enhancement requests. As
> long as this package is in “Experimental” mode, some changes to the
> API are to be expected. Read the [NEWS.md](NEWS.md) to be informed of
> the last changes.

This package has only been tested on these platforms for now, so it
might not work on others :

  - neo4j 3.3.3
    
      - Mac OSX

# play4j

The goal of play4j is to facilitate Neo4J orchestration from R.

## Installation

You can install {play4j} from GitHub with:

``` r
# install.packages("remotes")
remotes::install_github("ThinkR-open/play4j")
```

## Example

### Casual Neo4J Orchestration

  - Create an instance with `neo4j_shell$new` and the path to your
    `NEO4JHOME`:

<!-- end list -->

``` r
cypher_con <- play4j::neo4j_shell$new("/Users/colin/neo4j/")
```

  - Start Neo4J :

<!-- end list -->

``` r
# In the background
cypher_con$start()
# In the front
cypher_con$console()
```

  - Make cypher call

You can make cypher call with the cypher method :

``` r
cypher_con$cypher(cypher = "MATCH (n) RETURN n LIMIT 5;",
          username = "neo4j", password = "pouetpouet", format = "plain")
```

  - Restart Neo4J :

<!-- end list -->

``` r
cypher_con$restart()
```

  - See logs and certificates list :

<!-- end list -->

``` r
# See the last 5 lines
cypher_con$see_logs(size = 5)
#> 2018-03-09 15:20:27.208+0000 INFO  Bolt enabled on 127.0.0.1:7687.
#> 2018-03-09 15:22:39.929+0000 INFO  ======== Neo4j 3.3.3 ========
#> 2018-03-09 15:22:40.035+0000 INFO  Starting...
#> 2018-03-09 15:22:41.207+0000 INFO  Neo4j Server shutdown initiated by request
#> 2018-03-09 15:22:41.951+0000 INFO  Bolt enabled on 127.0.0.1:7687.
cypher_con$see_certificates()
#> neo4j.cert
#> neo4j.key
```

You can also see plugins, imports, data and run.

  - See status

<!-- end list -->

``` r
cypher_con$status()
```

  - Get Neo4J version

<!-- end list -->

``` r
cypher_con$version()
```

  - Stop Neo4J

<!-- end list -->

``` r
cypher_con$stop()
```

### Neo4J API Calls

If you simply want to make API calls, start a new `neo4j_api`
object:

``` r
api_con <- play4j::neo4j_api$new(url = "http://localhost:7474", user = "neo4j", password = "pouetpouet")
```

Then query (result as JSON or as an R list):

``` r
# As JSON (default)
api_con$query("MATCH (p:Person) RETURN p.name LIMIT 1")
#> [
#>   [
#>     {
#>       "row": [
#>         ["Keanu Reeves"]
#>       ],
#>       "meta": [
#>         {}
#>       ]
#>     }
#>   ]
#> ]
# As R list 
api_con$query("MATCH (p:Person) RETURN p.name LIMIT 1", format = "R")
#> [[1]]
#> [[1]][[1]]
#> [[1]][[1]]$row
#> [[1]][[1]]$row[[1]]
#> [1] "Keanu Reeves"
#> 
#> 
#> [[1]][[1]]$meta
#> [[1]][[1]]$meta[[1]]
#> NULL
```

### Neo4J Admin Orchestration

You can call [Neo4J admin
commands](https://neo4j.com/docs/operations-manual/current/tools/neo4j-admin/)
by creating a new neo4j\_admin object:

``` r
admin <- play4j::neo4j_admin$new("/Users/colin/neo4j/")
```

You can call admin commands with args that looks like shell commands
(i.e. you should type `args = "--verbose true"`, for example).

``` r
admin$memrec()
```

Every admin method comes with a `help` arg, that can be turned on to get
the list of args to pass to the commands.

``` r
admin$check_consistency(help = TRUE)
```

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.
