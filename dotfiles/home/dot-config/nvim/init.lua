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

-- Install lazy.nvim if not already installed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
    lazy = true
  },

  -- SSH
  {
     "amitds1997/remote-nvim.nvim",
     version = "*",
     dependencies = { "MunifTanjim/nui.nvim" },
     config = true,
  },

  -- LSP and completion
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'dcampos/nvim-snippy' },
  { 'dcampos/cmp-snippy' },
  { 'rmagatti/goto-preview' },

  -- Telescope and utilities
  { 'nvim-telescope/telescope.nvim', dependencies = 'nvim-lua/plenary.nvim' },

  -- Treesitter
  -- { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  -- { 'nvim-treesitter/nvim-treesitter-context' },

  -- { 'folke/trouble.nvim', cmd = "Trouble" },

  -- Miscellaneous plugins
  { 'koryschneider/vim-trim' },
  { 'NMAC427/guess-indent.nvim' },
  -- Slow as hell
  { 'sheerun/vim-polyglot' },
  { 'lewis6991/gitsigns.nvim' },

  -- -- Themes
  { 'EdenEast/nightfox.nvim' },
  { 'rebelot/kanagawa.nvim' },
  { 'ellisonleao/gruvbox.nvim' },
  { 'cocopon/iceberg.vim' },

  -- Tools
  { 'folke/zen-mode.nvim' },
  { 'junegunn/vim-easy-align' },
  { 'echasnovski/mini.surround' },
  { 'nvim-tree/nvim-tree.lua' },
  { 'windwp/nvim-ts-autotag' },
  { 'uga-rosa/ccc.nvim' },

  { 'petertriho/nvim-scrollbar' },
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
vim.opt.tabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 2
vim.opt.fileformat = 'unix'
vim.opt.expandtab = true
vim.opt.smarttab = true
-- vim.opt.guioptions = 'mT'
vim.opt.encoding = 'UTF-8'
vim.opt.number = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.autochdir = true
vim.opt.list = true
vim.opt.showmode = true
vim.opt.cmdheight = 0
vim.opt.cinoptions = 'l1'
vim.opt.listchars = { tab = '┊ ', space = '·' }
-- vim.opt.listchars = { tab = '┊ ', space = '·', eol = '↵' }
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = 'unnamed'
-- vim.opt.cursorline = true
vim.opt.cursorline = false
vim.opt.cursorlineopt = 'number'
vim.opt.omnifunc = 'syntaxcomplete#Complete'
vim.opt.colorcolumn = '80'
vim.opt.textwidth = 0
vim.opt.termguicolors = true
vim.opt.pumblend = 30
vim.opt.winblend = 30
vim.opt.signcolumn = 'yes'
vim.opt.statusline = ' '
-- vim.opt.fillchars = { stl = '─', stlnc = '─' }
vim.opt.fillchars = { stl = ' ', stlnc = ' ' }
vim.opt.laststatus = 2
vim.opt.winbar = ''
vim.opt.guicursor='n-sm:block,i-c-ci-ve:ver25,r-cr-o-v:hor20'
-- vim.opt.guicursor='n-sm:block,i-c-ci-ve:block,r-cr-o-v:hor20'
vim.opt.swapfile = false
vim.opt.redrawtime = 1111
-- vim.opt.keymap = 'russian-jcuken'

-- for ghostty, until the scroll multiplication is fixed
-- vim.opt.mousescroll = 'ver:1,hor:2'

-- Stop fucking annoying labels from jumping around when expanded from relative
-- to full paths in the tabline when focused/unfocused. Another one of a
-- thousand and one setting designed for you to waste time on.
function MyTabLine()
  local s = ''
  for t = 1, vim.fn.tabpagenr('$') do
    s = s .. (t == vim.fn.tabpagenr() and '%#TabLineSel#' or '%#TabLine#')
    s = s .. '%' .. t .. 'T ' .. t .. ' '
    local n = ''
    local bc = 0
    for _, b in ipairs(vim.fn.tabpagebuflist(t)) do
      local bn = ''
      local bt = vim.fn.getbufvar(b, '&buftype')
      if bt == 'help' then
        bn = '[Help]' .. vim.fn.fnamemodify(vim.fn.bufname(b), ':t:s/.txt$//')
      elseif bt == 'quickfix' then
        bn = '[Quickfix]'
      else
        local tn = vim.fn.fnamemodify(vim.fn.bufname(b), ':t')
        if tn:match('NvimTree_') then
          bn = '[File tree]'
        elseif bt == 'prompt' or bt == 'nofile' then
          goto continue
        elseif tn == '' then
          bn = '[New file]'
        else
          bn = tn
        end
      end
      if vim.fn.getbufvar(b, '&modified') == 1 then
        bn = bn .. ' (modified)'
      end
      n = n .. (bc > 0 and ', ' or '') .. bn
      bc = bc + 1
      ::continue::
    end
    s = s .. n .. ' '
  end
  s = s .. '%#TabLineFill#%T'
  if vim.fn.tabpagenr('$') > 1 then
    s = s .. '%=%#TabLineFill#%999X'
  end
  return s
end
vim.opt.tabline = '%!v:lua.MyTabLine()'

vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = ' '
vim.g.snippy_enable_snipmate = true
vim.g.EasyMotion_use_migemo = 1
vim.g.rainbow_active = true
vim.g.lazygit_floating_window_winblend = 30
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

vim.g.loaded_zipPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_sql_completion = 1

-- Neovide :3
if vim.g.neovide then
  vim.opt.guifont = "Hack:h12"

  vim.g.terminal_color_0  = "#3b4252"
  vim.g.terminal_color_1  = "#BF616A"
  vim.g.terminal_color_2  = "#A3B38C"
  vim.g.terminal_color_3  = "#D08770"
  vim.g.terminal_color_4  = "#5E81AC"
  vim.g.terminal_color_5  = "#B48EAD"
  vim.g.terminal_color_6  = "#88C0D0"
  vim.g.terminal_color_7  = "#81A1C1"
  vim.g.terminal_color_8  = "#4C566A"
  vim.g.terminal_color_9  = "#BF616A"
  vim.g.terminal_color_10 = "#A3B38C"
  vim.g.terminal_color_11 = "#D08770"
  vim.g.terminal_color_12 = "#5E81AC"
  vim.g.terminal_color_13 = "#B48EAD"
  vim.g.terminal_color_14 = "#88C0D0"
  vim.g.terminal_color_15 = "#E5E9F0"

  vim.g.neovide_refresh_rate = 144
  vim.g.neovide_scroll_animation_length = 0.05
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_cursor_animation_length = 0
end

vim.g.nvim_tree_open = 0
function NvimTreeToggle2()
  if vim.g.nvim_tree_open == 1 then
    vim.cmd('NvimTreeClose')
    vim.g.nvim_tree_open = 0
  else
    vim.cmd('NvimTreeFindFile')
    vim.g.nvim_tree_open = 1
  end
end
if vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
  vim.g.nvim_tree_open = 1
end

-- Key mappings
vim.keymap.set('n', '<C-g>', 'g<C-g>', { silent = true })
vim.keymap.set('v', '<C-g>', 'g<C-g>', { silent = true })

vim.keymap.set('n', '<C-o>', '<Nop>', { silent = true })
vim.keymap.set('n', 'gA', '<Plug>(EasyAlign)')
vim.keymap.set('v', 'gA', '<Plug>(EasyAlign)')

vim.keymap.set('n', '<C-p>', ':Telescope<CR>', { silent = true })
vim.keymap.set('n', '<C-b>', ':lua NvimTreeToggle2()<CR>', { silent = true })

vim.keymap.set('n', '<Space>e',
  ':lua vim.diagnostic.open_float()<CR>', { silent = true })
vim.keymap.set('n', '<Space>ll',
  ':lua vim.diagnostic.setloclist()<CR>', { silent = true })

-- Search bindings. Very convenient and fucking stupid.
vim.keymap.set('n', '<Esc>', ':noh<CR><ESC>', { silent = true })
vim.keymap.set('n', '?',
  ':silent setl hls | let @/ = input("/")<CR>', { silent = true })
vim.keymap.set('v', '?',
  ':silent setl hls | let @/ = input("/")<CR>', { silent = true })

vim.keymap.set('n', '*',
  ':let @/ = "<C-r><C-w>" | set hlsearch<CR>',
  { silent = true })
vim.keymap.set('v', '*',
  '"0y | :let @/ = "<C-r>0" | set hlsearch<CR>',
  { silent = true })

vim.keymap.set('n', '<C-s>',
  ':let @/ = "<C-r><C-w>" | lua live_grep_from_project_git_root()<CR> <C-o>"/p<C-o>0<C-o>x<C-o>$',
  { silent = true})
vim.keymap.set('v', '<C-s>',
  '"0y | :let @/ = "<C-r>0" | lua live_grep_from_project_git_root()<CR> <C-o>"/p<C-o>0<C-o>x<C-o>$',
  { silent = true})

vim.keymap.set('n', '<S-Tab>',
  ':lua find_files_from_project_git_root()<CR>', { silent = true })
vim.keymap.set('n', '<Tab>',
  ':lua live_grep_from_project_git_root()<CR>', { silent = true })

-- Same as above, without git
vim.keymap.set('n', '<Space><S-Tab>',
  ':Telescope find_files<CR>', { silent = true })
vim.keymap.set('n', '<Space><Tab>',
  ':Telescope live_grep<CR>', { silent = true })

vim.keymap.set('n', '<Space>y', '"+y')
vim.keymap.set('n', '<Space>p', '"+p')
vim.keymap.set('v', '<Space>y', '"+y')
vim.keymap.set('v', '<Space>p', '"+p')

vim.keymap.set('v', '<C-Right>', 'w')
vim.keymap.set('v', '<C-Left>', 'b')
vim.keymap.set('n', '<C-Right>', 'w')
vim.keymap.set('n', '<C-Left>', 'b')

vim.keymap.set('n', '<C-Up>', '{')
vim.keymap.set('n', '<C-Down>', '}')
vim.keymap.set('i', '<C-Up>', '<C-o>{')
vim.keymap.set('i', '<C-Down>', '<C-o>}')
vim.keymap.set('v', '<C-Up>', '{')
vim.keymap.set('v', '<C-Down>', '}')

vim.keymap.set('n', '<C-o>', '<Nop>', { silent = true })
vim.keymap.set('n', 'gA', '<Plug>(EasyAlign)')
vim.keymap.set('v', 'gA', '<Plug>(EasyAlign)')

vim.keymap.set('n', '<Space>e',
  ':lua vim.diagnostic.open_float()<CR>', { silent = true })
vim.keymap.set('n', '<Space>ll',
  ':lua vim.diagnostic.setloclist()<CR>', { silent = true })

-- Move lines with ALT + up/down
vim.api.nvim_set_keymap('n', '<A-Down>', ':m .+1<CR>==', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-Up>', ':m .-2<CR>==', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-Down>', '<Esc>:m .+1<CR>==gi', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-Up>', '<Esc>:m .-2<CR>==gi', { noremap = true })

-- Emacs' keys to jump to beginning/end of the line
vim.api.nvim_set_keymap('i', '<C-e>', '<End>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-a>', '<Home>', { noremap = true })
vim.api.nvim_set_keymap('v', '<C-e>', '$', { noremap = true })
vim.api.nvim_set_keymap('v', '<C-a>', '0', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-e>', '$', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-a>', '0', { noremap = true })

-- Emacs' keys to switch previous buffers
vim.api.nvim_set_keymap('n', '<C-x><Left>', '<C-o>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-x><Right>', '<C-i>', { noremap = true })

-- Emacs' keys to remove words
vim.api.nvim_set_keymap('i', '<C-BS>', '<C-w>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-Del>', '<C-o>dw', { noremap = true })

-- Do not suspend Vi with C-z
vim.api.nvim_set_keymap('n', '<C-z>', '<NOP>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-S-z>', '<NOP>', { noremap = true })

-- I use arrows a lot, so q/a for Insert/Append is way better
vim.api.nvim_set_keymap('n', 'q', 'i', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-q>', 'q', { noremap = true })

-- Latex mappings
vim.api.nvim_set_keymap('n', 'в;', 'd$', { noremap = true })
vim.api.nvim_set_keymap('n', 'й', 'i', { noremap = true })
vim.api.nvim_set_keymap('n', 'ш', 'i', { noremap = true })
vim.api.nvim_set_keymap('n', 'вв', 'dd', { noremap = true })
vim.api.nvim_set_keymap('n', 'М', 'V', { noremap = true })
vim.api.nvim_set_keymap('n', 'вц', 'dw', { noremap = true })
vim.api.nvim_set_keymap('n', 'ц', 'w', { noremap = true })
vim.api.nvim_set_keymap('n', 'м', 'v', { noremap = true })
vim.api.nvim_set_keymap('n', 'ф', 'a', { noremap = true })
vim.api.nvim_set_keymap('n', 'ч', 'x', { noremap = true })
vim.api.nvim_set_keymap('n', 'г', 'u', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-к>', '<C-r>', { noremap = true })

vim.api.nvim_set_keymap('v', 'в', 'd', { noremap = true })

vim.api.nvim_set_keymap('n', 'm', 'O<ESC>', { noremap = true })

-- vim.api.nvim_create_autocmd({"BufEnter"}, {
--   pattern = "*", command = "silent GuessIndent",
-- })

-- Don't show status on nofile buffers
vim.api.nvim_create_autocmd({"VimEnter", "BufWinEnter"}, {
  callback = function()
    if vim.bo.buftype ~= 'nofile' then
      vim.opt_local.statusline = "%.f:%l:%c%=[%{mode(1)}]%=%=%{&filetype} %P"
    end
  end
})

-- Until it's fixed
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.cmd('silent set cmdheight=0')
  end
})

-- Theme
-- vim.cmd.colorscheme 'duskfox'
-- vim.cmd.colorscheme 'nightfox'
-- vim.cmd.colorscheme 'dawnfox' -- light theme
vim.cmd.colorscheme 'terafox'
-- vim.cmd.colorscheme 'carbonfox'
-- vim.cmd.colorscheme 'gruvbox'
-- vim.cmd.colorscheme 'kanagawa-wave'
-- vim.cmd.colorscheme 'nordfox'
-- vim.cmd.colorscheme 'iceberg'
-- vim.cmd.colorscheme 'default'

function get_bg_color(highlight_name)
  local success, hl = pcall(function () return vim.api.nvim_get_hl_by_name(highlight_name, true) end)
  if not success then return nil end
  return hl.background and string.format("#%06x", hl.background) or nil
end

function get_fg_color(highlight_name)
  local success, hl = pcall(function () return vim.api.nvim_get_hl_by_name(highlight_name, true) end)
  if not success then return nil end
  return hl.foreground and string.format("#%06x", hl.foreground) or nil
end

vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = 'red' })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = 'yellow' })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { underdashed = true, sp = 'white' })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { underdotted = true, sp = 'gray' })

