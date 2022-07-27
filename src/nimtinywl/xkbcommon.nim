{.push dynLib:"libxkbcommon.so.(1 | 0)".}
import xkbkeysyms, xkbcommonnames
export xkbkeysyms, xkbcommonnames
#
##  Copyright 1985, 1987, 1990, 1998  The Open Group
##  Copyright 2008  Dan Nicholson
##
##  Permission is hereby granted, free of charge, to any person obtaining a
##  copy of this software and associated documentation files (the "Software"),
##  to deal in the Software without restriction, including without limitation
##  the rights to use, copy, modify, merge, publish, distribute, sublicense,
##  and/or sell copies of the Software, and to permit persons to whom the
##  Software is furnished to do so, subject to the following conditions:
##
##  The above copyright notice and this permission notice shall be included in
##  all copies or substantial portions of the Software.
##
##  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
##  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
##  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
##  AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
##  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
##  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
##
##  Except as contained in this notice, the names of the authors or their
##  institutions shall not be used in advertising or otherwise to promote the
##  sale, use or other dealings in this Software without prior written
##  authorization from the authors.
##
## ***********************************************************
##  Copyright (c) 1993 by Silicon Graphics Computer Systems, Inc.
##
##  Permission to use, copy, modify, and distribute this
##  software and its documentation for any purpose and without
##  fee is hereby granted, provided that the above copyright
##  notice appear in all copies and that both that copyright
##  notice and this permission notice appear in supporting
##  documentation, and that the name of Silicon Graphics not be
##  used in advertising or publicity pertaining to distribution
##  of the software without specific prior written permission.
##  Silicon Graphics makes no representation about the suitability
##  of this software for any purpose. It is provided "as is"
##  without any express or implied warranty.
##
##  SILICON GRAPHICS DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
##  SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
##  AND FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL SILICON
##  GRAPHICS BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL
##  DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
##  DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
##  OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION  WITH
##  THE USE OR PERFORMANCE OF THIS SOFTWARE.
##
## ******************************************************
##
##  Copyright © 2009-2012 Daniel Stone
##  Copyright © 2012 Intel Corporation
##  Copyright © 2012 Ran Benita
##
##  Permission is hereby granted, free of charge, to any person obtaining a
##  copy of this software and associated documentation files (the "Software"),
##  to deal in the Software without restriction, including without limitation
##  the rights to use, copy, modify, merge, publish, distribute, sublicense,
##  and/or sell copies of the Software, and to permit persons to whom the
##  Software is furnished to do so, subject to the following conditions:
##
##  The above copyright notice and this permission notice (including the next
##  paragraph) shall be included in all copies or substantial portions of the
##  Software.
##
##  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
##  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
##  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
##  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
##  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
##  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
##  DEALINGS IN THE SOFTWARE.
##
##  Author: Daniel Stone <daniel@fooishbar.org>
##

## *
##  @file
##  Main libxkbcommon API.
##
## *
##  @struct xkb_context
##  Opaque top level library context object.
##
##  The context contains various general library data and state, like
##  logging level and include paths.
##
##  Objects are created in a specific context, and multiple contexts may
##  coexist simultaneously.  Objects from different contexts are completely
##  separated and do not share any memory or state.
##

discard "forward decl of xkb_context"
discard "forward decl of xkb_keymap"
discard "forward decl of xkb_state"
type
  Context* = ptr object
  Keymap* = ptr object
  State* = ptr object
  xkb_keycode_t* = uint32

## *
##  A number used to represent the symbols generated from a key on a keyboard.
##
##  A key, represented by a keycode, may generate different symbols according
##  to keyboard state.  For example, on a QWERTY keyboard, pressing the key
##  labled \<A\> generates the symbol 'a'.  If the Shift key is held, it
##  generates the symbol 'A'.  If a different layout is used, say Greek,
##  it generates the symbol 'α'.  And so on.
##
##  Each such symbol is represented by a keysym.  Note that keysyms are
##  somewhat more general, in that they can also represent some "function",
##  such as "Left" or "Right" for the arrow keys.  For more information,
##  see:
##  https://www.x.org/releases/current/doc/xproto/x11protocol.html#keysym_encoding
##
##  Specifically named keysyms can be found in the
##  xkbcommon/xkbcommon-keysyms.h header file.  Their name does not include
##  the XKB_KEY_ prefix.
##
##  Besides those, any Unicode/ISO 10646 character in the range U0100 to
##  U10FFFF can be represented by a keysym value in the range 0x01000100 to
##  0x0110FFFF.  The name of Unicode keysyms is "U<codepoint>", e.g. "UA1B2".
##
##  The name of other unnamed keysyms is the hexadecimal representation of
##  their value, e.g. "0xabcd1234".
##
##  Keysym names are case-sensitive.
##

type
  xkb_keysym_t* = uint32

## *
##  Index of a keyboard layout.
##
##  The layout index is a state component which detemines which <em>keyboard
##  layout</em> is active.  These may be different alphabets, different key
##  arrangements, etc.
##
##  Layout indices are consecutive.  The first layout has index 0.
##
##  Each layout is not required to have a name, and the names are not
##  guaranteed to be unique (though they are usually provided and unique).
##  Therefore, it is not safe to use the name as a unique identifier for a
##  layout.  Layout names are case-sensitive.
##
##  Layout names are specified in the layout's definition, for example
##  "English (US)".  These are different from the (conventionally) short names
##  which are used to locate the layout, for example "us" or "us(intl)".  These
##  names are not present in a compiled keymap.
##
##  If the user selects layouts from a list generated from the XKB registry
##  (using libxkbregistry or directly), and this metadata is needed later on, it
##  is recommended to store it along with the keymap.
##
##  Layouts are also called "groups" by XKB.
##
##  @sa xkb_keymap_num_layouts() xkb_keymap_num_layouts_for_key()
##

type
  xkb_layout_index_t* = uint32

## * A mask of layout indices.

type
  xkb_layout_mask_t* = uint32

## *
##  Index of a shift level.
##
##  Any key, in any layout, can have several <em>shift levels</em>.  Each
##  shift level can assign different keysyms to the key.  The shift level
##  to use is chosen according to the current keyboard state; for example,
##  if no keys are pressed, the first level may be used; if the Left Shift
##  key is pressed, the second; if Num Lock is pressed, the third; and
##  many such combinations are possible (see xkb_mod_index_t).
##
##  Level indices are consecutive.  The first level has index 0.
##

type
  xkb_level_index_t* = uint32

## *
##  Index of a modifier.
##
##  A @e modifier is a state component which changes the way keys are
##  interpreted.  A keymap defines a set of modifiers, such as Alt, Shift,
##  Num Lock or Meta, and specifies which keys may @e activate which
##  modifiers (in a many-to-many relationship, i.e. a key can activate
##  several modifiers, and a modifier may be activated by several keys.
##  Different keymaps do this differently).
##
##  When retrieving the keysyms for a key, the active modifier set is
##  consulted; this detemines the correct shift level to use within the
##  currently active layout (see xkb_level_index_t).
##
##  Modifier indices are consecutive.  The first modifier has index 0.
##
##  Each modifier must have a name, and the names are unique.  Therefore, it
##  is safe to use the name as a unique identifier for a modifier.  The names
##  of some common modifiers are provided in the xkbcommon/xkbcommon-names.h
##  header file.  Modifier names are case-sensitive.
##
##  @sa xkb_keymap_num_mods()
##

type
  xkb_mod_index_t* = uint32

## * A mask of modifier indices.

type
  xkb_mod_mask_t* = uint32

