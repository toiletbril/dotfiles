---@diagnostic disable: undefined-global

-- So, imagine your editor requires 1K line settings file.

-- It just happens that every fucking setting is utterly awful by default in
-- this fucking stupid terminal application and every terribly atrocious plugin
-- written by a greasy nerd requires a thousand line confuguration to behave
-- like it supposed to begin with and it makes my head want to explode and there
-- is literally no other editors that do a better job of not using 100% of my
-- RAM and CPU to render god damn fucking text and I swear I will find the one
-- who forced me to learn all these keys and layouts instead of writing
-- parentheses and holding CTRL for everything but after a month of writing
-- mercilessly horibble bullshit in vimscript and lua it's actually pretty
-- useful and nice to use, althrough consumes as much memory as CLion now.

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_nvim_net_plugin = true

-- Install lazy.nvim if not already installed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup({
  defaults = {
    lazy = true,
  },

  spec = {
    -- lol
    -- { "wakatime/vim-wakatime", lazy = false },

    -- LSP and completion
    { "neovim/nvim-lspconfig" },
    { "saghen/blink.cmp", version = "*" },

    {
      "folke/snacks.nvim",
      lazy = false,
      priority = 1000,
      opts = {
        bigfile = {},
        image = { enabled = false },
        input = {},
        notifier = { style = "compact", top_down = true },
        words = { debounce = 200 },
        zen = {},
        lazygit = {},
        picker = {
          matcher = { frecency = true },
          win = {
            list = { wo = { scrolloff = 0 } },
          },
        },
      },
    },

    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      lazy = false,
      build = ":TSUpdate",
    },

    -- Miscellaneous plugins
    { "cappyzawa/trim.nvim" },
    { "NMAC427/guess-indent.nvim" },
    { "lewis6991/gitsigns.nvim" },

    { "fennec-support/kosh.nvim", lazy = false, opts = {} },

    -- Themes
    { "EdenEast/nightfox.nvim" },
    { "cocopon/iceberg.vim" },

    -- Tools
    {
      "nvim-tree/nvim-tree.lua",
      opts = {
        sort = { sorter = "case_sensitive" },
        view = {
          cursorline = false,
          float = {
            enable = true,
            open_win_config = function()
              local window_width = math.floor(vim.o.columns * 0.5)
              local window_height =
                math.floor((vim.o.lines - vim.o.cmdheight) * 0.7)

              return {
                relative = "editor",
                border = "rounded",
                width = window_width,
                height = window_height,
                row = math.floor((vim.o.lines - window_height) / 2) - 1,
                col = math.floor((vim.o.columns - window_width) / 2),
              }
            end,
          },
        },
        renderer = { group_empty = true },
        git = { ignore = false },
        filters = { dotfiles = false },
        on_attach = function(buffer)
          local api = require("nvim-tree.api")

          local function get_opts(description)
            return {
              desc = "nvim-tree: " .. description,
              buffer = buffer,
              noremap = true,
              silent = true,
              nowait = true,
            }
          end

          api.config.mappings.default_on_attach(buffer)
          vim.keymap.del("n", "<2-LeftMouse>", { buffer = buffer })

          vim.keymap.set(
            "n",
            "<LeftRelease>",
            api.node.open.edit,
            get_opts("Open")
          )
          vim.keymap.set("n", "<CR>", function()
            local node = api.tree.get_node_under_cursor()
            if node ~= nil and node.type == "directory" then
              api.tree.change_root_to_node(node)
              return
            end

            api.node.open.edit(node)
          end, get_opts("Enter directory or open file"))
          vim.keymap.set("n", "T", api.node.open.tab, get_opts("Tab"))
        end,
      },
    },
    { "echasnovski/mini.align" },
    { "echasnovski/mini.surround" },
    { "uga-rosa/ccc.nvim" },

    -- { 'lewis6991/satellite.nvim' },
  },
})