vim.api.nvim_set_hl(0, 'ColorColumn', { link = 'CursorColumn' })
vim.api.nvim_set_hl(0, 'CurSearch', { link = 'Search' })
vim.api.nvim_set_hl(0, 'SignColumn', { link = 'LineNr' })
vim.api.nvim_set_hl(0, 'MatchParen', { bg = 'gray', fg = 'pink' })
vim.api.nvim_set_hl(0, 'TreesitterContext', { link = 'SignColumn' })
vim.api.nvim_set_hl(0, 'Winbar', { link = 'SignColumn' })

vim.api.nvim_set_hl(0, 'TabLine', { bg = get_bg_color('TabLineFill'), fg = get_fg_color('Conceal') })
vim.api.nvim_set_hl(0, 'TabLineSel', { link = 'SignColumn' })
vim.api.nvim_set_hl(0, 'WinSeparator', { link = 'Whitespace' })
-- vim.api.nvim_set_hl(0, 'StatusLine', { link = 'Conceal' })
-- vim.api.nvim_set_hl(0, 'StatusLineNC', { link = 'Whitespace' })
vim.api.nvim_set_hl(0, 'StatusLine', { bg = get_bg_color('NvimTreeNormal'), fg = get_fg_color('Conceal') })
vim.api.nvim_set_hl(0, 'StatusLineNC', { link = 'StatusLine' })
vim.api.nvim_set_hl(0, 'WinSeparator', { bg = get_bg_color('NvimTreeNormal'), fg = get_bg_color('NvimTreeNormal') })
vim.api.nvim_set_hl(0, 'VertSplit', { link = 'WinSeparator' })
vim.api.nvim_set_hl(0, 'NvimTreeStatusLine', { link = 'StatusLineNC' })
vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Whitespace' })
vim.api.nvim_set_hl(0, 'FTerm', { link = 'Normal' })
vim.api.nvim_set_hl(0, 'LazyGitFloat', { link = 'Normal' })
vim.api.nvim_set_hl(0, 'LazyGitBorder', { link = 'FloatBorder' })
vim.api.nvim_set_hl(0, 'NvimTreeWinSeparator', { link = 'VertSplit' })

