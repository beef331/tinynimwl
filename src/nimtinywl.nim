import wlroots/[backend, render, types, util, xcursor, xwayland]
import wayland
from wayland/util import wlcontainerof
import nimtinywl/xkbkeysyms



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
    link: ptr WlList
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
      view.link.remove()
      server.views.insert view.link
      discard cast[ptr XdgSurface](view.xdgTopLevel).setActivatedTopLevel(true)

      if keyboard != nil:
        seat.keyboardNotifyEnter(view.xdgTopLevel.base.surface, keyboard.keycodes[0].addr, keyboard.numKeyCodes, keyboard.modifiers.addr)

proc keyboardHandleModifiers(listener: WlListener, data: pointer) =
  let keyboard = listener.wlcontainerOf(TinyKeyboard, modifiers)
  keyboard.server.seat.setKeyboard(keyboard.keyboard)
  keyboard.server.seat.keyboardNotifyModifiers keyboard.keyboard.modifiers.addr

proc handleKeyBinding(server: Server, sym: XkbKeySym): bool =
  result = true
  case sym
  of XkbKeyEscape:
      server.display[].terminate()
  of XkbKeyF1:
    if server.views.len >= 2:
      let nextView = wlContainerOf(server.views[].prev, nextView, link)
      nextView.focusView nextView.xdgTopLevel.base.surface
  else:
    result = false

proc handleKey(listener: WlListener, data: pointer) =
