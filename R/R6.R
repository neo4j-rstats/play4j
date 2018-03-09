#' Run Neo4J
#'
#'
#' @return An R6 object that can manage Neo4J
#'
#' @importFrom R6 R6Class
#' @importFrom glue glue
#' @importFrom attempt stop_if
#' @export
#'
#'
#' @examples
#' \dontrun{
#' db <- neo4j_shell$new(neo4jhome = "inst")
#' db$start()
#' db$see_logs(size = 10)
#' db$version()
#' db$restart()
#' db$cypher(cypher = "MATCH (n) RETURN COUNT(*);",
#'           username = "neo4j", password = "pouetpouet", format = "verbose")
#' }

neo4j_shell <- R6::R6Class("Neo4JShell",
                     public = list(
                       neo4jhome = character(),
                       neo4j = character(),
                       cypher_shell = character(),

                       ## Init
                       initialize = function(neo4jhome){
                         self$neo4jhome <- neo4jhome
                         files_in_home <- list.files(path = neo4jhome, recursive = TRUE)
                         neo4jbin <- grep("neo4j(\\.bat)*$", files_in_home, value = TRUE)
                         self$neo4j <- normalizePath(file.path(neo4jhome, neo4jbin))
                         cypher_shell <- grep("cypher-shell(\\.bat)*$", files_in_home, value = TRUE)
                         self$cypher_shell <- normalizePath(file.path(neo4jhome, cypher_shell))
                       },
                       # logs
                       see_logs = function(which = c("neo4j","debug", "http","gc","query","security","service-error"), size = Inf){
                         which <- match.arg(which)
                         files_in_home <- list.files(path = self$neo4jhome, recursive = TRUE, full.names = TRUE)
                         logfile <- grep(glue("{which}\\.log"), files_in_home, value = TRUE)
                         if (length(logfile)) {
                           if (size == Inf){
                             cat(readLines(normalizePath(logfile)), sep = '\n')
                           } else {
                             a <- readLines(normalizePath(logfile))
                             lines <- length(a)
                             cat(a[(lines-size+1):lines], sep = '\n')
                           }

                         } else {
                           message("No log file found")
                         }
                       },

                       # Peak into folder
                       see_plugins = function(){
                         plugins <- list.files(path = file.path(self$neo4jhome, "plugins"), recursive = TRUE)
                         if (length(plugins)) {
                           cat(basename(plugins), sep = '\n')
                         } else {
                           message("No plugins found")
                         }
                       },
                       see_import = function(){
                         import <- list.files(path = file.path(self$neo4jhome, "import"), recursive = TRUE)
                         if (length(import)) {
                           cat(basename(import), sep = '\n')
                         } else {
                           message("No import found")
                         }
                       },
                       see_data = function(){
                         data <- list.files(path = file.path(self$neo4jhome, "data"), recursive = TRUE)
                         if (length(data)) {
                           cat(basename(data), sep = '\n')
                         } else {
                           message("No data found")
                         }
                       },
                       see_certificates = function(){
                         certificates <- list.files(path = file.path(self$neo4jhome, "certificates"), recursive = TRUE)
                         if (length(certificates)) {
                           cat(basename(certificates), sep = '\n')
                         } else {
                           message("No certificates found")
                         }
                       },
                       see_run = function(){
                         run <- list.files(path = file.path(self$neo4jhome, "run"), recursive = TRUE)
                         if (length(run)) {
                           cat(basename(run), sep = '\n')
                         } else {
                           message("No run found")
                         }
                       },

                       # neo4j *
                       console = function(){
                         system(glue("{self$neo4j} console"), wait = FALSE)
                       },
                       start = function(){
                         system(glue("{self$neo4j} start"))
                       },
                       stop = function(){
                         system(glue("{self$neo4j} stop"))
                       },
                       restart = function(){
                         system(glue("{self$neo4j} restart"))
                       },
                       status = function(){
                         system(glue("{self$neo4j} status"))
                       },
                       version = function(){
                         system(glue("{self$neo4j} version"))
                       },

                       #cypher shell
                       cypher = function(cypher, adress = "bolt://localhost:7687", username = NA, password= NA,
                                         help = FALSE, fail_fast = FALSE, fail_at_end = FALSE,
                                         encryption = TRUE, format = c("auto","verbose","plain"),
                                         debug = FALSE, non_interactive = TRUE, version = FALSE){
                         format <- match.arg(format)
                         call <- ""
                         stop_if(fail_fast & fail_at_end, msg = "you can't chose both fail_fast and fail_at_end")
                         if (help) {
                           system(glue("{self$cypher_shell} --help"))
                         } else if (version) {
                           system(glue("{self$cypher_shell} --version"))
                         }
                         call <- glue("{call} {shQuote(cypher)}")
                         call <- glue("{call} -a {adress}")
                         if (!is.na(username)) call <- glue("{call} -u {username}")
                         if (!is.na(password)) call <- glue("{call} -p {password}")
                         if(!encryption) call <- glue("{call} --encryption false")
                         call <- glue("{call} --format {format}")
                         if(debug) call <- glue("{call} --debug")
                         if(!non_interactive) call <- glue("{call} --non-interactive")
                         system(glue("{self$cypher_shell} {call}"))
                       }
                     ))

