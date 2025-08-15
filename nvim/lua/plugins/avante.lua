-- https://github.com/yetone/avante.nvim
return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false,
  version = false,
  build = 'make',
  opts = {
    provider = 'openai',
    providers = {
      openai = {
        endpoint = 'https://api.openai.com/v1',
        model = 'gpt-5', -- your desired model (or use gpt-4o, etc.)
        timeout = 90000, -- Timeout in milliseconds, increase this for reasoning models
        extra_request_body = {
          temperature = 0,
          max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
          reasoning_effort = 'medium', -- low|medium|high, only used for reasoning models
        },
      },
    },
    windows = {
      sidebar_header = { rounded = false },
      input = { prefix = ' ' },
      ask = { floating = true, border = 'rounded' },
    },
  },
}
