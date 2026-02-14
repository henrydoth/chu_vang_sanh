// vang_sanh_don_gian.js
// Mục tiêu: hiểu code. Cực đơn giản.
// - Đọc file chu_hoa.txt
// - SPACE: hiện 1 câu (1 dòng)
// - q hoặc Ctrl+C: thoát

const fs = require("fs");

// 1) Đọc toàn bộ file (UTF-8 để hiện chữ Hán đúng)
const text = fs.readFileSync("chu_hoa.txt", "utf8");

// 2) Tách thành từng dòng + bỏ dòng trống
const lines = text
  .split(/\r?\n/)                 // cắt theo xuống dòng (Windows/Linux đều OK)
  .map(s => s.trimEnd())          // bỏ khoảng trắng cuối dòng
  .filter(s => s.trim() !== "");  // bỏ dòng rỗng

// 3) Hàm “ngủ” để chạy chữ
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// 4) In từng ký tự (typewriter)
async function typeLine(line, delayMs = 25) {
  for (const ch of line) {
    process.stdout.write(ch);
    await sleep(delayMs);
  }
  process.stdout.write("\n");
}

// 5) Chuẩn bị bắt phím
console.log("VANG SANH - DON GIAN");
console.log("SPACE: 1 cau | q: thoat | Ctrl+C: thoat\n");

let i = 0; // chỉ số câu hiện tại

process.stdin.setRawMode(true);   // bắt phím ngay (không cần Enter)
process.stdin.resume();           // bắt đầu lắng nghe
process.stdin.setEncoding("utf8");

process.stdin.on("data", async (key) => {
  if (key === "\u0003") process.exit();      // Ctrl+C
  if (key.toLowerCase() === "q") process.exit();

  if (key === " ") {                         // SPACE
    if (i < lines.length) {
      await typeLine(lines[i]);              // in câu i
      i++;                                   // tăng lên câu tiếp theo
    } else {
      console.log("\nDA HET CAU. (q de thoat)");
    }
  }
});
