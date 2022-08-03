import wlroots/[backend, render, types, util, xcursor, xwayland]
import wayland
import xkb


type
  CursorMode = enum
    passthrough
    move
    resize

  Server = ref object
    display: ptr WlDisplay
    backend: ptr Backend
    renderer: ptr Renderer
    allocator: ptr Allocator
    scene: ptr Scene

    shell: XdgShell
    surface: WlListener
    views: ptr WlList

    cursor: ptr Cursor
    cursorManager: ptr XcursorManager
    cursorMotion, cursorMotionAbsolute, cursorButton, cursorAxis, cursorFrame: WlListener

    seat: ptr Seat
    newInput, requestCursor, requestSetSelection: WlListener
    keyboards: ptr WlList
    cursorMode: CursorMode
    grabPos: tuple[x: float, y: float]
    grabGeoBox: Box

    layout: ptr OutputLayoutOutput

  BaseObj {.pure, inheritable.} = object
    link: WlList
    server: Server

  Output = ptr object of BaseObj
    output: ptr OutputLayoutOutput
    frame, destroy: WlListener


  View = ptr object of BaseObj
    xdgToplevel: ptr XdgToplevel

    sceneTree: ptr SceneTree
    map, unmap, destroy, requestMove, requestResize, requestMaximize, requestFullScreen: WlListener
    x, y: float32

  TinyKeyboard = ptr object of BaseObj
    keyboard: ptr Keyboard
    modifiers, key, destroy: WlListener


proc focusView(view: View, surface: ptr types.Surface) =
  if view != nil:
    let
      server = view.server
      seat = server.seat
      prevSurface = seat.keyboardState.focusedSurface
    if prevSurface != surface:
      if prevSurface != nil:
        let previous = xdgSurface(seat.keyboardState.focused_surface)
        assert previous.role == XdgSurfaceRole.TopLevel
        discard cast[ptr XdgSurface](previous.anowlrxdgshell189.topLevel).setActivatedTopLevel(false)

      let keyboard = seat.getKeyboard()
      view.sceneTree.node.addr.raiseToTop()
      view.link.addr.remove()
      server.views.insert view.link.addr
      discard cast[ptr XdgSurface](view.xdgTopLevel).setActivatedTopLevel(true)

      if keyboard != nil:
        seat.keyboardNotifyEnter(view.xdgTopLevel.base.surface, keyboard.keycodes[0].addr, keyboard.numKeyCodes, keyboard.modifiers.addr)

proc keyboardHandleModifiers(listener: ptr WlListener, data: pointer) =
  let keyboard = listener.containerOf(TinyKeyboard, modifiers)

  keyboard.server.seat.setKeyboard(cast[ptr InputDevice](keyboard.keyboard))
  keyboard.server.seat.keyboardNotifyModifiers keyboard.keyboard.modifiers.addr

proc handleKeyBinding(server: Server, sym: uint32): bool =
  result = true
  case sym
  of XkbKeyEscape:
      server.display.terminate()
  of XkbKeyF1:
    if server.views.length >= 2:
      let nextView = server.views[].prev.containerOf(View, link)
      nextView[].focusView nextView.xdgTopLevel.base.surface
  else:
    result = false

proc handleKey(listener: ptr WlListener, data: pointer) =
  let
    keyboard = listener.containerOf(TinyKeyboard, key)
    server = keyboard.server
    event = cast[ptr EventKeyboardKey](data)
    seat = server.seat
    keycode = event.keycode + 8
  var
    syms: ptr XkbKeySym
    nSyms = keyboard.keyboard.xkbState.getSyms(keycode, syms.addr)


  var
    handled = false
    modifiers = cast[set[KeyboardModifier]](keyboard.keyboard.getModifiers())
  if KeyboardModifier.Alt in modifiers and event.state == WlKeyboardKeyState.Pressed:
    for sym in cast[ptr UncheckedArray[XkbKeySym]](syms).toOpenArray(0, nSyms - 1):
      handled = handleKeyBinding(server, sym)
  if not handled:
    seat.setKeyboard(cast[ptr InputDevice](keyboard.keyboard))
  seat.keyboardNotifyKey(event.timeMsec, event.keycode, uint32 event.state)

proc handleDestroy(listener: ptr WlListener, data: pointer) =
  let keyboard = listener.containerOf(TinyKeyboard, destroy)
  remove keyboard.modifiers.link.addr
  remove keyboard.key.link.addr
  remove keyboard.destroy.link.addr
  remove keyboard.link.addr
  dealloc keyboard

proc newKeyboard(server: Server, device: ptr InputDevice) =
  let
    keyboard = create(TinyKeyboard)
  keyboard.server = server
  keyboard.keyboard = cast[ptr Keyboard](device)

  let
    context = newXkbContext(XkbContextFlags.NoFlags)
    keymap = xkbMapNewFromNames(context, nil, XkbKeymapCompile.NoFlags)