## *
##  Index of a keyboard LED.
##
##  LEDs are logical objects which may be @e active or @e inactive.  They
##  typically correspond to the lights on the keyboard. Their state is
##  determined by the current keyboard state.
##
##  LED indices are non-consecutive.  The first LED has index 0.
##
##  Each LED must have a name, and the names are unique. Therefore,
##  it is safe to use the name as a unique identifier for a LED.  The names
##  of some common LEDs are provided in the xkbcommon/xkbcommon-names.h
##  header file.  LED names are case-sensitive.
##
##  @warning A given keymap may specify an exact index for a given LED.
##  Therefore, LED indexing is not necessarily sequential, as opposed to
##  modifiers and layouts.  This means that when iterating over the LEDs
##  in a keymap using e.g. xkb_keymap_num_leds(), some indices might be
##  invalid.  Given such an index, functions like xkb_keymap_led_get_name()
##  will return NULL, and xkb_state_led_index_is_active() will return -1.
##
##  LEDs are also called "indicators" by XKB.
##
##  @sa xkb_keymap_num_leds()
##

type
  xkb_led_index_t* = uint32

## * A mask of LED indices.

type
  xkb_led_mask_t* = uint32

const
  XKB_KEYCODE_INVALID* = (0xffffffff)
  XKB_LAYOUT_INVALID* = (0xffffffff)
  XKB_LEVEL_INVALID* = (0xffffffff)
  XKB_MOD_INVALID* = (0xffffffff)
  XKB_LED_INVALID* = (0xffffffff)
  XKB_KEYCODE_MAX* = (0xffffffff - 1)

## *
##  Test whether a value is a valid extended keycode.
##  @sa xkb_keycode_t
##

template xkb_keycode_is_legal_ext*(key: untyped): untyped =
  (key <= XKB_KEYCODE_MAX)

## *
##  Test whether a value is a valid X11 keycode.
##  @sa xkb_keycode_t
##

template xkb_keycode_is_legal_x11*(key: untyped): untyped =
  (key >= 8 and key <= 255)

## *
##  Names to compile a keymap with, also known as RMLVO.
##
##  The names are the common configuration values by which a user picks
##  a keymap.
##
##  If the entire struct is NULL, then each field is taken to be NULL.
##  You should prefer passing NULL instead of choosing your own defaults.
##

type
  xkb_rule_names* {.bycopy.} = object
    rules*: cstring ## *
                  ##  The rules file to use. The rules file describes how to interpret
                  ##  the values of the model, layout, variant and options fields.
                  ##
                  ##  If NULL or the empty string "", a default value is used.
                  ##  If the XKB_DEFAULT_RULES environment variable is set, it is used
                  ##  as the default.  Otherwise the system default is used.
                  ##
    ## *
    ##  The keyboard model by which to interpret keycodes and LEDs.
    ##
    ##  If NULL or the empty string "", a default value is used.
    ##  If the XKB_DEFAULT_MODEL environment variable is set, it is used
    ##  as the default.  Otherwise the system default is used.
    ##
    model*: cstring ## *
                  ##  A comma separated list of layouts (languages) to include in the
                  ##  keymap.
                  ##
                  ##  If NULL or the empty string "", a default value is used.
                  ##  If the XKB_DEFAULT_LAYOUT environment variable is set, it is used
                  ##  as the default.  Otherwise the system default is used.
                  ##
    layout*: cstring ## *
                   ##  A comma separated list of variants, one per layout, which may
                   ##  modify or augment the respective layout in various ways.
                   ##
                   ##  Generally, should either be empty or have the same number of values
                   ##  as the number of layouts. You may use empty values as in "intl,,neo".
                   ##
                   ##  If NULL or the empty string "", and a default value is also used
                   ##  for the layout, a default value is used.  Otherwise no variant is
                   ##  used.
                   ##  If the XKB_DEFAULT_VARIANT environment variable is set, it is used
                   ##  as the default.  Otherwise the system default is used.
                   ##
    variant*: cstring ## *
                    ##  A comma separated list of options, through which the user specifies
                    ##  non-layout related preferences, like which key combinations are used
                    ##  for switching layouts, or which key is the Compose key.
                    ##
                    ##  If NULL, a default value is used.  If the empty string "", no
                    ##  options are used.
                    ##  If the XKB_DEFAULT_OPTIONS environment variable is set, it is used
                    ##  as the default.  Otherwise the system default is used.
                    ##
    options*: cstring


## *
##  @defgroup keysyms Keysyms
##  Utility functions related to keysyms.
##
##  @{
##
## *
##  @page keysym-transformations Keysym Transformations
##
##  Keysym translation is subject to several "keysym transformations",
##  as described in the XKB specification.  These are:
##
##  - Capitalization transformation.  If the Caps Lock modifier is
##    active and was not consumed by the translation process, a single
##    keysym is transformed to its upper-case form (if applicable).
##    Similarly, the UTF-8/UTF-32 string produced is capitalized.
##
##    This is described in:
##    https://www.x.org/releases/current/doc/kbproto/xkbproto.html#Interpreting_the_Lock_Modifier
##
##  - Control transformation.  If the Control modifier is active and
##    was not consumed by the translation process, the string produced
##    is transformed to its matching ASCII control character (if
##    applicable).  Keysyms are not affected.
##
##    This is described in:
##    https://www.x.org/releases/current/doc/kbproto/xkbproto.html#Interpreting_the_Control_Modifier
##
##  Each relevant function discusses which transformations it performs.
##
##  These transformations are not applicable when a key produces multiple
##  keysyms.
##
## *
##  Get the name of a keysym.
##
##  For a description of how keysyms are named, see @ref xkb_keysym_t.
##
##  @param[in]  keysym The keysym.
##  @param[out] buffer A string buffer to write the name into.
##  @param[in]  size   Size of the buffer.
##
##  @warning If the buffer passed is too small, the string is truncated
##  (though still NUL-terminated); a size of at least 64 bytes is recommended.
##
##  @returns The number of bytes in the name, excluding the NUL byte. If
##  the keysym is invalid, returns -1.
##
##  You may check if truncation has occurred by comparing the return value
##  with the length of buffer, similarly to the snprintf(3) function.
##
##  @sa xkb_keysym_t
##

proc getName*(keysym: KeySym; buffer: cstring; size: csize_t): cint {.importc: "xkb_keysym_get_name".}
## * Flags for xkb_keysym_from_name().

type
  xkb_keysym_flags* = enum      ## * Do not apply any flags.
    XKB_KEYSYM_NO_FLAGS = 0,    ## * Find keysym by case-insensitive search.
    XKB_KEYSYM_CASE_INSENSITIVE = (1 shl 0)


## *
##  Get a keysym from its name.
##
##  @param name The name of a keysym. See remarks in xkb_keysym_get_name();
##  this function will accept any name returned by that function.
##  @param flags A set of flags controlling how the search is done. If
##  invalid flags are passed, this will fail with XKB_KEY_NoSymbol.
##
##  If you use the XKB_KEYSYM_CASE_INSENSITIVE flag and two keysym names
##  differ only by case, then the lower-case keysym is returned.  For
##  instance, for KEY_a and KEY_A, this function would return KEY_a for the
##  case-insensitive search.  If this functionality is needed, it is
##  recommended to first call this function without this flag; and if that
##  fails, only then to try with this flag, while possibly warning the user
##  he had misspelled the name, and might get wrong results.
##
##  Case folding is done according to the C locale; the current locale is not
##  consulted.
##
##  @returns The keysym. If the name is invalid, returns XKB_KEY_NoSymbol.
##
##  @sa xkb_keysym_t
##

proc fromName*(name: cstring; flags: xkb_keysym_flags): KeySym {.importc: "xkb_keysym_from_name".}
## *
##  Get the Unicode/UTF-8 representation of a keysym.
##
##  @param[in]  keysym The keysym.
##  @param[out] buffer A buffer to write the UTF-8 string into.
##  @param[in]  size   The size of buffer.  Must be at least 7.
##
##  @returns The number of bytes written to the buffer (including the
##  terminating byte).  If the keysym does not have a Unicode
##  representation, returns 0.  If the buffer is too small, returns -1.
##
##  This function does not perform any @ref keysym-transformations.
##  Therefore, prefer to use xkb_state_key_get_utf8() if possible.
##
##  @sa xkb_state_key_get_utf8()
##