-- transparency for suppoting terminals
-- vim.cmd [[
--   highlight Normal guibg=none
--   highlight NonText guibg=none
--   highlight Normal ctermbg=none
--   highlight NonText ctermbg=none
-- ]]

-- Plugins
local cmp = require("cmp")
-- local cmptypes = require("cmp.types")
local lspconfig = vim.lsp.config
local lspconfigutil = require("lspconfig/util")
local snippy = require("snippy")
-- local fterm = require("FTerm")
local nvimtree = require("nvim-tree")
local nvimtreeapi = require("nvim-tree.api")
local telescope = require("telescope")
local telescopebuiltin = require("telescope/builtin")
local guessindent = require("guess-indent")
local gitsigns = require("gitsigns")
local gotopreview = require("goto-preview")
local minisurround = require("mini.surround")
local kanagawa = require('kanagawa')
-- local trouble = require("trouble")
-- local dap = require('dap')
local scrollbar = require('scrollbar')
local autotag = require('/nvim-ts-autotag')
local ccc = require('ccc')

scrollbar.setup()

ccc.setup {
  pickers = {
    ccc.picker.custom_entries({
      aliceblue = "#f0f8ff",
      antiquewhite = "#faebd7",
      aqua = "#00ffff",
      aquamarine = "#7fffd4",
      azure = "#f0ffff",
      beige = "#f5f5dc",
      bisque = "#ffe4c4",
      black = "#000000",
      blanchedalmond = "#ffebcd",
      blue = "#0000ff",
      blueviolet = "#8a2be2",
      brown = "#a52a2a",
      burlywood = "#deb887",
      cadetblue = "#5f9ea0",
      chartreuse = "#7fff00",
      chocolate = "#d2691e",
      coral = "#ff7f50",
      cornflowerblue = "#6495ed",
      cornsilk = "#fff8dc",
      crimson = "#dc143c",
      cyan = "#00ffff",
      darkblue = "#00008b",
      darkcyan = "#008b8b",
      darkgoldenrod = "#b8860b",
      darkgray = "#a9a9a9",
      darkgreen = "#006400",
      darkkhaki = "#bdb76b",
      darkmagenta = "#8b008b",
      darkolivegreen = "#556b2f",
      darkorange = "#ff8c00",
      darkorchid = "#9932cc",
      darkred = "#8b0000",
      darksalmon = "#e9967a",
      darkseagreen = "#8fbc8f",
      darkslateblue = "#483d8b",
      darkslategray = "#2f4f4f",
      darkturquoise = "#00ced1",
      darkviolet = "#9400d3",
      deeppink = "#ff1493",
      deepskyblue = "#00bfff",
      dimgray = "#696969",
      dodgerblue = "#1e90ff",
      firebrick = "#b22222",
      floralwhite = "#fffaf0",
      forestgreen = "#228b22",
      fuchsia = "#ff00ff",
      gainsboro = "#dcdcdc",
      ghostwhite = "#f8f8ff",
      gold = "#ffd700",
      goldenrod = "#daa520",
      gray = "#808080",
      green = "#008000",
      greenyellow = "#adff2f",
      honeydew = "#f0fff0",
      hotpink = "#ff69b4",
      indianred = "#cd5c5c",
      indigo = "#4b0082",
      ivory = "#fffff0",
      khaki = "#f0e68c",
      lavender = "#e6e6fa",
      lavenderblush = "#fff0f5",
      lawngreen = "#7cfc00",
      lemonchiffon = "#fffacd",
      lightblue = "#add8e6",
      lightcoral = "#f08080",
      lightcyan = "#e0ffff",
      lightgoldenrodyellow = "#fafad2",
      lightgray = "#d3d3d3",
      lightgreen = "#90ee90",
      lightpink = "#ffb6c1",
      lightsalmon = "#ffa07a",
      lightseagreen = "#20b2aa",
      lightskyblue = "#87cefa",
      lightslategray = "#778899",
      lightsteelblue = "#b0c4de",
      lightyellow = "#ffffe0",
      lime = "#00ff00",
      limegreen = "#32cd32",
      linen = "#faf0e6",
      magenta = "#ff00ff",
      maroon = "#800000",
      mediumaquamarine = "#66cdaa",
      mediumblue = "#0000cd",
      mediumorchid = "#ba55d3",
      mediumpurple = "#9370db",
      mediumseagreen = "#3cb371",
      mediumslateblue = "#7b68ee",
      mediumspringgreen = "#00fa9a",
      mediumturquoise = "#48d1cc",
      mediumvioletred = "#c71585",
      midnightblue = "#191970",
      mintcream = "#f5fffa",
      mistyrose = "#ffe4e1",
      moccasin = "#ffe4b5",
      navajowhite = "#ffdead",
      navy = "#000080",
      oldlace = "#fdf5e6",
      olive = "#808000",
      olivedrab = "#6b8e23",
      orange = "#ffa500",
      orangered = "#ff4500",
      orchid = "#da70d6",
      palegoldenrod = "#eee8aa",
      palegreen = "#98fb98",
      paleturquoise = "#afeeee",
      palevioletred = "#db7093",
      papayawhip = "#ffefd5",
      peachpuff = "#ffdab9",
      peru = "#cd853f",
      pink = "#ffc0cb",
      plum = "#dda0dd",
      powderblue = "#b0e0e6",
      purple = "#800080",
      red = "#ff0000",
      rosybrown = "#bc8f8f",
      royalblue = "#4169e1",
      saddlebrown = "#8b4513",
      salmon = "#fa8072",
      sandybrown = "#f4a460",
      seagreen = "#2e8b57",
      seashell = "#fff5ee",
      sienna = "#a0522d",
      silver = "#c0c0c0",
      skyblue = "#87ceeb",
      slateblue = "#6a5acd",
      slategray = "#708090",
      snow = "#fffafa",
      springgreen = "#00ff7f",
      steelblue = "#4682b4",
      tan = "#d2b48c",
      teal = "#008080",
      thistle = "#d8bfd8",
      tomato = "#ff6347",
      turquoise = "#40e0d0",
      violet = "#ee82ee",
      wheat = "#f5deb3",
      white = "#ffffff",
      whitesmoke = "#f5f5f5",
      yellow = "#ffff00",
      yellowgreen = "#9acd32",
    }),
  },
  inputs = {
    ccc.input.hsl,
    ccc.input.rgb,
  },
  highlighter = {
    auto_enable = true,
    lsp = true,
  },
  virtual_symbol = '■ ',
  highlight_mode = 'bg'
}