vim.cmd([[
  syntax on
  filetype plugin indent off
]])

-- completion's height
vim.opt.pumheight = 6

vim.opt.lazyredraw = true
vim.opt.wrap = false
vim.opt.scrolloff = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.fileformat = "unix"
vim.opt.expandtab = true
vim.opt.smarttab = true
-- vim.opt.guioptions = 'mT'
vim.opt.encoding = "UTF-8"
vim.opt.number = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.autochdir = true
vim.opt.list = true
vim.opt.showmode = true
vim.opt.cmdheight = 0
vim.opt.cinoptions = "l1"
vim.opt.listchars = { tab = "┊ ", space = "·" }
-- vim.opt.listchars = { tab = '┊ ', space = '·', eol = '↵' }
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamed"
vim.opt.cursorline = false
-- vim.opt.cursorline = true
vim.opt.cursorlineopt = "both"
vim.opt.omnifunc = "syntaxcomplete#Complete"
vim.opt.colorcolumn = "80"
vim.opt.textwidth = 0
vim.opt.termguicolors = true
vim.opt.pumblend = 30
vim.opt.signcolumn = "yes"
vim.opt.statusline = " "
-- vim.opt.fillchars = { stl = '─', stlnc = '─' }
vim.opt.fillchars = { stl = " ", stlnc = " " }
vim.opt.laststatus = 2
vim.opt.winbar = ""
vim.opt.guicursor = "n-sm:block,i-c-ci-ve:ver25,r-cr-o-v:hor20"
-- vim.opt.guicursor='n-sm:block,i-c-ci-ve:block,r-cr-o-v:hor20'
vim.opt.swapfile = false
vim.opt.redrawtime = 1111
-- vim.opt.keymap = 'russian-jcuken'

-- for ghostty, until the scroll multiplication is fixed
-- vim.opt.mousescroll = 'ver:1,hor:2'

-- Stop fucking annoying labels from jumping around when expanded from relative
-- to full paths in the tabline when focused/unfocused. Another one of a
-- thousand and one setting designed for you to waste time on.
function _G.MyTabLine()
  local s = ""
  local tab_count = vim.fn.tabpagenr("$")
  local current_tab = vim.fn.tabpagenr()
  for t = 1, tab_count do
    s = s .. (t == current_tab and "%#TabLineSel#" or "%#TabLine#")
    s = s .. "%" .. t .. "T " .. t .. " "
    local n = ""
    local bc = 0
    for _, b in ipairs(vim.fn.tabpagebuflist(t)) do
      local bn = ""
      local bt = vim.fn.getbufvar(b, "&buftype")
      if bt == "help" then
        bn = "[Help]" .. vim.fn.fnamemodify(vim.fn.bufname(b), ":t:s/.txt$//")
      elseif bt == "quickfix" then
        bn = "[Quickfix]"
      else
        local tn = vim.fn.fnamemodify(vim.fn.bufname(b), ":t")
        if bt == "prompt" or bt == "nofile" then
          goto continue
        elseif tn == "" then
          bn = "[New file]"
        else
          bn = tn
        end
      end
      if vim.fn.getbufvar(b, "&modified") == 1 then
        bn = bn .. " (modified)"
      end
      n = n .. (bc > 0 and ", " or "") .. bn
      bc = bc + 1
      ::continue::
    end
    s = s .. n .. " "
  end
  s = s .. "%#TabLineFill#%T"
  if tab_count > 1 then
    s = s .. "%=%#TabLineFill#%999X"
  end
  return s
end
vim.opt.tabline = "%!v:lua.MyTabLine()"

vim.g.mapleader = " "
vim.g.editorconfig = false

-- OF COURSE there is some idiotic dog water that explodes your settings for
-- no reason. OF COURSE I wasted 2 hours trying to understand why this shit
-- happens.
vim.g.yaml_recommended_style = 0
vim.g.rust_recommended_style = 0
vim.g.ruby_recommended_style = 0
vim.g.hare_recommended_style = 0
vim.g.markdown_recommended_style = 0
vim.g.python_recommended_style = 0
vim.g.sass_recommended_style = 0
vim.g.meson_recommended_style = 0

