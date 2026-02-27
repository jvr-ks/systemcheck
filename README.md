# Systemcheck

The app can execute Windows console commands (always as an administrator!).  
I use it to execute check/repair commands,  
so I don't have to remember this rarely used ones.  
  
Commands are read from the file "systemcheck.txt"  
and executed in a hidden console window.  
Click on an entry to execute the command.  

The result is displayed only after the command has finished (using the clipboard).  
Add the word "\[unhidden]" to the command to execute it in an unhidden console window.  
If the command requires a userinput (like "chkdsk ...") the "\[unhidden]" parameter is always required!  

  
#### App-start  
**systemcheck.exe** 64 bit Windows  
**systemcheck32.exe** 32 bit Windows  
  
#### Download  
[Virusscan](#virusscan) at Virustotal, see below.  

from github, these files are essential:  
  
List of Commands (editable with notepad etc.):  
[systemcheck.txt](https://github.com/jvr-ks/systemcheck/raw/main/systemcheck.txt)  
and  
[systemcheck.exe 64bit](https://github.com/jvr-ks/systemcheck/raw/main/systemcheck.exe)  
or  
[systemcheck32.exe 32bit](https://github.com/jvr-ks/systemcheck/raw/main/systemcheck32.exe)  
  
**Be shure to use only one of the \*.exe at a time!**  
  
From time to time there are some false positive virus detections,  
especially if using only Windows Defender!
  
#### Control-modifier  
  
Modifier | Description  
------------ | -------------  
\[unhidden] | use an unhidden console window  
\[noAdmin] | do not request admin-privileges to run the command  
\[autoclose] | closes the console window after running the command (in conjunction with \[unhidden])
\[locale] | replace "[locale]" with the language code, like "en_US"  
\[all other text] | undefined modifier are treated as a comment

Control-modifiers are not case-sensitive.  
  
#### Sourcecode: [Autohotkey format](https://www.autohotkey.com)  
* "systemcheck.ahk"  
 
#### Requirements  
* Windows 10 or later only.  
  
#### Sourcecode  
Github URL [github](https://github.com/jvr-ks/systemcheck).

#### Latest changes: 
  
Version (>=)| Change
------------ | -------------
0.003 | [long] replace by [unhidden]
0.001 | First edition


#### License: MIT  
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sub-license, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANT-ABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Copyright (c) 2021 J. v. Roos

<a name="virusscan"></a>
##### Virusscan at Virustotal 
[Virusscan at Virustotal, systemcheck.exe 64bit-exe, Check here](https://www.virustotal.com/gui/url/1756849eaf337043c1ecd4a4d8764f9c4c67e4c09cca1de500911fe2491276a1/detection/u-1756849eaf337043c1ecd4a4d8764f9c4c67e4c09cca1de500911fe2491276a1-1772216461
)  
[Virusscan at Virustotal, systemcheck32.exe 32bit-exe, Check here](https://www.virustotal.com/gui/url/8f6f0fe309541f0d4f20f12d6ea2256e096e8da59342a2a115554f0abb569136/detection/u-8f6f0fe309541f0d4f20f12d6ea2256e096e8da59342a2a115554f0abb569136-1772216462
)  
