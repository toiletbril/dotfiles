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
    lazy = true
  },

  -- lol
  { "wakatime/vim-wakatime", lazy = false },

  -- SSH
  {
     "amitds1997/remote-nvim.nvim",
     version = "*",
     dependencies = { "MunifTanjim/nui.nvim" },
     config = true,
  },

  -- LSP and completion
  { 'neovim/nvim-lspconfig' },
  { 'saghen/blink.cmp', version = '*' },
  { 'rmagatti/goto-preview' },

  -- Pickers: telescope kept only as <C-p> command palette; fff.nvim is the
  -- workhorse for find_files / live_grep.
  { 'nvim-telescope/telescope.nvim', dependencies = 'nvim-lua/plenary.nvim' },
  {
    'dmtrKovalenko/fff.nvim',
    -- Prefer building the Rust binary locally; only fall back to the
    -- prebuilt-download path if cargo build fails.
    build = function()
      local d = require('fff.download')
      local done, err = false, nil
      d.build_binary(function(ok, e)
        if not ok then err = e end
        done = true
      end)
      vim.wait(2 * 60 * 1000, function() return done end, 100)
      if err then
        vim.notify(
          'fff.nvim: local build failed (' .. err
            .. '); falling back to download_or_build_binary',
          vim.log.levels.WARN
        )
        d.download_or_build_binary()
      end
    end,
  },

  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', branch = 'main', lazy = false, build = ':TSUpdate' },
  -- { 'nvim-treesitter/nvim-treesitter-context' },

  -- { 'folke/trouble.nvim', cmd = "Trouble" },

  -- Miscellaneous plugins
  { 'cappyzawa/trim.nvim' },
  { 'NMAC427/guess-indent.nvim' },
  { 'lewis6991/gitsigns.nvim' },

  -- -- Themes
  { 'EdenEast/nightfox.nvim' },
  { 'rebelot/kanagawa.nvim' },
  { 'ellisonleao/gruvbox.nvim' },
  { 'cocopon/iceberg.vim' },

  -- Tools
  { 'folke/zen-mode.nvim' },
  { 'echasnovski/mini.align' },
  { 'echasnovski/mini.surround' },
  { 'nvim-tree/nvim-tree.lua' },
  -- { 'windwp/nvim-ts-autotag' },
  { 'uga-rosa/ccc.nvim' },

  { 'lewis6991/satellite.nvim' },
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
vim.opt.cursorline = false
-- vim.opt.cursorline = true
vim.opt.cursorlineopt = 'both'
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
vim.opt.mousescroll = 'ver:1,hor:2'

-- Stop fucking annoying labels from jumping around when expanded from relative
-- to full paths in the tabline when focused/unfocused. Another one of a
-- thousand and one setting designed for you to waste time on.
function _G.MyTabLine()
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

vim.filetype.add({
  extension = {
    h = "c",
  },
})

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

-- Key mappings
vim.keymap.set('n', '<C-g>', 'g<C-g>', { silent = true })
vim.keymap.set('v', '<C-g>', 'g<C-g>', { silent = true })

vim.keymap.set('n', '<C-p>', ':Telescope<CR>', { silent = true })
vim.keymap.set('n', '<C-b>', ':NvimTreeFindFile<CR>', { silent = true })

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

vim.keymap.set('n', '<C-s>', function()
  vim.fn.setreg('/', vim.fn.expand('<cword>'))
  require('fff').live_grep({ query = vim.fn.expand('<cword>') })
end, { silent = true })
vim.keymap.set('v', '<C-s>', function()
  vim.cmd('normal! "0y')
  local q = vim.fn.getreg('0')
  vim.fn.setreg('/', q)
  require('fff').live_grep({ query = q })
end, { silent = true })

vim.keymap.set('n', '<S-Tab>', function() require('fff').find_files() end,
  { silent = true })
vim.keymap.set('n', '<Tab>', function() require('fff').live_grep() end,
  { silent = true })

-- Telescope-backed alternates (telescope is kept only for these and <C-p>).
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

-- Move lines with ALT + up/down
vim.keymap.set('n', '<A-Down>', ':m .+1<CR>==')
vim.keymap.set('n', '<A-Up>', ':m .-2<CR>==')
vim.keymap.set('i', '<A-Down>', '<Esc>:m .+1<CR>==gi')
vim.keymap.set('i', '<A-Up>', '<Esc>:m .-2<CR>==gi')

-- Emacs' keys to jump to beginning/end of the line
vim.keymap.set('i', '<C-e>', '<End>')
vim.keymap.set('i', '<C-a>', '<Home>')
vim.keymap.set({ 'n', 'v' }, '<C-e>', '$')
vim.keymap.set({ 'n', 'v' }, '<C-a>', '0')