local user_augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.g.loaded_zipPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_sql_completion = 1

vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Neovide :3
if vim.g.neovide then
  vim.opt.guifont = "Terminess:h12"
  vim.opt.mousescroll = "ver:3,hor:3"

  vim.g.terminal_color_0 = "#3b4252"
  vim.g.terminal_color_1 = "#BF616A"
  vim.g.terminal_color_2 = "#A3B38C"
  vim.g.terminal_color_3 = "#D08770"
  vim.g.terminal_color_4 = "#5E81AC"
  vim.g.terminal_color_5 = "#B48EAD"
  vim.g.terminal_color_6 = "#88C0D0"
  vim.g.terminal_color_7 = "#81A1C1"
  vim.g.terminal_color_8 = "#4C566A"
  vim.g.terminal_color_9 = "#BF616A"
  vim.g.terminal_color_10 = "#A3B38C"
  vim.g.terminal_color_11 = "#D08770"
  vim.g.terminal_color_12 = "#5E81AC"
  vim.g.terminal_color_13 = "#B48EAD"
  vim.g.terminal_color_14 = "#88C0D0"
  vim.g.terminal_color_15 = "#E5E9F0"

  vim.g.neovide_refresh_rate = 120
  vim.g.neovide_scroll_animation_length = 0.05
  vim.g.neovide_hide_mouse_when_typing = false
  vim.g.neovide_cursor_animation_length = 0.01
end

-- Key mappings
vim.keymap.set("n", "<C-g>", "g<C-g>", { silent = true })
vim.keymap.set("v", "<C-g>", "g<C-g>", { silent = true })

vim.keymap.set(
  "n",
  "<Space>e",
  ":lua vim.diagnostic.open_float()<CR>",
  { silent = true }
)
vim.keymap.set("n", "<Space>ll", function()
  Snacks.picker.diagnostics_buffer()
end, { desc = "Buffer diagnostics" })

-- Search bindings. Very convenient and fucking stupid.
vim.keymap.set("n", "<Esc>", ":noh<CR><ESC>", { silent = true })
vim.keymap.set(
  "n",
  "?",
  ':silent setl hls | let @/ = input("/")<CR>',
  { silent = true }
)
vim.keymap.set(
  "v",
  "?",
  ':silent setl hls | let @/ = input("/")<CR>',
  { silent = true }
)

vim.keymap.set(
  "n",
  "*",
  ':let @/ = "<C-r><C-w>" | set hlsearch<CR>',
  { silent = true }
)
vim.keymap.set(
  "v",
  "*",
  '"0y | :let @/ = "<C-r>0" | set hlsearch<CR>',
  { silent = true }
)

local function get_project_root()
  return Snacks.git.get_root() or vim.fn.getcwd()
end

local function do_grep_project(search_text)
  vim.fn.setreg("/", search_text)
  Snacks.picker.grep({
    cwd = get_project_root(),
    search = search_text,
    regex = false,
  })
end

vim.keymap.set("n", "<C-s>", function()
  do_grep_project(vim.fn.expand("<cword>"))
end, { desc = "Grep word" })
vim.keymap.set("v", "<C-s>", function()
  vim.cmd('normal! "0y')
  do_grep_project(vim.fn.getreg("0"))
end, { desc = "Grep selection" })

local function do_pick(picker_name, picker_opts)
  return function()
    Snacks.picker[picker_name](picker_opts and picker_opts() or nil)
  end
end

local function do_get_root_opts()
  return { cwd = get_project_root() }
end

