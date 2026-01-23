# 1) Mục tiêu bài 2

- Đọc file `chu_vang_sanh.md` (ở thư mục project)
- In từng dòng ra Terminal (giữ nguyên dòng trống và dòng bắt đầu bằng `#`)
- Chạy được từ thư mục `c_cpp/`

Trong R tương đương:

```
readLines("chu_vang_sanh.md")
```

------

# 2) Console R (RStudio Console) – bạn làm gì?

Console R dùng để: **tạo/sửa/xem file**, kiểm tra đường dẫn, mở editor.

## 2.1 Tạo file và mở sửa

```
file.edit("c_cpp/b_2_vang_sanh.cpp")
```

## 2.2 Xem nội dung file C++ ngay trong R

```
readLines("c_cpp/b_2_vang_sanh.cpp")
# hoặc xem đẹp:
cat(readLines("c_cpp/b_2_vang_sanh.cpp"), sep = "\n")
```

## 2.3 (Quan trọng) Hiểu path giống R

Trong R, nếu bạn đang ở project root `chu_vang_sanh/`:

- `readLines("chu_vang_sanh.md")` đọc được ngay

- nhưng nếu “đứng” trong `c_cpp/` thì tương đương:

  ```
  readLines("../chu_vang_sanh.md")
  ```

👉 Đó chính là lý do bạn phải dùng `../` trong C++.

------

# 3) Code C++ bài 2 – ý nghĩa từng khối

File hiện đúng của bạn:

```
#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main() {
  ifstream file("../chu_vang_sanh.md");

  if (!file.is_open()) {
    cout << "Cannot open file chu_vang_sanh.md\n";
    return 1;
  }

  string line;
  while (getline(file, line)) {
    cout << line << endl;
  }

  file.close();
  return 0;
}
```

## 3.1 `#include <fstream>` là “readLines của C++”

- `ifstream` = input file stream (đọc file)
- `getline(file, line)` = đọc từng dòng giống `readLines` nhưng theo vòng lặp

## 3.2 Vì sao phải là `"../chu_vang_sanh.md"`?

Vì bạn chạy chương trình trong thư mục:

```
chu_vang_sanh/c_cpp
```

nên đường dẫn tương đối:

- `chu_vang_sanh.md` nằm ở thư mục cha → `../chu_vang_sanh.md`

👉 Đây là “bài học path” quan trọng nhất của C/C++.

## 3.3 `if (!file.is_open())` là “file.exists()”

Tương đương R:

```
if (!file.exists("../chu_vang_sanh.md")) stop("Cannot open")
```

## 3.4 Vòng lặp `while (getline(...))`

- Mỗi lần đọc được 1 dòng → in ra
- Đọc tới EOF (end-of-file) thì dừng

------

# 4) Terminal (zsh) – compile & run

Terminal dùng để: **dịch (compile) và chạy (execute)**.

## 4.1 Vào đúng thư mục chứa code C++

```
cd ~/Documents/chu_vang_sanh/c_cpp
ls
```

Phải thấy:

```
b_2_vang_sanh.cpp
```

## 4.2 Compile (dịch)

```
clang++ b_2_vang_sanh.cpp -o b_2_vang_sanh
```

📌 Ghi nhớ:

- `-o` là chữ **o** (“output”), không phải số 0.
- Không hiện gì = compile OK.

## 4.3 Run (chạy)

```
./b_2_vang_sanh
```

## 4.4 Gộp 1 dòng (nhanh)

```
clang++ b_2_vang_sanh.cpp -o b_2_vang_sanh && ./b_2_vang_sanh
```

------

# 5) Vì sao lần đầu bạn bị “Cannot open file”, rồi sửa xong chạy được?

Lần đầu code là:

```
ifstream file("chu_vang_sanh.md");
```

Nhưng bạn chạy trong `c_cpp/` nên C++ tìm:

```
chu_vang_sanh/c_cpp/chu_vang_sanh.md  (không có)
```

=> fail.

Sau khi sửa thành:

```
ifstream file("../chu_vang_sanh.md");
```

C++ tìm:

```
chu_vang_sanh/chu_vang_sanh.md  (có)
```

=> OK.

------

# 6) Tóm tắt 1 trang để nhớ

## Console R (quản lý & xem)

```
file.edit("c_cpp/b_2_vang_sanh.cpp")
cat(readLines("c_cpp/b_2_vang_sanh.cpp"), sep="\n")
```

## Terminal (dịch & chạy)

```
cd ~/Documents/chu_vang_sanh/c_cpp
clang++ b_2_vang_sanh.cpp -o b_2_vang_sanh
./b_2_vang_sanh
```

------

# 7) Bài 2.1 (nâng nhẹ để học tiếp, bạn chọn 1)

1. **Bỏ dòng bắt đầu bằng `#`** (chỉ hiện tiếng Việt)
2. **Chỉ hiện dòng `#`** (chỉ hiện chữ Hán)
3. **Đánh số dòng** (01, 02, …)
4. **In chậm từng dòng** (tụng, giống bạn làm trong R)