# =========================================
# commands.R (optimized)
# - vs()     : nạp hệ Chú Vãng Sanh (chu_md.R)
# - lns()    : nạp hệ Lăng Nghiêm (ln_md.R)
# - where()  : kiểm tra project/root + file đang dùng
# - reload() : nạp lại nhanh
# =========================================

.ensure_here <- function() {
  if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
  
  suppressMessages({
    here::i_am("chu_vang_sanh.Rproj")
  })
  
  invisible(TRUE)
}

.source_local <- function(rel_path) {
  .ensure_here()
  root <- here::here()
  f <- file.path(root, rel_path)
  
  if (!file.exists(f)) stop("Khong thay file: ", f)
  
  # QUAN TRỌNG: KHÔNG dùng local=TRUE,
  # để các hàm (ln, lnnc, ...) tồn tại trong Global Env/Console
  source(f, encoding = "UTF-8")
  
  invisible(f)
}

# ---- Chú Vãng Sanh ----
vs <- function() {
  .source_local(file.path("R", "chu_md.R"))
}

# ---- Lăng Nghiêm ----
lns <- function() {
  .source_local(file.path("R", "ln_md.R"))
}

# ---- kiểm tra nhanh ----
where <- function() {
  .ensure_here()
  cat("Project root:", here::here(), "\n")
  
  if (exists("md_file", inherits = TRUE)) {
    cat("md_file:", get("md_file", inherits = TRUE), "\n")
  } else {
    cat("md_file: (chua nap ln_md.R) -> chay: lns()\n")
  }
  
  invisible(TRUE)
}

# ---- nạp lại nhanh ----
reload <- function(which = c("ln", "vs", "all")) {
  which <- match.arg(which)
  if (which == "ln") return(lns())
  if (which == "vs") return(vs())
  vs(); lns()
  invisible(TRUE)
}
