/*
 *********************************************************************************
 * 
 * systemcheck.ahk
 * 
 * all files are UTF-8 no BOM encoded
 * 
 * Version -> appVersion
 * 
 * Copyright (c) 2021 jvr.de. All rights reserved.
 *
 * Licens -> Licenses.txt
 * 
 *********************************************************************************
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance force

Loop % A_Args.Length()
{
  if(eq(A_Args[A_index],"remove"))
    exit()
}

SendMode Input
SetWorkingDir %A_ScriptDir%

FileEncoding, UTF-8-RAW
SetTitleMatchMode, 2

wrkDir := A_ScriptDir . "\"

bit := (A_PtrSize == 8 ? "64" : "32")

bitName := (bit="64" ? "" : bit)

appName := "Systemcheck"
appnameLower := "systemcheck"
extension := ".exe"
appVersion := "0.010"
app := appName . " " . appVersion . " " . bit . "-bit"

;iniFile := wrkDir . "systemcheck.ini"
cmdsFile := wrkDir . "systemcheck.txt"

system := "https://github.com/jvr-ks/" . appnameLower . "/raw/main/"

exeFilename := appnameLower . bitName . extension


cmdsArr := []
selectedCommand := ""

if (!FileExist(cmdsFile)){
  msgbox, ERROR`, the commands-file:`n"%cmdsFile%"`nis missing!
}

readCommands()
mainWindow()

return

;-------------------------------- mainWindow --------------------------------
mainWindow() {
  global app
  global appName
  global appVersion  

  global bit
  global hMain
  global cmdsArr
  global LV1
  global Text1
  
  Menu, Tray, UseErrorLevel
  
  Menu, MainMenuWeb, Add, Github, openGithub
  Menu, MainMenuWeb, Add, Sysinternals, openSysinternals
  
  Menu, MainMenu, Add, Edit Commands, editCommandsFile
  Menu, MainMenu, Add, Update-check, updateApp
  Menu, MainMenu, Add, Internet, :MainMenuWeb 
  Menu, MainMenu, Add, Exit, exit
  
  Gui,guiMain:New, +OwnDialogs +LastFound -MaximizeBox HwndhMain, %app%

  Gui, Margin,6,4
  Gui, guiMain:Font, s10, Segoe UI

  lv1Width := 500
  lv1Height := 200
  editHeight := lv1Height + 30
  
  Gui, guiMain:Add, ListView, x5 y5 h%lv1Height% w%lv1Width% gLVCommands vLV1 hwndhLV1 Grid AltSubmit -Multi NoSortHdr -LV0x10, |Command
  Gui, guiMain:Add, Edit, x5 r20 w%lv1Width% y%editHeight% vText1
  
  for index, command in cmdsArr
  {
    row := LV_Add("",index,command)
  }
  
  LV_ModifyCol(1,"AutoHdr Integer")
  LV_ModifyCol(2,"AutoHdr Text")
  

  Menu, MainMenu, Add, Exit, exit
  Gui, guiMain:Menu, MainMenu
  
  Gui, guiMain:Add, StatusBar, 0x800 hWndhMySB
  
  Gui, guiMain:Show, autosize center
  
  showStatus("")
  
  return
}
;-------------------------------- LVCommands --------------------------------
LVCommands(){
  global selectedCommand
  global cmdsArr
    
  if (A_GuiEvent == "Normal" || A_GuiEvent == "DoubleClick"){
    selectedCommand := cmdsArr[A_EventInfo]

    foundUnhidden := RegExMatch(selectedCommand,"Oi)(\[unhidden])", match, 1)
    foundNoAdmin := RegExMatch(selectedCommand,"Oi)(\[noAdmin])", match, 1)
    foundAutoclose := RegExMatch(selectedCommand,"Oi)(\[autoclose])", match, 1)
    
    selectedCommand := modifyCommand(selectedCommand)
    
    GuiControl,guiMain:,Text1,
      
    if (selectedCommand != ""){
      GuiControl,guiMain:,Text1,Executing may take a while`,`n`nplease be patient ...
      showstatus("Run command: " . selectedCommand)
      
      consoleModifier := "/k"
      if (foundAutoclose)
        consoleModifier := "/c"
      
      result := ""
      if (foundUnhidden){
        GuiControl,guiMain:,Text1,Using a console window!
        
        if (foundNoAdmin)
          runwait, %comspec% %consoleModifier% %selectedCommand%
        else
          runwait, *RunAs %comspec% %consoleModifier% %selectedCommand%
        
        GuiControl,guiMain:,Text1,
      } else {
        if (foundNoAdmin)
          runwait, %comspec% /c %selectedCommand% | clip,,hide
        else
          runwait, *RunAs %comspec% /c %selectedCommand% | clip,,hide
        
        result := clipboard
        GuiControl,guiMain:,Text1,%result%
        showstatus("Result is copied to the clipboard!")
      }
    } else {
      showstatus("Command is empty! ")
    }
  }

  return
}
;------------------------------- modifyCommand -------------------------------
modifyCommand(s){

  locale := getLocale()

  s := StrReplace(s, "[locale]", locale)
  
  s := RegExReplace(s, "\[.*?]", "")
  
  return s
}
;------------------------------- readCommands -------------------------------
readCommands(){
  global cmdsFile
  global cmdsArr

  cmdsArr := []

  Loop, read, %cmdsFile%
  {
    if (A_LoopReadLine != "") {
      cmdsArr.Push(A_LoopReadLine)
    }
  }
  
  return
}
;-------------------------------- showStatus --------------------------------
showStatus(s){

  SB_SetParts(400)
  SB_SetText(" " . s , 1, 1)

  memory := "[" . GetProcessMemoryUsage() . " MB]      "
  SB_SetText("`t`t" . memory , 2, 2)

  return
}
;--------------------------- GetProcessMemoryUsage ---------------------------
GetProcessMemoryUsage() {
    PID := DllCall("GetCurrentProcessId")
    size := 440
    VarSetCapacity(pmcex,size,0)
    ret := ""
    
    hProcess := DllCall( "OpenProcess", UInt,0x400|0x0010,Int,0,Ptr,PID, Ptr )
    if (hProcess)
    {
        if (DllCall("psapi.dll\GetProcessMemoryInfo", Ptr, hProcess, Ptr, &pmcex, UInt,size))
            ret := Round(NumGet(pmcex, (A_PtrSize=8 ? "16" : "12"), "UInt") / 1024**2, 2)
        DllCall("CloseHandle", Ptr, hProcess)
    }
    return % ret
}
;--------------------------- getVersionFromGithub ---------------------------
getVersionFromGithub(){
  global appnameLower

  r := "unknown!"
  url := "https://github.com/jvr-ks/" . appnameLower . "/raw/main/version.txt"
  whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
  Try
  {
    whr.Open("GET", url)
    whr.Send()
    Sleep 500
    status := whr.Status
    if (status == 200)
      r := whr.ResponseText
  }
  catch e
  {
    msgbox, Connection to %url% failed! [Error: %e%]
  }

  return r
}
;-------------------------- checkVersionFromGithub --------------------------
checkVersionFromGithub(){
  global appVersion
  global msgDefault
  global MainStatusBarHwnd
  
  ret := false
  
  vers := getVersionFromGithub()
  if (vers != "unknown"){
    if (vers > appVersion){
      msg := "New version available, this is: " . appVersion . ", available on Github is: " . vers
      SB_SetParts()
      SB_SetText(" " . msg , 1, 1)
      SendMessage, 0x2001, 0, 0x9999FF,, ahk_id %MainStatusBarHwnd%
      SendMessage, 0x0133, 0, 0xFFFFFF,, ahk_id %MainStatusBarHwnd%
      openGithubDownloadPage()
      ret := true
    }
  }
  
  return ret
}
;--------------------------------- updateApp ---------------------------------
updateApp(){
  global appName
  global bitName
  global appVersion

  vers := getVersionFromGithub()
  if (vers != "unknown"){
    if (vers > appVersion){
      msg := "This is: " . appVersion . ", available on Github is: " . vers . " update now?"
      MsgBox , 1, Update available!, %msg%
      
      IfMsgBox, OK
        {
          openGithubDownloadPage()
          exitApp
        }
    } else {
      msgbox, This version: %appVersion%, available version %vers%, no update available!
    }
  }
  return
}
;-------------------------- openGithubDownloadPage --------------------------
openGithubDownloadPage(){
  global appnameLower
  
  Run https://github.com/jvr-ks/%appnameLower%/raw/main/%appnameLower%.exe

  return
}
;------------------------------- editCommandsFile -------------------------------
editCommandsFile() {
  global cmdsFile
  
  f := "notepad.exe" . " " . cmdsFile
  showStatus("Please close the editor!")
  runWait %f%,,max
  
  refreshGui()
}
;-------------------------------- refreshGui --------------------------------
refreshGui(){
  global cmdsArr
  global selectedCommand

  cmdsArr := []
  selectedCommand := ""

  readCommands()

  LV_Delete()
  
  for index, url in cmdsArr
  {
    row := LV_Add("",index,url)
  }
  
  showStatus("")
  
  return
}
;------------------------------------ eq ------------------------------------
eq(a, b) {
  if (InStr(a, b) && InStr(b, a))
    return 1
  return 0
}
;--------------------------------- showHint ---------------------------------
; showHint(s, n){
  ; global hinttimer
  ; global font
  ; global fontsize
  
  ; Gui, hint:Font, %fontsize%, %font%
  ; Gui, hint:Add, Text,, %s%
  ; Gui, hint:-Caption
  ; Gui, hint:+ToolWindow
  ; Gui, hint:+AlwaysOnTop
  ; Gui, hint:Show
  ; t := -1 * n
  ; setTimer,showHintDestroy, %t%
  ; return
; }
;------------------------------ showHintDestroy ------------------------------
; showHintDestroy(){
  ; global hinttimer

  ; setTimer,showHintDestroy, delete
  ; Gui, hint:Destroy
  ; return
; }
;------------------------------ guiMainGuiClose ------------------------------
guiMainGuiClose(){
  exit()

  return
}
;-------------------------------- openGithub --------------------------------
openGithub(){
  global appnameLower
  
  Run https://github.com/jvr-ks/%appnameLower%
  
  return
}
;----------------------------- openSysinternals -----------------------------
openSysinternals(){
  global appnameLower
  
  locale := getLocale()
  Run https://learn.microsoft.com/%locale%/sysinternals

  return
}
;--------------------------------- getLocale ---------------------------------
getLocale() {
  RegRead, theLocale, HKEY_CURRENT_USER\Control Panel\International, LocaleName
  
  return theLocale
}
;----------------------------------- exit -----------------------------------
exit(){
  ExitApp
}
;----------------------------------------------------------------------------
