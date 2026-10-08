# ============================================================
# Flutter DAY1 Setup Script
# ============================================================

$ErrorActionPreference = "Continue"

# ---- Config ----
$Day1Dir = "D:\FlutterPractice\DAY1"
$ProjectDir = Join-Path $Day1Dir "hello_world"
$DocsDir = Join-Path $Day1Dir "docs"
$ReadmeTemplate = Join-Path $Day1Dir "README-template.md"
$userProfile = [Environment]::GetFolderPath("UserProfile")
$WorkDir = Join-Path $userProfile "AppData\Roaming\TRAE SOLO CN\ModularData\ai-agent\work-mode-projects\6aabb269f1e1524f76b8cd56"

# Env vars
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$env:PATH = $env:JAVA_HOME + "\bin;" + $env:PATH
$env:CHROME_EXECUTABLE = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$androidSdk = Join-Path $userProfile "AppData\Local\Android\Sdk"
$env:ANDROID_HOME = $androidSdk
$env:ANDROID_SDK_ROOT = $androidSdk
$sdkmanager = Join-Path $env:ANDROID_HOME "cmdline-tools\latest\bin\sdkmanager.bat"
$avdmanager = Join-Path $env:ANDROID_HOME "cmdline-tools\latest\bin\avdmanager.bat"
$emulator = Join-Path $env:ANDROID_HOME "emulator\emulator.exe"
$adb = Join-Path $env:ANDROID_HOME "platform-tools\adb.exe"

$SystemImage = "system-images;android-35;google_apis;x86_64"
$AvdName = "Pixel_7_API_35"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Flutter DAY1 - One-Click Setup" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# ---- Step 0: Git config ----
Write-Host "[0/7] Checking Git config..." -ForegroundColor Yellow
$gitName = git config --global user.name
$gitEmail = git config --global user.email
if ([string]::IsNullOrWhiteSpace($gitName)) {
    Write-Host "  Setting git user.name..."
    git config --global user.name "Su6731"
    $gitName = "Su6731"
}
if ([string]::IsNullOrWhiteSpace($gitEmail)) {
    Write-Host "  Setting git user.email..."
    git config --global user.email "Su6731@users.noreply.github.com"
    $gitEmail = "Su6731@users.noreply.github.com"
}
Write-Host ("  Git user: " + $gitName) -ForegroundColor Green

# ---- Step 1: Create Flutter project ----
Write-Host ""
Write-Host "[1/7] Creating Flutter project hello_world..." -ForegroundColor Yellow
if (!(Test-Path $ProjectDir)) {
    $srcProject = Join-Path $WorkDir "hello_world"
    if (Test-Path $srcProject) {
        Write-Host "  Copying from workspace..."
        Copy-Item -Recurse -Path $srcProject -Destination $ProjectDir -Force
        Write-Host "  Copy done" -ForegroundColor Green
    } else {
        Write-Host "  Running flutter create..."
        Set-Location $Day1Dir
        flutter create hello_world --project-name hello_world --platforms=web,android,windows
        Write-Host "  Create done" -ForegroundColor Green
    }
} else {
    Write-Host "  Project already exists, skipped" -ForegroundColor Green
}

# ---- Step 2: First Git commit ----
Write-Host ""
Write-Host "[2/7] First Git commit..." -ForegroundColor Yellow
Set-Location $Day1Dir

if (!(Test-Path (Join-Path $Day1Dir ".git"))) {
    Write-Host "  Initializing git repo..."
    git init
    git branch -M main
}

git add -A
$status = git status --short
if ($status) {
    git commit -m "feat: flutter create hello_world"
    Write-Host "  Committed: feat: flutter create hello_world" -ForegroundColor Green
} else {
    Write-Host "  No changes, skipped" -ForegroundColor Gray
}

# ---- Step 3: Install system image and create AVD ----
Write-Host ""
Write-Host "[3/7] Checking Android emulator..." -ForegroundColor Yellow

$installed = & $sdkmanager --list_installed 2>&1 | Select-String $SystemImage
if (!$installed) {
    Write-Host "  Downloading Android 35 Google APIs x86_64 system image..."
    Write-Host "  This may take a few minutes, please wait..." -ForegroundColor Cyan
    "y" | & $sdkmanager $SystemImage 2>&1 | Out-Null
    Write-Host "  System image installed" -ForegroundColor Green
} else {
    Write-Host "  System image already installed" -ForegroundColor Green
}

$avdExists = & $avdmanager list avd 2>&1 | Select-String ("Name: " + $AvdName)
if (!$avdExists) {
    Write-Host "  Creating AVD: $AvdName ..."
    "no" | & $avdmanager create avd -n $AvdName -k $SystemImage -d "pixel_7" 2>&1 | Out-Null
    Write-Host "  AVD created" -ForegroundColor Green
} else {
    Write-Host "  AVD already exists: $AvdName" -ForegroundColor Green
}

# ---- Step 4: Start emulator ----
Write-Host ""
Write-Host "[4/7] Starting Android emulator..." -ForegroundColor Yellow

