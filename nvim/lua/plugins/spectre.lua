-- https://github.com/nvim-pack/nvim-spectre
return {
  'nvim-pack/nvim-spectre',
  opts = function()
    vim.schedule(
      function()
        require('colors.highlights').setup {
          colorscheme = 'sourdiesel',
          plugin = 'spectre',
        }
      end
    )
    return {
      result_padding = '',
      default = {
        replace = {
          cmd = 'sed',
        },
      },
    }
  end,
}
