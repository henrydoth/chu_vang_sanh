// vang_sanh_tung_dong.js
// Mục tiêu: học Node.js cơ bản
// - Đọc chu.txt
// - SPACE: in ra 1 dòng
// - q / Ctrl+C: thoát

const fs = require("fs");

// Đọc file chu.txt (UTF-8 để không lỗi tiếng Việt)
const text = fs.readFileSync("chu.txt", "utf8");

// Tách file thành từng dòng (GIỮ dòng trống)
const lines = text.split(/\r?\n/);

console.log("TUNG TUNG DONG (DOC TU chu.txt)");
console.log("SPACE: 1 dong | q: thoat | Ctrl+C: thoat\n");

let i = 0;

// Bật chế độ bắt phím
process.stdin.setRawMode(true);
process.stdin.resume();
process.stdin.setEncoding("utf8");

process.stdin.on("data", (key) => {
  if (key === "\u0003") process.exit(); // Ctrl+C
  if (key.toLowerCase() === "q") process.exit();

  if (key === " ") {                   // SPACE
    if (i < lines.length) {
      console.log(lines[i]);            // in nguyên dòng
      i++;
    } else {
      console.log("\n--- HET FILE ---");
    }
  }
});
