##  This file is autogenerated; please do not commit directly.

type XkbKeySym* = distinct int

const
  XKB_KEY_NoSymbol* = XkbKeySym 0x000000

## **********************************************************
## Copyright 1987, 1994, 1998  The Open Group
##
## Permission to use, copy, modify, distribute, and sell this software and its
## documentation for any purpose is hereby granted without fee, provided that
## the above copyright notice appear in all copies and that both that
## copyright notice and this permission notice appear in supporting
## documentation.
##
## The above copyright notice and this permission notice shall be included
## in all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
## OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
## MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
## IN NO EVENT SHALL THE OPEN GROUP BE LIABLE FOR ANY CLAIM, DAMAGES OR
## OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
## ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
## OTHER DEALINGS IN THE SOFTWARE.
##
## Except as contained in this notice, the name of The Open Group shall
## not be used in advertising or otherwise to promote the sale, use or
## other dealings in this Software without prior written authorization
## from The Open Group.
##
##
## Copyright 1987 by Digital Equipment Corporation, Maynard, Massachusetts
##
##                         All Rights Reserved
##
## Permission to use, copy, modify, and distribute this software and its
## documentation for any purpose and without fee is hereby granted,
## provided that the above copyright notice appear in all copies and that
## both that copyright notice and this permission notice appear in
## supporting documentation, and that the name of Digital not be
## used in advertising or publicity pertaining to distribution of the
## software without specific, written prior permission.
##
## DIGITAL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
## ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL
## DIGITAL BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR
## ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
## WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
## ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
## SOFTWARE.
##
## ****************************************************************
##
##  The "X11 Window System Protocol" standard defines in Appendix A the
##  keysym codes. These 29-bit integer values identify characters or
##  functions associated with each key (e.g., via the visible
##  engraving) of a keyboard layout. This file assigns mnemonic macro
##  names for these keysyms.
##
##  This file is also compiled (by src/util/makekeys.c in libX11) into
##  hash tables that can be accessed with X11 library functions such as
##  XStringToKeysym() and XKeysymToString().
##
##  Where a keysym corresponds one-to-one to an ISO 10646 / Unicode
##  character, this is noted in a comment that provides both the U+xxxx
##  Unicode position, as well as the official Unicode name of the
##  character.
##
##  Where the correspondence is either not one-to-one or semantically
##  unclear, the Unicode position and name are enclosed in
##  parentheses. Such legacy keysyms should be considered deprecated
##  and are not recommended for use in future keyboard mappings.
##
##  For any future extension of the keysyms with characters already
##  found in ISO 10646 / Unicode, the following algorithm shall be
##  used. The new keysym code position will simply be the character's
##  Unicode number plus 0x01000000. The keysym values in the range
##  0x01000100 to 0x0110ffff are reserved to represent Unicode
##  characters in the range U+0100 to U+10FFFF.
##
##  While most newer Unicode-based X11 clients do already accept
##  Unicode-mapped keysyms in the range 0x01000100 to 0x0110ffff, it
##  will remain necessary for clients -- in the interest of
##  compatibility with existing servers -- to also understand the
##  existing legacy keysym values in the range 0x0100 to 0x20ff.
##
##  Where several mnemonic names are defined for the same keysym in this
##  file, all but the first one listed should be considered deprecated.
##
##  Mnemonic names for keysyms are defined in this file with lines
##  that match one of these Perl regular expressions:
##
##     /^\#define XKB_KEY_([a-zA-Z_0-9]+)\s+0x([0-9a-f]+)\s*\/\* U\+([0-9A-F]{4,6}) (.*) \*\/\s*$/
##     /^\#define XKB_KEY_([a-zA-Z_0-9]+)\s+0x([0-9a-f]+)\s*\/\*\(U\+([0-9A-F]{4,6}) (.*)\)\*\/\s*$/
##     /^\#define XKB_KEY_([a-zA-Z_0-9]+)\s+0x([0-9a-f]+)\s*(\/\*\s*(.*)\s*\*\/)?\s*$/
##
##  Before adding new keysyms, please do consider the following: In
##  addition to the keysym names defined in this file, the
##  XStringToKeysym() and XKeysymToString() functions will also handle
##  any keysym string of the form "U0020" to "U007E" and "U00A0" to
##  "U10FFFF" for all possible Unicode characters. In other words,
##  every possible Unicode character has already a keysym string
##  defined algorithmically, even if it is not listed here. Therefore,
##  defining an additional keysym macro is only necessary where a
##  non-hexadecimal mnemonic name is needed, or where the new keysym
##  does not represent any existing Unicode character.
##
##  When adding new keysyms to this file, do not forget to also update the
##  following as needed:
##
##    - the mappings in src/KeyBind.c in the libX11 repo
##      https://gitlab.freedesktop.org/xorg/lib/libx11
##
##    - the protocol specification in specs/keysyms.xml in this repo
##      https://gitlab.freedesktop.org/xorg/proto/xorgproto
##
##

