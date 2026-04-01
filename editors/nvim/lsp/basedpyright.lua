-- https://docs.basedpyright.com/latest/configuration/language-server-settings/
return {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },

  root_markers = {
    'pyproject.toml',
    'uv.lock',
    'requirements.txt',
    'setup.cfg',
    'setup.py',
    '.git',
  },

  settings = {
    basedpyright = {
      typeCheckingMode = 'strict',
      venvPath = '.',
      venv = '.venv',
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'workspace',
        useLibraryCodeForTypes = true,
      },
    },
  },
}
