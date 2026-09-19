# =====================================================================
#  Uhm Graphics Pack v3 - Installer
#  نصب خودکار و هوشمند پک گرافیک
#  Double-click friendly / Persian GUI / auto-detect / auto-fix
# =====================================================================
$ErrorActionPreference = 'Stop'
try {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $Host.UI.RawUI.WindowTitle = 'Uhm Graphics Pack v3 - Installer'
} catch {}

# ---------------- GUI helpers ----------------
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Msg {
    param([string]$Text, [string]$Title = 'Uhm Graphics Pack v3', [string]$Icon = 'Information', [string]$Buttons = 'OK')
    $o = New-Object System.Windows.Forms.MessageBoxOptions
    $o = $o -bor 'RtlReading'
    return [System.Windows.Forms.MessageBox]::Show($Text, $Title, $Buttons, $Icon, 'Button1', $o)
}

function Pick-Folder {
    param([string]$Description)
    $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
    $dlg.Description = $Description
    $dlg.ShowNewFolderButton = $false
    $dlg.RootFolder = 'MyComputer'
    if ($dlg.ShowDialog() -eq 'OK') { return $dlg.SelectedPath }
    return $null
}

function Log { param([string]$m, [string]$c = 'Gray') Write-Host ('  ' + $m) -ForegroundColor $c }
function Ok   { param([string]$m) Log ('[OK]    ' + $m) 'Green' }
function Warn { param([string]$m) Log ('[WARN]  ' + $m) 'Yellow' }
function Bad  { param([string]$m) Log ('[FAIL]  ' + $m) 'Red' }
function Step { param([string]$m) Write-Host ''; Write-Host ('== ' + $m + ' ==') -ForegroundColor Cyan }

$report = New-Object System.Collections.Generic.List[string]
function Rep { param([string]$m) $report.Add($m) }

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$packFolder = Split-Path -Parent $scriptRoot

# ---------------- 0. Admin check ----------------
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

Write-Host ''
Write-Host '   ===============================================================' -ForegroundColor Magenta
Write-Host '        Uhm Graphics Pack v3  -  نصب‌کننده هوشمند / نسخه ۳' -ForegroundColor Magenta
Write-Host '   ===============================================================' -ForegroundColor Magenta
Write-Host ''

Msg -Text ("به نصب‌کننده پک گرافیک Uhm نسخه ۳ خوش آمدید.`n`n" +
    "این برنامه به‌صورت خودکار:`n" +
    "  • مسیر Assetto Corsa را پیدا یا از شما می‌پرسد`n" +
    "  • فایل‌ها را در مسیر درست نصب می‌کند`n" +
    "  • مشکلات و فایل‌های قدیمی را پیدا و اصلاح می‌کند`n" +
    "  • گزارش کامل نصب می‌سازد`n`n" +
    "پیشنهاد: برنامه را به‌صورت Run as Administrator اجرا کنید`n(اگر بازی در Program Files نصب است).") -Icon Information

# ---------------- 1. Detect Assetto Corsa ----------------
Step 'قدم ۱/۶ : پیدا کردن مسیر Assetto Corsa'

