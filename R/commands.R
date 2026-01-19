vs <- function() {
  if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
  root <- here::here()
  source(file.path(root, "R", "chu_md.R"), encoding = "UTF-8", local = TRUE)
}

# chạy chú lăng nghiêm 

lns <- function() {
  if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
  root <- here::here()
  source(file.path(root, "R", "ln_md.R"), encoding = "UTF-8", local = TRUE)
}

# =========================================
# lnn(): tụng theo CHU KỲ 12 DÒNG
# lnn(n)      -> chu kỳ n
# lnn(n1, n2) -> từ chu kỳ n1 đến n2
# =========================================

lnn <- function(n1, n2 = NULL, delay = 2, show_han = FALSE) {
  
  # ---- kiểm tra tham số ----
  if (!is.numeric(n1) || n1 < 0 || n1 != as.integer(n1)) {
    stop("n1 phai la so nguyen >= 0")
  }
  
  if (!is.null(n2)) {
    if (!is.numeric(n2) || n2 < n1 || n2 != as.integer(n2)) {
      stop("n2 phai la so nguyen >= n1")
    }
  } else {
    n2 <- n1
  }
  
  # ---- tính start / end ----
  start <- n1 * 12 + 1
  end   <- n2 * 12 + 12
  
  ln(
    start = start,
    end   = end,
    delay = delay,
    show_han = show_han
  )
}

