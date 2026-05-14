# Hebrew-English Keyboard Layout Fixer

> Typed in the wrong language? One key fixes it instantly.

A lightweight AutoHotkey v2 script that runs silently in your system tray and converts text between Hebrew and English keyboard layouts. Direction is detected automatically.

---

## Installation & Running

1. Install [AutoHotkey v2](https://www.autohotkey.com/) (free)
2. Download or clone this repo
3. Double-click `Hebrew-English.ahk`
4. The script runs silently in the background (check your system tray)

> To stop: right-click the tray icon → **Exit**
> To auto-start with Windows: see [Auto-start](#auto-start-with-windows) below

---

## How to Use

### Option 1 — Convert a single word (no selection needed)
Just type, realize you're in the wrong language, press **Pause**:

```
You typed:   akldm
Press:       Pause
Result:      שלום
```

### Option 2 — Convert any amount of text (select first)
Select any text with your mouse or keyboard, then press **Pause**:

```
You typed:   akldm hru
Select all → Pause
Result:      שלום עיר
```

```
You typed:   שלום מה נשמע
Select all → Pause
Result:      akldm nd bgnd
```

> Works in **any direction**: English→Hebrew or Hebrew→English, detected automatically.

---

## Where is the Pause key?

On most laptops the **Pause** key is a secondary function printed on another key — look for the word **"Pause"** or **"Brk"** written in a different color on one of the keys in the top-right area of the keyboard (often **Fn + F12**, **Fn + Insert**, or **Fn + B** depending on the model). Hold **Fn** and press that key.

---

## Keyboard Map (Standard Israeli Layout)

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

## Hotkey Summary

| Situation | What to do |
|-----------|------------|
| Typed one wrong word | Press **Pause** |
| Typed multiple wrong words | Select them → Press **Pause** |
| Typed a whole wrong sentence | Select it → Press **Pause** |
| Convert via menu | Right-click tray icon → **Convert** |

---

## Auto-start with Windows

By default you need to double-click the script every time you restart. To make it **start automatically with Windows**, run this once in PowerShell (adjust the path if needed):

```powershell
$ws = New-Object -ComObject WScript.Shell
$sc = $ws.CreateShortcut("$([Environment]::GetFolderPath('Startup'))\HebrewFixer.lnk")
$sc.TargetPath = "$PWD\Hebrew-English.ahk"
$sc.WorkingDirectory = "$PWD"
$sc.Save()
```

This creates a shortcut in your Windows Startup folder. From now on the script launches automatically every time you log in.

> To remove auto-start: open `shell:startup` in File Explorer and delete `HebrewFixer.lnk`

---

## Compile to .exe (run without AHK installed)

```powershell
& "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" `
  /in  "Hebrew-English.ahk" `
  /out "HebrewFixer.exe" `
  /base "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"
```

---

## Why AutoHotkey and not C / Rust / Assembly?

| Language | What you'd need to do | Verdict |
|----------|-----------------------|---------|
| **AHK v2** | 80 lines, done | Right tool |
| **C / Rust** | `SetWindowsHookEx`, `SendInput`, message loop, tray icon — 1000+ lines | Same result, 10x the work |
| **Assembly** | Every Windows API call by hand at register level | Weeks of work |
| **Python / Ruby** | No native keyboard hook — wraps the same API with added overhead | More deps, slower |

AHK wraps the Windows keyboard hook API natively. Idle usage: **0% CPU, ~5MB RAM**.

---

## License

MIT — do whatever you want with it.