vim.keymap.set("n", "<C-h>", function() vim.cmd([[:CccPick]]) end)

autotag.setup {
  alias = {
    aliases = {
    -- ["typescriptreact"] = "html",
    }
  },
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false,
  },
}


kanagawa.setup({
  colors = {
    theme = {
      wave = {
        ui = {
          bg_gutter = "none"
        }
      }
    }
  }
})

-- trouble.setup {}

-- Laggy and buggy
-- local treesitterconfigs = require("nvim-treesitter.configs")
-- local treesittercontext = require("treesitter-context")
-- 
-- treesitterconfigs.setup {
--   ensure_installed = { "c", "lua", "cpp", "javascript", "python", "rust", "go", "make", "bash", "vimdoc" },
--   auto_install = true,
--   sync_install = false,
-- 
--   highlight = {
--     enable = true,
--     disable = function(lang, bufnr)
--       if vim.api.nvim_buf_line_count(bufnr) > 3333 then
--         return true
--       end
--       return false
--     end,
--   }
-- }
-- 
-- treesittercontext.setup{
--   mode = "topline",
--   max_lines = 6,
--   trim_scope = "inner",
--   enable = true
--   -- separator = "─",
-- }
-- 
-- vim.keymap.set("n", "<C-t>", treesittercontext.toggle)