$runningEmulator = & $adb devices 2>&1 | Select-String "emulator-"
if ($runningEmulator) {
    Write-Host "  Emulator already running" -ForegroundColor Green
} else {
    Write-Host "  Launching emulator $AvdName ..."
    Start-Process -FilePath $emulator -ArgumentList "-avd $AvdName -no-snapshot-load" -WindowStyle Minimized
    Write-Host "  Waiting for emulator to boot..." -ForegroundColor Cyan

    $waitCount = 0
    do {
        Start-Sleep -Seconds 5
        $waitCount += 5
        $booted = & $adb shell getprop sys.boot_completed 2>&1
        Write-Host ("  Waited " + $waitCount + "s...")
        if ($booted -match "1") {
            Write-Host "  Emulator booted!" -ForegroundColor Green
            break
        }
    } while ($waitCount -lt 120)

    if ($waitCount -ge 120) {
        Write-Host "  WARNING: Emulator boot timeout, continuing..." -ForegroundColor Red
    }
}

# ---- Step 5: Web run and screenshot ----
Write-Host ""
Write-Host "[5/7] Running on Web and taking screenshot..." -ForegroundColor Yellow

if (!(Test-Path $DocsDir)) {
    New-Item -ItemType Directory -Path $DocsDir -Force | Out-Null
}

Set-Location $ProjectDir

Write-Host "  Starting Flutter Web (port 8124)..."
$webProcess = Start-Process -FilePath "flutter" -ArgumentList "run -d chrome --web-port=8124" -PassThru -WindowStyle Hidden

Write-Host "  Waiting for web app to start (~25s)..."
Start-Sleep -Seconds 25

$webScreenshotPath = Join-Path $DocsDir "web_run.png"
Write-Host "  Taking web screenshot..."

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bitmap = New-Object System.Drawing.Bitmap($screen.Width, $screen.Height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($screen.Location, [System.Drawing.Point]::Empty, $screen.Size)
$bitmap.Save($webScreenshotPath, [System.Drawing.Imaging.ImageFormat]::Png)
$graphics.Dispose()
$bitmap.Dispose()

Write-Host "  Web screenshot saved: $webScreenshotPath" -ForegroundColor Green

Stop-Process -Id $webProcess.Id -Force -ErrorAction SilentlyContinue
Write-Host "  Web process stopped"

# ---- Step 6: Emulator run and screenshot ----
Write-Host ""
Write-Host "[6/7] Running on emulator and taking screenshot..." -ForegroundColor Yellow

Set-Location $ProjectDir

Write-Host "  Installing and running app on emulator..."
$emuRunJob = Start-Job -ScriptBlock {
    Set-Location $using:ProjectDir
    flutter run -d emulator-5554 --no-pause-after-exit 2>&1
}

Write-Host "  Waiting for app to start (~35s)..."
Start-Sleep -Seconds 35

$emuScreenshotPath = Join-Path $DocsDir "emulator_run.png"
& $adb shell screencap -p /sdcard/emulator_run.png 2>&1 | Out-Null
& $adb pull /sdcard/emulator_run.png $emuScreenshotPath 2>&1 | Out-Null
& $adb shell rm /sdcard/emulator_run.png 2>&1 | Out-Null

if (Test-Path $emuScreenshotPath) {
    Write-Host "  Emulator screenshot saved: $emuScreenshotPath" -ForegroundColor Green
} else {
    Write-Host "  WARNING: adb screenshot failed, using fullscreen capture..." -ForegroundColor Red
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    $screen2 = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $bitmap2 = New-Object System.Drawing.Bitmap($screen2.Width, $screen2.Height)
    $graphics2 = [System.Drawing.Graphics]::FromImage($bitmap2)
    $graphics2.CopyFromScreen($screen2.Location, [System.Drawing.Point]::Empty, $screen2.Size)
    $bitmap2.Save($emuScreenshotPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics2.Dispose()
    $bitmap2.Dispose()
    Write-Host "  Fullscreen screenshot saved: $emuScreenshotPath" -ForegroundColor Yellow
}

# Clean up background job
Stop-Job $emuRunJob -ErrorAction SilentlyContinue
Remove-Job $emuRunJob -Force -ErrorAction SilentlyContinue
Get-Process -Name "flutter" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

# ---- Step 7: Second commit + README + third commit + push ----
Write-Host ""
Write-Host "[7/7] Git commits and push..." -ForegroundColor Yellow

Set-Location $Day1Dir

# Second commit
Write-Host "  Second commit (screenshots)..."
git add -A
git commit -m "feat: run on web and emulator with screenshots"
Write-Host "  Committed: feat: run on web and emulator with screenshots" -ForegroundColor Green

# Copy README from template
Write-Host "  Copying README from template..."
if (Test-Path $ReadmeTemplate) {
    Copy-Item $ReadmeTemplate (Join-Path $Day1Dir "README.md") -Force
    Write-Host "  README.md copied" -ForegroundColor Green
} else {
    Write-Host "  WARNING: README template not found at $ReadmeTemplate" -ForegroundColor Red
}

# Third commit
Write-Host "  Third commit (README)..."
git add -A
git commit -m "docs: add README with screenshots"
Write-Host "  Committed: docs: add README with screenshots" -ForegroundColor Green

# Push
$remote = git remote -v
if ($remote -match "origin") {
    Write-Host "  Pushing to remote..."
    git push -u origin main
    Write-Host "  Push done!" -ForegroundColor Green
} else {
    Write-Host "  No remote found, skip push" -ForegroundColor Yellow
    Write-Host "  To add remote, run:"
    Write-Host "    git remote add origin https://github.com/Su6731/FlutterStudy.git"
    Write-Host "    git push -u origin main"
}

# ---- Done ----
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  DAY1 setup complete!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Project: $ProjectDir"
Write-Host "Screenshots: $DocsDir"
Write-Host ""
Write-Host "Git log:"
git log --oneline -5
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
