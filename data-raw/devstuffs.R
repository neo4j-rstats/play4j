library(usethis)
library(desc)

# Remove default DESC
unlink("DESCRIPTION")
# Create and clean desc
my_desc <- description$new("!new")

# Set your package name
my_desc$set("Package", "play4j")

#Set your name
my_desc$set("Authors@R", "person('Colin', 'Fay', email = 'colin@thinkr.fr', role = c('cre', 'aut'))")

# Remove some author fields
my_desc$del("Maintainer")

# Set the version
my_desc$set_version("0.0.0.9000")

# The title of your package
my_desc$set(Title = "Neo4j Orchestration from R")
# The description of your package
my_desc$set(Description = "Manage your Neo4J installation from R.")

# The urls
my_desc$set("URL", "https://github.com/thinkr/play4j")
my_desc$set("BugReports", "https://github.com/thinkr/play4j/issues")
# Save everyting
my_desc$write(file = "DESCRIPTION")

# If you want to use the MIT licence, code of conduct, and lifecycle badge
use_mit_license(name = "ThinkR")
use_readme_rmd()
use_code_of_conduct()
use_lifecycle_badge("Experimental")
use_news_md()


# Test that
use_testthat()
use_test("")

# Get the dependencies
use_package("attempt")
use_package("R6")
use_package("glue")
use_package("jsonlite")
use_package("httr")


# Vignette
use_vignette("play4j")
devtools::build_vignettes()

# Codecov
use_travis()
use_appveyor()
use_coverage()

# Clean your description
use_tidy_description()

# Test with rhub
rhub::check_for_cran()
