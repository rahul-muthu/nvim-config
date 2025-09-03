# My Neovim Configuration

This is my personal Neovim configuration that I've built up over time to create a development environment. It's built around modern Neovim features with Lua configuration.


## 📁 Structure

```
nvim/
├── init.lua              # Entry point
├── lua/
│   ├── options.lua       # Neovim settings
│   ├── keymaps.lua       # Key bindings  
│   ├── autocommands.lua  # Automated behaviors
│   ├── Lazy.lua          # Plugin manager setup
│   └── plugins/          # Individual plugin configs
```

## ⚙️ Key Settings

Here are the most important settings I use:

- **Leader Key**: Space (`<leader>`)
- **Clipboard**: System clipboard integration
- **Indentation**: 4 spaces
- **Line Numbers**: Both absolute and relative
- **Search**: Case-insensitive unless capitals used
- **Scrolling**: 12 lines buffer above/below cursor
- **No Mouse**: Keyboard-only workflow
- **No Swap Files**: Using persistent undo instead

## 🎯 Essential Keybindings

### Navigation & Windows
| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate between windows |
| `<C-Up/Down/Left/Right>` | Resize windows |
| `-` | Open Oil file manager |
| `s` | Flash jump (quick navigation) |

### Buffer Management
| Key | Action |
|-----|--------|
| `<S-l>` | Next buffer |
| `<S-h>` | Previous buffer |
| `<S-q>` | Close buffer intelligently |
| `<leader>bd` | Delete buffer |
| `<leader>ba` | Delete all buffers |

### File Operations (Telescope)
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>ft` | Live grep search |
| `<leader>fb` | Browse buffers |
| `<leader>fp` | Browse projects |

### Code Navigation (LSP)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Show references |
| `K` | Hover documentation |
| `<leader>la` | Code actions |
| `<leader>lr` | Rename symbol |
| `<leader>lf` | Format code |
| `<leader>lj/lk` | Next/previous diagnostic |

### Editor Features
| Key | Action |
|-----|--------|
| `<leader>/` | Toggle comment |
| `<leader>h` | Clear search highlights |
| `<C-Space>` | Toggle terminal |
| `<leader>z` | Open PDF with Zathura |
| `<leader>p` | Paste image from clipboard |

## 🔧 Language Support

I have LSP configured for the languages I work with most:

### Language Servers (Auto-installed via Mason):
- **Lua**: `lua_ls` - For Neovim config and scripting
- **Python**: `pyright` - Type checking and IntelliSense  
- **Bash**: `bashls` - Shell scripting support
- **JSON**: `jsonls` - Configuration files
- **C/C++**: `clangd` - Systems programming
- **Rust**: `rustaceanvim` - Modern systems language

### Formatters:
- **Lua**: stylua (consistent formatting)
- **Python**: black (opinionated formatting)
- **C/C++**: clang_format (customizable style)

### Syntax Highlighting:
Treesitter provides syntax highlighting for all my languages plus Markdown, LaTeX, HTML, and more.

### File Management: Oil
I replaced netrw with Oil because it lets me edit directories like buffers. Much more intuitive for file operations.

## 🏗️ Key Plugins

### Completion (nvim-cmp)
Smart autocompletion with multiple sources:
- LSP completions
- Snippet expansions
- Buffer text
- File paths
- Lua API (for config editing)

**Navigation**: Tab/Shift-Tab to navigate, Enter to accept

### Fuzzy Finding (Telescope)
My primary way to navigate and find things:
- **Files**: Fuzzy find any file in project
- **Text**: Live grep across all files  
- **Buffers**: Quick buffer switching
- **Projects**: Automatic project detection

### Terminal (ToggleTerm)
Integrated terminal that doesn't get in the way:
- **Ctrl-Space**: Toggle vertical terminal
- **Ctrl-h/j/k/l**: Navigate between terminal and editor windows
- Starts in insert mode for immediate use

### Navigation (Flash)
Super fast navigation to any visible text:
- Press `s` + any 2 characters to jump anywhere on screen
- Works in normal, visual, and operator-pending modes

## 🤖 Automation Features

### LaTeX Workflow
I do a lot of LaTeX writing, so I automated the compilation:
- Auto-compiles `.tex` files on save using `pdflatex`
- Shows notifications for success/failure
- `<leader>z` opens the compiled PDF with Zathura

### Markdown to PDF
For documentation and notes:
- Auto-converts any markdown file to PDF on save using Pandoc
- Creates PDF in the same directory as the source
- Works anywhere, not tied to specific directories

### Smart Behaviors
- **Yank Highlighting**: Briefly highlights yanked text
- **Auto-resize**: Automatically rebalances windows on resize
- **Spell Check**: Enables spell check for markdown and git commits
- **Quick Close**: Press `q` to close help/quickfix windows
- **Visual Paste**: Paste without yanking the replaced text

### Workflow Tips
1. **Project Management**: Telescope automatically remembers your projects
2. **Buffer Navigation**: Use Shift+H/L for quick buffer switching  
3. **LSP Features**: Hover with `K`, go to definition with `gd`
4. **Visual Mode**: Use `</>` to indent and stay in visual mode
5. **Terminal**: Use Ctrl-Space for quick terminal access


## 🚦 Dependencies

Make sure you have these installed:
- **Neovim** 0.9+ (for all modern features)
- **ripgrep** (for Telescope live grep)
- **fd** (for faster file finding)
- **lazygit** (optional, for git integration)
- **pandoc** (for markdown to PDF conversion)
- **zathura** (for PDF viewing)
- **xclip** (for image pasting functionality)

---