vim.keymap.set("n", "<C-b>", function()
  local api = require("nvim-tree.api")
  if api.tree.is_visible() then
    api.tree.find_file({ focus = true })
    return
  end

  api.tree.open({ path = get_project_root(), find_file = true })
end, { desc = "File tree" })
vim.keymap.set("n", "<Space>z", function()
  Snacks.zen()
end, { desc = "Zen mode" })
vim.keymap.set("n", "<Space>Z", function()
  Snacks.zen.zoom()
end, { desc = "Zoom window" })
vim.keymap.set("n", "<Space>n", function()
  Snacks.notifier.show_history()
end, { desc = "Notification history" })
vim.keymap.set("n", "<Space>gg", function()
  Snacks.lazygit({ cwd = get_project_root() })
end, { desc = "Lazygit" })
vim.keymap.set("n", "]]", function()
  Snacks.words.jump(vim.v.count1)
end, { desc = "Next reference" })
vim.keymap.set("n", "[[", function()
  Snacks.words.jump(-vim.v.count1)
end, { desc = "Previous reference" })
vim.keymap.set("n", "<C-p>", do_pick("commands"), { desc = "Commands" })
vim.keymap.set("n", "<Space>sC", do_pick("commands"), { desc = "Commands" })
vim.keymap.set(
  "n",
  "<Space>:",
  do_pick("command_history"),
  { desc = "Command history" }
)
vim.keymap.set("n", "<Space>sk", do_pick("keymaps"), { desc = "Keymaps" })
vim.keymap.set("n", "<Space>sh", do_pick("help"), { desc = "Help pages" })
vim.keymap.set("n", "<Space>sp", do_pick("pickers"), { desc = "Pickers" })
vim.keymap.set("n", "<Space>sR", do_pick("resume"), { desc = "Resume picker" })
vim.keymap.set(
  "n",
  "<Space>sd",
  do_pick("diagnostics"),
  { desc = "Diagnostics" }
)
vim.keymap.set(
  "n",
  "<Space>ss",
  do_pick("lsp_symbols"),
  { desc = "LSP symbols" }
)
vim.keymap.set(
  "n",
  "<Tab>",
  do_pick("files", do_get_root_opts),
  { desc = "Find files" }
)
vim.keymap.set(
  "n",
  "<Space>fg",
  do_pick("git_files", do_get_root_opts),
  { desc = "Find git files" }
)
vim.keymap.set("n", "<Space>fr", do_pick("recent"), { desc = "Recent files" })
vim.keymap.set("n", "<Space>,", do_pick("buffers"), { desc = "Buffers" })
vim.keymap.set(
  "n",
  "<Space><Tab>",
  do_pick("grep", do_get_root_opts),
  { desc = "Grep" }
)
vim.keymap.set(
  { "n", "x" },
  "<Space>sw",
  do_pick("grep_word", do_get_root_opts),
  { desc = "Grep word" }
)

vim.keymap.set("n", "<Space>y", '"+y')
vim.keymap.set("n", "<Space>p", '"+p')
vim.keymap.set("v", "<Space>y", '"+y')
vim.keymap.set("v", "<Space>p", '"+p')

vim.keymap.set("v", "<C-Right>", "w")
vim.keymap.set("v", "<C-Left>", "b")
vim.keymap.set("n", "<C-Right>", "w")
vim.keymap.set("n", "<C-Left>", "b")

vim.keymap.set("n", "<C-Up>", "{")
vim.keymap.set("n", "<C-Down>", "}")
vim.keymap.set("i", "<C-Up>", "<C-o>{")
vim.keymap.set("i", "<C-Down>", "<C-o>}")
vim.keymap.set("v", "<C-Up>", "{")
vim.keymap.set("v", "<C-Down>", "}")

vim.keymap.set("n", "<C-o>", "<Nop>", { silent = true })