function trans_border()
  local w = cmp.config.window.bordered()
  w.winblend = 30
  return w
end

function get_git_toplevel()
  cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    clients = vim.lsp.get_active_clients()
    if clients[1] ~= nil then
      cwd = clients[1].config.root_dir
    else
      cwd = "./"
    end
  end
  return cwd
end

guessindent.setup {
  auto_cmd = true,
  on_tab_options = {
    ["expandtab"] = false,
  },
  on_space_options = {
    ["expandtab"] = true,
    ["tabstop"] = "detected",
    ["softtabstop"] = "detected",
    ["shiftwidth"] = "detected",
  }
}

gitsigns.setup {}

vim.keymap.set("n", "<C-c>c", gitsigns.blame_line)
vim.keymap.set("n", "<C-c>a", gitsigns.blame)

minisurround.setup {}

gotopreview.setup {
  opacity = 30,
  border = "rounded",
  focus_on_open = true,
  post_open_hook = function(buf, win)
    vim.api.nvim_create_autocmd({ 'WinLeave' }, {
        buffer = buf,
        callback = function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, false)
          end
          return true
        end,
      })
  end
}

-- <C-i> is equivalent to <Tab>. yeah this took me 1.5 hours to debug
vim.keymap.set("n", "<C-o>", gotopreview.goto_preview_definition)
vim.keymap.set("i", "<C-o>", gotopreview.goto_preview_definition)

