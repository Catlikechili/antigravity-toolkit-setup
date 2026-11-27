# Bản Prompt Tự Động Cài Đặt Bộ Công Cụ GitHub & AI Agent Cho Máy Mới

> Copy toàn bộ khung bên dưới và dán trực tiếp vào khung chat **Antigravity** trên máy tính Windows mới. Agent sẽ tự động kiểm tra, tải về, xác thực `SHA256` và cấu hình từ A–Z.

---

```markdown
Hãy thiết lập trọn bộ môi trường GitHub, Firecrawl, Our Free Model và 6 gói AI Agent Skills/Plugins cho máy Windows này theo đúng quy trình chuẩn sau:

### 1. Kiểm tra & Cài đặt công cụ nền tảng (qua `winget`)
- Kiểm tra lần lượt `git`, `gh` (GitHub CLI), `node` (Node.js LTS), `python`. Công cụ nào chưa có thì cài tự động bằng `winget` (`Git.Git`, `GitHub.cli`, `OpenJS.NodeJS.LTS`, `Python.Python.3.11`) với cờ `--accept-package-agreements --accept-source-agreements --silent`.
- Nạp lại biến môi trường `PATH` trong phiên làm việc sau khi cài.
- Kiểm tra trạng thái đăng nhập GitHub bằng `gh auth status`:
  - Nếu chưa đăng nhập: hướng dẫn tôi chạy lệnh đăng nhập lưu vĩnh viễn vào Windows Keyring (`"C:\Program Files\GitHub CLI\gh.exe" auth login --web --git-protocol https`), sau đó chạy `gh auth setup-git` để đồng bộ thông tin đăng nhập sang `git` và thiết lập `git config --global user.name` / `user.email` theo tài khoản vừa đăng nhập.

### 2. Cài đặt Firecrawl CLI & SDK (#2 Trending 24h)
- Cài đặt thư viện Python: `pip install --quiet firecrawl-py`
- Cài đặt công cụ dòng lệnh toàn cục: `npm install -g firecrawl-cli --quiet`

### 3. Tải mã nguồn & Tích hợp các bộ Agent Skills / Plugins vào Antigravity (`~/.gemini/config/`)
Tải (`git clone --depth 1`) các repository sau vào thư mục tạm `C:\Users\$env:USERNAME\.gemini\antigravity\scratch\github-repos`:
1. `cathrynlavery/diagram-design` → Copy nội dung `skills/diagram-design/*` vào `~/.gemini/config/skills/diagram-design/`.
2. `blader/humanizer` → Copy `SKILL.md`, `README.md`, `LICENSE`, `agents`, `scripts` vào `~/.gemini/config/skills/humanizer/`.
3. `anthropics/skills` → Tạo plugin bundle tại `~/.gemini/config/plugins/anthropic-skills/` (gồm `plugin.json` chuẩn Antigravity và thư mục `skills/` chứa toàn bộ các skill trong repo, tự động bỏ qua những skill đã tồn tại sẵn trong `~/.gemini/config/skills/` để tránh trùng tên).
4. `firecrawl/firecrawl` → Tạo plugin bundle tại `~/.gemini/config/plugins/firecrawl-skills/` (gồm `plugin.json` chuẩn Antigravity và toàn bộ 5 skill trong thư mục `skills/` của repo Firecrawl).
5. `obra/superpowers` → Tìm plugin chính thức `antigravity-plugins-partners/plugin/superpowers` bằng công cụ `search_marketplace` và hiển thị thẻ `<plugin-card>` trên một dòng riêng để tôi bấm cài 1 chạm và nhận cập nhật tự động.

### 4. Cài đặt ứng dụng `Our Free Model` bản Windows chính thức (có kiểm tra `SHA256`)
- Dùng `gh release download` (hoặc GitHub Releases API của repo `Ebony-Vinyl/dsh-our-free-model`) tải file cài đặt `Our.Free.Model_*_x64-setup.exe` mới nhất cùng file `SHA256SUMS`.
- Tính mã băm `Get-FileHash -Algorithm SHA256` của file `.exe` và đối chiếu với `SHA256SUMS`.
- **Chỉ khi khớp 100% mã SHA256**, chạy cài đặt im lặng với tham số `/S` (`Start-Process ... -ArgumentList "/S" -Wait`). Tuyệt đối hủy cài đặt nếu lệch mã băm.

### 5. Xác minh hoàn tất
- Kiểm tra lại danh sách plugin Antigravity (`GetAllPlugins`), xác nhận `diagram-design`, `humanizer`, `anthropic-skills`, `firecrawl-skills`, `firecrawl --version`, `firecrawl-py` và shortcut `Our Free Model` trong Start Menu đều hoạt động tốt, sau đó báo cáo tóm tắt kèm link quản lý `customization://<dir>`.
```