#' Admin Neo4J
#'
#'
#' @return An R6 object that can manage Neo4J Admin
#'
#' @importFrom R6 R6Class
#' @importFrom glue glue
#' @export
#'
#'
#' @examples
#' \dontrun{
#' admin <- neo4j_admin$new(neo4jhome = "inst")
#' admin$()
#' db$see_logs(size = 10)
#' db$version()
#' db$restart()
#' db$cypher(cypher = "MATCH (n) RETURN COUNT(*);",
#'           username = "neo4j", password = "pouetpouet", format = "verbose")
#' }

neo4j_admin <- R6::R6Class("Neo4JAdmin",
                           public = list(
                             # Neo4J-admin
                             neo4jhome = character(),
                             neo4j_admin = character(),

                             ## Init
                             initialize = function(neo4jhome){
                               self$neo4jhome <- neo4jhome
                               files_in_home <- list.files(path = neo4jhome, recursive = TRUE)
                               neo4j_admin <- grep("neo4j-admin(\\.bat)*$", files_in_home, value = TRUE)
                               self$neo4j_admin <- normalizePath(file.path(neo4jhome, neo4j_admin))
                             },
                             check_consistency = function(args = "", help = FALSE){
                               if (help){
                                 system(glue("{self$neo4j_admin} help check-consistency"))
                               } else {
                                 system(glue("{self$neo4j_admin} check-consistency {args}"))
                               }
                             },
                             help = function(){
                               system(glue("{self$neo4j_admin} help"))
                             },
                             import = function(args = "", help = FALSE){
                               if (help){
                                 system(glue("{self$neo4j_admin} help import"))
                               } else {
                                 system(glue("{self$neo4j_admin} import {args}"))
                               }
                             },
                             memrec = function(args = "", help = FALSE){
                               if (help){
                                 system(glue("{self$neo4j_admin} help memrec"))
                               } else {
                                 system(glue("{self$neo4j_admin} memrec {args}"))
                               }
                             },
                             store_info = function(args = "", help = FALSE){
                               if (help){
                                 system(glue("{self$neo4j_admin} help store-info"))
                               } else {
                                 system(glue("{self$neo4j_admin} store-info {args}"))
                               }
                             },
                             set_default_admin = function(args = "", help = FALSE){
                               if (help){
                                 system(glue("{self$neo4j_admin} help set-default-admin"))
                               } else {
                                 system(glue("{self$neo4j_admin} set-default-admin {args}"))
                               }
                             },
                             set_initial_password = function(args = "", help = FALSE){
                               if (help){
                                 system(glue("{self$neo4j_admin} help set-initial-password"))
                               } else {
                                 system(glue("{self$neo4j_admin} set-initial-password {args}"))
                               }
                             },
                             dump = function(args = "", help = FALSE){
                               if (help){
                                 system(glue("{self$neo4j_admin} help dump"))
                               } else {
                                 system(glue("{self$neo4j_admin} dump {args}"))
                               }
                             },
                             load = function(args = "", help = FALSE){
                               if (help){
                                 system(glue("{self$neo4j_admin} help load"))
                               } else {
                                 system(glue("{self$neo4j_admin} load {args}"))
                               }
                             }

                           )
)

#' Neo4J API
#'
#'
#' @return An R6 object that can call the API
#'
#' @importFrom jsonlite base64_enc toJSON
#' @importFrom httr POST content add_headers
#' @importFrom glue glue
#'
#' @export
#'

neo4j_api <- R6::R6Class("Neo4JAPI",
                         public = list(
                           url = character(0),
                           user = character(0),
                           password = character(0),
                           initialize = function(url, user, password){
                             self$url <- paste0(url, "/db/data/transaction/commit")
                             self$user <- user
                             self$password <- password
                           },
                           query = function(query, format = c("json", "R")){
                             format <- match.arg(format)
                             auth <- base64_enc(paste0(self$user,':',self$password))
                             res <- POST(url = self$url,
                                         add_headers(.headers = c("Content-Type"="application/json",
                                                                  "accept"="application/json",
                                                                  "Authorization"= paste0("Basic ", auth))),
                                         body = glue('{"statements" : [ { "statement" : "%query%"} ]}', .open = "%", .close = "%"))
                             if (format == "json"){
                               toJSON(lapply(content(res)$results, function(x) x$data), pretty = TRUE)
                             } else {
                               lapply(content(res)$results, function(x) x$data)
                             }
                           }
                         )
)
