# Cavanaugh AstroNvim

**NOTE:** This is for AstroNvim v4+

## Backlog

### Lazyvim Migration

### Next Items

- tmux, vim & wsl clipboard
- diffview (see icebox)

### Todo Items

- Typing practice, uncommon sequences that need to become automatic \[\]/,.\<>
  - Practice text object manipulations
    - inner (diw, di", di}, viw) and after (daw, da", da})
    - motion w, b, }, {
  - Next/Prev (Perhaps look at modal)
    - \]d \]c
- Help navigation
  - Figure out how to set custom mappings in help files.
- Final mappings
- Hydra plugin for state based mappings??
- Folding (understand ufo preview & color highlighting)
- Develop new solution for ctrl-g that pops a window with more info

### Tolearn Items

- quickfix window (never used it)
- open file under cursor gff but what about line #
- lsp go to definition (vs show definition etc)
- trouble
- ultimate-autopair
- neoclip
- lsp-colors
- neoconf

## Icebox

### diffview

Need to really fix this as its not working effectively now and is inhibiting productivity

### Neotree

Write a neotree panel to show Info such as name, folder, possibly do something for buffers also

### Folding

Need to set highlight for the fold marker to be more visible for folded lines nnoremap
z<space><space> za

Ive got something for now, but could really use a bit more visibility on the fold info

### Mappings

#### what are these for

nmap > :cnext nmap \< :cprev

can i reuse these for help navigation vs spc-enter and spc-backspace?

### Old classic vim settings

#### Are these useful??

- Need to make a standard file for this, I have copies in multiple places

```
" Fancy ANSI Chars Reference
""
" ▉
" ╔══╦══╗ ┌──┬──┐ ╭──┬──╮ ╭──┬──╮ ┏━━┳━━┓ ╱╲╱╲╳╳╳ ▊
" ║┌─╨─┐║ │╔═╧═╗│ │╒═╪═╕│ │╓─╁─╖│ ┃┌─╂─┐┃ ╲╱╲╱╳╳╳ ▋
" ╠╡ ╳ ╞╣ ├╢   ╟┤ ├┼─┼─┼┤ ├╫─╂─╫┤ ┣┿╾┼╼┿┫ ┌┄┄┐ ╎ ┏┅┅┓ ┋ ▌
" ║└─╥─┘║ │╚═╤═╝│ │╘═╪═╛│ │╙─╀─╜│ ┃└─╂─┘┃ ░░▒▒▓▓██ ┊ ┆ ╎ ╏ ┇ ┋ ▍ ▁▂▃▄▅▆▇█
" ╚══╩══╝ └──┴──┘ ╰──┴──╯ ╰──┴──╯ ┗━━┻━━┛ └╌╌┘ ╎ ┗╍╍┛ ┋ ▎
" ▏
" ▶  ❱ ⚑ ▲ △ ▴ ▵ ▶ ▷ ▸ ▹ ► ▻ ▼ ▽ ✓ ✔ ✕ ✖ ✗ ✘ ❍ ❎ ❏ ❪ ❫ ❬ ❭ ❮ ❯ ❰ ❱ ➢ ➣ ➤ ➥
" ⚠ ⚡ ◇ ◈ ◉ ◊ ○ ◌ ◍ ◎ ● ◐ ◑ ◒ ◓ ◔ ◕ ◖ ◗ ◠ ◡ ◢ ◣ ◤ ◥ ◦ ◧ ◨ ◩ ◪ ◫ ◬ ◭ ◮ ◯ ◰ ◱ ◲
" ◳ ◴ ◵ ◶ ◷ ◸ ◹ ◺ ◻ ◼ ◽ ◾ ◿ ✅ ☐ ☑ ☒
"
" ︙ ⡇ | . │ ┃ ┄ ┅ ┆ ┇ ┈ ┉ ┊ ┋ ╵ ╶ ╷ ⠅⠂
"
```

#### vim-signify

Do i need to switch to this from gitsigns so hg works. Perhaps an autocmd for mercurial tracked
files that also disables gitsigns???

let g:signify_sign_change = '▲' let g:signify_sign_add = '+' let g:signify_sign_delete = '✘' let
g:signify_sign_delete_first_line = '✘' let g:signify_sign_change = '~'

#### Tags and navigation

Can these be set per buffer? Like help?

map <Space><Return> \<C-\]> map <Space><BS> <C-T>
