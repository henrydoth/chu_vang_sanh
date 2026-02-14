/**
 * learn_node_for_chanting.js
 * Học Node.js cơ bản để viết script tụng/niệm trong Terminal (Git Bash của RStudio).
 *
 * Cách chạy:
 *   node learn_node_for_chanting.js
 *
 * Phím:
 *   SPACE : sang bước tiếp theo
 *   b     : quay lại 1 bước
 *   q     : thoát
 *   Ctrl+C: thoát
 *
 * Gợi ý:
 *   - Đây là “bài học tương tác”. Mỗi lần bấm SPACE sẽ hiện 1 phần kiến thức + ví dụ chạy ngay.
 */

const fs = require("fs");

// ====== CẤU HÌNH BÀI HỌC ======
const TYPE_DELAY_MS = 10;      // tốc độ “chạy chữ” khi in demo
const KEY_DEBOUNCE_MS = 180;   // chống giữ phím gây nhảy bước
const SAMPLE_FILE = "chu_hoa.txt"; // dùng chính file kinh của bạn
// ===============================

// ANSI helpers (không đổi nền, chỉ clear & đậm)
const CLR   = "\x1b[0m";
const BOLD  = "\x1b[1m";
const HOME  = "\x1b[H";
const CLEAR = "\x1b[2J";

function sleep(ms){ return new Promise(r => setTimeout(r, ms)); }
function cols(){ return process.stdout.columns || 80; }

function centerLine(text){
  const w = cols();
  const t = String(text ?? "");
  const pad = Math.max(0, Math.floor((w - t.length) / 2));
  return " ".repeat(pad) + t;
}

function clearScreen(){
  process.stdout.write(CLEAR + HOME);
}

async function typeLine(text, delay = TYPE_DELAY_MS){
  const s = String(text ?? "");
  for (const ch of s){
    process.stdout.write(ch);
    await sleep(delay);
  }
  process.stdout.write("\n");
}

// ====== DEMO: đọc file kinh và tách dòng ======
function readTextFileSafe(path){
  try {
    return fs.readFileSync(path, "utf8");
  } catch (e) {
    return null;
  }
}

function splitLines(text){
  return text
    .split(/\r?\n/)
    .map(s => s.trimEnd())
    .filter(s => s.trim() !== "");
}