-- Move lines with ALT + up/down
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==")
vim.keymap.set("i", "<A-Down>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("i", "<A-Up>", "<Esc>:m .-2<CR>==gi")

-- Emacs' keys to jump to beginning/end of the line
vim.keymap.set("i", "<C-e>", "<End>")
vim.keymap.set("i", "<C-a>", "<Home>")
vim.keymap.set({ "n", "v" }, "<C-e>", "$")
vim.keymap.set({ "n", "v" }, "<C-a>", "0")

-- Emacs' keys to switch previous buffers
vim.keymap.set("n", "<C-x><Left>", "<C-o>")
vim.keymap.set("n", "<C-x><Right>", "<C-i>")

-- Emacs' keys to remove words
vim.keymap.set("i", "<C-BS>", "<C-w>")
vim.keymap.set("i", "<C-Del>", "<C-o>dw")

-- Do not suspend Vi with C-z
vim.keymap.set("n", "<C-z>", "<Nop>")
vim.keymap.set("n", "<C-S-z>", "<Nop>")

-- I use arrows a lot, so q/a for Insert/Append is way better
vim.keymap.set("n", "q", "i")
vim.keymap.set("n", "<C-q>", "q")

-- Latex mappings
vim.keymap.set("n", "в;", "d$")
vim.keymap.set("n", "й", "i")
vim.keymap.set("n", "ш", "i")
vim.keymap.set("n", "вв", "dd")
vim.keymap.set("n", "М", "V")
vim.keymap.set("n", "вц", "dw")
vim.keymap.set("n", "ц", "w")
vim.keymap.set("n", "м", "v")
vim.keymap.set("n", "ф", "a")
vim.keymap.set("n", "ч", "x")
vim.keymap.set("n", "г", "u")
vim.keymap.set("n", "<C-к>", "<C-r>")
vim.keymap.set("v", "в", "d")

vim.keymap.set("n", "m", "O<ESC>")

-- Don't show status on nofile buffers
vim.api.nvim_create_autocmd({ "VimEnter", "BufWinEnter" }, {
  group = user_augroup,
  callback = function()
    local is_floating = vim.api.nvim_win_get_config(0).relative ~= ""
    if vim.bo.buftype ~= "nofile" and not is_floating then
      vim.opt_local.statusline = "%.f:%l:%c%=[%{mode(1)}]%=%=%{&filetype} %P"
    end
  end,
})

-- Until it's fixed
-- vim.api.nvim_create_autocmd("InsertEnter", {
--   group = user_augroup,
--   callback = function()
--     vim.cmd('silent set cmdheight=0')
--   end,
-- })

-- Some terminals re-send an OSC 11 background report on resize. The built-in
-- TermResponse handler would then flip 'background' and re-source the
-- colorscheme, wiping the manual highlight overrides below. The group exists
-- only when nvim runs attached to a tty, so the call is guarded.
pcall(
  vim.api.nvim_clear_autocmds,
  { group = "nvim.tty", event = "TermResponse" }
)

vim.o.background = "dark"
-- vim.o.background = "light"
vim.cmd.colorscheme("duskfox")
-- vim.cmd.colorscheme "carbonfox"
-- vim.cmd.colorscheme 'dawnfox'
-- vim.cmd.colorscheme 'nordfox'
-- vim.cmd.colorscheme("nightfox")
-- vim.cmd.colorscheme 'kanagawa-lotus'

local function get_bg_color(highlight_name)
  local success, hl = pcall(function()
    return vim.api.nvim_get_hl(0, { name = highlight_name })
  end)
  if not success then
    return nil
  end
  return hl.bg and string.format("#%06x", hl.bg) or nil
end

local function get_fg_color(highlight_name)
  local success, hl = pcall(function()
    return vim.api.nvim_get_hl(0, { name = highlight_name })
  end)
  if not success then
    return nil
  end
  return hl.fg and string.format("#%06x", hl.fg) or nil
end

vim.api.nvim_set_hl(
  0,
  "DiagnosticUnderlineError",
  { undercurl = true, sp = "red" }
)
vim.api.nvim_set_hl(
  0,
  "DiagnosticUnderlineWarn",
  { undercurl = true, sp = "yellow" }
)
vim.api.nvim_set_hl(
  0,
  "DiagnosticUnderlineHint",
  { underdashed = true, sp = "white" }
)
vim.api.nvim_set_hl(
  0,
  "DiagnosticUnderlineInfo",
  { underdotted = true, sp = "gray" }
)

vim.api.nvim_set_hl(0, "ColorColumn", { link = "CursorColumn" })
vim.api.nvim_set_hl(0, "CurSearch", { link = "Search" })
vim.api.nvim_set_hl(0, "SignColumn", { link = "LineNr" })
vim.api.nvim_set_hl(0, "MatchParen", { bg = "gray", fg = "pink" })
vim.api.nvim_set_hl(0, "Winbar", { link = "SignColumn" })

vim.api.nvim_set_hl(
  0,
  "TabLine",
  { bg = get_bg_color("TabLineFill"), fg = get_fg_color("Conceal") }
)
vim.api.nvim_set_hl(0, "TabLineSel", { link = "SignColumn" })
-- vim.api.nvim_set_hl(0, 'StatusLine', { link = 'Conceal' })
-- vim.api.nvim_set_hl(0, 'StatusLineNC', { link = 'Whitespace' })
vim.api.nvim_set_hl(
  0,
  "StatusLine",
  { bg = get_bg_color("NvimTreeNormal"), fg = get_fg_color("Conceal") }
)
vim.api.nvim_set_hl(0, "StatusLineNC", { link = "StatusLine" })
vim.api.nvim_set_hl(
  0,
  "WinSeparator",
  { bg = get_bg_color("NvimTreeNormal"), fg = get_bg_color("NvimTreeNormal") }
)
vim.api.nvim_set_hl(0, "VertSplit", { link = "WinSeparator" })
vim.api.nvim_set_hl(0, "NvimTreeStatusLine", { link = "StatusLineNC" })
vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { link = "VertSplit" })
vim.api.nvim_set_hl(0, "FloatBorder", { link = "Whitespace" })

