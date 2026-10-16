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

vim.g.mapleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_nvim_net_plugin = true
vim.g.loaded_sql_completion = 1

vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazy_path) then
  vim
    .system({
      "git",
      "clone",
      "--filter=blob:none",
      "--branch=stable",
      "https://github.com/folke/lazy.nvim.git",
      lazy_path,
    })
    :wait()
end
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup({
  defaults = {
    lazy = true,
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "editorconfig",
        "gzip",
        "net",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },

  spec = {
    -- LSP and completion
    { "neovim/nvim-lspconfig", lazy = false },
    { "saghen/blink.cmp", version = "*", lazy = false },

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
    {
      "cappyzawa/trim.nvim",
      cmd = { "Trim", "TrimToggle" },
      opts = { trim_on_write = false },
    },
    {
      "NMAC427/guess-indent.nvim",
      event = { "BufReadPre", "BufNewFile" },
      opts = {
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
      },
    },
    {
      "lewis6991/gitsigns.nvim",
      event = "VeryLazy",
      opts = {},
      keys = {
        {
          "<C-c>c",
          function()
            require("gitsigns").blame_line()
          end,
        },
        {
          "<C-c>a",
          function()
            require("gitsigns").blame()
          end,
        },
      },
    },

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
          vim.keymap.set(
            "n",
            "<CR>",
            api.node.open.preview,
            get_opts("Open Preview")
          )
          vim.keymap.set("n", "T", api.node.open.tab, get_opts("Tab"))
        end,
      },
    },
    { "echasnovski/mini.align", event = "VeryLazy", opts = {} },
    { "echasnovski/mini.surround", event = "VeryLazy", opts = {} },
    {
      "uga-rosa/ccc.nvim",
      event = "VeryLazy",
      opts = function()
        local ccc = require("ccc")

        return {
          inputs = {
            ccc.input.hsl,
            ccc.input.rgb,
          },
          highlighter = {
            auto_enable = true,
            lsp = false,
          },
          virtual_symbol = "■ ",
          highlight_mode = "bg",
        }
      end,
      config = function(_, opts)
        require("ccc").setup(opts)
        vim.api.nvim_exec_autocmds("BufEnter", {
          group = "ccc-highlighter-auto-enable",
          buffer = vim.api.nvim_get_current_buf(),
        })
      end,
    },
  },
})

vim.cmd("filetype plugin indent off")

-- completion's height
vim.opt.pumheight = 6

vim.opt.lazyredraw = true
vim.opt.wrap = false
vim.opt.scrolloff = 4
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.autochdir = true
vim.opt.list = true
vim.opt.cmdheight = 0
vim.opt.cinoptions = "l1"
vim.opt.listchars = { tab = "┊ ", space = "⸱" }
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamed"
vim.opt.omnifunc = "syntaxcomplete#Complete"
vim.opt.colorcolumn = "80"
vim.opt.termguicolors = true
vim.opt.pumblend = 30
vim.opt.signcolumn = "yes"
vim.opt.statusline = " "
vim.opt.fillchars = { stl = " ", stlnc = " " }
vim.opt.guicursor = "n-sm:block,i-c-ci-ve:ver25,r-cr-o-v:hor20"
vim.opt.swapfile = false
vim.opt.redrawtime = 1111
vim.opt.tabstop = 4
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 0

-- Stop fucking annoying labels from jumping around when expanded from relative
-- to full paths in the tabline when focused/unfocused. Another one of a
-- thousand and one setting designed for you to waste time on.
function _G.MyTabLine()
  local tabline_parts = {}
  local tab_count = vim.fn.tabpagenr("$")
  local current_tab = vim.fn.tabpagenr()

  for tab = 1, tab_count do
    table.insert(
      tabline_parts,
      tab == current_tab and "%#TabLineSel#" or "%#TabLine#"
    )
    table.insert(tabline_parts, "%" .. tab .. "T " .. tab .. " ")

    local buffer_labels = {}
    for _, buffer in ipairs(vim.fn.tabpagebuflist(tab)) do
      local buffer_type = vim.bo[buffer].buftype
      local buffer_basename =
        vim.fs.basename(vim.api.nvim_buf_get_name(buffer))
      local buffer_label = nil

      if buffer_type == "help" then
        buffer_label = "[Help]" .. buffer_basename:gsub("%.txt$", "")
      elseif buffer_type == "quickfix" then
        buffer_label = "[Quickfix]"
      elseif buffer_type ~= "prompt" and buffer_type ~= "nofile" then
        buffer_label = buffer_basename == "" and "[New file]"
          or buffer_basename
      end

      if buffer_label ~= nil then
        if vim.bo[buffer].modified then
          buffer_label = buffer_label .. " (modified)"
        end

        table.insert(buffer_labels, buffer_label)
      end
    end

    table.insert(tabline_parts, table.concat(buffer_labels, ", ") .. " ")
  end

  table.insert(tabline_parts, "%#TabLineFill#%T")
  if tab_count > 1 then
    table.insert(tabline_parts, "%=%#TabLineFill#%999X")
  end

  return table.concat(tabline_parts)
end
vim.opt.tabline = "%!v:lua.MyTabLine()"

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
vim.keymap.set({ "n", "v" }, "<C-g>", "g<C-g>", { silent = true })

