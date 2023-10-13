@rem compile.bat

@echo off

@call systemcheck.exe remove
@call systemcheck32.exe remove

@call "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in systemcheck.ahk /out systemcheck.exe /icon systemcheck.ico /bin "C:\Program Files\AutoHotkey\Compiler\Unicode 64-bit.bin"

@call "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in systemcheck.ahk /out systemcheck32.exe /icon systemcheck.ico /bin "C:\Program Files\AutoHotkey\Compiler\Unicode 32-bit.bin"



