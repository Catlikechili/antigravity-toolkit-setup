#Requires -Version 5.1
$ErrorActionPreference = "Stop"

Write-Host "=== [1/5] Kiem tra va cai dat cong cu nen tang ===" -ForegroundColor Cyan

function Refresh-Path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path", "User")
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "-> Dang cai Git..."
    winget install --id Git.Git -e --accept-package-agreements --accept-source-agreements --silent
    Refresh-Path
}

if (-not (Get-Command gh -ErrorAction SilentlyContinue) -and -not (Test-Path "C:\Program Files\GitHub CLI\gh.exe")) {
    Write-Host "-> Dang cai GitHub CLI (gh)..."
    winget install --id GitHub.cli -e --accept-package-agreements --accept-source-agreements --silent
    Refresh-Path
}

if (-not (Get-Command node -ErrorAction SilentlyContinue) -and -not (Test-Path "C:\Program Files\nodejs\node.exe")) {
    Write-Host "-> Dang cai Node.js LTS..."
    winget install --id OpenJS.NodeJS.LTS -e --accept-package-agreements --accept-source-agreements --silent
    Refresh-Path
}

Write-Host "=== [2/5] Cai dat Firecrawl CLI va Python SDK ===" -ForegroundColor Cyan
if (Get-Command pip -ErrorAction SilentlyContinue) {
    pip install --quiet firecrawl-py
}
$npmCmd = if (Get-Command npm.cmd -ErrorAction SilentlyContinue) { "npm.cmd" } else { "C:\Program Files\nodejs\npm.cmd" }
if (Test-Path $npmCmd -ErrorAction SilentlyContinue) {
    & $npmCmd install -g firecrawl-cli --quiet
} elseif (Get-Command npm -ErrorAction SilentlyContinue) {
    npm install -g firecrawl-cli --quiet
}

Write-Host "=== [3/5] Tai ma nguon cac bo Agent Skills ===" -ForegroundColor Cyan
$base = Join-Path $HOME ".gemini\antigravity\scratch\github-repos"
New-Item -ItemType Directory -Force -Path $base | Out-Null

$repos = @(
    "cathrynlavery/diagram-design",
    "blader/humanizer",
    "anthropics/skills",
    "firecrawl/firecrawl",
    "obra/superpowers"
)

foreach ($r in $repos) {
    $folder = $r.Split("/")[1]
    $target = Join-Path $base $folder
    if (-not (Test-Path $target)) {
        Write-Host "-> Cloning $r..."
        git clone --depth 1 "https://github.com/$r.git" $target --quiet
    }
}

Write-Host "=== [4/5] Tich hop Skills & Plugins vao Antigravity ===" -ForegroundColor Cyan
$skillsDir = Join-Path $HOME ".gemini\config\skills"
$pluginsDir = Join-Path $HOME ".gemini\config\plugins"
New-Item -ItemType Directory -Force -Path $skillsDir | Out-Null
New-Item -ItemType Directory -Force -Path $pluginsDir | Out-Null

# 1. diagram-design
New-Item -ItemType Directory -Force -Path "$skillsDir\diagram-design" | Out-Null
Copy-Item -Path "$base\diagram-design\skills\diagram-design\*" -Destination "$skillsDir\diagram-design" -Recurse -Force

# 2. humanizer
New-Item -ItemType Directory -Force -Path "$skillsDir\humanizer" | Out-Null
foreach ($item in @("SKILL.md", "README.md", "LICENSE", "agents", "scripts")) {
    if (Test-Path "$base\humanizer\$item") {
        Copy-Item -Path "$base\humanizer\$item" -Destination "$skillsDir\humanizer" -Recurse -Force
    }
}

# 3. anthropic-skills plugin (bo qua skill da co san trong ~/.gemini/config/skills)
$existingSkills = @(Get-ChildItem $skillsDir -Directory -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name)
New-Item -ItemType Directory -Force -Path "$pluginsDir\anthropic-skills\skills" | Out-Null
Get-ChildItem "$base\skills\skills" -Directory | Where-Object { $_.Name -notin $existingSkills } | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination "$pluginsDir\anthropic-skills\skills\$($_.Name)" -Recurse -Force
}
@"
{
  "name": "anthropic-skills",
  "displayName": "Anthropic Official Skills",
  "version": "1.0.0",
  "description": "Bo ky nang chinh thuc tu Anthropic (anthropics/skills): frontend-design, pdf, pptx, xlsx, webapp-testing, mcp-builder, skill-creator, canvas-design, claude-api...",
  "homepage": "https://github.com/anthropics/skills",
  "repository": "https://github.com/anthropics/skills"
}
"@ | Set-Content -Path "$pluginsDir\anthropic-skills\plugin.json" -Encoding UTF8

# 4. firecrawl-skills plugin
New-Item -ItemType Directory -Force -Path "$pluginsDir\firecrawl-skills\skills" | Out-Null
Get-ChildItem "$base\firecrawl\skills" -Directory | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination "$pluginsDir\firecrawl-skills\skills\$($_.Name)" -Recurse -Force
}
@"
{
  "name": "firecrawl-skills",
  "displayName": "Firecrawl Skills",
  "version": "1.0.0",
  "description": "Bo 5 ky nang chinh thuc tu Firecrawl ho tro cao du lieu web, tim kiem va tich hop SDK/CLI cho AI Agent.",
  "homepage": "https://firecrawl.dev",
  "repository": "https://github.com/firecrawl/firecrawl"
}
"@ | Set-Content -Path "$pluginsDir\firecrawl-skills\plugin.json" -Encoding UTF8

Write-Host "=== [5/5] Tai va xac thuc SHA256 ung dung Our Free Model ===" -ForegroundColor Cyan
$dlDir = Join-Path $base "ofm-release"
New-Item -ItemType Directory -Force -Path $dlDir | Out-Null
$rel = Invoke-RestMethod -Uri "https://api.github.com/repos/Ebony-Vinyl/dsh-our-free-model/releases/latest" -Headers @{"User-Agent"="Antigravity-Setup"}
$exeAsset = $rel.assets | Where-Object { $_.name -match "x64-setup\.exe$" } | Select-Object -First 1
$sumAsset = $rel.assets | Where-Object { $_.name -eq "SHA256SUMS" } | Select-Object -First 1

if ($exeAsset -and $sumAsset) {
    $exePath = Join-Path $dlDir $exeAsset.name
    $sumPath = Join-Path $dlDir "SHA256SUMS"
    Invoke-WebRequest -Uri $exeAsset.browser_download_url -OutFile $exePath -UseBasicParsing
    Invoke-WebRequest -Uri $sumAsset.browser_download_url -OutFile $sumPath -UseBasicParsing

    $sumLine = Get-Content $sumPath | Where-Object { $_ -match [regex]::Escape($exeAsset.name) } | Select-Object -First 1
    $expected = ($sumLine -split "\s+")[0].Trim().ToLower()
    $actual = (Get-FileHash $exePath -Algorithm SHA256).Hash.ToLower()

    if ($expected -and ($expected -eq $actual)) {
        Write-Host "-> SHA256 khop 100% ($actual). Dang cai dat im lang..." -ForegroundColor Green
        Start-Process -FilePath $exePath -ArgumentList "/S" -Wait
    } else {
        Write-Warning "SHA256 KHONG KHOP! Da huy chay bo cai Our Free Model."
    }
}

Write-Host "`nHoan tat! Mo Antigravity Marketplace de bat them plugin 'Superpowers' va chay 'gh auth login' neu may chua dang nhap GitHub." -ForegroundColor Green