proc toUtf8*(keysym: KeySym; buffer: cstring; size: csize_t): cint {.importc: "xkb_keysym_to_utf8".}
## *
##  Get the Unicode/UTF-32 representation of a keysym.
##
##  @returns The Unicode/UTF-32 representation of keysym, which is also
##  compatible with UCS-4.  If the keysym does not have a Unicode
##  representation, returns 0.
##
##  This function does not perform any @ref keysym-transformations.
##  Therefore, prefer to use xkb_state_key_get_utf32() if possible.
##
##  @sa xkb_state_key_get_utf32()
##

proc toUtf32*(keysym: KeySym): uint32 {.importc: "xkb_keysym_to_utf32".}
## *
##  Get the keysym corresponding to a Unicode/UTF-32 codepoint.
##
##  @returns The keysym corresponding to the specified Unicode
##  codepoint, or XKB_KEY_NoSymbol if there is none.
##
##  This function is the inverse of @ref xkb_keysym_to_utf32. In cases
##  where a single codepoint corresponds to multiple keysyms, returns
##  the keysym with the lowest value.
##
##  Unicode codepoints which do not have a special (legacy) keysym
##  encoding use a direct encoding scheme. These keysyms don't usually
##  have an associated keysym constant (XKB_KEY_*).
##
##  For noncharacter Unicode codepoints and codepoints outside of the
##  defined Unicode planes this function returns XKB_KEY_NoSymbol.
##
##  @sa xkb_keysym_to_utf32()
##  @since 1.0.0
##

proc toKeySym*(ucs: uint32): KeySym {.importc: "xkb_utf32_to_keysym".}
## *
##  Convert a keysym to its uppercase form.
##
##  If there is no such form, the keysym is returned unchanged.
##
##  The conversion rules may be incomplete; prefer to work with the Unicode
##  representation instead, when possible.
##

proc toUpper*(ks: KeySym): KeySym {.importc: "xkb_keysym_to_upper".}
## *
##  Convert a keysym to its lowercase form.
##
##  The conversion rules may be incomplete; prefer to work with the Unicode
##  representation instead, when possible.
##

proc toLower*(ks: KeySym): KeySym {.importc: "xkb_keysym_to_lower".}
## * @}
## *
##  @defgroup context Library Context
##  Creating, destroying and using library contexts.
##
##  Every keymap compilation request must have a context associated with
##  it.  The context keeps around state such as the include path.
##
##  @{
##
## *
##  @page envvars Environment Variables
##
##  The user may set some environment variables which affect the library:
##
##  - `XKB_CONFIG_ROOT`, `XKB_CONFIG_EXTRA_PATH`, `XDG_CONFIG_DIR`, `HOME` - see @ref include-path.
##  - `XKB_LOG_LEVEL` - see xkb_context_set_log_level().
##  - `XKB_LOG_VERBOSITY` - see xkb_context_set_log_verbosity().
##  - `XKB_DEFAULT_RULES`, `XKB_DEFAULT_MODEL`, `XKB_DEFAULT_LAYOUT`,
##    `XKB_DEFAULT_VARIANT`, `XKB_DEFAULT_OPTIONS` - see xkb_rule_names.
##
## * Flags for context creation.

type
  xkb_context_flags* = enum     ## * Do not apply any context flags.
    XKB_CONTEXT_NO_FLAGS = 0,   ## * Create this context with an empty include path.
    XKB_CONTEXT_NO_DEFAULT_INCLUDES = (1 shl 0), ## *
                                            ##  Don't take RMLVO names from the environment.
                                            ##  @since 0.3.0
                                            ##
    XKB_CONTEXT_NO_ENVIRONMENT_NAMES = (1 shl 1)


## *
##  Create a new context.
##
##  @param flags Optional flags for the context, or 0.
##
##  @returns A new context, or NULL on failure.
##
##  @memberof xkb_context
##

proc newContext*(flags: xkb_context_flags): Context {.importc: "xkb_context_new".}
## *
##  Take a new reference on a context.
##
##  @returns The passed in context.
##
##  @memberof xkb_context
##

proc releaseRef*(context: Context): Context {.importc: "xkb_context_new".}
## *
##  Release a reference on a context, and possibly free it.
##
##  @param context The context.  If it is NULL, this function does nothing.
##
##  @memberof xkb_context
##

proc unref*(context: Context) {.importc: "xkb_context_unref".}
## *
##  Store custom user data in the context.
##
##  This may be useful in conjunction with xkb_context_set_log_fn() or other
##  callbacks.
##
##  @memberof xkb_context
##

proc setUserData*(context: Context; user_data: pointer) {.importc: "xkb_context_set_user_data".}
## *
##  Retrieves stored user data from the context.
##
##  @returns The stored user data.  If the user data wasn't set, or the
##  passed in context is NULL, returns NULL.
##
##  This may be useful to access private user data from callbacks like a
##  custom logging function.
##
##  @memberof xkb_context
##

proc getUserPath*(context: Context): pointer {.importc: "xkb_context_get_user_data".}
## * @}
## *
##  @defgroup include-path Include Paths
##  Manipulating the include paths in a context.
##
##  The include paths are the file-system paths that are searched when an
##  include statement is encountered during keymap compilation.
##
##  The default include paths are, in that lookup order:
##  - The path `$XDG_CONFIG_HOME/xkb`, with the usual `XDG_CONFIG_HOME`
##    fallback to `$HOME/.config/` if unset.
##  - The path `$HOME/.xkb`, where $HOME is the value of the environment
##    variable `HOME`.
##  - The `XKB_CONFIG_EXTRA_PATH` environment variable, if defined, otherwise the
##    system configuration directory, defined at library configuration time
##    (usually `/etc/xkb`).
##  - The `XKB_CONFIG_ROOT` environment variable, if defined, otherwise
##    the system XKB root, defined at library configuration time.
##
##  @{
##
## *
##  Append a new entry to the context's include path.
##
##  @returns 1 on success, or 0 if the include path could not be added or is
##  inaccessible.
##
##  @memberof xkb_context
##

proc includePathAppend*(context: Context; path: cstring): cint {.importc: "xkb_context_include_path_append".}
## *
##  Append the default include paths to the context's include path.
##
##  @returns 1 on success, or 0 if the primary include path could not be added.
##
##  @memberof xkb_context
##

proc includePathAppend*(context: Context): cint {.importc: "xkb_context_include_path_append_default".}
## *
##  Reset the context's include path to the default.
##
##  Removes all entries from the context's include path, and inserts the
##  default paths.
##
##  @returns 1 on success, or 0 if the primary include path could not be added.
##
##  @memberof xkb_context
##

proc includePathReset*(context: Context): cint {.importc: "xkb_context_include_path_reset_defaults".}
## *
##  Remove all entries from the context's include path.
##
##  @memberof xkb_context
##

proc includePathClear*(context: Context) {.importC: "xkb_context_include_path_clear".}
## *
##  Get the number of paths in the context's include path.
##
##  @memberof xkb_context
##

proc pathLen*(context: Context): cuint {.importc: "xkb_context_num_include_paths".}
## *
##  Get a specific include path from the context's include path.
##
##  @returns The include path at the specified index.  If the index is
##  invalid, returns NULL.
##
##  @memberof xkb_context
##

proc includePathGet*(context: Context; index: cuint): cstring {.importc: "xkb_context_include_path_get".}
## * @}
## *
##  @defgroup logging Logging Handling
##  Manipulating how logging from this library is handled.
##
##  @{
##
## * Specifies a logging level.

type
  xkb_log_level* = enum
    XKB_LOG_LEVEL_CRITICAL = 10, ## *< Log critical internal errors only.
    XKB_LOG_LEVEL_ERROR = 20,   ## *< Log all errors.
    XKB_LOG_LEVEL_WARNING = 30, ## *< Log warnings and errors.
    XKB_LOG_LEVEL_INFO = 40,    ## *< Log information, warnings, and errors.
    XKB_LOG_LEVEL_DEBUG = 50


## *
##  Set the current logging level.
##
##  @param context The context in which to set the logging level.
##  @param level   The logging level to use.  Only messages from this level
##  and below will be logged.
##
##  The default level is XKB_LOG_LEVEL_ERROR.  The environment variable
##  XKB_LOG_LEVEL, if set in the time the context was created, overrides the
##  default value.  It may be specified as a level number or name.
##
##  @memberof xkb_context
##

