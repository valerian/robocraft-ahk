/*
Robocraft.ahk
Copyright (C) 2014 Valerian Gaudeau
This script is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.
This script is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.
You should have received a copy of the GNU Affero General Public License
along with this script. If not, see <http://www.gnu.org/licenses/>.
*/
;========================================================================
;
; Script: Robocraft
; Description: Hotkeys and map alerts for Robocraft
; URL (+info): 
;
; Last Update: 23/August/2014
;
; Created by Valerian Gaudeau
;
;========================================================================


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#singleInstance, Force
#MaxThreads, 100
#MaxThreadsPerHotkey, 2
#Persistent
SetBatchLines, -1
DetectHiddenWindows, On

CoordMode, Mouse, Relative
CoordMode, Pixel, Relative
CoordMode, Tooltip, Relative

SetKeyDelay, 30, 30
SetMouseDelay 5
SendMode Event
SetTitleMatchMode 1
#InstallKeybdHook
#InstallMouseHook
#UseHook, On

map_alert(location, message = "", message_end = "") {
	ifWinActive Robocraft
	{
		if (location == "minimap") {
			MouseGetPos, xpos, ypos
			WinGetPos,,, win_width, win_height
			map_size := (win_height * 100) / 332
			map_border := 10 + ((win_height) / 110)
			if (xpos > (win_width - map_size - map_border)
				&& ypos > (win_height - map_size - map_border)
				&& xpos < (win_width - map_border) && ypos < (win_height - map_border))
			{
				KeyWait Alt
				KeyWait Control
				KeyWait Shift
				xmap := Floor(1 + ((xpos - win_width + map_size + map_border) / (map_size / 10)))
				ymap := Floor(1 + ((ypos - win_height + map_size + map_border) / (map_size / 10)))
				ymap_letter := Chr(ymap + asc("A") - 1)
				location := " " . ymap_letter . "-" . xmap
			}
			else
			{
				return
			}
		}
		if (message == "" && message_end == "")
		{
			Send {Enter}
			Sleep 100
			if GetKeyState("Alt")
			{
				message := "[ff5500]Danger [ffffff]"
				message_end := "{!}"
			}
			else if GetKeyState("Ctrl")
			{
				message := "[4488ff]Attention [ffffff]to"
				message_end := ""
			}
			else if GetKeyState("PgUp")
			{
				message := "[4488ff]Too many [ffffff]people around "
				message_end := ""
			}
			else if GetKeyState("PgDn")
			{
				message := "[44ff44]Need more [ffffff]people around "
				message_end := "path"
			}
			else
			{
				message := "[ff5500]Need help [ffffff]"
				message_end := ""
			}
		}
		SendInput /msg  [b]%message%[ffff00]%location% [ffffff]%message_end%
		Sleep 200
		Send {Enter}
	}
}

clean_message(message, everyone = 0)
{
ifWinActive Robocraft
	{
	KeyWait Alt
	KeyWait Control
	KeyWait Shift
	BlockInput On
	if (everyone)
	{
		Send {Enter}`t%message%{Enter}{Enter}`t{Enter}
	}
	else
	{
		Send {Enter}%message%{Enter}
	}
	BlockInput Off
	}
}

~LButton::
map_alert("minimap", "[ff5500]Need help [ffffff]in", "{!}")
return

~RButton::
map_alert("minimap", "[ff5500]Danger [ffffff]in", "{!} be careful{!}")
return

~MButton::
map_alert("minimap", "[4488ff]Attention [ffffff]to", "")
return

~+LButton::
map_alert("minimap", "[ff5500]Need help [ffffff]in", "against [ffff00]flyer")
return

~XButton1::
map_alert("minimap", "[4488ff]Too many [ffffff]people around", "")
return

~XButton2::
map_alert("minimap", "[44ff44]Need more [ffffff]people on the path near", "")
return

*Numpad1::
map_alert("south-west")
return

*Numpad2::
map_alert("south")
return

*Numpad3::
map_alert("south-east")
return

*Numpad4::
map_alert("west")
return

*Numpad5::
map_alert("middle")
return

*Numpad6::
map_alert("east")
return

*Numpad7::
map_alert("north-west")
return

*Numpad8::
map_alert("north")
return

*Numpad9::
map_alert("north-east")
return

F1::
clean_message("Good Luck and Have Fun{!}", 1)
return

F2::
clean_message("Capture ennemy base{!}", 0)
return

F3::
clean_message("Defend our base{!}", 0)
return

F4::
clean_message("Good Game", 1)
return