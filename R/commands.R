vs <- function() {
  if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
  root <- here::here()
  source(file.path(root, "R", "chu_md.R"), encoding = "UTF-8", local = TRUE)
}
