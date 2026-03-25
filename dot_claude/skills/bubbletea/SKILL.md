---
name: bubbletea
description: Use when writing, debugging, or migrating Bubbletea v2 TUI applications in Go. Covers inline mode, scrollback output, key handling, tea.View, and v1→v2 breaking changes.
allowed-tools: Read, Grep, Glob, Bash, Edit, Write
---

# Bubbletea v2

Import: `charm.land/bubbletea/v2` (aliased as `tea`)

## Model Interface

```go
type Model interface {
    Init() tea.Cmd
    Update(msg tea.Msg) (tea.Model, tea.Cmd)
    View() tea.View   // Returns tea.View, NOT string — breaking change from v1
}
```

## Inline Mode vs Alt Screen

**Inline mode** (default — no `AltScreen`): the program renders at the bottom of the terminal. Output above it is permanent terminal scrollback. This is the correct mode for chat/agent UIs.

**Alt screen**: full-window takeover. Clears terminal. Use for editors, dashboards.

```go
// Inline (default): do NOT set AltScreen
func (m Model) View() tea.View {
    return tea.NewView(m.content)
}

// Alt screen: set in View(), not at program creation
func (m Model) View() tea.View {
    v := tea.NewView(m.content)
    v.AltScreen = true
    return v
}
```

## Persistent Scrollback Output (Inline Only)

`tea.Printf` and `tea.Println` print **above** the program — permanently committed to terminal scrollback. Use these for completed chat messages, tool results, notices. They are suppressed in alt screen mode.

```go
// Return as a Cmd from Update
return m, tea.Printf("user: %s\n", text)
return m, tea.Println("assistant: done")

// Batch with other commands
return m, tea.Batch(
    tea.Printf("• tool(%s)\n%s\n", name, output),
    m.awaitNext(),
)
```

**Rule**: never use `tea.Printf` for in-flight/streaming content — that belongs in `View()`.

## View() and tea.View

```go
func (m Model) View() tea.View {
    // Simplest form
    return tea.NewView(m.renderContent())
}

// With declarative terminal features
func (m Model) View() tea.View {
    v := tea.NewView(m.renderContent())
    v.AltScreen = true                         // full screen
    v.MouseMode = tea.MouseClickMode           // enable mouse
    v.CursorVisible = true                     // show hardware cursor
    v.ReportFocus = true                       // get FocusMsg/BlurMsg
    return v
}
```

## Key Handling

v2 uses `tea.KeyPressMsg` (not `tea.KeyMsg`). `msg.String()` returns a canonical name.

```go
case tea.KeyPressMsg:
    switch msg.String() {
    case "enter":
    case "shift+enter":
    case "ctrl+c":
    case "ctrl+a":
    case "esc":
    case "up", "down":
    case "tab", "shift+tab":
    case "space":         // NOTE: was " " in v1, now "space"
    }
```

**v1→v2 key field renames:**

| v1          | v2                             |
| ----------- | ------------------------------ |
| `msg.Type`  | `msg.Code` (rune)              |
| `msg.Runes` | `msg.Text` (string)            |
| `msg.Alt`   | `msg.Mod.Contains(tea.ModAlt)` |

Modifier check:

```go
if msg.Mod.Contains(tea.ModShift) { ... }
if msg.Mod.Contains(tea.ModCtrl)  { ... }
if msg.Mod.Contains(tea.ModAlt)   { ... }
```

## Mouse Events

v2 splits `tea.MouseMsg` into concrete types:

```go
case tea.MouseClickMsg:
    x, y := msg.X, msg.Y
    if msg.Button == tea.MouseLeft { ... }
case tea.MouseReleaseMsg:
case tea.MouseWheelMsg:
case tea.MouseMotionMsg:
```

Enable in `View()`: `v.MouseMode = tea.MouseClickMode` or `tea.MouseModeCellMotion`.

## Window Size

```go
case tea.WindowSizeMsg:
    m.width = msg.Width
    m.height = msg.Height
    m.ready = true
```

## Commands

```go
tea.Batch(cmds...)      // run concurrently, no ordering guarantee
tea.Sequence(cmds...)   // run one at a time in order (was Sequentially in v1)
tea.Quit                // graceful quit
tea.Tick(d, fn)         // one-shot timer
tea.Every(d, fn)        // recurring timer

// Return nil to do nothing
return m, nil
```

