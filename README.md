# ⌨️ Hebrew-English Keyboard Layout Fixer

> Typed in the wrong language? One key fixes it instantly.

A lightweight AutoHotkey v2 script that runs silently in your system tray and converts the last typed word between Hebrew ↔ English keyboard layouts — direction detected automatically.

---

## ✨ How It Works

Press **NumLock** after typing a word in the wrong language:

- Typed `akldm` but meant `שלום`? → Press NumLock → instant fix
- Typed `שלום` but meant `akldm`? → Press NumLock → converts back

The script detects direction automatically.

---

## 🗺️ Keyboard Map (Standard Israeli Layout)

| En | He | En | He | En | He | En | He |
|----|----|----|----|----|----|----|-----|
| e | ק | r | ר | t | א | y | ט |
| u | ו | i | ן | o | ם | p | פ |
| a | ש | s | ד | d | ג | f | כ |
| g | ע | h | י | j | ח | k | ל |
| l | ך | z | ז | x | ס | c | ב |
| v | ה | b | נ | n | מ | m | צ |
| ; | ף | , | ת | . | ץ | | |

---

## 🚀 Installation

**Requirements:** [AutoHotkey v2](https://www.autohotkey.com/) (free)

1. Install AutoHotkey v2
2. Download this repo
3. Double-click `Hebrew-English.ahk`
4. Done — script runs silently in background

---

## ⚡ Usage

| Action | Hotkey |
|--------|--------|
| Convert last word | **NumLock** |
| Convert last sentence | Right-click tray icon |
| Exit | Right-click tray icon → Exit |

---

## 🔁 Auto-start with Windows

Run once in PowerShell:

```powershell
$ws = New-Object -ComObject WScript.Shell
$sc = $ws.CreateShortcut("$([Environment]::GetFolderPath('Startup'))\HebrewFixer.lnk")
$sc.TargetPath = "$PWD\Hebrew-English.ahk"
$sc.WorkingDirectory = "$PWD"
$sc.Save()
```

---

## 📦 Compile to .exe

```powershell
& "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" `
  /in  "Hebrew-English.ahk" `
  /out "HebrewFixer.exe" `
  /base "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"
```

---

## 🛠️ Why AutoHotkey and not C / Rust / Assembly?

| Language | What you'd need to do | Verdict |
|----------|-----------------------|---------|
| **AHK v2** | 80 lines, done | ✅ Right tool |
| **C / Rust** | `SetWindowsHookEx`, `SendInput`, message loop, tray icon — 1000+ lines | ❌ Same result, 10× work |
| **Assembly** | Every Windows API call by hand | ❌ Weeks of work |
| **Python / Ruby** | No native keyboard hook — wraps the same API with added overhead | ❌ More deps, slower |

AHK wraps the Windows keyboard hook API natively. Idle usage: **0% CPU, ~5MB RAM**.

---

## 📝 License

MIT — do whatever you want with it.