proc `logLevel=`*(context: Context; level: xkb_log_level) {.importc: "xkb_context_set_log_level".}
## *
##  Get the current logging level.
##
##  @memberof xkb_context
##

proc loglevel*(context: Context): xkb_log_level {.importc: "xkb_context_get_log_level".}
## *
##  Sets the current logging verbosity.
##
##  The library can generate a number of warnings which are not helpful to
##  ordinary users of the library.  The verbosity may be increased if more
##  information is desired (e.g. when developing a new keymap).
##
##  The default verbosity is 0.  The environment variable XKB_LOG_VERBOSITY,
##  if set in the time the context was created, overrides the default value.
##
##  @param context   The context in which to use the set verbosity.
##  @param verbosity The verbosity to use.  Currently used values are
##  1 to 10, higher values being more verbose.  0 would result in no verbose
##  messages being logged.
##
##  Most verbose messages are of level XKB_LOG_LEVEL_WARNING or lower.
##
##  @memberof xkb_context
##

proc `logVerbosity=`*(context: Context; verbosity: cint) {.importc: "xkb_context_set_log_verbosity".}
## *
##  Get the current logging verbosity of the context.
##
##  @memberof xkb_context
##

proc logVerbosity*(context: Context): cint {.importc: "xkb_context_get_log_verbosity".}
## *
##  Set a custom function to handle logging messages.
##
##  @param context The context in which to use the set logging function.
##  @param log_fn  The function that will be called for logging messages.
##  Passing NULL restores the default function, which logs to stderr.
##
##  By default, log messages from this library are printed to stderr.  This
##  function allows you to replace the default behavior with a custom
##  handler.  The handler is only called with messages which match the
##  current logging level and verbosity settings for the context.
##  level is the logging level of the message.  @a format and @a args are
##  the same as in the vprintf(3) function.
##
##  You may use xkb_context_set_user_data() on the context, and then call
##  xkb_context_get_user_data() from within the logging function to provide
##  it with additional private context.
##
##  @memberof xkb_context
##

#[
  TODO:
  proc xkb_context_set_log_fn*(context: Context; log_fn: proc (
      context: Context; level: xkb_log_level; format: cstring; args: va_list))
  ## * @}
  ## *
  ##  @defgroup keymap Keymap Creation
  ##  Creating and destroying keymaps.
  ##
  ##  @{
  ##
  ## * Flags for keymap compilation.
]#

type
  xkb_keymap_compile_flags* = enum ## * Do not apply any flags.
    XKB_KEYMAP_COMPILE_NO_FLAGS = 0


## *
##  Create a keymap from RMLVO names.
##
##  The primary keymap entry point: creates a new XKB keymap from a set of
##  RMLVO (Rules + Model + Layouts + Variants + Options) names.
##
##  @param context The context in which to create the keymap.
##  @param names   The RMLVO names to use.  See xkb_rule_names.
##  @param flags   Optional flags for the keymap, or 0.
##
##  @returns A keymap compiled according to the RMLVO names, or NULL if
##  the compilation failed.
##
##  @sa xkb_rule_names
##  @memberof xkb_keymap
##

proc newKeymapFrom*(context: Context; names: ptr xkb_rule_names;
                               flags: xkb_keymap_compile_flags): Keymap {.importc: "xkb_keymap_new_from_names".}
## * The possible keymap formats.

type
  xkb_keymap_format* = enum     ## * The current/classic XKB text format, as generated by xkbcomp -xkb.
    XKB_KEYMAP_FORMAT_TEXT_V1 = 1


## *
##  Create a keymap from a keymap file.
##
##  @param context The context in which to create the keymap.
##  @param file    The keymap file to compile.
##  @param format  The text format of the keymap file to compile.
##  @param flags   Optional flags for the keymap, or 0.
##
##  @returns A keymap compiled from the given XKB keymap file, or NULL if
##  the compilation failed.
##
##  The file must contain a complete keymap.  For example, in the
##  XKB_KEYMAP_FORMAT_TEXT_V1 format, this means the file must contain one
##  top level '%xkb_keymap' section, which in turn contains other required
##  sections.
##
##  @memberof xkb_keymap
##

proc keymapFrom*(context: Context; file: ptr FILE;
                              format: xkb_keymap_format;
                              flags: xkb_keymap_compile_flags): Keymap {.importc: "xkb_keymap_new_from_file".}
## *
##  Create a keymap from a keymap string.
##
##  This is just like xkb_keymap_new_from_file(), but instead of a file, gets
##  the keymap as one enormous string.
##
##  @see xkb_keymap_new_from_file()
##  @memberof xkb_keymap
##

proc keymapFrom*(context: Context; string: cstring;
                                format: xkb_keymap_format;
                                flags: xkb_keymap_compile_flags): Keymap {.importc: "xkb_keymap_new_from_string".}
## *
##  Create a keymap from a memory buffer.
##
##  This is just like xkb_keymap_new_from_string(), but takes a length argument
##  so the input string does not have to be zero-terminated.
##
##  @see xkb_keymap_new_from_string()
##  @memberof xkb_keymap
##  @since 0.3.0
##

proc keymapFrom*(context: Context; buffer: cstring;
                                length: csize_t; format: xkb_keymap_format;
                                flags: xkb_keymap_compile_flags): Keymap {.importc: "xkb_keymap_new_from_buffer".}
## *
##  Take a new reference on a keymap.
##
##  @returns The passed in keymap.
##
##  @memberof xkb_keymap
##

proc releaseRef*(keymap: Keymap): Keymap {.importC: "xkb_keymap_ref".}
## *
##  Release a reference on a keymap, and possibly free it.
##
##  @param keymap The keymap.  If it is NULL, this function does nothing.
##
##  @memberof xkb_keymap
##

proc unref*(keymap: Keymap) {.importc: "xkb_keymap_unref".}
## *
##  Get the keymap as a string in the format from which it was created.
##  @sa xkb_keymap_get_as_string()
##

let
  XKB_KEYMAP_USE_ORIGINAL_FORMAT* = (cast[xkb_keymap_format](-1))

## *
##  Get the compiled keymap as a string.
##
##  @param keymap The keymap to get as a string.
##  @param format The keymap format to use for the string.  You can pass
##  in the special value XKB_KEYMAP_USE_ORIGINAL_FORMAT to use the format
##  from which the keymap was originally created.
##
##  @returns The keymap as a NUL-terminated string, or NULL if unsuccessful.
##
##  The returned string may be fed back into xkb_keymap_new_from_string() to get
##  the exact same keymap (possibly in another process, etc.).
##
##  The returned string is dynamically allocated and should be freed by the
##  caller.
##
##  @memberof xkb_keymap
##

proc getAsString*(keymap: Keymap; format: xkb_keymap_format): cstring {.importc: "xkb_keymap_get_as_string".}
## * @}
## *
##  @defgroup components Keymap Components
##  Enumeration of state components in a keymap.
##
##  @{
##
## *
##  Get the minimum keycode in the keymap.
##
##  @sa xkb_keycode_t
##  @memberof xkb_keymap
##  @since 0.3.1
##

proc minKeycode*(keymap: Keymap): xkb_keycode_t {.importc: "xkb_keymap_min_keycode".}
## *
##  Get the maximum keycode in the keymap.
##
##  @sa xkb_keycode_t
##  @memberof xkb_keymap
##  @since 0.3.1
##

proc maxKeycode*(keymap: Keymap): xkb_keycode_t {.importc: "xkb_keymap_max_keycode".}
## *
##  The iterator used by xkb_keymap_key_for_each().
##
##  @sa xkb_keymap_key_for_each
##  @memberof xkb_keymap
##  @since 0.3.1
##
{.push importc.}
type
  xkb_keymap_key_iter_t* = proc (keymap: Keymap; key: xkb_keycode_t;
                              data: pointer) {.cdecl.}

