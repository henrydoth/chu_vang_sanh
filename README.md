------

```
BẮT BUỘC (mỗi phiên R)
source("R/ln_md.R", encoding = "UTF-8")

📌 1️⃣ ln() – tụng theo dòng
ln(start = 1, end = Inf, delay = 2, show_han = FALSE)

Dùng khi:

Muốn tụng tùy ý theo dòng

Kiểm tra nội dung

Ví dụ:
ln()                         # tụng toàn bộ, chỉ tiếng Việt
ln(1, 12)                    # dòng 1–12
ln(13, 24, delay = 1)
ln(1, 12, show_han = TRUE)   # hiện Việt + Hán

📌 2️⃣ lnnc() – tụng theo CHU KỲ 12 DÒNG (có Chinese)

Chu kỳ bắt đầu từ 0

lnnc(n)
lnnc(n1, n2, n3, ...)
lnnc(n1:n2)

Dùng khi:

Tụng theo đoạn kinh chuẩn

Học thuộc theo khối

Ví dụ:
lnnc(0)            # chu kỳ 0  → dòng 1–12
lnnc(1)            # chu kỳ 1  → dòng 13–24
lnnc(2)            # chu kỳ 2  → dòng 25–36

lnnc(0, 1, 2)      # chu kỳ 0 → 1 → 2
lnnc(3:6)          # chu kỳ 3,4,5,6
lnnc(0, 1, delay=1)

🎨 MÀU SẮC (tự động)

Tiếng Việt: chu kỳ 12 màu (red → pink → white → green → …)

#: xám

Chữ Hán: cyan (luôn cố định)

🔎 LỆNH KIỂM TRA HỮU ÍCH
ls()        # xem các hàm đã nạp
ln          # xem code hàm ln()
lnnc        # xem code hàm lnnc()
getwd()     # xem thư mục hiện tạixxxxxxxxxx ---
```