-- Emacs' keys to switch previous buffers
vim.keymap.set('n', '<C-x><Left>', '<C-o>')
vim.keymap.set('n', '<C-x><Right>', '<C-i>')

-- Emacs' keys to remove words
vim.keymap.set('i', '<C-BS>', '<C-w>')
vim.keymap.set('i', '<C-Del>', '<C-o>dw')

-- Do not suspend Vi with C-z
vim.keymap.set('n', '<C-z>', '<Nop>')
vim.keymap.set('n', '<C-S-z>', '<Nop>')

-- I use arrows a lot, so q/a for Insert/Append is way better
vim.keymap.set('n', 'q', 'i')
vim.keymap.set('n', '<C-q>', 'q')

-- Latex mappings
vim.keymap.set('n', 'в;', 'd$')
vim.keymap.set('n', 'й', 'i')
vim.keymap.set('n', 'ш', 'i')
vim.keymap.set('n', 'вв', 'dd')
vim.keymap.set('n', 'М', 'V')
vim.keymap.set('n', 'вц', 'dw')
vim.keymap.set('n', 'ц', 'w')
vim.keymap.set('n', 'м', 'v')
vim.keymap.set('n', 'ф', 'a')
vim.keymap.set('n', 'ч', 'x')
vim.keymap.set('n', 'г', 'u')
vim.keymap.set('n', '<C-к>', '<C-r>')
vim.keymap.set('v', 'в', 'd')

vim.keymap.set('n', 'm', 'O<ESC>')

vim.api.nvim_create_autocmd({"BufEnter"}, {
  pattern = "*", command = "silent GuessIndent",
})

-- Don't show status on nofile buffers
vim.api.nvim_create_autocmd({ "VimEnter", "BufWinEnter" }, {
  group = user_augroup,
  callback = function()
    if vim.bo.buftype ~= 'nofile' then
      vim.opt_local.statusline = "%.f:%l:%c%=[%{mode(1)}]%=%=%{&filetype} %P"
    end
  end,
})

-- Until it's fixed
vim.api.nvim_create_autocmd("InsertEnter", {
  group = user_augroup,
  callback = function()
    vim.cmd('silent set cmdheight=0')
  end,
})

local function get_system_theme()
  local handle = io.popen([[
    dbus-send --session --print-reply=literal --dest=org.freedesktop.portal.Desktop \
      /org/freedesktop/portal/desktop \
      org.freedesktop.portal.Settings.Read \
      string:org.freedesktop.appearance string:color-scheme 2>/dev/null | \
      grep -oP '(?<=uint32 )\d+'
  ]])

  if handle then
    local result = handle:read("*a")
    handle:close()

    -- 1 = prefer-dark, 2 = prefer-light, 0 = no-preference
    if result:match("1") then
      return "dark"
    elseif result:match("2") then
      return "light"
    end
  end

  return "light"
end

if get_system_theme() == "dark" then
  vim.cmd.colorscheme 'duskfox'
  -- vim.cmd.colorscheme 'nightfox'
  -- vim.cmd.colorscheme 'terafox'
  -- vim.cmd.colorscheme 'carbonfox'
  -- vim.cmd.colorscheme 'gruvbox'
  -- vim.cmd.colorscheme 'kanagawa-wave'
  -- vim.cmd.colorscheme 'nordfox'
  -- vim.cmd.colorscheme 'iceberg'
else
  vim.cmd.colorscheme 'dawnfox'
  -- vim.cmd.colorscheme 'kanagawa-lotus'
end

local function get_bg_color(highlight_name)
  local success, hl = pcall(function () return vim.api.nvim_get_hl(0, { name = highlight_name }) end)
  if not success then return nil end
  return hl.bg and string.format("#%06x", hl.bg) or nil
end

local function get_fg_color(highlight_name)
  local success, hl = pcall(function () return vim.api.nvim_get_hl(0, { name = highlight_name }) end)
  if not success then return nil end
  return hl.fg and string.format("#%06x", hl.fg) or nil
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
local satellite = require('satellite')
satellite.setup({
  handlers = {
    cursor = { enable = false },
    search = { enable = true },
    diagnostic = { enable = true },
    gitsigns = { enable = true },
    marks = { enable = false },
    quickfix = { enable = false },
  },
})

