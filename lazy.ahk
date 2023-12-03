#Persistent
#NoEnv
; 
; 
;          LazyBunnyStrafing
;          @elliottophellia
;      paypal.me/elliottophellia
;
;
SetBatchLines, -1

Process, Priority, , R
StrafingActive := BunnyHopActive := 0

Gui, Color, 2e3440
my_picturefile = %A_Temp%\lazy.png
FileInstall, lazy.png, %my_picturefile%, 1
Gui, Add, Picture, w260 h260, %my_picturefile%
Gui, Font, s12 Bold cWhite, Arial
Gui, Add, Text, x290 y15, _____________________
Gui, Font, s16 cWhite, Arial
Gui, Add, Text, x290 y45, LazyBunnyStrafing
Gui, Font, s12 cWhite, Arial
Gui, Add, Text, x290 y70, @elliottophellia   -   v1.0.0
Gui, Add, Text, x290 y90, _____________________
Gui, Add, Text, x290 y120, paypal.me/elliottophellia`nsaweria.co/elliottophellia
Gui, Add, Text, x290 y160, _____________________

Gui, Font, s12 cRed, Arial
Gui, Add, Text, x290 y190 vStrafingStatusRed, F6 MACRO : OFF
Gui, Font, s12 cGreen, Arial
Gui, Add, Text, x290 y190 vStrafingStatusGreen, F6 MACRO : ON
GuiControl, Hide, StrafingStatusGreen

Gui, Font, s12 cRed, Arial
Gui, Add, Text, x290 y210 vBunnyHopStatusRed, F5 MACRO : OFF
Gui, Font, s12 cGreen, Arial
Gui, Add, Text, x290 y210 vBunnyHopStatusGreen, F5 MACRO : ON
GuiControl, Hide, BunnyHopStatusGreen

Gui, Font, s12 cWhite, Arial
Gui, Add, Text, x290 y230, _____________________

Gui, Font, s9 cYellow, Arial
Gui, Add, Text, x10 y270, NOTE : 
Gui, Font, s8 cWhite, Arial
Gui, Add, Text, x10 y285, F6 - COUNTER STRAFING ( AUTOMATIC )`nF5 - BUNNY HOP ( SEMI-AUTO - HOLD SPACE AND STRAFING WHILE JUMPING )`nPLEASE ADD THIS (
Gui, Font, s8 cYellow, Arial
Gui, Add, Text, x115 y315, bind mwheeldown "+jump;"
Gui, Font, s8 cWhite, Arial
Gui, Add, Text, x273 y315, ) IN YOUR AUTOEXEC.CFG

Gui, Show, w510 h335, LazyBunnyStrafing
return

F6::
ToggleStatus(StrafingActive, "StrafingStatusRed", "StrafingStatusGreen")
return

F5::
ToggleStatus(BunnyHopActive, "BunnyHopStatusRed", "BunnyHopStatusGreen")
return

~*Space::
BunnyKey := "Space"
64INMS := 15.6
counter := 0

While (BunnyHopActive = 1)
{
    ; If the BunnyKey is pressed
    If GetKeyState(BunnyKey, "P") 
    {
        ; Perform a mouse wheel down action
        MouseClick, WheelDown
        Sleep, % (64INMS * 1)
        MouseClick, WheelDown

        ; Increment the counter
        counter := counter + 1

        ; If the counter reaches 2
        if (counter = 2) {  
            ; Send a control down action
            Send, {LCtrl down}
            Sleep, % (64INMS * 1.5)
            Send, {LCtrl up}

            ; Reset the counter
            counter := 0
        }

        ; While the BunnyKey is still pressed
        While GetKeyState(BunnyKey, "P")
        {
            ; Perform a mouse wheel down action
            MouseClick, WheelDown
            Sleep, % (64INMS * 2)
        }
    }
    else
    {
        ; If the BunnyKey is not pressed, sleep for 1 ms
        Sleep, 1
    }
}
return

~*a up::
~*d up::
If (StrafingActive = 1)
{
    ; Extract the key from the hotkey
    key := StrReplace(A_ThisHotkey, "~*", "")
    key := StrReplace(key, " up", "")

    ; Determine the opposite key
    oppositeKey := key == "a" ? "d" : key == "d" ? "a" : key

    ; If the opposite key is pressed, exit the subroutine
    If (GetKeyState(oppositeKey,"P"))
        return

    ; Set a start time for the key press
    start := A_TickCount + 33

    ; Press the opposite key
    Send, {%oppositeKey% down}

    ; Wait until the opposite key is pressed or the time limit is reached
    While (!GetKeyState(oppositeKey,"P") && A_TickCount < start)
        Sleep 15

    ; If the opposite key is not pressed, release it
    If !GetKeyState(oppositeKey,"P")
        Send, {%oppositeKey% up}

    ; Wait until the opposite key is released
    KeyWait, %oppositeKey%, U

    ; Log the key press
    ;FileAppend, %oppositeKey% - %start%`n, log.txt
}
return

GuiClose:
ExitApp

ToggleStatus(ByRef status, controlRed, controlGreen) {
    status := !status
    if (status) {
        GuiControl, Hide, %controlRed%
        GuiControl, Show, %controlGreen%
    } else {
        GuiControl, Show, %controlRed%
        GuiControl, Hide, %controlGreen%
    }
}