## *
##  Run a specified function for every valid keycode in the keymap.  If a
##  keymap is sparse, this function may be called fewer than
##  (max_keycode - min_keycode + 1) times.
##
##  @sa xkb_keymap_min_keycode() xkb_keymap_max_keycode() xkb_keycode_t
##  @memberof xkb_keymap
##  @since 0.3.1
##

proc xkb_keymap_key_for_each*(keymap: Keymap; iter: xkb_keymap_key_iter_t;
                             data: pointer)
## *
##  Find the name of the key with the given keycode.
##
##  This function always returns the canonical name of the key (see
##  description in xkb_keycode_t).
##
##  @returns The key name. If no key with this keycode exists,
##  returns NULL.
##
##  @sa xkb_keycode_t
##  @memberof xkb_keymap
##  @since 0.6.0
##

proc xkb_keymap_key_get_name*(keymap: Keymap; key: xkb_keycode_t): cstring
## *
##  Find the keycode of the key with the given name.
##
##  The name can be either a canonical name or an alias.
##
##  @returns The keycode. If no key with this name exists,
##  returns XKB_KEYCODE_INVALID.
##
##  @sa xkb_keycode_t
##  @memberof xkb_keymap
##  @since 0.6.0
##

proc xkb_keymap_key_by_name*(keymap: Keymap; name: cstring): xkb_keycode_t
## *
##  Get the number of modifiers in the keymap.
##
##  @sa xkb_mod_index_t
##  @memberof xkb_keymap
##

proc xkb_keymap_num_mods*(keymap: Keymap): xkb_mod_index_t
## *
##  Get the name of a modifier by index.
##
##  @returns The name.  If the index is invalid, returns NULL.
##
##  @sa xkb_mod_index_t
##  @memberof xkb_keymap
##

proc xkb_keymap_mod_get_name*(keymap: Keymap; idx: xkb_mod_index_t): cstring
## *
##  Get the index of a modifier by name.
##
##  @returns The index.  If no modifier with this name exists, returns
##  XKB_MOD_INVALID.
##
##  @sa xkb_mod_index_t
##  @memberof xkb_keymap
##

proc xkb_keymap_mod_get_index*(keymap: Keymap; name: cstring): xkb_mod_index_t
## *
##  Get the number of layouts in the keymap.
##
##  @sa xkb_layout_index_t xkb_rule_names xkb_keymap_num_layouts_for_key()
##  @memberof xkb_keymap
##

proc xkb_keymap_num_layouts*(keymap: Keymap): xkb_layout_index_t
## *
##  Get the name of a layout by index.
##
##  @returns The name.  If the index is invalid, or the layout does not have
##  a name, returns NULL.
##
##  @sa xkb_layout_index_t
##      For notes on layout names.
##  @memberof xkb_keymap
##

proc xkb_keymap_layout_get_name*(keymap: Keymap; idx: xkb_layout_index_t): cstring
## *
##  Get the index of a layout by name.
##
##  @returns The index.  If no layout exists with this name, returns
##  XKB_LAYOUT_INVALID.  If more than one layout in the keymap has this name,
##  returns the lowest index among them.
##
##  @sa xkb_layout_index_t
##      For notes on layout names.
##  @memberof xkb_keymap
##

proc xkb_keymap_layout_get_index*(keymap: Keymap; name: cstring): xkb_layout_index_t
## *
##  Get the number of LEDs in the keymap.
##
##  @warning The range [ 0...xkb_keymap_num_leds() ) includes all of the LEDs
##  in the keymap, but may also contain inactive LEDs.  When iterating over
##  this range, you need the handle this case when calling functions such as
##  xkb_keymap_led_get_name() or xkb_state_led_index_is_active().
##
##  @sa xkb_led_index_t
##  @memberof xkb_keymap
##

proc xkb_keymap_num_leds*(keymap: Keymap): xkb_led_index_t
## *
##  Get the name of a LED by index.
##
##  @returns The name.  If the index is invalid, returns NULL.
##
##  @memberof xkb_keymap
##

proc xkb_keymap_led_get_name*(keymap: Keymap; idx: xkb_led_index_t): cstring
## *
##  Get the index of a LED by name.
##
##  @returns The index.  If no LED with this name exists, returns
##  XKB_LED_INVALID.
##
##  @memberof xkb_keymap
##

proc xkb_keymap_led_get_index*(keymap: Keymap; name: cstring): xkb_led_index_t
## *
##  Get the number of layouts for a specific key.
##
##  This number can be different from xkb_keymap_num_layouts(), but is always
##  smaller.  It is the appropriate value to use when iterating over the
##  layouts of a key.
##
##  @sa xkb_layout_index_t
##  @memberof xkb_keymap
##

proc xkb_keymap_num_layouts_for_key*(keymap: Keymap; key: xkb_keycode_t): xkb_layout_index_t
## *
##  Get the number of shift levels for a specific key and layout.
##
##  If @c layout is out of range for this key (that is, larger or equal to
##  the value returned by xkb_keymap_num_layouts_for_key()), it is brought
##  back into range in a manner consistent with xkb_state_key_get_layout().
##
##  @sa xkb_level_index_t
##  @memberof xkb_keymap
##

proc xkb_keymap_num_levels_for_key*(keymap: Keymap; key: xkb_keycode_t;
                                   layout: xkb_layout_index_t): xkb_level_index_t
## *
##  Retrieves every possible modifier mask that produces the specified
##  shift level for a specific key and layout.
##
##  This API is useful for inverse key transformation; i.e. finding out
##  which modifiers need to be active in order to be able to type the
##  keysym(s) corresponding to the specific key code, layout and level.
##
##  @warning It returns only up to masks_size modifier masks. If the
##  buffer passed is too small, some of the possible modifier combinations
##  will not be returned.
##
##  @param[in] keymap      The keymap.
##  @param[in] key         The keycode of the key.
##  @param[in] layout      The layout for which to get modifiers.
##  @param[in] level       The shift level in the layout for which to get the
##  modifiers. This should be smaller than:
##  @code xkb_keymap_num_levels_for_key(keymap, key) @endcode
##  @param[out] masks_out  A buffer in which the requested masks should be
##  stored.
##  @param[out] masks_size The size of the buffer pointed to by masks_out.
##
##  If @c layout is out of range for this key (that is, larger or equal to
##  the value returned by xkb_keymap_num_layouts_for_key()), it is brought
##  back into range in a manner consistent with xkb_state_key_get_layout().
##
##  @returns The number of modifier masks stored in the masks_out array.
##  If the key is not in the keymap or if the specified shift level cannot
##  be reached it returns 0 and does not modify the masks_out buffer.
##
##  @sa xkb_level_index_t
##  @sa xkb_mod_mask_t
##  @memberof xkb_keymap
##  @since 1.0.0
##

proc xkb_keymap_key_get_mods_for_level*(keymap: Keymap; key: xkb_keycode_t;
                                       layout: xkb_layout_index_t;
                                       level: xkb_level_index_t;
                                       masks_out: ptr xkb_mod_mask_t;
                                       masks_size: csize_t): csize_t
## *
##  Get the keysyms obtained from pressing a key in a given layout and
##  shift level.
##
##  This function is like xkb_state_key_get_syms(), only the layout and
##  shift level are not derived from the keyboard state but are instead
##  specified explicitly.
##
##  @param[in] keymap    The keymap.
##  @param[in] key       The keycode of the key.
##  @param[in] layout    The layout for which to get the keysyms.
##  @param[in] level     The shift level in the layout for which to get the
##  keysyms. This should be smaller than:
##  @code xkb_keymap_num_levels_for_key(keymap, key) @endcode
##  @param[out] syms_out An immutable array of keysyms corresponding to the
##  key in the given layout and shift level.
##
##  If @c layout is out of range for this key (that is, larger or equal to
##  the value returned by xkb_keymap_num_layouts_for_key()), it is brought
##  back into range in a manner consistent with xkb_state_key_get_layout().
##
##  @returns The number of keysyms in the syms_out array.  If no keysyms
##  are produced by the key in the given layout and shift level, returns 0
##  and sets syms_out to NULL.
##
##  @sa xkb_state_key_get_syms()
##  @memberof xkb_keymap
##