telescope.setup {
  defaults = {
    winblend = 30,
    layout_strategy = 'horizontal',
    layout_config = {
      prompt_position = 'top',
      height = 0.90,
      width = 0.90
    },
  }
}

function live_grep_from_project_git_root()
  local opts = { cwd = get_git_toplevel() }
  telescopebuiltin.live_grep(opts)
end

function find_files_from_project_git_root()
  local opts = { cwd = get_git_toplevel() }
  telescopebuiltin.find_files(opts)
end

-- fterm.setup({
--   border = "rounded",
--   dimensions  = {
--     height = 0.9,
--     width = 0.9,
--   },
--   blend = 30,
--   hl = "Bullshit"
-- })
--
-- vim.keymap.set("n", "<C-t>", fterm.toggle)
-- vim.keymap.set("t", "<C-t>", fterm.toggle)

function open_tab_silent(node)
  nvimtreeapi.node.open.tab(node)
end

function why_is_this_plugin_author_is_not_ashamed_of_breathing_air(bufnr)
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  nvimtreeapi.config.mappings.default_on_attach(bufnr)

  vim.keymap.set("n", "?", nvimtreeapi.tree.toggle_help, opts("Help"))
  vim.keymap.set("n", "T", open_tab_silent, opts("Tab"))
end

