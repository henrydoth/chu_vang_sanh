# =========================================
# commands.R (optimized)
# - vs()     : nạp hệ Chú Vãng Sanh (chu_md.R)
# - lns()    : nạp hệ Lăng Nghiêm (ln_md.R)
# - niem()   : niệm Nam mô A Di Đà Phật (chuông + mõ, ban đêm)
# - helpn()  : trợ giúp nhanh cho niem()
# - where()  : kiểm tra project/root + file đang dùng
# - reload() : nạp lại nhanh
# =========================================
# 
# 
# # =========================================
# command(): CỔNG ĐIỀU KHIỂN DUY NHẤT
# =========================================
command <- function(action = NULL, ...) {
  
  if (is.null(action)) {
    cat("
🧭 COMMAND — BẢNG ĐIỀU KHIỂN

Gõ:
  command('niem')   : Niệm Nam mô A Di Đà Phật
  command('ln')     : Tụng Chú Lăng Nghiêm
  command('vs')     : Tụng Chú Vãng Sanh
  command('help')   : Trợ giúp niệm
  command('where')  : Xem project & file
  command('reload') : Nạp lại nhanh

Ví dụ:
  command('niem', 49)
  command('ln')
  command('vs')
")
    return(invisible(TRUE))
  }
  
  action <- tolower(action)
  
  switch(
    action,
    
    "niem" = niem(...),
    "niệm" = niem(...),
    
    "ln"   = lns(),
    "langnghiem" = lns(),
    
    "vs"   = vs(),
    "vangsan" = vs(),
    
    "help" = helpn(),
    "?"    = helpn(),
    
    "where" = where(),
    
    "reload" = reload("all"),
    
    stop("Lenh khong hop le. Goi: command() de xem menu.")
  )
}


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
  
  # KHÔNG dùng local=TRUE → hàm sống trong GlobalEnv
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

# ---- Niệm A Di Đà Phật ----
niem <- function(...) {
  .source_local(file.path("R", "niem_nam_mo.R"))
  if (exists("niem", mode = "function")) {
    niem(...)
  } else {
    stop("Ham niem() chua duoc nap dung.")
  }
}

# ---- Help cho niệm ----
helpn <- function() {
  .source_local(file.path("R", "niem_nam_mo.R"))
  if (exists("help_niem", mode = "function")) {
    help_niem()
  } else {
    stop("Khong thay help_niem().")
  }
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
reload <- function(which = c("ln", "vs", "niem", "all")) {
  which <- match.arg(which)
  if (which == "ln")   return(lns())
  if (which == "vs")   return(vs())
  if (which == "niem") return(niem())
  vs(); lns(); niem()
  invisible(TRUE)
}