const
  XKB_KEY_VoidSymbol* = XkbKeySym 0xffffff

##
##  TTY function keys, cleverly chosen to map to ASCII, for convenience of
##  programming, but could have been arbitrary (at the cost of lookup
##  tables in client code).
##

const
  XKB_KEY_BackSpace* = XkbKeySym 0xff08
  XKB_KEY_Tab* = XkbKeySym 0xff09
  XKB_KEY_Linefeed* = XkbKeySym 0xff0a
  XKB_KEY_Clear* = XkbKeySym 0xff0b
  XKB_KEY_Return* = XkbKeySym 0xff0d
  XKB_KEY_Pause* = XkbKeySym 0xff13
  XKB_KEY_Scroll_Lock* = XkbKeySym 0xff14
  XKB_KEY_Sys_Req* = XkbKeySym 0xff15
  XKB_KEY_Escape* = XkbKeySym 0xff1b
  XKB_KEY_Delete* = XkbKeySym 0xffff

##  International & multi-key character composition

const
  XKB_KEY_Multi_key* = XkbKeySym 0xff20
  XKB_KEY_Codeinput* = XkbKeySym 0xff37
  XKB_KEY_SingleCandidate* = XkbKeySym 0xff3c
  XKB_KEY_MultipleCandidate* = XkbKeySym 0xff3d
  XKB_KEY_PreviousCandidate* = XkbKeySym 0xff3e

##  Japanese keyboard support

const
  XKB_KEY_Kanji* = XkbKeySym 0xff21
  XKB_KEY_Muhenkan* = XkbKeySym 0xff22
  XKB_KEY_Henkan_Mode* = XkbKeySym 0xff23
  XKB_KEY_Henkan* = XkbKeySym 0xff23
  XKB_KEY_Romaji* = XkbKeySym 0xff24
  XKB_KEY_Hiragana* = XkbKeySym 0xff25
  XKB_KEY_Katakana* = XkbKeySym 0xff26
  XKB_KEY_Hiragana_Katakana* = XkbKeySym 0xff27
  XKB_KEY_Zenkaku* = XkbKeySym 0xff28
  XKB_KEY_Hankaku* = XkbKeySym 0xff29
  XKB_KEY_Zenkaku_Hankaku* = XkbKeySym 0xff2a
  XKB_KEY_Touroku* = XkbKeySym 0xff2b
  XKB_KEY_Massyo* = XkbKeySym 0xff2c
  XKB_KEY_Kana_Lock* = XkbKeySym 0xff2d
  XKB_KEY_Kana_Shift* = XkbKeySym 0xff2e
  XKB_KEY_Eisu_Shift* = XkbKeySym 0xff2f
  XKB_KEY_Eisu_toggle* = XkbKeySym 0xff30
  XKB_KEY_Kanji_Bangou* = XkbKeySym 0xff37
  XKB_KEY_Zen_Koho* = XkbKeySym 0xff3d
  XKB_KEY_Mae_Koho* = XkbKeySym 0xff3e

##  0xff31 thru 0xff3f are under XK_KOREAN
##  Cursor control & motion

const
  XKB_KEY_Home* = XkbKeySym 0xff50
  XKB_KEY_Left* = XkbKeySym 0xff51
  XKB_KEY_Up* = XkbKeySym 0xff52
  XKB_KEY_Right* = XkbKeySym 0xff53
  XKB_KEY_Down* = XkbKeySym 0xff54
  XKB_KEY_Prior* = XkbKeySym 0xff55
  XKB_KEY_Page_Up* = XkbKeySym 0xff55
  XKB_KEY_Next* = XkbKeySym 0xff56
  XKB_KEY_Page_Down* = XkbKeySym 0xff56
  XKB_KEY_End* = XkbKeySym 0xff57
  XKB_KEY_Begin* = XkbKeySym 0xff58

##  Misc functions