local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

local nvimtree_enable_float = true

-- Close nvim-tree and exit if it's the last buffer remaining.
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local tree_wins = {}
    local floating_wins = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("NvimTree_") ~= nil then
        table.insert(tree_wins, w)
      end
      if vim.api.nvim_win_get_config(w).relative ~= '' then
        table.insert(floating_wins, w)
      end
    end
    if 1 == #wins - #floating_wins - #tree_wins then
      for _, w in ipairs(tree_wins) do
        vim.api.nvim_win_close(w, true)
      end
    end
  end
})

nvimtree.setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    float = {
      enable = nvimtree_enable_float,
      open_win_config = function()
        local screen_w = vim.opt.columns:get()
        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
        local window_w = screen_w * WIDTH_RATIO
        local window_h = screen_h * HEIGHT_RATIO
        local window_w_int = math.floor(window_w)
        local window_h_int = math.floor(window_h)
        local center_x = (screen_w - window_w) / 2
        local center_y = ((vim.opt.lines:get() - window_h) / 2)
                           - vim.opt.cmdheight:get()
        return {
          border = "rounded",
          relative = "editor",
          row = center_y,
          col = center_x,
          width = window_w_int,
          height = window_h_int,
        }
      end,
    },
    width = function()
      if nvimtree_enable_float then
        return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
      else
        return math.floor(vim.opt.columns:get() * 0.2)
      end
    end,
  },
  renderer = {
    group_empty = true,
  },
  git = {
    ignore = false,
  },
  filters = {
    dotfiles = false,
  },
  on_attach = why_is_this_plugin_author_is_not_ashamed_of_breathing_air,
})

vim.g.completion_trigger_character_length = 4

-- this eats memory and makes lsp do weird things. my log was 1.2 GiB =D
vim.lsp.set_log_level("error")

vim.lsp.handlers["textDocument/hover"] =
  vim.lsp.with(vim.lsp.handlers.hover, trans_border())
vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(vim.lsp.handlers.signature_help, trans_border())

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

