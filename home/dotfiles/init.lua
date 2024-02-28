require("telescope").setup({
  extensions = {
    coc = {
      theme = 'ivy',
      prefer_locations = true,
    },
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})
require('telescope').load_extension('coc')
require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')

require('gitsigns').setup()

vim.opt.termguicolors = true
vim.notify = require("notify")

require('bufferline').setup()
require('lualine').setup()
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true;
  }
}

require('bufferline').setup {
  options = {
    mode = "tabs", -- set to "tabs" to only show tabpages instead
    diagnostics = "coc",
    diagnostics_update_in_insert = true,
    show_tab_indicators = true,
    enforce_regular_tabs = true,
    sort_by = 'tabs',
    max_name_length = 25,
    tab_size = 25,
    name_formatter = function(buf)
      if #buf.buffers > 1 then
        return tostring(#buf.buffers) .. " buffers"
      else
        return buf.name
      end
    end
  },
}