const
  XKB_KEY_Select* = XkbKeySym 0xff60
  XKB_KEY_Print* = XkbKeySym 0xff61
  XKB_KEY_Execute* = XkbKeySym 0xff62
  XKB_KEY_Insert* = XkbKeySym 0xff63
  XKB_KEY_Undo* = XkbKeySym 0xff65
  XKB_KEY_Redo* = XkbKeySym 0xff66
  XKB_KEY_Menu* = XkbKeySym 0xff67
  XKB_KEY_Find* = XkbKeySym 0xff68
  XKB_KEY_Cancel* = XkbKeySym 0xff69
  XKB_KEY_Help* = XkbKeySym 0xff6a
  XKB_KEY_Break* = XkbKeySym 0xff6b
  XKB_KEY_Mode_switch* = XkbKeySym 0xff7e
  XKB_KEY_script_switch* = XkbKeySym 0xff7e
  XKB_KEY_Num_Lock* = XkbKeySym 0xff7f

##  Keypad functions, keypad numbers cleverly chosen to map to ASCII

const
  XKB_KEY_KP_Space* = XkbKeySym 0xff80
  XKB_KEY_KP_Tab* = XkbKeySym 0xff89
  XKB_KEY_KP_Enter* = XkbKeySym 0xff8d
  XKB_KEY_KP_F1* = XkbKeySym 0xff91
  XKB_KEY_KP_F2* = XkbKeySym 0xff92
  XKB_KEY_KP_F3* = XkbKeySym 0xff93
  XKB_KEY_KP_F4* = XkbKeySym 0xff94
  XKB_KEY_KP_Home* = XkbKeySym 0xff95
  XKB_KEY_KP_Left* = XkbKeySym 0xff96
  XKB_KEY_KP_Up* = XkbKeySym 0xff97
  XKB_KEY_KP_Right* = XkbKeySym 0xff98
  XKB_KEY_KP_Down* = XkbKeySym 0xff99
  XKB_KEY_KP_Prior* = XkbKeySym 0xff9a
  XKB_KEY_KP_Page_Up* = XkbKeySym 0xff9a
  XKB_KEY_KP_Next* = XkbKeySym 0xff9b
  XKB_KEY_KP_Page_Down* = XkbKeySym 0xff9b
  XKB_KEY_KP_End* = XkbKeySym 0xff9c
  XKB_KEY_KP_Begin* = XkbKeySym 0xff9d
  XKB_KEY_KP_Insert* = XkbKeySym 0xff9e
  XKB_KEY_KP_Delete* = XkbKeySym 0xff9f
  XKB_KEY_KP_Equal* = XkbKeySym 0xffbd
  XKB_KEY_KP_Multiply* = XkbKeySym 0xffaa
  XKB_KEY_KP_Add* = XkbKeySym 0xffab
  XKB_KEY_KP_Separator* = XkbKeySym 0xffac
  XKB_KEY_KP_Subtract* = XkbKeySym 0xffad
  XKB_KEY_KP_Decimal* = XkbKeySym 0xffae
  XKB_KEY_KP_Divide* = XkbKeySym 0xffaf
  XKB_KEY_KP_0* = XkbKeySym 0xffb0
  XKB_KEY_KP_1* = XkbKeySym 0xffb1
  XKB_KEY_KP_2* = XkbKeySym 0xffb2
  XKB_KEY_KP_3* = XkbKeySym 0xffb3
  XKB_KEY_KP_4* = XkbKeySym 0xffb4
  XKB_KEY_KP_5* = XkbKeySym 0xffb5
  XKB_KEY_KP_6* = XkbKeySym 0xffb6
  XKB_KEY_KP_7* = XkbKeySym 0xffb7
  XKB_KEY_KP_8* = XkbKeySym 0xffb8
  XKB_KEY_KP_9* = XkbKeySym 0xffb9

##
##  Auxiliary functions; note the duplicate definitions for left and right
##  function keys;  Sun keyboards and a few other manufacturers have such
##  function key groups on the left and/or right sides of the keyboard.
##  We've not found a keyboard with more than 35 function keys total.
##