local ccc = require('ccc')
ccc.setup {
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

-- local autotag = require('/nvim-ts-autotag')
-- autotag.setup {
--   alias = {
--     aliases = {
--     -- ["typescriptreact"] = "html",
--     }
--   },
--   opts = {
--     enable_close = true,
--     enable_rename = true,
--     enable_close_on_slash = false,
--   },
-- }

local kanagawa = require('kanagawa')
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

-- Laggy and buggy
local treesitter = require("nvim-treesitter")
treesitter.setup {}
treesitter.install({ "svelte" })

vim.api.nvim_create_autocmd('FileType', {
  group = user_augroup,
  callback = function(args)
    if vim.api.nvim_buf_line_count(args.buf) > 3333 then
      return
    end
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if lang
      and vim.list_contains(treesitter.get_available(), lang)
      and not vim.list_contains(treesitter.get_installed('parsers'), lang)
    then
      treesitter.install({ lang })
    end
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- local treesittercontext = require("treesitter-context")

-- treesittercontext.setup{
--   mode = "topline",
--   max_lines = 6,
--   trim_scope = "inner",
--   enable = true
--   -- separator = "─",
-- }
--
-- vim.keymap.set("n", "<C-t>", treesittercontext.toggle)

local function trans_border()
  return { border = 'solid', winblend = 30 }
end

vim.opt.tabstop = 4
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 0

local guessindent = require("guess-indent")
guessindent.setup {
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
  }
}

local gitsigns = require("gitsigns")
gitsigns.setup {}

vim.keymap.set("n", "<C-c>c", gitsigns.blame_line)
vim.keymap.set("n", "<C-c>a", gitsigns.blame)

require("mini.surround").setup {}
require("mini.align").setup {}

require("trim").setup({ trim_on_write = false })

require("fff").setup({})

local gotopreview = require("goto-preview")
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

local telescope = require("telescope")
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

function _G.live_grep_from_project_git_root(query)
  require("fff").live_grep({ query = query })
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

local nvimtreeapi = require("nvim-tree.api")

local function open_tab_silent(node)
  nvimtreeapi.node.open.tab(node)
end

local function why_is_this_plugin_author_is_not_ashamed_of_breathing_air(bufnr)
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  nvimtreeapi.config.mappings.default_on_attach(bufnr)

  vim.keymap.set("n", "?", nvimtreeapi.tree.toggle_help, opts("Help"))
  vim.keymap.set("n", "T", open_tab_silent, opts("Tab"))
end

local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

local nvimtree_enable_float = false

-- Close nvim-tree and exit if it's the last buffer remaining.
vim.api.nvim_create_autocmd("QuitPre", {
  group = user_augroup,
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

local nvimtree = require("nvim-tree")
nvimtree.setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    float = {
      enable = nvimtree_enable_float,
      open_win_config = function()
        local screen_w = vim.o.columns
        local screen_h = vim.o.lines - vim.o.cmdheight
        local window_w = screen_w * WIDTH_RATIO
        local window_h = screen_h * HEIGHT_RATIO
        local window_w_int = math.floor(window_w)
        local window_h_int = math.floor(window_h)
        local center_x = (screen_w - window_w) / 2
        local center_y = ((vim.o.lines - window_h) / 2)
                           - vim.o.cmdheight
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
        return math.floor(vim.o.columns * WIDTH_RATIO)
      else
        return math.floor(vim.o.columns * 0.2)
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
  "tinymist",
}

-- disable lsp on demand
if true then

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
    capabilities = blink_capabilities,
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

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end

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
      vim.print(vim.lsp.buf.list_workspace_folders())
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

require("blink.cmp").setup({
  enabled = function()
    -- Disable completion in markdown/plain-text/no-filetype buffers and
    -- inside comment treesitter/syntax captures. Cmdline ('c') completion
    -- stays on regardless.
    if vim.api.nvim_get_mode().mode == "c" then
      return true
    end
    if vim.bo.filetype == "markdown"
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
      function(c) if c.is_visible() then c.cancel() end end,
      "fallback",
    },
    ["<Tab>"] = {
      function(c)
        if c.get_selected_item() ~= nil then return c.accept() end
        if c.is_visible() then return c.select_next() end
        if c.snippet_active({ direction = 1 }) then
          return c.snippet_forward()
        end
      end,
      "fallback",
    },
    ["<S-Tab>"] = {
      function(c)
        if c.is_visible() then return c.select_prev() end
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
    window = { border = "solid", winblend = 30 },
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
    completion = { menu = { auto_show = true } },
  },
  completion = {
    trigger = { prefetch_on_insert = false },
    keyword = { range = "prefix" },
    list = {
      selection = { preselect = false, auto_insert = false },
    },
    accept = { auto_brackets = { enabled = false } },
    menu = {
      border = "solid",
      winblend = 30,
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
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 150,
      window = { border = "solid", winblend = 30 },
    },
    ghost_text = { enabled = true },
  },
})