function default_on_init(client, buffer)
  -- client.server_capabilities.semanticTokensProvider = nil
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
  "clangd",
  "rust_analyzer",
  -- "texlab",
  "gopls",
  "bashls",
  "powershell_es",
}

-- disable lsp on demand
if true then

vim.lsp.enable("lua_ls", {
  on_init = default_on_init,
  telemetry = default_telemetry,
  flags = default_flags,
  settings = {
    Lua = {
      diagnostics = {
        globals = {
          "vim",
          "require"
        }
      }
    }
  },
  workspace = {
    library = vim.api.nvim_get_runtime_file("", true),
  },
})

lspconfig("powershell_es", {
  bundle_path = '/home/sd/External/powershell-eds',
})

for _, lsp in ipairs(default_servers) do
  vim.lsp.enable(lsp, {
    on_init = default_on_init,
    flags = default_flags,
    telemetry = default_telemetry,
    root_dir = lspconfigutil.root_pattern(".git", "Makefile")
  })
end

end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = ev.buf }

    vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover, opts)
    vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)

    vim.keymap.set("n", "<Space>ll", vim.diagnostic.setloclist, opts)
    vim.keymap.set("n", "<Space>e", vim.diagnostic.open_float, opts)

    vim.keymap.set("n", "<Space>gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<Space>gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<Space>gs", vim.lsp.buf.document_symbol, opts)
    vim.keymap.set("n", "<Space>gS", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<Space>gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>gt", vim.lsp.buf.typehierarchy, opts)

    vim.keymap.set("n", "<Space>co", vim.lsp.buf.outgoing_calls, opts)
    vim.keymap.set("n", "<Space>ci", vim.lsp.buf.incoming_calls, opts)

    vim.keymap.set("n", "<Space>wc", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<Space>wd", vim.lsp.buf.remove_workspace_folder, opts)

    vim.keymap.set("n", "<Space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)

    vim.keymap.set("n", "<Space>d", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<Space>rr", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<Space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

    vim.keymap.set("n", "<Space>ff", function()
      vim.lsp.buf.format { async = true }
    end, opts)
    end,
})

cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" }
    }
  })

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" }
      }, {
        { name = "cmdline" }
      })
  })

cmp.setup({
  enabled = function()
    -- disable completion in comments
    local context = require("cmp.config.context")
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == "c" then
      return true
    else
      return not (vim.bo.filetype == "markdown")
      and not (vim.bo.filetype == "text")
      and not (vim.bo.filetype == "")
      and not context.in_treesitter_capture("comment")
      and not context.in_syntax_group("Comment")
    end
  end,
  completion = {
    keyword_length = 2,
    -- autocomplete = {
    --   cmptypes.cmp.TriggerEvent.TextChanged
    -- },
  },
  snippet = {
    expand = function(args)
      require("snippy").expand_snippet(args.body)
    end,
  },
  window = {
    completion = trans_border(),
    documentation = trans_border()
  },
  view = {
    docs = {
      auto_open = false
    },
    entries = 'custom'
  },
  formatting = {
    fields = { "menu", "abbr", "kind" },
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = "💎",
        path   =   "⚣ ",
        luasnip  = "✌ ",
        buffer   = "  ",
      }
      item.abbr = string.sub(item.abbr, 1, 32)
      item.menu = menu_icon[entry.source.name]
      return item
    end
  },
  experimental = {
    ghost_text = true
  },
  mapping = cmp.mapping.preset.insert({
  ["<C-b>"] = cmp.mapping.scroll_docs(-4),
  ["<C-f>"] = cmp.mapping.scroll_docs(4),
  ["<C-Space>"] = cmp.mapping.complete(),
  ["<ESC>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.mapping.abort()
      fallback()
    else
      fallback()
    end
  end, { "i", "s" }),
  -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
  ["<CR>"] = cmp.mapping(function(fallback)
    fallback()
  end, { "i" }),
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.get_selected_entry() ~= nil then
      cmp.confirm()
    elseif cmp.visible() then
      cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
    elseif snippy.can_jump(1) then
      snippy.next()
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif snippy.can_jump(-1) then
      snippy.previous()
    else
      fallback()
    end
  end, { "i", "s" }),
}),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "snippy" },
    { name = "buffer" },
  })
})
