const fs = require("fs");

// ====== CONFIG ======
const TYPE_DELAY_MS = 25;      // tốc độ chạy chữ (nhỏ = nhanh hơn)
const PADDING_TOP = 6;         // khoảng trống phía trên (tăng để câu lên cao/thấp)
const KEY_DEBOUNCE_MS = 220;   // chống auto-repeat khi giữ phím
// ====================

const lines = fs.readFileSync("chu_hoa.txt", "utf8")
  .split(/\r?\n/)
  .map(s => s.trimEnd())
  .filter(s => s.trim() !== "");

function sleep(ms){ return new Promise(r => setTimeout(r, ms)); }
function cols(){ return process.stdout.columns || 80; }

// ANSI helpers (KHÔNG ép nền)
const CLR  = "\x1b[0m";
const BOLD = "\x1b[1m";
const HOME = "\x1b[H";
const CLEAR = "\x1b[2J";

function centerLine(text, width){
  const t = text ?? "";
  const pad = Math.max(0, Math.floor((width - t.length) / 2));
  return " ".repeat(pad) + t;
}

async function typewriterCentered(text, delay=TYPE_DELAY_MS){
  const w = cols();
  const line = centerLine(text, w);
  for (const ch of line){
    process.stdout.write(ch);
    await sleep(delay);
  }
  process.stdout.write("\n");
}

// KHÔNG tô nền, chỉ clear + in tiêu đề
function drawFrame(title, hint){
  const w = cols();
  process.stdout.write(CLEAR + HOME);

  const t = centerLine(title, w);
  const h = centerLine(hint, w);

  process.stdout.write(BOLD + t + CLR + "\n");
  process.stdout.write(h + "\n");

  for (let i = 0; i < PADDING_TOP; i++) process.stdout.write("\n");
}

// ---- Start ----
console.clear();
console.log("TỤNG CHÚ VÃNG SANH (HÁN)");
console.log("SPACE: 1 câu | q hoặc Ctrl+C: thoát");
console.log("\n(Đang chuyển sang chế độ trình bày...)\n");

let i = 0;
let lastSpaceAt = 0;

process.stdin.setRawMode(true);
process.stdin.resume();
process.stdin.setEncoding("utf8");

drawFrame("TỤNG CHÚ VÃNG SANH (HÁN)", "SPACE: 1 câu  •  q / Ctrl+C: thoát");

process.stdin.on("data", async (key) => {
  if (key === "\u0003") process.exit();      // Ctrl+C
  if (key.toLowerCase() === "q") process.exit();

  if (key === " ") {
    const now = Date.now();
    if (now - lastSpaceAt < KEY_DEBOUNCE_MS) return;
    lastSpaceAt = now;

    if (i < lines.length) {
      drawFrame("TỤNG CHÚ VÃNG SANH (HÁN)", "SPACE: 1 câu  •  q / Ctrl+C: thoát");
      await typewriterCentered(lines[i]);
      i++;

      if (i === lines.length) {
        await sleep(300);
        drawFrame("ĐÃ TỤNG XONG", "Nhấn q để thoát");
      }
    }
  }
});
