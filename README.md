# Antigravity Toolkit & Top Trending Skills Setup

Bộ **Master Prompt** và **Script cài đặt tự động** giúp thiết lập nhanh toàn bộ môi trường làm việc chuẩn trên máy tính Windows mới cho **Antigravity IDE**:

- **Công cụ nền tảng**: `Git`, `GitHub CLI (gh)` (lưu đăng nhập vĩnh viễn vào Windows Keyring + liên kết `git credential`), `Node.js LTS`, `firecrawl-cli` & `firecrawl-py`.
- **Bộ kỹ năng độc lập (`~/.gemini/config/skills/`)**:
  - [`cathrynlavery/diagram-design`](https://github.com/cathrynlavery/diagram-design) — Vẽ 52 loại sơ đồ kiến trúc HTML + SVG chuẩn thiết kế.
  - [`blader/humanizer`](https://github.com/blader/humanizer) — Biên tập văn bản tự nhiên, loại bỏ 26 dấu hiệu văn phong máy móc của AI.
- **Bộ Plugin kỹ năng (`~/.gemini/config/plugins/`)**:
  - [`anthropics/skills`](https://github.com/anthropics/skills) (`anthropic-skills`) — Trọn bộ kỹ năng chính thức từ Anthropic (`frontend-design`, `pdf`, `pptx`, `xlsx`, `webapp-testing`, `mcp-builder`, `skill-creator`, `canvas-design`, `claude-api`...).
  - [`firecrawl/firecrawl`](https://github.com/firecrawl/firecrawl) (`firecrawl-skills`) — Bộ 5 kỹ năng cào web, tìm kiếm và trích xuất dữ liệu chuẩn LLM cho AI Agent.
  - [`obra/superpowers`](https://github.com/obra/superpowers) — Quy trình kỹ thuật phần mềm TDD & điều phối Subagent trên Antigravity Marketplace.
- **Ứng dụng AI Desktop**:
  - [`Ebony-Vinyl/dsh-our-free-model`](https://github.com/Ebony-Vinyl/dsh-our-free-model) — Tự động tải bản phát hành Windows mới nhất, kiểm tra đối chiếu mã băm bảo mật `SHA256` trước khi cài đặt.

---

## Cách 1: Dùng trong Antigravity trên máy mới (Nhanh nhất - 1 câu lệnh)

Mở **Antigravity** trên máy mới và nhắn đúng 1 câu sau vào khung chat:

```text
Hãy đọc file hướng dẫn tại https://raw.githubusercontent.com/Catlikechili/antigravity-toolkit-setup/main/PROMPT_SETUP.md và thực hiện cài đặt đầy đủ từng bước cho máy này.
```

*(Hoặc mở file [`PROMPT_SETUP.md`](./PROMPT_SETUP.md), copy nội dung khung Prompt và dán trực tiếp vào chat).*

---

## Cách 2: Chạy trực tiếp Script PowerShell tự động (`install.ps1`)

Nếu không mở chat AI, bạn có thể mở **PowerShell** trên máy mới và chạy:

```powershell
git clone https://github.com/Catlikechili/antigravity-toolkit-setup.git
powershell -ExecutionPolicy Bypass -File .\antigravity-toolkit-setup\install.ps1
```

Sau khi script chạy xong, nếu máy chưa đăng nhập GitHub, chỉ cần chạy thêm:

```cmd
"C:\Program Files\GitHub CLI\gh.exe" auth login --web --git-protocol https
"C:\Program Files\GitHub CLI\gh.exe" auth setup-git
```
