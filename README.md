# ⌨️ Hebrew-English Keyboard Layout Fixer

> Typed in the wrong language? One hotkey fixes it instantly.

A lightweight AutoHotkey v2 script that runs silently in your system tray and converts the last typed word between Hebrew and English keyboard layouts — in both directions, automatically detected.

---

## ✨ Features

- **Alt+Q** — Convert last typed word (instant, no delay)
- **Double-tap Right Shift** — Same action, alternative trigger
- **Auto-detects direction** — English→Hebrew or Hebrew→English based on what you typed
- **English→Hebrew**: buffer-based, zero latency (no clipboard touch)
- **Hebrew→English**: clipboard-based selection
- **Convert Last Sentence** — via system tray right-click menu
- **~0% CPU, ~5MB RAM** when idle
- Runs silently in the system tray

---

## 🗺️ Keyboard Map (Standard Israeli Layout)

| English | Hebrew | English | Hebrew | English | Hebrew |
|---------|--------|---------|--------|---------|--------|
| e | ק | r | ר | t | א |
| y | ט | u | ו | i | ן |
| o | ם | p | פ | a | ש |
| s | ד | d | ג | f | כ |
| g | ע | h | י | j | ח |
| k | ל | l | ך | ; | ף |
| z | ז | x | ס | c | ב |
| v | ה | b | נ | n | מ |
| m | צ | , | ת | . | ץ |

---

## 🚀 Installation

### Requirements
- Windows 10/11
- [AutoHotkey v2](https://www.autohotkey.com/) (free, open source)

### Steps
1. Install AutoHotkey v2 from https://www.autohotkey.com
2. Download or clone this repo
3. Double-click `Hebrew-English.ahk`
4. Look for the icon in your system tray — you're running!

---

## ⚡ Usage

1. Type a word in the wrong language, e.g. `akldm` instead of `שלום`
2. Press **Alt+Q**
3. The word is instantly replaced with the correct version

Works in any text field: browsers, editors, chat apps, email, etc.

---

## 🔁 Auto-start with Windows

Run this **once** in PowerShell to add the script to your Startup folder:

```powershell
$ws = New-Object -ComObject WScript.Shell
$sc = $ws.CreateShortcut("$([Environment]::GetFolderPath('Startup'))\HebrewFixer.lnk")
$sc.TargetPath = "$PWD\Hebrew-English.ahk"
$sc.WorkingDirectory = "$PWD"
$sc.Save()
Write-Host "✅ Added to Startup"
```

---

## 📦 Compile to .exe (optional)

If you want to run without AHK installed, compile with Ahk2Exe (bundled with AutoHotkey):

```powershell
& "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" `
  /in  "Hebrew-English.ahk" `
  /out "HebrewFixer.exe" `
  /base "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"
```

> Keep `dictionary.txt` in the same folder as the `.exe`.

---

## 🗂️ Files

```
Hebrew-English/
├── Hebrew-English.ahk   # Main script — everything lives here
└── dictionary.txt       # Hebrew words for future auto-convert feature (one per line)
```

---

## ⚙️ Tray Menu

Right-click the tray icon for:

| Option | Action |
|--------|--------|
| Convert Last Word | Same as Alt+Q |
| Convert Last Sentence | Converts entire current line |
| Exit | Quit the script |

---

## 🛠️ How It Works

The script installs a **low-level Windows keyboard hook** via AutoHotkey. Every keystroke is appended to a rolling 200-character buffer. On trigger:

1. The last word is extracted from the buffer
2. If it's ASCII → each character is mapped to Hebrew via the Israeli layout table → backspaces erase the word → Hebrew is typed instantly
3. If it's Hebrew → `Ctrl+Shift+Left` selects the word → clipboard copy → map each character to English → paste back

**Why AHK over C/Rust/Python?**
AHK wraps `SetWindowsHookEx`, `SendInput`, and the Windows message loop for you. The result is identical performance with a fraction of the code. Idle CPU usage is effectively 0%.

---

## 📝 License

MIT — do whatever you want with it.
