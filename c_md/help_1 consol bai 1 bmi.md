- 1. **ôn lại TOÀN BỘ lệnh** bạn đã dùng – **chia rõ Console R vs Terminal** – theo kiểu **cheat-sheet để nhớ nhanh**, đúng với workflow bạn đang dùng.

     ------
  
     # 🧠 1. Console R (RStudio Console)

     👉 Dùng để **quản lý file, xem code, mở sửa, test R**

     ## 📁 Thư mục & file
  
     ```
     getwd()                     # xem thư mục hiện tại
     list.files()                # liệt kê file
     list.dirs(".", FALSE)       # liệt kê thư mục con
     
     dir.create("c_cpp")         # tạo thư mục
     file.rename("a", "b")       # đổi tên / di chuyển file
     file.exists("bmi.cpp")      # kiểm tra file tồn tại
     ```

     ------
  
     ## 📄 Đọc / mở file

     ```
     readLines("c_cpp/bmi.cpp")          # đọc file (thô)
     cat(readLines("c_cpp/bmi.cpp"),     # xem đẹp
         sep = "\n")
     
     file.edit("c_cpp/bmi.cpp")          # mở sửa trong Source
     ```

     ------

     ## 🧭 Điều hướng (trong R)

     ```
     setwd("c_cpp")              # đổi thư mục làm việc
     getwd()
     ```
  
     (👉 thường **không cần** nếu dùng project RStudio)
  
     ------
  
     ## 🧪 Tiện ích
  
     ```
     history(50)                 # xem lịch sử lệnh
     savehistory(".Rhistory")    # lưu history
     ```

     ------
  
     # 💻 2. Terminal (zsh) – chạy C++
  
     👉 Dùng để **compile & chạy chương trình C++**
  
     ## 📁 Điều hướng
  
     ```
     pwd                          # xem thư mục hiện tại
     ls                           # liệt kê file
     cd c_cpp                     # vào thư mục con
     cd ..                        # quay lại
     cd ~/Documents/chu_vang_sanh # vào project
     ```
  
     ------
  
     ## 🛠 Compile C++
  
     ```
     clang++ bmi.cpp -o bmi       # dịch bmi.cpp → file chạy bmi
     ```
  
     📌 Ghi nhớ:
  
     - `-o` = chữ **o**
     - `-0` = sai (số 0)
  
     ------
  
     ## ▶️ Chạy chương trình
  
     ```
     ./bmi
     ```
  
     Thoát:
  
     - nhập `0` trong menu
     - hoặc `Ctrl + C` (ngắt cưỡng bức)

     ------

     ## ⚡ Gộp 1 dòng (rất hay dùng)

     ```
     clang++ bmi.cpp -o bmi && ./bmi
     ```
  
     ------

     # 🔄 3. Workflow chuẩn (1 vòng làm việc)

     ### Trong RStudio
  
     1️⃣ Sửa code
  
     ```
     file.edit("c_cpp/bmi.cpp")
     ```
  
     2️⃣ Compile & chạy
  
     ```
     cd c_cpp
     clang++ bmi.cpp -o bmi && ./bmi
     ```
  
     3️⃣ Test → quay lại sửa → lặp lại
  
     ------
  
     # 🚨 Những lỗi bạn đã gặp (và cách nhớ)
  
     | Lỗi                | Nguyên nhân            | Cách tránh              |
     | ------------------ | ---------------------- | ----------------------- |
     | `-0`               | nhầm 0 với o           | nhớ: **o = output**     |
     | nhập chữ cho `int` | `cin` fail             | chỉ nhập số             |
     | tên có dấu bị lỗi  | `cin >>`               | dùng `getline()`        |
     | `^C`               | chương trình chờ input | nhập đúng hoặc sửa code |

     ------

     # 🧩 4. Cách nhớ nhanh (1 câu)
  
     > **Console R = quản lý & xem**
     >  **Terminal = dịch & chạy**

     ------