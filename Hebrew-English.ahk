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
    A_Clipboard := ""
    Send "^+{Left}"
    Sleep 50
    Send "^c"
    if !ClipWait(1) {
        A_Clipboard := old
        return
    }
    A_Clipboard := Convert(A_Clipboard)
    Sleep 30
    Send "^v"
    Sleep 30
    A_Clipboard := old
}

NumLock::DoConvert()

; Tray
A_IconTip := "Hebrew/English Fixer — NumLock"
menuTray := A_TrayMenu
menuTray.Delete()
menuTray.Add("Convert Word (CapsLock)", (*) => DoConvert())
menuTray.Add()
menuTray.Add("Exit", (*) => ExitApp())
