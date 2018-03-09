download_4j <- function(path = "internal", flavor = c("unix", "windows")){
  if (path == "internal"){
    path <- system.file(package = "run4j")
  }
  flavor <- match.arg(flavor)
  message("This function will download and install neo4j community edition on your machine.")
  answer <- readline("Continue? (y/n)\n")
  if(answer == "y"){
    fourj_version <- "neo4j-community-3.3.3"
    if (flavor == "unix"){
      file <- glue("{fourj_version}-unix.tar.gz")
    } else {
      file <- glue("{fourj_version}-windows.zip")
    }
    url <- paste0("https://neo4j.com/artifact.php?name=", file)
    path <- normalizePath(path)
    file <- file.path(path, file)
    download.file(url, file)
    if (flavor == "unix"){
      untar(file, exdir = path)
    } else {
      unzip(file, exdir = path)
    }
    unlink(file)
    l <- list.files(path, recursive = TRUE)
    message("Neo4J downloaded and unpacked at ", file.path(path, fourj_version))
  }
}

# download_4j(path = "inst/", flavor = "unix")