proc xkb_keymap_key_get_syms_by_level*(keymap: Keymap; key: xkb_keycode_t;
                                      layout: xkb_layout_index_t;
                                      level: xkb_level_index_t;
                                      syms_out: ptr ptr xkb_keysym_t): cint
## *
##  Determine whether a key should repeat or not.
##
##  A keymap may specify different repeat behaviors for different keys.
##  Most keys should generally exhibit repeat behavior; for example, holding
##  the 'a' key down in a text editor should normally insert a single 'a'
##  character every few milliseconds, until the key is released.  However,
##  there are keys which should not or do not need to be repeated.  For
##  example, repeating modifier keys such as Left/Right Shift or Caps Lock
##  is not generally useful or desired.
##
##  @returns 1 if the key should repeat, 0 otherwise.
##
##  @memberof xkb_keymap
##

proc xkb_keymap_key_repeats*(keymap: Keymap; key: xkb_keycode_t): cint
## * @}
## *
##  @defgroup state Keyboard State
##  Creating, destroying and manipulating keyboard state objects.
##
##  @{
##
## *
##  Create a new keyboard state object.
##
##  @param keymap The keymap which the state will use.
##
##  @returns A new keyboard state object, or NULL on failure.
##
##  @memberof xkb_state
##

proc xkb_state_new*(keymap: Keymap): State
## *
##  Take a new reference on a keyboard state object.
##
##  @returns The passed in object.
##
##  @memberof xkb_state
##

proc xkb_state_ref*(state: State): State
## *
##  Release a reference on a keybaord state object, and possibly free it.
##
##  @param state The state.  If it is NULL, this function does nothing.
##
##  @memberof xkb_state
##

proc xkb_state_unref*(state: State)
## *
##  Get the keymap which a keyboard state object is using.
##
##  @returns The keymap which was passed to xkb_state_new() when creating
##  this state object.
##
##  This function does not take a new reference on the keymap; you must
##  explicitly reference it yourself if you plan to use it beyond the
##  lifetime of the state.
##
##  @memberof xkb_state
##

proc xkb_state_get_keymap*(state: State): Keymap
## * Specifies the direction of the key (press / release).

type
  xkb_key_direction* = enum
    XKB_KEY_UP,               ## *< The key was released.
    XKB_KEY_DOWN              ## *< The key was pressed.


## *
##  Modifier and layout types for state objects.  This enum is bitmaskable,
##  e.g. (XKB_STATE_MODS_DEPRESSED | XKB_STATE_MODS_LATCHED) is valid to
##  exclude locked modifiers.
##
##  In XKB, the DEPRESSED components are also known as 'base'.
##

type
  xkb_state_component* = enum   ## * Depressed modifiers, i.e. a key is physically holding them.
    XKB_STATE_MODS_DEPRESSED = (1 shl 0), ## * Latched modifiers, i.e. will be unset after the next non-modifier
                                     ##   key press.
    XKB_STATE_MODS_LATCHED = (1 shl 1), ## * Locked modifiers, i.e. will be unset after the key provoking the
                                   ##   lock has been pressed again.
    XKB_STATE_MODS_LOCKED = (1 shl 2), ## * Effective modifiers, i.e. currently active and affect key
                                  ##   processing (derived from the other state components).
                                  ##   Use this unless you explicitly care how the state came about.
    XKB_STATE_MODS_EFFECTIVE = (1 shl 3), ## * Depressed layout, i.e. a key is physically holding it.
    XKB_STATE_LAYOUT_DEPRESSED = (1 shl 4), ## * Latched layout, i.e. will be unset after the next non-modifier
                                       ##   key press.
    XKB_STATE_LAYOUT_LATCHED = (1 shl 5), ## * Locked layout, i.e. will be unset after the key provoking the lock
                                     ##   has been pressed again.
    XKB_STATE_LAYOUT_LOCKED = (1 shl 6), ## * Effective layout, i.e. currently active and affects key processing
                                    ##   (derived from the other state components).
                                    ##   Use this unless you explicitly care how the state came about.
    XKB_STATE_LAYOUT_EFFECTIVE = (1 shl 7), ## * LEDs (derived from the other state components).
    XKB_STATE_LEDS = (1 shl 8)


## *
##  Update the keyboard state to reflect a given key being pressed or
##  released.
##
##  This entry point is intended for programs which track the keyboard state
##  explicitly (like an evdev client).  If the state is serialized to you by
##  a master process (like a Wayland compositor) using functions like
##  xkb_state_serialize_mods(), you should use xkb_state_update_mask() instead.
##  The two functions should not generally be used together.
##
##  A series of calls to this function should be consistent; that is, a call
##  with XKB_KEY_DOWN for a key should be matched by an XKB_KEY_UP; if a key
##  is pressed twice, it should be released twice; etc. Otherwise (e.g. due
##  to missed input events), situations like "stuck modifiers" may occur.
##
##  This function is often used in conjunction with the function
##  xkb_state_key_get_syms() (or xkb_state_key_get_one_sym()), for example,
##  when handling a key event.  In this case, you should prefer to get the
##  keysyms *before* updating the key, such that the keysyms reported for
##  the key event are not affected by the event itself.  This is the
##  conventional behavior.
##
##  @returns A mask of state components that have changed as a result of
##  the update.  If nothing in the state has changed, returns 0.
##
##  @memberof xkb_state
##
##  @sa xkb_state_update_mask()
##

proc xkb_state_update_key*(state: State; key: xkb_keycode_t;
                          direction: xkb_key_direction): xkb_state_component
## *
##  Update a keyboard state from a set of explicit masks.
##
##  This entry point is intended for window systems and the like, where a
##  master process holds an xkb_state, then serializes it over a wire
##  protocol, and clients then use the serialization to feed in to their own
##  xkb_state.
##
##  All parameters must always be passed, or the resulting state may be
##  incoherent.
##
##  The serialization is lossy and will not survive round trips; it must only
##  be used to feed slave state objects, and must not be used to update the
##  master state.
##
##  If you do not fit the description above, you should use
##  xkb_state_update_key() instead.  The two functions should not generally be
##  used together.
##
##  @returns A mask of state components that have changed as a result of
##  the update.  If nothing in the state has changed, returns 0.
##
##  @memberof xkb_state
##
##  @sa xkb_state_component
##  @sa xkb_state_update_key
##

proc xkb_state_update_mask*(state: State; depressed_mods: xkb_mod_mask_t;
                           latched_mods: xkb_mod_mask_t;
                           locked_mods: xkb_mod_mask_t;
                           depressed_layout: xkb_layout_index_t;
                           latched_layout: xkb_layout_index_t;
                           locked_layout: xkb_layout_index_t): xkb_state_component
## *
##  Get the keysyms obtained from pressing a particular key in a given
##  keyboard state.
##
##  Get the keysyms for a key according to the current active layout,
##  modifiers and shift level for the key, as determined by a keyboard
##  state.
##
##  @param[in]  state    The keyboard state object.
##  @param[in]  key      The keycode of the key.
##  @param[out] syms_out An immutable array of keysyms corresponding the
##  key in the given keyboard state.
##
##  As an extension to XKB, this function can return more than one keysym.
##  If you do not want to handle this case, you can use
##  xkb_state_key_get_one_sym() for a simpler interface.
##
##  This function does not perform any @ref keysym-transformations.
##  (This might change).
##
##  @returns The number of keysyms in the syms_out array.  If no keysyms
##  are produced by the key in the given keyboard state, returns 0 and sets
##  syms_out to NULL.
##
##  @memberof xkb_state
##

proc xkb_state_key_get_syms*(state: State; key: xkb_keycode_t;
                            syms_out: ptr ptr xkb_keysym_t): cint