// ====== NỘI DUNG BÀI HỌC (mỗi step = 1 khối) ======
const steps = [
  {
    title: "Bài 0: Bạn đang học gì?",
    body: [
      "Mục tiêu: viết script tụng/niệm trong Terminal (RStudio Git Bash).",
      "Node.js = chạy JavaScript trong terminal.",
      "",
      "Bạn sẽ học: console.log, const/let, đọc file (fs), tách dòng, bắt phím, sleep/async.",
    ],
    run: async () => {
      await typeLine("Ví dụ nhỏ:");
      console.log("Nam mô A Di Đà Phật");
    }
  },
  {
    title: "Bài 1: console.log() và chuỗi (string)",
    body: [
      "console.log(\"...\") dùng để in ra màn hình.",
      "Chuỗi (string) là văn bản: tiếng Việt, Hán tự đều là string.",
      "",
      "Ví dụ:",
      "  console.log(\"阿彌陀佛\");",
    ],
    run: async () => {
      console.log("阿彌陀佛");
    }
  },
  {
    title: "Bài 2: const vs let",
    body: [
      "const: giá trị cố định (không đổi).",
      "let: giá trị thay đổi (đếm câu, đếm vòng...).",
      "",
      "Ví dụ:",
      "  const title = \"TỤNG\";",
      "  let i = 0; i++;",
    ],
    run: async () => {
      const title = "TỤNG";
      let i = 0;
      i++;
      console.log({ title, i });
    }
  },
  {
    title: "Bài 3: Module fs để đọc file",
    body: [
      "Node dùng require(\"fs\") để làm việc với file.",
      "Đọc file nhanh nhất cho tụng: fs.readFileSync(path, \"utf8\").",
      "",
      `Ta sẽ thử đọc file: ${SAMPLE_FILE}`,
    ],
    run: async () => {
      const text = readTextFileSafe(SAMPLE_FILE);
      if (!text) {
        console.log(`Không đọc được ${SAMPLE_FILE}. Hãy chắc file này nằm cùng thư mục.`);
        console.log("Gợi ý: cd vào project rồi chạy lại.");
        return;
      }
      console.log("Đọc file OK. 120 ký tự đầu:");
      console.log(text.slice(0, 120));
    }
  },
  {
    title: "Bài 4: Tách file thành từng câu (mảng lines)",
    body: [
      "Sau khi có text, ta tách theo dòng:",
      "  const lines = text.split(/\\r?\\n/).filter(...)",
      "",
      "Kết quả: lines là một mảng các câu kinh/chú.",
    ],
    run: async () => {
      const text = readTextFileSafe(SAMPLE_FILE);
      if (!text) { console.log("Thiếu file để demo."); return; }
      const lines = splitLines(text);
      console.log(`Số câu (dòng không rỗng): ${lines.length}`);
      console.log("3 câu đầu:");
      console.log(lines.slice(0, 3));
    }
  },
  {
    title: "Bài 5: sleep + async/await (tạo nhịp)",
    body: [
      "Node không có sleep sẵn, ta tự tạo:",
      "  function sleep(ms){ return new Promise(r => setTimeout(r, ms)); }",
      "",
      "Dùng await sleep(300) để tạo nhịp dừng.",
    ],
    run: async () => {
      await typeLine("Đếm nhịp:");
      await typeLine("1..."); await sleep(300);
      await typeLine("2..."); await sleep(300);
      await typeLine("3...");
    }
  },
  {
    title: "Bài 6: In chậm (typewriter) để tụng rõ",
    body: [
      "Typewriter = in từng ký tự với delay.",
      "Rất hợp tụng: chữ hiện ra chậm, tâm dễ bám.",
    ],
    run: async () => {
      await typeLine("阿彌利多毘迦蘭帝。", 25);
    }
  },
  {
    title: "Bài 7: Bắt phím (raw mode) – linh hồn của script tụng",
    body: [
      "Bạn đang dùng:",
      "  process.stdin.setRawMode(true);",
      "  process.stdin.on(\"data\", key => {...});",
      "",
      "Trong raw mode: bấm phím là nhận ngay, không cần Enter.",
      "",
      "Demo: bấm SPACE sẽ in 1 câu; bấm q để thoát demo.",
    ],
    run: async () => {
      const text = readTextFileSafe(SAMPLE_FILE) || "阿彌陀佛\n娑婆訶\n";
      const lines = splitLines(text);
      let j = 0;

      clearScreen();
      console.log(centerLine("DEMO BẮT PHÍM (SPACE in 1 câu, q thoát)"));
      console.log("");

      // Lắng nghe tạm thời trong demo này
      const handler = async (key) => {
        if (key === "\u0003") process.exit();     // Ctrl+C
        if (key.toLowerCase() === "q") {
          process.stdin.off("data", handler);
          clearScreen();
          console.log("Thoát demo. Quay lại bài học.");
          return;
        }
        if (key === " ") {
          if (j < lines.length) {
            await typeLine(lines[j], 15);
            j++;
          } else {
            await typeLine("(Hết câu) bấm q để thoát demo", 5);
          }
        }
      };

      process.stdin.on("data", handler);

      // Đợi người dùng tự thoát demo bằng phím q
      await typeLine("Bấm SPACE để hiện câu. Bấm q để thoát demo.", 5);
    }
  },
  {
    title: "Bài 8: Debounce – chống giữ phím chạy vèo vèo",
    body: [
      "Nếu giữ SPACE, terminal có thể gửi nhiều lần.",
      "Debounce: chỉ nhận nếu cách lần trước > N ms.",
      "",
      "Bạn đã dùng:",
      "  if (Date.now() - last < 220) return;",
    ],
    run: async () => {
      console.log("Debounce giúp tụng đúng nhịp, tránh 'lỡ tay' chạy hết bài.");
    }
  },
  {
    title: "Bài 9: Clear màn hình + căn giữa (trình bày nghi thức)",
    body: [
      "Clear màn hình:",
      "  process.stdout.write(\"\\x1b[2J\\x1b[H\");",
      "",
      "Căn giữa dùng process.stdout.columns.",
      "Bạn đang dùng centerLine() là chuẩn.",
    ],
    run: async () => {
      clearScreen();
      console.log(centerLine("TỤNG CHÚ VÃNG SANH (HÁN)"));
      console.log(centerLine("SPACE: 1 câu • q: thoát"));
      console.log("");
      console.log(centerLine("阿彌陀佛"));
    }
  },
  {
    title: "Kết thúc: Bạn đã đủ kiến thức để tự viết bài tụng",
    body: [
      "Bạn đã nắm 90% thứ cần để tự viết script tụng:",
      "- fs.readFileSync (đọc kinh)",
      "- split/filter (tách câu)",
      "- raw keypress (SPACE/q)",
      "- sleep + async/await (nhịp)",
      "- clear + center (trình bày)",
      "- debounce (chống giữ phím)",
      "",
      "Bước tiếp theo: bạn thử tự làm 1 bản tụng mới từ file khác.",
    ],
    run: async () => {
      console.log("🙏 Hoàn tất bài học. Bấm q để thoát.");
    }
  },
];

// ====== Engine hiển thị bài học ======
let idx = 0;
let lastSpaceAt = 0;

function renderStepHeader(){
  clearScreen();
  console.log(BOLD + centerLine(steps[idx].title) + CLR);
  console.log(centerLine("SPACE: tiếp  •  b: lùi  •  q/Ctrl+C: thoát"));
  console.log("");
}

async function renderStep(){
  renderStepHeader();

  for (const line of steps[idx].body){
    await typeLine(line, 2);
  }
  console.log("");

  try {
    await steps[idx].run();
  } catch (e) {
    console.log("\n(Lỗi khi chạy demo step này)");
    console.log(String(e));
  }

  console.log("\n" + centerLine(`Bước ${idx + 1}/${steps.length}`));
}

async function next(){
  if (idx < steps.length - 1) idx++;
  await renderStep();
}

async function back(){
  if (idx > 0) idx--;
  await renderStep();
}

// ====== Start interactive lesson ======
process.stdin.setRawMode(true);
process.stdin.resume();
process.stdin.setEncoding("utf8");

(async () => {
  await renderStep();

  process.stdin.on("data", async (key) => {
    if (key === "\u0003") process.exit();     // Ctrl+C
    if (key.toLowerCase() === "q") process.exit();

    if (key.toLowerCase() === "b") {
      await back();
      return;
    }

    if (key === " ") {
      const now = Date.now();
      if (now - lastSpaceAt < KEY_DEBOUNCE_MS) return;
      lastSpaceAt = now;
      await next();
    }
  });
})();
