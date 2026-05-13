#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

; ── מיפויים ──────────────────────────────────────────────────────────────────
global heMap := Map(
    "e","ק", "r","ר", "t","א", "y","ט", "u","ו", "i","ן", "o","ם", "p","פ",
    "a","ש", "s","ד", "d","ג", "f","כ", "g","ע", "h","י", "j","ח", "k","ל",
    "l","ך", "z","ז", "x","ס", "c","ב", "v","ה", "b","נ", "n","מ", "m","צ",
    ";","ף", ",","ת", ".","ץ", "q","/", "w","'"
)
global enMap := Map()
for _e, _h in heMap
    enMap[_h] := _e

; ── Buffer ────────────────────────────────────────────────────────────────────
global buf := ""
global lastShift := 0

BufAdd(ch) {
    global buf
    buf .= ch
    if StrLen(buf) > 200
        buf := SubStr(buf, -199)
}

; רישום לכידת הקלדה — כל אות + סימנים נפוצים
loop parse, "abcdefghijklmnopqrstuvwxyz" {
    Hotkey "~*" A_LoopField, BufKey
}
for _s in [",", ".", ";", "'", "/", "-", "="] {
    try Hotkey "~" _s, BufKey
}
Hotkey "~Space",     BufKey
Hotkey "~Enter",     BufKey
Hotkey "~Backspace", BufBS

; איפוס buffer אם המשתמש לחץ חץ/עכבר (למנוע desync)
~Left::  { global buf := "" }
~Right:: { global buf := "" }
~Up::    { global buf := "" }
~Down::  { global buf := "" }
~LButton::{ global buf := "" }

BufKey(hk) {
    global buf
    if GetKeyState("Ctrl","P") || GetKeyState("Alt","P")
        return
    key := RegExReplace(hk, "^[~*^!]+")
    ch  := (key = "Space") ? " " : (key = "Enter") ? "`n" : key
    BufAdd(StrLower(ch))
}

BufBS(*) {
    global buf
    if StrLen(buf) > 0
        buf := SubStr(buf, 1, -1)
}

; ── המרה ─────────────────────────────────────────────────────────────────────
IsHebrew(text) {
    loop parse, text {
        c := Ord(A_LoopField)
        if c >= 0x05D0 && c <= 0x05EA
            return true
    }
    return false
}

GetLastWord() {
    global buf
    bounds := " `t`n,.!?;:"
    i := StrLen(buf)
    while i >= 1 {
        if InStr(bounds, SubStr(buf, i, 1))
            break
        i--
    }
    return SubStr(buf, i + 1)
}

ConvertWord() {
    global buf, heMap, enMap
    word := GetLastWord()
    if word = ""
        return

    if IsHebrew(word) {
        ; עברית → אנגלית (clipboard כי אי אפשר ל-backspace עברית בטוח)
        old := ClipboardAll()
        A_Clipboard := ""
        Send "^+{Left}"
        Sleep 40
        Send "^c"
        if ClipWait(0.3) {
            result := ""
            loop parse, A_Clipboard
                result .= enMap.Has(A_LoopField) ? enMap[A_LoopField] : A_LoopField
            A_Clipboard := result
            Sleep 20
            Send "^v"
            Sleep 20
        }
        A_Clipboard := old
    } else {
        ; אנגלית → עברית (buffer — מיידי)
        result := ""
        loop parse, word {
            ch := StrLower(A_LoopField)
            result .= heMap.Has(ch) ? heMap[ch] : A_LoopField
        }
        n := StrLen(word)
        Send "{Backspace " n "}"
        SendText result
        buf := SubStr(buf, 1, StrLen(buf) - n) . result
    }
}

ConvertSentence() {
    global buf, heMap, enMap
    bounds := ".!?`n"
    i := StrLen(buf)
    while i >= 1 {
        if InStr(bounds, SubStr(buf, i, 1))
            break
        i--
    }
    sentence := LTrim(SubStr(buf, i + 1))
    if sentence = ""
        return

    if IsHebrew(sentence) {
        old := ClipboardAll()
        A_Clipboard := ""
        Send "+{Home}"
        Sleep 40
        Send "^c"
        if ClipWait(0.3) {
            result := ""
            loop parse, A_Clipboard
                result .= enMap.Has(A_LoopField) ? enMap[A_LoopField] : A_LoopField
            A_Clipboard := result
            Sleep 20
            Send "^v"
            Sleep 20
        }
        A_Clipboard := old
    } else {
        result := ""
        loop parse, sentence {
            ch := StrLower(A_LoopField)
            result .= heMap.Has(ch) ? heMap[ch] : A_LoopField
        }
        n := StrLen(sentence)
        Send "{Backspace " n "}"
        SendText result
        buf := SubStr(buf, 1, StrLen(buf) - n) . result
    }
}

; ── Hotkeys ───────────────────────────────────────────────────────────────────

; Alt+Q — המרת מילה אחרונה (מהיר)
!q::ConvertWord()

; Double-tap RShift — גיבוי
~RShift:: {
    global lastShift
    now := A_TickCount
    if now - lastShift < 400 {
        lastShift := 0
        ConvertWord()
    } else {
        lastShift := now
    }
}

; ── Tray ──────────────────────────────────────────────────────────────────────
A_IconTip := "Hebrew/English Fixer — Alt+Q"
try TraySetIcon "shell32.dll", 315

tray := A_TrayMenu
tray.Delete()
tray.Add("Convert Last Word     Alt+Q", (*) => ConvertWord())
tray.Add("Convert Last Sentence",        (*) => ConvertSentence())
tray.Add()
tray.Add("Exit", (*) => ExitApp())
