#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent()

heMap := Map(
    "e","ק", "r","ר", "t","א", "y","ט", "u","ו", "i","ן", "o","ם", "p","פ",
    "a","ש", "s","ד", "d","ג", "f","כ", "g","ע", "h","י", "j","ח", "k","ל",
    "l","ך", "z","ז", "x","ס", "c","ב", "v","ה", "b","נ", "n","מ", "m","צ",
    ";","ף", ",","ת", ".","ץ", "q","/", "w","'"
)
enMap := Map()
for eng, heb in heMap
    enMap[heb] := eng

IsHebrew(text) {
    loop parse, text {
        c := Ord(A_LoopField)
        if c >= 0x05D0 && c <= 0x05EA
            return true
    }
    return false
}

Convert(text) {
    result := ""
    if IsHebrew(text) {
        loop parse, text {
            ch := A_LoopField
            result .= enMap.Has(ch) ? enMap[ch] : ch
        }
    } else {
        loop parse, text {
            ch := StrLower(A_LoopField)
            result .= heMap.Has(ch) ? heMap[ch] : A_LoopField
        }
    }
    return result
}

DoConvert() {
    old := ClipboardAll()

    ; ── נסה להעתיק סלקשן קיים ──────────────────────────────────────────────
    A_Clipboard := ""
    Send "^c"
    hasSelection := ClipWait(0.15)   ; מחכה 150ms — אם יש סלקשן הוא יגיע

    ; ── אם אין סלקשן — בחר מילה אחרונה ──────────────────────────────────────
    if !hasSelection {
        A_Clipboard := ""
        Send "^+{Left}"
        Sleep 40
        Send "^c"
        if !ClipWait(0.5) {
            A_Clipboard := old
            return
        }
    }

    ; ── המר והדבק ────────────────────────────────────────────────────────────
    A_Clipboard := Convert(A_Clipboard)
    Sleep 30
    Send "^v"
    Sleep 30
    A_Clipboard := old
}

; Hotkey 1: Pause (= Fn+RShift on this laptop)
Pause::DoConvert()

; Hotkey 2: double-tap RShift within 300ms
~RShift:: {
    static lastTap := 0
    now := A_TickCount
    if (now - lastTap < 300) {
        lastTap := 0
        DoConvert()
    } else {
        lastTap := now
    }
}

; Tray
A_IconTip := "Hebrew/English Fixer — double-tap RShift or Fn+RShift"
menuTray := A_TrayMenu
menuTray.Delete()
menuTray.Add("Convert", (*) => DoConvert())
menuTray.Add()
menuTray.Add("Exit", (*) => ExitApp())