## *
##  Get the Unicode/UTF-8 string obtained from pressing a particular key
##  in a given keyboard state.
##
##  @param[in]  state  The keyboard state object.
##  @param[in]  key    The keycode of the key.
##  @param[out] buffer A buffer to write the string into.
##  @param[in]  size   Size of the buffer.
##
##  @warning If the buffer passed is too small, the string is truncated
##  (though still NUL-terminated).
##
##  @returns The number of bytes required for the string, excluding the
##  NUL byte.  If there is nothing to write, returns 0.
##
##  You may check if truncation has occurred by comparing the return value
##  with the size of @p buffer, similarly to the snprintf(3) function.
##  You may safely pass NULL and 0 to @p buffer and @p size to find the
##  required size (without the NUL-byte).
##
##  This function performs Capitalization and Control @ref
##  keysym-transformations.
##
##  @memberof xkb_state
##  @since 0.4.1
##

proc xkb_state_key_get_utf8*(state: State; key: xkb_keycode_t;
                            buffer: cstring; size: csize_t): cint
## *
##  Get the Unicode/UTF-32 codepoint obtained from pressing a particular
##  key in a a given keyboard state.
##
##  @returns The UTF-32 representation for the key, if it consists of only
##  a single codepoint.  Otherwise, returns 0.
##
##  This function performs Capitalization and Control @ref
##  keysym-transformations.
##
##  @memberof xkb_state
##  @since 0.4.1
##

proc xkb_state_key_get_utf32*(state: State; key: xkb_keycode_t): uint32
## *
##  Get the single keysym obtained from pressing a particular key in a
##  given keyboard state.
##
##  This function is similar to xkb_state_key_get_syms(), but intended
##  for users which cannot or do not want to handle the case where
##  multiple keysyms are returned (in which case this function is
##  preferred).
##
##  @returns The keysym.  If the key does not have exactly one keysym,
##  returns XKB_KEY_NoSymbol
##
##  This function performs Capitalization @ref keysym-transformations.
##
##  @sa xkb_state_key_get_syms()
##  @memberof xkb_state
##

proc xkb_state_key_get_one_sym*(state: State; key: xkb_keycode_t): xkb_keysym_t
## *
##  Get the effective layout index for a key in a given keyboard state.
##
##  @returns The layout index for the key in the given keyboard state.  If
##  the given keycode is invalid, or if the key is not included in any
##  layout at all, returns XKB_LAYOUT_INVALID.
##
##  @invariant If the returned layout is valid, the following always holds:
##  @code
##  xkb_state_key_get_layout(state, key) < xkb_keymap_num_layouts_for_key(keymap, key)
##  @endcode
##
##  @memberof xkb_state
##

proc xkb_state_key_get_layout*(state: State; key: xkb_keycode_t): xkb_layout_index_t
## *
##  Get the effective shift level for a key in a given keyboard state and
##  layout.
##
##  @param state The keyboard state.
##  @param key The keycode of the key.
##  @param layout The layout for which to get the shift level.  This must be
##  smaller than:
##  @code xkb_keymap_num_layouts_for_key(keymap, key) @endcode
##  usually it would be:
##  @code xkb_state_key_get_layout(state, key) @endcode
##
##  @return The shift level index.  If the key or layout are invalid,
##  returns XKB_LEVEL_INVALID.
##
##  @invariant If the returned level is valid, the following always holds:
##  @code
##  xkb_state_key_get_level(state, key, layout) < xkb_keymap_num_levels_for_key(keymap, key, layout)
##  @endcode
##
##  @memberof xkb_state
##

proc xkb_state_key_get_level*(state: State; key: xkb_keycode_t;
                             layout: xkb_layout_index_t): xkb_level_index_t
## *
##  Match flags for xkb_state_mod_indices_are_active() and
##  xkb_state_mod_names_are_active(), specifying the conditions for a
##  successful match.  XKB_STATE_MATCH_NON_EXCLUSIVE is bitmaskable with
##  the other modes.
##

type
  xkb_state_match* = enum       ## * Returns true if any of the modifiers are active.
    XKB_STATE_MATCH_ANY = (1 shl 0), ## * Returns true if all of the modifiers are active.
    XKB_STATE_MATCH_ALL = (1 shl 1), ## * Makes matching non-exclusive, i.e. will not return false if a
                                ##   modifier not specified in the arguments is active.
    XKB_STATE_MATCH_NON_EXCLUSIVE = (1 shl 16)


## *
##  The counterpart to xkb_state_update_mask for modifiers, to be used on
##  the server side of serialization.
##
##  @param state      The keyboard state.
##  @param components A mask of the modifier state components to serialize.
##  State components other than XKB_STATE_MODS_* are ignored.
##  If XKB_STATE_MODS_EFFECTIVE is included, all other state components are
##  ignored.
##
##  @returns A xkb_mod_mask_t representing the given components of the
##  modifier state.
##
##  This function should not be used in regular clients; please use the
##  xkb_state_mod_*_is_active API instead.
##
##  @memberof xkb_state
##

proc xkb_state_serialize_mods*(state: State; components: xkb_state_component): xkb_mod_mask_t
## *
##  The counterpart to xkb_state_update_mask for layouts, to be used on
##  the server side of serialization.
##
##  @param state      The keyboard state.
##  @param components A mask of the layout state components to serialize.
##  State components other than XKB_STATE_LAYOUT_* are ignored.
##  If XKB_STATE_LAYOUT_EFFECTIVE is included, all other state components are
##  ignored.
##
##  @returns A layout index representing the given components of the
##  layout state.
##
##  This function should not be used in regular clients; please use the
##  xkb_state_layout_*_is_active API instead.
##
##  @memberof xkb_state
##

proc xkb_state_serialize_layout*(state: State;
                                components: xkb_state_component): xkb_layout_index_t
## *
##  Test whether a modifier is active in a given keyboard state by name.
##
##  @returns 1 if the modifier is active, 0 if it is not.  If the modifier
##  name does not exist in the keymap, returns -1.
##
##  @memberof xkb_state
##

proc xkb_state_mod_name_is_active*(state: State; name: cstring;
                                  `type`: xkb_state_component): cint
## *
##  Test whether a set of modifiers are active in a given keyboard state by
##  name.
##
##  @param state The keyboard state.
##  @param type  The component of the state against which to match the
##  given modifiers.
##  @param match The manner by which to match the state against the
##  given modifiers.
##  @param ...   The set of of modifier names to test, terminated by a NULL
##  argument (sentinel).
##
##  @returns 1 if the modifiers are active, 0 if they are not.  If any of
##  the modifier names do not exist in the keymap, returns -1.
##
##  @memberof xkb_state
##

##[
  TODO
proc xkb_state_mod_names_are_active*(state: State;
                                    `type`: xkb_state_component;
                                    match: xkb_state_match): cint {.varargs.}
## *
##  Test whether a modifier is active in a given keyboard state by index.
##
##  @returns 1 if the modifier is active, 0 if it is not.  If the modifier
##  index is invalid in the keymap, returns -1.
##
##  @memberof xkb_state
##
]##

proc xkb_state_mod_index_is_active*(state: State; idx: xkb_mod_index_t;
                                   `type`: xkb_state_component): cint
## *
##  Test whether a set of modifiers are active in a given keyboard state by
##  index.
##
##  @param state The keyboard state.
##  @param type  The component of the state against which to match the
##  given modifiers.
##  @param match The manner by which to match the state against the
##  given modifiers.
##  @param ...   The set of of modifier indices to test, terminated by a
##  XKB_MOD_INVALID argument (sentinel).
##
##  @returns 1 if the modifiers are active, 0 if they are not.  If any of
##  the modifier indices are invalid in the keymap, returns -1.
##
##  @memberof xkb_state
##

proc xkb_state_mod_indices_are_active*(state: State;
                                      `type`: xkb_state_component;
                                      match: xkb_state_match): cint {.varargs.}