const
  XKB_KEY_F1* = XkbKeySym 0xffbe
  XKB_KEY_F2* = XkbKeySym 0xffbf
  XKB_KEY_F3* = XkbKeySym 0xffc0
  XKB_KEY_F4* = XkbKeySym 0xffc1
  XKB_KEY_F5* = XkbKeySym 0xffc2
  XKB_KEY_F6* = XkbKeySym 0xffc3
  XKB_KEY_F7* = XkbKeySym 0xffc4
  XKB_KEY_F8* = XkbKeySym 0xffc5
  XKB_KEY_F9* = XkbKeySym 0xffc6
  XKB_KEY_F10* = XkbKeySym 0xffc7
  XKB_KEY_F11* = XkbKeySym 0xffc8
  XKB_KEY_L1* = XkbKeySym 0xffc8
  XKB_KEY_F12* = XkbKeySym 0xffc9
  XKB_KEY_L2* = XkbKeySym 0xffc9
  XKB_KEY_F13* = XkbKeySym 0xffca
  XKB_KEY_L3* = XkbKeySym 0xffca
  XKB_KEY_F14* = XkbKeySym 0xffcb
  XKB_KEY_L4* = XkbKeySym 0xffcb
  XKB_KEY_F15* = XkbKeySym 0xffcc
  XKB_KEY_L5* = XkbKeySym 0xffcc
  XKB_KEY_F16* = XkbKeySym 0xffcd
  XKB_KEY_L6* = XkbKeySym 0xffcd
  XKB_KEY_F17* = XkbKeySym 0xffce
  XKB_KEY_L7* = XkbKeySym 0xffce
  XKB_KEY_F18* = XkbKeySym 0xffcf
  XKB_KEY_L8* = XkbKeySym 0xffcf
  XKB_KEY_F19* = XkbKeySym 0xffd0
  XKB_KEY_L9* = XkbKeySym 0xffd0
  XKB_KEY_F20* = XkbKeySym 0xffd1
  XKB_KEY_L10* = XkbKeySym 0xffd1
  XKB_KEY_F21* = XkbKeySym 0xffd2
  XKB_KEY_R1* = XkbKeySym 0xffd2
  XKB_KEY_F22* = XkbKeySym 0xffd3
  XKB_KEY_R2* = XkbKeySym 0xffd3
  XKB_KEY_F23* = XkbKeySym 0xffd4
  XKB_KEY_R3* = XkbKeySym 0xffd4
  XKB_KEY_F24* = XkbKeySym 0xffd5
  XKB_KEY_R4* = XkbKeySym 0xffd5
  XKB_KEY_F25* = XkbKeySym 0xffd6
  XKB_KEY_R5* = XkbKeySym 0xffd6
  XKB_KEY_F26* = XkbKeySym 0xffd7
  XKB_KEY_R6* = XkbKeySym 0xffd7
  XKB_KEY_F27* = XkbKeySym 0xffd8
  XKB_KEY_R7* = XkbKeySym 0xffd8
  XKB_KEY_F28* = XkbKeySym 0xffd9
  XKB_KEY_R8* = XkbKeySym 0xffd9
  XKB_KEY_F29* = XkbKeySym 0xffda
  XKB_KEY_R9* = XkbKeySym 0xffda
  XKB_KEY_F30* = XkbKeySym 0xffdb
  XKB_KEY_R10* = XkbKeySym 0xffdb
  XKB_KEY_F31* = XkbKeySym 0xffdc
  XKB_KEY_R11* = XkbKeySym 0xffdc
  XKB_KEY_F32* = XkbKeySym 0xffdd
  XKB_KEY_R12* = XkbKeySym 0xffdd
  XKB_KEY_F33* = XkbKeySym 0xffde
  XKB_KEY_R13* = XkbKeySym 0xffde
  XKB_KEY_F34* = XkbKeySym 0xffdf
  XKB_KEY_R14* = XkbKeySym 0xffdf
  XKB_KEY_F35* = XkbKeySym 0xffe0
  XKB_KEY_R15* = XkbKeySym 0xffe0

##  Modifiers

const
  XKB_KEY_Shift_L* = XkbKeySym 0xffe1
  XKB_KEY_Shift_R* = XkbKeySym 0xffe2
  XKB_KEY_Control_L* = XkbKeySym 0xffe3
  XKB_KEY_Control_R* = XkbKeySym 0xffe4
  XKB_KEY_Caps_Lock* = XkbKeySym 0xffe5
  XKB_KEY_Shift_Lock* = XkbKeySym 0xffe6
  XKB_KEY_Meta_L* = XkbKeySym 0xffe7
  XKB_KEY_Meta_R* = XkbKeySym 0xffe8
  XKB_KEY_Alt_L* = XkbKeySym 0xffe9
  XKB_KEY_Alt_R* = XkbKeySym 0xffea
  XKB_KEY_Super_L* = XkbKeySym 0xffeb
  XKB_KEY_Super_R* = XkbKeySym 0xffec
  XKB_KEY_Hyper_L* = XkbKeySym 0xffed
  XKB_KEY_Hyper_R* = XkbKeySym 0xffee