$candidates = @()
function Test-AcRoot { param([string]$p)
    if ($p -and (Test-Path (Join-Path $p 'AssettoCorsa.exe'))) { return $p }
    return $null
}
# Steam registry path
try {
    $steamPath = (Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Valve\Steam' -ErrorAction SilentlyContinue).InstallPath
    if (-not $steamPath) { $steamPath = (Get-ItemProperty 'HKCU:\SOFTWARE\Valve\Steam' -ErrorAction SilentlyContinue).SteamPath }
    if ($steamPath) {
        $r = Test-AcRoot (Join-Path $steamPath 'steamapps\common\assettocorsa')
        if ($r) { $candidates += $r; Log ('پیدا شد از رجیستری Steam: ' + $r) 'DarkGreen' }
        $vdf = Join-Path $steamPath 'steamapps\libraryfolders.vdf'
        if (Test-Path $vdf) {
            $libs = [regex]::Matches((Get-Content $vdf -Raw), '"path"\s+"([^"]+)"') | ForEach-Object { $_.Groups[1].Value -replace '\\\\','\' }
            foreach ($lib in $libs) {
                $r = Test-AcRoot (Join-Path $lib 'steamapps\common\assettocorsa')
                if ($r) { $candidates += $r; Log ('پیدا شد در کتابخانه Steam: ' + $r) 'DarkGreen' }
            }
        }
    }
} catch {}
# Common manual locations
foreach ($d in @("$env:ProgramFiles", "${env:ProgramFiles(x86})", "$env:USERPROFILE\Games", 'C:\Games', 'D:\Games', 'D:\')) {
    if ($d -and (Test-Path $d)) {
        Get-ChildItem $d -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'assettocorsa|assetto corsa' } | ForEach-Object {
            $r = Test-AcRoot $_.FullName
            if ($r) { $candidates += $r }
        }
    }
}
$candidates = $candidates | Select-Object -Unique

$acRoot = $null
if ($candidates.Count -ge 1) {
    $msg = 'این مسیر(ها) برای Assetto Corsa پیدا شد:' + "`n`n" + (($candidates | ForEach-Object { '  • ' + $_ }) -join "`n") + "`n`nآیا مسیر درست است؟"
    if ((Msg -Text $msg -Buttons YesNo -Icon Question) -eq 'Yes') { $acRoot = $candidates[0] }
}
if (-not $acRoot) {
    Log 'مسیر را به‌صورت دستی انتخاب کنید (پوشه‌ای که AssettoCorsa.exe داخل آن است)...' 'Yellow'
    do {
        $sel = Pick-Folder 'پوشه اصلی Assetto Corsa را انتخاب کنید (جایی که AssettoCorsa.exe هست)'
        if (-not $sel) { Msg -Text 'نصب لغو شد.' -Icon Warning; exit 0 }
        if (Test-Path (Join-Path $sel 'AssettoCorsa.exe')) {
            $acRoot = $sel
        } else {
            $again = Msg -Text ('در این پوشه فایل AssettoCorsa.exe پیدا نشد:' + "`n" + $sel + "`n`nپوشه دیگری انتخاب می‌کنید؟") -Buttons YesNo -Icon Warning
            if ($again -eq 'No') { Msg -Text 'نصب لغو شد.' -Icon Warning; exit 0 }
        }
    } while (-not $acRoot)
}
Ok ('مسیر بازی: ' + $acRoot)
Rep 'مسیر بازی: ' + $acRoot

# ---------------- 2. Detect environment ----------------
Step 'قدم ۲/۶ : شناسایی محیط (نسخه‌ها و مادها)'

# CSP
$cspOk = $false; $cspVer = 'نامشخص'
$dwrite = Join-Path $acRoot 'dwrite.dll'
$extDir = Join-Path $acRoot 'extension'
if ((Test-Path $dwrite) -and (Test-Path $extDir)) {
    $cspOk = $true
    try { $cspVer = (Get-Item $dwrite).VersionInfo.FileVersion } catch {}
    Ok ('Custom Shaders Patch نصب است (نسخه حدودی: ' + $cspVer + ')')
} else {
    Bad 'Custom Shaders Patch پیدا نشد! این پک بدون CSP کار نمی‌کند. بعداً نصبش کنید.'
}
Rep 'CSP: ' + $(if ($cspOk) { 'نصب - نسخه ' + $cspVer } else { 'پیدا نشد!' })

# Pure
$pureOk = $false
$purePaths = @(
    (Join-Path $acRoot 'extension\lua\new-modes\pure'),
    (Join-Path $acRoot 'extension\lua\pure'),
    (Join-Path $acRoot 'apps\lua\PureConfig')
)
foreach ($pp in $purePaths) { if (Test-Path $pp) { $pureOk = $true; break } }
if (-not $pureOk) {
    # shallow search for Pure weather/controller lua files
    $wf = Join-Path $acRoot 'extension\lua\weather'
    if (Test-Path $wf) {
        if (Get-ChildItem $wf -Recurse -Filter '*pure*' -ErrorAction SilentlyContinue | Select-Object -First 1) { $pureOk = $true }
    }
}
if ($pureOk) { Ok 'مود Pure نصب است.' } else { Warn 'Pure پیدا نشد. برای آسمان/هوای پویا، Pure را نصب کنید.' }
Rep 'Pure: ' + $(if ($pureOk) { 'نصب' } else { 'پیدا نشد' })

# Content Manager
$cmExe = $null
foreach ($c in @((Join-Path $acRoot 'Content Manager.exe'),
                 (Join-Path $acRoot 'Content Manager Safe.exe'),
                 (Join-Path (Split-Path $acRoot -Parent) 'Content Manager.exe'),
                 "$env:USERPROFILE\Downloads\Content Manager.exe",
                 "$env:USERPROFILE\Desktop\Content Manager.exe")) {
    if ($c -and (Test-Path $c)) { $cmExe = $c; break }
}
if ($cmExe) { Ok ('Content Manager پیدا شد: ' + $cmExe) } else { Warn 'Content Manager پیدا نشد؛ پریست‌ها را می‌توانید دستی در CM بارگذاری کنید.' }
Rep 'Content Manager: ' + $(if ($cmExe) { $cmExe } else { 'پیدا نشد' })

# Documents folder
$docAc = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Assetto Corsa'
$docCfg = Join-Path $docAc 'cfg'
if (Test-Path $docCfg) { Ok ('پوشه کاربری بازی: ' + $docCfg) } else { Warn 'پوشه Documents\Assetto Corsa\cfg هنوز ساخته نشده (بعد از اولین اجرا ساخته می‌شود).' }

# ---------------- 3. Install PPFilter ----------------
Step 'قدم ۳/۶ : نصب فیلتر گرافیکی (PPFilter)'

$sysPp = Join-Path $acRoot 'system\cfg\ppfilters'
if (-not (Test-Path $sysPp)) { New-Item -ItemType Directory -Path $sysPp -Force | Out-Null; Log 'پوشه ppfilters ساخته شد.' 'DarkGreen' }
$filterSrc = Get-ChildItem (Join-Path $packFolder '2-PPFilter') -Filter '*.ini'
$installedFilters = @()
foreach ($f in $filterSrc) {
    $dst = Join-Path $sysPp $f.Name
    if (Test-Path $dst) {
        $bak = $dst + '.bak'
        Copy-Item $dst $bak -Force
        Log ('نسخه قدیمی فیلتر پشتیبان گرفته شد: ' + (Split-Path $bak -Leaf)) 'DarkYellow'
    }
    Copy-Item $f.FullName $dst -Force
    Ok ('فیلتر نصب شد: ' + $f.Name)
    $installedFilters += [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
    Rep 'PPFilter نصب شد: ' + $f.Name
}
# Fix: old/conflicting copy in Documents overrides the game folder
$docPp = Join-Path $docCfg 'ppfilters'
if (Test-Path $docPp) {
    foreach ($f in $filterSrc) {
        $conflict = Join-Path $docPp $f.Name
        if (Test-Path $conflict) {
            $old = $conflict + '.old.bak'
            Move-Item $conflict $old -Force
            Warn ('فیلتر تکراری/قدیمی در Documents پیدا و غیرفعال شد (پوشه کاربری اولویت دارد): ' + $f.Name)
            Rep 'اصلاح: فایل قدیمی فیلتر در Documents غیرفعال شد'
        }
    }
}

# ---------------- 4. Fix video.ini ----------------
Step 'قدم ۴/۶ : بررسی و اصلاح تنظیمات ویدیو'

$videoIni = Join-Path $docCfg 'video.ini'
if (Test-Path $videoIni) {
    $vtxt = Get-Content $videoIni -Raw -Encoding UTF8
    $m = [regex]::Match($vtxt, '(?mi)^FILTER=(.*)$')
    if ($m.Success) {
        $curFilter = $m.Groups[1].Value.Trim()
        if ($installedFilters -contains $curFilter) {
            Ok ('فیلتر فعال در بازی همین فیلتر پک است: ' + $curFilter)
        } else {
            Log ('فیلتر فعال فعلی بازی: «' + $curFilter + '»') 'DarkYellow'
            $fix = Msg -Text ('فیلتر فعال فعلی بازی «' + $curFilter + '» است.' + "`n`n" +
                'برای بهترین نتیجه با پک، فیلتر «' + $installedFilters[0] + '» پیشنهاد می‌شود.' + "`n" +
                'الان در تنظیمات ویدیوی بازی اعمال شود؟') -Buttons YesNo -Icon Question
            if ($fix -eq 'Yes') {
                $new = [regex]::Replace($vtxt, '(?mi)^FILTER=.*$', ('FILTER=' + $installedFilters[0]))
                Copy-Item $videoIni ($videoIni + '.bak') -Force
                Set-Content -Path $videoIni -Value $new -Encoding UTF8 -NoNewline
                Ok ('فیلتر فعال ویدیو تغییر کرد به: ' + $installedFilters[0])
                Rep 'اصلاح: فیلتر فعال ویدیو -> ' + $installedFilters[0]
            } else {
                Log 'تغییر فیلتر ویدیو رد شد.' 'DarkYellow'
            }
        }
    } else {
        Warn 'کلید FILTER در video.ini پیدا نشد؛ بعد از اجرای بازی تنظیمش کنید.'
    }
} else {
    Log 'video.ini هنوز وجود ندارد (بعد از اولین اجرای بازی ساخته می‌شود). مشکلی نیست.' 'DarkYellow'
}

# ---------------- 5. Copy presets for easy access ----------------
Step 'قدم ۵/۶ : کپی پریست‌ها برای دسترسی آسان'

$dropDir = Join-Path $acRoot 'Uhm Pack v3 Presets'
New-Item -ItemType Directory -Path $dropDir -Force | Out-Null
foreach ($sub in @('1-CSP-Settings', '3-Pure-Config', '4-Video-Settings')) {
    $src = Join-Path $packFolder $sub
    $dst = Join-Path $dropDir $sub
    New-Item -ItemType Directory -Path $dst -Force | Out-Null
    Get-ChildItem $src -File | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $dst $_.Name) -Force
        Log ('کپی شد: ' + $sub + '\' + $_.Name) 'DarkGreen'
    }
}
Ok ('پریست‌ها آماده شدند در: ' + $dropDir)
Rep 'پریست‌ها کپی شدند به: ' + $dropDir

# ---------------- 6. Final report ----------------
Step 'قدم ۶/۶ : گزارش نهایی'

$reportText = @(
    'Uhm Graphics Pack v3 - گزارش نصب',
    ('تاریخ: ' + (Get-Date -Format 'yyyy-MM-dd HH:mm')),
    ('مسیر بازی: ' + $acRoot),
    ('CSP: ' + $(if ($cspOk) { 'نصب است (نسخه ' + $cspVer + ')' } else { 'پیدا نشد! حتماً نصب کنید' })),
    ('Pure: ' + $(if ($pureOk) { 'نصب است' } else { 'پیدا نشد' })),
    ('فیلتر نصب‌شده: ' + ($installedFilters -join ', ')),
    ('پوشه پریست‌ها: ' + $dropDir),
    '',
    '=================================',
    'راهنمای استفاده:',
    '1) پریست ویدیو: فایل‌های پوشه "4-Video-Settings" را یکی‌یکی روی Content Manager بکشید و رها کنید (یا دابل‌کلیک)، سپس در CM دکمه "Go" را بزنید.',
    '2) پریست CSP: در CM به Settings > Custom Shaders Patch بروید و فایل‌های پوشه "1-CSP-Settings" را داخل پنجره بکشید و رها کنید، یا از دکمه بارگذاری پریست استفاده کنید.',
    '3) در بازی: اپ "Pure Config" را باز کنید و از پوشه "3-Pure-Config" کانفیگ دلخواه را Load کنید:',
    '     - سیستم قوی + پکیج Highres => Uhm Config-Realistic',
    '     - سیستم متوسط یا پکیج ساده => Uhm PureConfig-Simple',
    '',
    
'نکته ویژه کارت‌های RTX (سری 30/40/50):',
'اگر نسخه CSP شما 0.3.0 (پیش‌نمایش 338 به بالا) است، می‌توانید در CM به',
'Settings > Custom Shaders Patch > Graphics Adjustments > Upscaling بروید و',
'روش را روی NVIDIA DLSS (حالت Quality یا DLAA برای حداکثر کیفیت) بگذارید.',
'نکته مهم رنگ:',
    'پریست‌های این پک برای فضای رنگی LCS ساخته شده‌اند. در تنظیمات WeatherFX پریست "Pure LCS" را انتخاب کنید.',
    '',
    'انتخاب حالت پیشنهادی:',
    '     - کارت گرافیک پرچم‌دار (مثل 5090) => Ultra',
    '     - سیستم قوی => VeryHigh',
    '     - سیستم متوسط رو به بالا => High',
    '     - سیستم متوسط => Medium',
    '     - سیستم ضعیف => Low'
) -join "`r`n"

$reportFile = Join-Path $scriptRoot 'install-report.txt'
Set-Content -Path $reportFile -Value $reportText -Encoding UTF8
Ok ('گزارش نصب ذخیره شد: ' + $reportFile)
Rep 'گزارش: ' + $reportFile

Write-Host ''
Write-Host '   ---------------------------------------------------------------' -ForegroundColor Green
Write-Host '                     نصب با موفقیت انجام شد' -ForegroundColor Green
Write-Host '   ---------------------------------------------------------------' -ForegroundColor Green
Write-Host ''
foreach ($line in $reportText.Split("`r`n")) { Write-Host ('  ' + $line) 'Gray' }

Msg -Text ('نصب کامل شد!' + "`n`n" +
    'فیلتر گرافیکی نصب شد و پریست‌ها آماده‌اند.' + "`n`n" +
    'قدم بعدی:' + "`n" +
    '  ۱. پریست ویدیو را روی Content Manager بکشید و رها کنید' + "`n" +
    '  ۲. پریست CSP را در تنظیمات CSP در CM بارگذاری کنید' + "`n" +
    '  ۳. در بازی، اپ Pure Config کانفیگ را باز کنید' + "`n`n" +
    'گزارش کامل در پوشه برنامه ذخیره شد.') -Icon Information

Write-Host ''
Write-Host 'برای بستن این پنجره یک کلید بزنید...' -ForegroundColor DarkGray
try { $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') } catch { Start-Sleep -Seconds 5 }