## *
##  @page consumed-modifiers Consumed Modifiers
##  @parblock
##
##  Some functions, like xkb_state_key_get_syms(), look at the state of
##  the modifiers in the keymap and derive from it the correct shift level
##  to use for the key.  For example, in a US layout, pressing the key
##  labeled \<A\> while the Shift modifier is active, generates the keysym
##  'A'.  In this case, the Shift modifier is said to be "consumed".
##  However, the Num Lock modifier does not affect this translation at all,
##  even if it is active, so it is not consumed by this translation.
##
##  It may be desirable for some application to not reuse consumed modifiers
##  for further processing, e.g. for hotkeys or keyboard shortcuts.  To
##  understand why, consider some requirements from a standard shortcut
##  mechanism, and how they are implemented:
##
##  1. The shortcut's modifiers must match exactly to the state.  For
##     example, it is possible to bind separate actions to \<Alt\>\<Tab\>
##     and to \<Alt\>\<Shift\>\<Tab\>.  Further, if only \<Alt\>\<Tab\> is
##     bound to an action, pressing \<Alt\>\<Shift\>\<Tab\> should not
##     trigger the shortcut.
##     Effectively, this means that the modifiers are compared using the
##     equality operator (==).
##
##  2. Only relevant modifiers are considered for the matching.  For example,
##     Caps Lock and Num Lock should not generally affect the matching, e.g.
##     when matching \<Alt\>\<Tab\> against the state, it does not matter
##     whether Num Lock is active or not.  These relevant, or "significant",
##     modifiers usually include Alt, Control, Shift, Super and similar.
##     Effectively, this means that non-significant modifiers are masked out,
##     before doing the comparison as described above.
##
##  3. The matching must be independent of the layout/keymap.  For example,
##     the \<Plus\> (+) symbol is found on the first level on some layouts,
##     but requires holding Shift on others.  If you simply bind the action
##     to the \<Plus\> keysym, it would work for the unshifted kind, but
##     not for the others, because the match against Shift would fail.  If
##     you bind the action to \<Shift\>\<Plus\>, only the shifted kind would
##     work.  So what is needed is to recognize that Shift is used up in the
##     translation of the keysym itself, and therefore should not be included
##     in the matching.
##     Effectively, this means that consumed modifiers (Shift in this example)
##     are masked out as well, before doing the comparison.
##
##  In summary, this is approximately how the matching would be performed:
##  @code
##    (keysym == shortcut_keysym) &&
##    ((state_mods & ~consumed_mods & significant_mods) == shortcut_mods)
##  @endcode
##
##  @c state_mods are the modifiers reported by
##  xkb_state_mod_index_is_active() and similar functions.
##  @c consumed_mods are the modifiers reported by
##  xkb_state_mod_index_is_consumed() and similar functions.
##  @c significant_mods are decided upon by the application/toolkit/user;
##  it is up to them to decide whether these are configurable or hard-coded.
##
##  @endparblock
##
## *
##  Consumed modifiers mode.
##
##  There are several possible methods for deciding which modifiers are
##  consumed and which are not, each applicable for different systems or
##  situations. The mode selects the method to use.
##
##  Keep in mind that in all methods, the keymap may decide to "preserve"
##  a modifier, meaning it is not reported as consumed even if it would
##  have otherwise.
##

type
  xkb_consumed_mode* = enum ## *
                         ##  This is the mode defined in the XKB specification and used by libX11.
                         ##
                         ##  A modifier is consumed if and only if it *may affect* key translation.
                         ##
                         ##  For example, if `Control+Alt+<Backspace>` produces some assigned keysym,
                         ##  then when pressing just `<Backspace>`, `Control` and `Alt` are consumed,
                         ##  even though they are not active, since if they *were* active they would
                         ##  have affected key translation.
                         ##
    XKB_CONSUMED_MODE_XKB, ## *
                          ##  This is the mode used by the GTK+ toolkit.
                          ##
                          ##  The mode consists of the following two independent heuristics:
                          ##
                          ##  - The currently active set of modifiers, excluding modifiers which do
                          ##    not affect the key (as described for @ref XKB_CONSUMED_MODE_XKB), are
                          ##    considered consumed, if the keysyms produced when all of them are
                          ##    active are different from the keysyms produced when no modifiers are
                          ##    active.
                          ##
                          ##  - A single modifier is considered consumed if the keysyms produced for
                          ##    the key when it is the only active modifier are different from the
                          ##    keysyms produced when no modifiers are active.
                          ##
    XKB_CONSUMED_MODE_GTK


## *
##  Get the mask of modifiers consumed by translating a given key.
##
##  @param state The keyboard state.
##  @param key   The keycode of the key.
##  @param mode  The consumed modifiers mode to use; see enum description.
##
##  @returns a mask of the consumed modifiers.
##
##  @memberof xkb_state
##  @since 0.7.0
##

proc xkb_state_key_get_consumed_mods2*(state: State; key: xkb_keycode_t;
                                      mode: xkb_consumed_mode): xkb_mod_mask_t
## *
##  Same as xkb_state_key_get_consumed_mods2() with mode XKB_CONSUMED_MODE_XKB.
##
##  @memberof xkb_state
##  @since 0.4.1
##

proc xkb_state_key_get_consumed_mods*(state: State; key: xkb_keycode_t): xkb_mod_mask_t
## *
##  Test whether a modifier is consumed by keyboard state translation for
##  a key.
##
##  @param state The keyboard state.
##  @param key   The keycode of the key.
##  @param idx   The index of the modifier to check.
##  @param mode  The consumed modifiers mode to use; see enum description.
##
##  @returns 1 if the modifier is consumed, 0 if it is not.  If the modifier
##  index is not valid in the keymap, returns -1.
##
##  @sa xkb_state_mod_mask_remove_consumed()
##  @sa xkb_state_key_get_consumed_mods()
##  @memberof xkb_state
##  @since 0.7.0
##

proc xkb_state_mod_index_is_consumed2*(state: State; key: xkb_keycode_t;
                                      idx: xkb_mod_index_t;
                                      mode: xkb_consumed_mode): cint
## *
##  Same as xkb_state_mod_index_is_consumed2() with mode XKB_CONSUMED_MOD_XKB.
##
##  @memberof xkb_state
##  @since 0.4.1
##

proc xkb_state_mod_index_is_consumed*(state: State; key: xkb_keycode_t;
                                     idx: xkb_mod_index_t): cint
## *
##  Remove consumed modifiers from a modifier mask for a key.
##
##  @deprecated Use xkb_state_key_get_consumed_mods2() instead.
##
##  Takes the given modifier mask, and removes all modifiers which are
##  consumed for that particular key (as in xkb_state_mod_index_is_consumed()).
##
##  @sa xkb_state_mod_index_is_consumed()
##  @memberof xkb_state
##

proc xkb_state_mod_mask_remove_consumed*(state: State; key: xkb_keycode_t;
                                        mask: xkb_mod_mask_t): xkb_mod_mask_t
## *
##  Test whether a layout is active in a given keyboard state by name.
##
##  @returns 1 if the layout is active, 0 if it is not.  If no layout with
##  this name exists in the keymap, return -1.
##
##  If multiple layouts in the keymap have this name, the one with the lowest
##  index is tested.
##
##  @sa xkb_layout_index_t
##  @memberof xkb_state
##

proc xkb_state_layout_name_is_active*(state: State; name: cstring;
                                     `type`: xkb_state_component): cint
## *
##  Test whether a layout is active in a given keyboard state by index.
##
##  @returns 1 if the layout is active, 0 if it is not.  If the layout index
##  is not valid in the keymap, returns -1.
##
##  @sa xkb_layout_index_t
##  @memberof xkb_state
##

proc xkb_state_layout_index_is_active*(state: State;
                                      idx: xkb_layout_index_t;
                                      `type`: xkb_state_component): cint
## *
##  Test whether a LED is active in a given keyboard state by name.
##
##  @returns 1 if the LED is active, 0 if it not.  If no LED with this name
##  exists in the keymap, returns -1.
##
##  @sa xkb_led_index_t
##  @memberof xkb_state
##

proc xkb_state_led_name_is_active*(state: State; name: cstring): cint
## *
##  Test whether a LED is active in a given keyboard state by index.
##
##  @returns 1 if the LED is active, 0 if it not.  If the LED index is not
##  valid in the keymap, returns -1.
##
##  @sa xkb_led_index_t
##  @memberof xkb_state
##

proc xkb_state_led_index_is_active*(state: State; idx: xkb_led_index_t): cint
## * @}
##  Leave this include last, so it can pick up our types, etc.
{.pop.}