## Async Event Loop Pattern

For streaming data (sessions, channels, websockets):

```go
func (m Model) awaitNext() tea.Cmd {
    return func() tea.Msg {
        ev, ok := <-m.events
        if !ok {
            return doneMsg{}
        }
        return ev  // any type works as tea.Msg
    }
}

// In Update, re-queue after every event:
case MyEventType:
    // handle event
    return m, m.awaitNext()
```

## Program Setup

```go
p := tea.NewProgram(model)
// or with options:
p := tea.NewProgram(model,
    tea.WithInput(os.Stdin),
    tea.WithOutput(os.Stderr),
    tea.WithContext(ctx),
    tea.WithFPS(60),
)
finalModel, err := p.Run()  // was p.Start() in v1
```

**Removed options** (now set in `View()` instead): `WithAltScreen`, `WithMouseCellMotion`, `WithReportFocus`.

## Paste Events

Paste no longer arrives via `KeyMsg`. Use dedicated types:

```go
case tea.PasteMsg:
    m.content += msg.Content
case tea.PasteStartMsg: // bracketed paste start
case tea.PasteEndMsg:   // bracketed paste end
```

## textarea Bubble (charm.land/bubbles/v2/textarea)

```go
ta := textarea.New()
ta.Placeholder = "Type here..."
ta.Prompt = "› "
ta.ShowLineNumbers = false
ta.MaxHeight = 10         // 0 = unlimited
ta.SetHeight(1)
ta.SetWidth(80)

// In Init():
return tea.Batch(textarea.Blink, ta.Focus())

// In Update():
m.textarea, cmd = m.textarea.Update(msg)

// In View():
m.textarea.View()  // returns string, not tea.View

// Useful methods:
ta.Value()         // current text
ta.Reset()         // clear
ta.LineCount()     // number of lines (for auto-expand)
ta.Line()          // cursor line (0-indexed, for history nav)
```

## spinner Bubble (charm.land/bubbles/v2/spinner)

```go
sp := spinner.New()
sp.Spinner = spinner.Dot

// Init: return sp.Tick
// Update: case spinner.TickMsg: m.sp, cmd = m.sp.Update(msg)
// View: m.sp.View()
```

## v1 → v2 Breaking Changes Summary

| v1                                     | v2                                      |
| -------------------------------------- | --------------------------------------- |
| `View() string`                        | `View() tea.View`                       |
| `tea.NewView(s)` not needed            | wrap with `tea.NewView(s)`              |
| `WithAltScreen()` on Program           | `v.AltScreen = true` in View            |
| `WithMouseCellMotion()`                | `v.MouseMode = tea.MouseModeCellMotion` |
| `p.Start()`                            | `p.Run()`                               |
| `tea.Sequentially()`                   | `tea.Sequence()`                        |
| `tea.WindowSize()`                     | `tea.RequestWindowSize`                 |
| `tea.KeyMsg` (struct)                  | `tea.KeyPressMsg` / `tea.KeyReleaseMsg` |
| `msg.Type`, `msg.Runes`, `msg.Alt`     | `msg.Code`, `msg.Text`, `msg.Mod`       |
| `" "` for space                        | `"space"` via `msg.String()`            |
| `tea.MouseMsg` (struct)                | `tea.MouseClickMsg` etc.                |
| `EnterAltScreen` / `DisableMouse` cmds | View fields                             |
| Paste via KeyMsg                       | `tea.PasteMsg`                          |

## Common Mistakes

| Mistake                               | Fix                                             |
| ------------------------------------- | ----------------------------------------------- |
| `View() string` return type           | `View() tea.View`, wrap with `tea.NewView(...)` |
| `WithAltScreen()` at program creation | Set `v.AltScreen = true` in `View()`            |
| Using `tea.Printf` in alt screen mode | It's suppressed; only works in inline mode      |
| Forgetting to re-queue `awaitNext()`  | Every event handler must return `m.awaitNext()` |
| Matching `" "` for space              | Match `"space"` in v2                           |
| `tea.KeyMsg` type switch              | Use `tea.KeyPressMsg`                           |
| `msg.Alt` modifier check              | `msg.Mod.Contains(tea.ModAlt)`                  |
