# ⌨️ Hebrew-English Keyboard Layout Fixer

> Typed in the wrong language? One key fixes it instantly.

A lightweight AutoHotkey v2 script that runs silently in your system tray and converts text between Hebrew ↔ English keyboard layouts. Direction is detected automatically.

---

## 🚀 Installation & Running

1. Install [AutoHotkey v2](https://www.autohotkey.com/) (free)
2. Download or clone this repo
3. Double-click `Hebrew-English.ahk`
4. A green **H** icon appears in your system tray (bottom-right near the clock) — the script is running

> To stop: right-click the tray icon → **Exit**
> To auto-start with Windows: see [Auto-start](#-auto-start-with-windows) below

---

## ✨ How to Use

### Option 1 — Convert a single word (no selection needed)
Just type, realize you're in the wrong language, press **NumLock**:

```
You typed:   akldm
Press:       NumLock
Result:      שלום
```

### Option 2 — Convert any amount of text (select first)
Select any text with your mouse or keyboard, then press **NumLock**:

```
You typed:   akldm hru
Select all → NumLock
Result:      שלום עיר
```

```
You typed:   שלום מה נשמע
Select all → NumLock
Result:      akldm nd bgnd
```

> Works in **any direction**: English→Hebrew or Hebrew→English, detected automatically.

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

## ⚡ Hotkey Summary

| Situation | What to do |
|-----------|------------|
| Typed one wrong word | Press **NumLock** |
| Typed multiple wrong words | Select them → Press **NumLock** |
| Typed a whole wrong sentence | Select it → Press **NumLock** |
| Convert via menu | Right-click tray icon → **Convert Last Sentence** |

---

## 🔁 Auto-start with Windows

Run once in PowerShell to add to Startup:

```powershell
$ws = New-Object -ComObject WScript.Shell
$sc = $ws.CreateShortcut("$([Environment]::GetFolderPath('Startup'))\HebrewFixer.lnk")
$sc.TargetPath = "$PWD\Hebrew-English.ahk"
$sc.WorkingDirectory = "$PWD"
$sc.Save()
```

---

## 📦 Compile to .exe (run without AHK installed)

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
| **C / Rust** | `SetWindowsHookEx`, `SendInput`, message loop, tray icon — 1000+ lines | ❌ Same result, 10× the work |
| **Assembly** | Every Windows API call by hand at register level | ❌ Weeks of work |
| **Python / Ruby** | No native keyboard hook — wraps the same API with added overhead | ❌ More deps, slower |

AHK wraps the Windows keyboard hook API natively. Idle usage: **0% CPU, ~5MB RAM**.

---

## 📝 License

MIT — do whatever you want with it.