local should_enable_transparent_background = false

if should_enable_transparent_background then
  vim.cmd([[
  highlight Normal guibg=none
  highlight NormalNC guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NormalNC ctermbg=none
  highlight NonText ctermbg=none
  highlight NvimTreeNormal guibg=none ctermbg=none
]])
end

local ccc = require("ccc")
ccc.setup({
  inputs = {
    ccc.input.hsl,
    ccc.input.rgb,
  },
  highlighter = {
    auto_enable = true,
    lsp = true,
  },
  virtual_symbol = "■ ",
  highlight_mode = "bg",
})

vim.keymap.set("n", "<C-h>", function()
  vim.cmd([[:CccPick]])
end)

local treesitter = require("nvim-treesitter")
treesitter.setup({})
treesitter.install({ "svelte" })

vim.api.nvim_create_autocmd("FileType", {
  group = user_augroup,
  callback = function(args)
    if
      vim.bo[args.buf].filetype == "bigfile"
      or vim.api.nvim_buf_line_count(args.buf) > 3333
    then
      return
    end
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if
      lang
      and vim.list_contains(treesitter.get_available(), lang)
      and not vim.list_contains(treesitter.get_installed("parsers"), lang)
    then
      treesitter.install({ lang })
    end
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

local function trans_border()
  return { border = "solid", winblend = 30 }
end

vim.opt.tabstop = 4
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 0

local guessindent = require("guess-indent")
guessindent.setup({
  auto_cmd = true,
  on_tab_options = {
    ["expandtab"] = false,
    ["tabstop"] = 4,
    ["softtabstop"] = 0,
    ["shiftwidth"] = 0,
  },
  on_space_options = {
    ["expandtab"] = true,
    ["tabstop"] = "detected",
    ["softtabstop"] = "detected",
    ["shiftwidth"] = "detected",
  },
})

local gitsigns = require("gitsigns")
gitsigns.setup({})

vim.keymap.set("n", "<C-c>c", gitsigns.blame_line)
vim.keymap.set("n", "<C-c>a", gitsigns.blame)

require("mini.surround").setup({})
require("mini.align").setup({})

require("trim").setup({ trim_on_write = false })

vim.api.nvim_create_autocmd("QuitPre", {
  group = user_augroup,
  callback = function()
    local tree_windows = {}
    local editor_window_count = 0
    for _, window in ipairs(vim.api.nvim_list_wins()) do
      local buffer = vim.api.nvim_win_get_buf(window)
      local is_floating = vim.api.nvim_win_get_config(window).relative ~= ""
      if vim.bo[buffer].filetype == "NvimTree" then
        table.insert(tree_windows, window)
      elseif not is_floating then
        editor_window_count = editor_window_count + 1
      end
    end

    if editor_window_count == 1 then
      for _, window in ipairs(tree_windows) do
        vim.api.nvim_win_close(window, true)
      end
    end
  end,
})

-- this eats memory and makes lsp do weird things. my log was 1.2 GiB =D
vim.lsp.log.set_level("error")

local hover_opts = trans_border()
vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx)
  return vim.lsp.handlers.hover(err, result, ctx, hover_opts)
end

local signature_opts = trans_border()
vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx)
  return vim.lsp.handlers.signature_help(err, result, ctx, signature_opts)
