If $CmdLine[0] = 0 Then
   Exit
Else
   Run($CmdLine[1])
EndIf

ConsoleWrite("sealsetup.exe started, waiting until window appears..." & @CRLF)
WinWait("SEAL Suite Setup")
Sleep(500)
WinActivate("SEAL Suite Setup")

; Welcome to SEAL Suite Setup Wizard
Sleep(500)
Send("!n")  ; Next

; License Agreement
Sleep(500)
Send("!a")   ; Agree

; Components
Send("{TAB}{TAB}{TAB}{SPACE}{TAB}{SPACE}{TAB}{TAB}{TAB}{TAB}{TAB}{SPACE}")  ; Select only netdome + OCON
Sleep(2000)
Send("!n") ; Next

; SEALService User Data
Send("{TAB}{TAB}")
Sleep(500)
Send("vagrant") ; User Name
Send("{TAB}")
Sleep(500)
Send("vagrant") ; Password
Send("{TAB}")
Send("") ; Domain (Optional)
Send("{TAB}")
Sleep(5000)
Send ("!n") ; Next

; Installation Folder
Sleep(500)
Send("!n") ; Next

; Choose Start Menu Folder
Sleep(500)
Send("!n") ; Next

; Customer Folder
Sleep(500)
Send("!n") ; Next

; Installation File
Sleep(500)
Send("!n") ; Next

; now tar.gz will be extracted which takes a long time...

; inst_package.pl
; ConsoleWrite("WinWait until security popup inst_package.pl appears..." & @CRLF)
; WinWait("Open File", "inst_package.pl")
; Sleep(500)
; WinActivate("Open File")
; 
; Send("!o") ; Open



; back to sealsetup installer
ConsoleWrite("WinWait until SEAL Suite Setup: Customer Data appears..." & @CRLF)
WinWait("SEAL Suite Setup: Customer Data")
Sleep(500)
WinActivate("SEAL Suite Setup: Customer Data")

Send("{TAB}{TAB}")
Send("vagrant") ; Name of Customer
Send("{TAB}{TAB}")
Send("500") ; Number of Devices
Send("{TAB}")
Send("") ; Checksum PLOSSYS
Send("{TAB}")
Send("{TAB}")
Send("{SPACE}") ; never expires
Send("!n") ; Next



; Installation Steps
ConsoleWrite("WinWait until Installation Steps appears..." & @CRLF)
WinWait("SEAL Suite Setup", "Installation Steps");
Sleep(500)
WinActivate("SEAL Suite Setup")

Send("!i") ; Install



; =============================================================
; Automate SEALService MSI
ConsoleWrite("WinWait until SEALService (64 bit) Setup appears..." & @CRLF)
WinWait("SEALService (64 bit) Setup")
Sleep(500)
WinActivate("SEALService (64 bit) Setup")

Send("!n") ; Next

; End-User Licsense Agreement
Sleep(1000)
ConsoleWrite("Send ALT-a + ALT-n")
Send("!a!n") ; Accept + Next

; User
Sleep(1000)
ConsoleWrite(", Send ALT-n")
Send("!n") ; Next (user already inserted by sealsetup.exe)

; Destination Folder
Sleep(1000)
ConsoleWrite(", Send ALT-n")
Send("!n") ; Next

; Ready to install
Sleep(1000)
ConsoleWrite(", Send ALT-i" & @CRLF)
Send("!i") ; Install

ConsoleWrite("WinWait until SEALService (64 bit) Setup Completed appears..." & @CRLF)
WinWait("SEALService (64 bit) Setup", "Completed")
ConsoleWrite(", Send ALT-f " & @CRLF)
Send("!f") ; Finish





Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
ConsoleWrite("WinWait until license.exe appears..." & @CRLF)
WinWait("license.exe")
Sleep(500)
WinActivate("license.exe")

; If you do not have this license.ini, then you have to enter the password manually
Dim $password
$password = IniRead("c:\vagrant\resources\license.ini", "license.exe", "password", "")
Send($password)  ; Enter Password
ConsoleWrite("Enter password >>" & $password & "<<" & @CRLF)
Send("{ENTER}")
; The license program will continue only after entering some input and not just ENTER key



; back to sealsetup installer
ConsoleWrite("WinWait until SEAL Suite Setup Completed appears..." & @CRLF)
WinWait("SEAL Suite Setup", "Completed")
Sleep(500)
WinActivate("SEAL Suite Setup")

Send("!n") ; Next

; Completing the SEAL Suite Setup Wizard
Send("!f") ; Finish


; addlocalsystem.pl
; ConsoleWrite("WinWait until addlocalsystem.pl appears..." & @CRLF)
; WinWait("Open File", "addlocalsystem.pl")
; Sleep(500)
; WinActivate("Open File")
; 
; Send("!o") ; Open

ConsoleWrite("Done!" & @CRLF)