vim.keymap.set("n", "<Space>e", vim.diagnostic.open_float, { silent = true })
vim.keymap.set("n", "<Space>ll", function()
  Snacks.picker.diagnostics_buffer()
end, { desc = "Buffer diagnostics" })

-- Search bindings. Very convenient and fucking stupid.
vim.keymap.set("n", "<Esc>", "<Cmd>noh<CR><Esc>", { silent = true })
vim.keymap.set(
  { "n", "v" },
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

vim.keymap.set({ "n", "v" }, "<Space>y", '"+y')
vim.keymap.set({ "n", "v" }, "<Space>p", '"+p')

vim.keymap.set({ "n", "v" }, "<C-Right>", "w")
vim.keymap.set({ "n", "v" }, "<C-Left>", "b")

vim.keymap.set({ "n", "v" }, "<C-Up>", "{")
vim.keymap.set({ "n", "v" }, "<C-Down>", "}")
vim.keymap.set("i", "<C-Up>", "<C-o>{")
vim.keymap.set("i", "<C-Down>", "<C-o>}")

vim.keymap.set("n", "<C-o>", "<Nop>", { silent = true })

-- Move lines with ALT + up/down
vim.keymap.set("n", "<A-Down>", "<Cmd>m .+1<CR>==")
vim.keymap.set("n", "<A-Up>", "<Cmd>m .-2<CR>==")
vim.keymap.set("i", "<A-Down>", "<Esc><Cmd>m .+1<CR>==gi")
vim.keymap.set("i", "<A-Up>", "<Esc><Cmd>m .-2<CR>==gi")

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

vim.keymap.set("n", "<C-h>", "<Cmd>CccPick<CR>")

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

-- Some terminals re-send an OSC 11 background report on resize. The built-in
-- TermResponse handler would then flip 'background' and re-source the
-- colorscheme, wiping the manual highlight overrides below. The group exists
-- only when nvim runs attached to a tty, so the call is guarded.
pcall(
  vim.api.nvim_clear_autocmds,
  { group = "nvim.tty", event = "TermResponse" }
)

vim.o.background = "dark"
vim.cmd.colorscheme("duskfox")

local function get_highlight_color(highlight_name, attribute_name)
  local color =
    vim.api.nvim_get_hl(0, { name = highlight_name })[attribute_name]
  return color and string.format("#%06x", color) or nil
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

vim.api.nvim_set_hl(0, "TabLine", {
  bg = get_highlight_color("TabLineFill", "bg"),
  fg = get_highlight_color("Conceal", "fg"),
})
vim.api.nvim_set_hl(0, "TabLineSel", { link = "SignColumn" })
vim.api.nvim_set_hl(0, "StatusLine", {
  bg = get_highlight_color("NvimTreeNormal", "bg"),
  fg = get_highlight_color("Conceal", "fg"),
})
vim.api.nvim_set_hl(0, "StatusLineNC", { link = "StatusLine" })
vim.api.nvim_set_hl(0, "WinSeparator", {
  bg = get_highlight_color("NvimTreeNormal", "bg"),
  fg = get_highlight_color("NvimTreeNormal", "bg"),
})
vim.api.nvim_set_hl(0, "VertSplit", { link = "WinSeparator" })
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

local treesitter = require("nvim-treesitter")
local treesitter_available_languages = nil
local treesitter_installed_languages = nil

vim.api.nvim_create_autocmd("FileType", {
  group = user_augroup,
  callback = function(args)
    if
      vim.bo[args.buf].filetype == "bigfile"
      or vim.api.nvim_buf_line_count(args.buf) > 3333
    then
      return
    end

    if treesitter_available_languages == nil then
      treesitter_available_languages = treesitter.get_available()
      treesitter_installed_languages = treesitter.get_installed("parsers")
    end

    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if
      lang
      and vim.list_contains(treesitter_available_languages, lang)
      and not vim.list_contains(treesitter_installed_languages, lang)
    then
      table.insert(treesitter_installed_languages, lang)
      treesitter.install({ lang })
    end

    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

local function get_float_window_opts()
  return { border = "solid", winblend = 30 }
end

-- this eats memory and makes lsp do weird things. my log was 1.2 GiB =D
vim.lsp.log.set_level("error")

vim.diagnostic.config({
  virtual_text = true,
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

local should_enable_lsp = true

if should_enable_lsp then
  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  })

  vim.lsp.config("powershell_es", {
    bundle_path = vim.env.HOME .. "/External/powershell-eds",
  })

  vim.lsp.enable({
    "lua_ls",
    "ts_ls",
    "svelte",
    "pylsp",
    "ruff",
    "zls",
    "rust_analyzer",
    "gopls",
    "powershell_es",
    "tinymist",
    "ansiblels",
    "yamlls",
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = user_augroup,
    callback = function(ev)
      vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if
        client ~= nil
        and client:supports_method("textDocument/inlayHint", ev.buf)
      then
        vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
      end

      local opts = { buffer = ev.buf }

      vim.keymap.set("n", "<C-k>", function()
        vim.lsp.buf.hover(get_float_window_opts())
      end, opts)
      vim.keymap.set("i", "<C-k>", function()
        vim.lsp.buf.signature_help(get_float_window_opts())
      end, opts)

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
      window = get_float_window_opts(),
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
      menu = vim.tbl_extend("force", get_float_window_opts(), {
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
        window = get_float_window_opts(),
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