end

vim.diagnostic.config({
  virtual_text = true,
  update_in_insert = false,
  signs = true,
  float = {
    border = "rounded",
    scope = "line",
    format = function(diagnostic)
      return string.format(
        "%d:%d: %s (%s)",
        diagnostic.lnum + 1,
        diagnostic.col + 1,
        diagnostic.message,
        diagnostic.source
      )
    end,
  },
})

local function default_on_init(client)
  client.server_capabilities.hover = true
  client.server_capabilities.signature_help = true
end

local default_flags = {
  debounce_text_changes = 150,
}

local default_telemetry = {
  enable = false,
}

local default_servers = {
  -- "biome",
  "ts_ls",
  "svelte",
  -- "eslint",
  "pylsp",
  "ruff",
  "zls",
  -- "clangd",
  "rust_analyzer",
  -- "texlab",
  "gopls",
  "powershell_es",
  "tinymist",
  "ansiblels",
  "yamlls",
}

local enable_lsp = true

if enable_lsp then
  local lspconfig = vim.lsp.config
  local lspconfigutil = require("lspconfig.util")
  local blink_capabilities = require("blink.cmp").get_lsp_capabilities()

  vim.lsp.enable("lua_ls", {
    on_init = default_on_init,
    capabilities = blink_capabilities,
    telemetry = default_telemetry,
    flags = default_flags,
    settings = {
      Lua = {
        diagnostics = {
          globals = {
            "vim",
            "require",
          },
        },
      },
    },
    workspace = {
      library = vim.api.nvim_get_runtime_file("", true),
    },
  })

  lspconfig("powershell_es", {
    bundle_path = vim.env.HOME .. "/External/powershell-eds",
  })

  for _, lsp in ipairs(default_servers) do
    vim.lsp.enable(lsp, {
      on_init = default_on_init,
      capabilities = blink_capabilities,
      flags = default_flags,
      telemetry = default_telemetry,
      root_dir = lspconfigutil.root_pattern(".git", "Makefile"),
    })
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client and client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
      end

      local opts = { buffer = ev.buf }

      vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover, opts)
      vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)

      local nowait_opts = { buffer = ev.buf, nowait = true }

      vim.keymap.set("n", "<Space>gd", Snacks.picker.lsp_definitions, opts)
      vim.keymap.set("n", "<Space>gi", Snacks.picker.lsp_implementations, opts)
      vim.keymap.set("n", "<Space>gs", Snacks.picker.lsp_symbols, opts)
      vim.keymap.set(
        "n",
        "<Space>gS",
        Snacks.picker.lsp_workspace_symbols,
        opts
      )
      vim.keymap.set("n", "<Space>gr", Snacks.picker.lsp_references, opts)
      vim.keymap.set("n", "<space>gt", vim.lsp.buf.typehierarchy, opts)

      vim.keymap.set("n", "<Space>co", Snacks.picker.lsp_outgoing_calls, opts)
      vim.keymap.set("n", "<Space>ci", Snacks.picker.lsp_incoming_calls, opts)

      vim.keymap.set("n", "<Space>wc", vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set(
        "n",
        "<Space>wd",
        vim.lsp.buf.remove_workspace_folder,
        opts
      )

      vim.keymap.set("n", "<Space>wl", function()
        vim.print(vim.lsp.buf.list_workspace_folders())
      end, opts)

      vim.keymap.set("n", "<Space>d", Snacks.picker.lsp_type_definitions, opts)
      vim.keymap.set("n", "<Space>rr", vim.lsp.buf.rename, opts)
      vim.keymap.set({ "n", "v" }, "<Space>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "gr", Snacks.picker.lsp_references, nowait_opts)

      vim.keymap.set("n", "<Space>ff", function()
        vim.lsp.buf.format({ async = true })
      end, opts)
    end,
  })

  require("blink.cmp").setup({
    enabled = function()
      if vim.api.nvim_get_mode().mode == "c" then
        return true
      end
      if
        vim.bo.filetype == "markdown"
        or vim.bo.filetype == "text"
        or vim.bo.filetype == ""
      then
        return false
      end
      local ok_ts, ts = pcall(vim.treesitter.get_captures_at_cursor)
      if ok_ts then
        for _, cap in ipairs(ts) do
          if cap == "comment" or cap:match("^comment%.") then
            return false
          end
        end
      end
      return true
    end,
    keymap = {
      preset = "default",
      ["<C-Space>"] = { "show", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<CR>"] = { "fallback" },
      ["<Esc>"] = {
        function(c)
          if c.is_visible() then
            c.cancel()
          end
        end,
        "fallback",
      },
      ["<Tab>"] = {
        function(c)
          if c.get_selected_item() ~= nil then
            return c.accept()
          end
          if c.is_visible() then
            return c.select_and_accept()
          end
          if c.snippet_active({ direction = 1 }) then
            return c.snippet_forward()
          end
        end,
        "fallback",
      },
      ["<S-Tab>"] = {
        function(c)
          if c.is_visible() then
            return c.select_prev()
          end
          if c.snippet_active({ direction = -1 }) then
            return c.snippet_backward()
          end
        end,
        "fallback",
      },
    },
    snippets = { preset = "default" },
    signature = {
      enabled = true,
      window = trans_border(),
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      min_keyword_length = 2,
      providers = {
        lsp = { name = "💎" },
        path = { name = "⚣ " },
        snippets = { name = "✌ " },
        buffer = { name = "  " },
      },
    },
    cmdline = {
      keymap = { preset = "cmdline" },
      completion = {
        menu = { auto_show = true },
        list = {
          selection = { preselect = false, auto_insert = true },
        },
      },
    },
    completion = {
      trigger = { prefetch_on_insert = false },
      keyword = { range = "prefix" },
      list = {
        selection = { preselect = false, auto_insert = false },
      },
      accept = { auto_brackets = { enabled = false } },
      menu = vim.tbl_extend("force", trans_border(), {
        auto_show = false,
        draw = {
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "source_name" },
          },
          components = {
            label = { width = { max = 32 } },
          },
        },
      }),
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 150,
        window = trans_border(),
      },
      ghost_text = {
        enabled = true,
        show_without_selection = true,
        show_with_selection = true,
        show_without_menu = true,
        show_with_menu = true,
      },
    },
  })
end
