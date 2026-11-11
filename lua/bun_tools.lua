local M = {}

local parsers = {
  javascript = 'babel', javascriptreact = 'babel',
  typescript = 'typescript', typescriptreact = 'typescript',
  json = 'json', jsonc = 'jsonc', json5 = 'json5',
  markdown = 'markdown', ['markdown.mdx'] = 'mdx',
}

local function format_args(_, ctx)
  local args = { 'fmt', '--no-script', '--stdin-filepath', ctx.filename }
  local parser = parsers[vim.bo[ctx.buf].filetype]
  if parser then
    vim.list_extend(args, { '--parser', parser })
  end
  return args
end

M.formatter = {
  command = 'bun',
  stdin = true,
  args = format_args,
  range_args = function(self, ctx)
    local start_offset, end_offset = require('conform.util').get_offsets_from_range(ctx.buf, ctx.range)
    -- Bun follows Prettier's UTF-16 offsets; Conform supplies byte offsets.
    local text = table.concat(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false), '\n') .. '\n'
    start_offset = vim.str_utfindex(text, 'utf-16', start_offset, false)
    end_offset = vim.str_utfindex(text, 'utf-16', end_offset, false)
    return vim.list_extend(format_args(self, ctx), {
      '--range-start=' .. start_offset, '--range-end=' .. end_offset,
    })
  end,
  -- Discover project settings relative to the file, including .editorconfig.
  cwd = function(_, ctx) return ctx.dirname end,
}

local eslint_configs = {
  'eslint.config.js', 'eslint.config.mjs', 'eslint.config.cjs',
  'eslint.config.ts', 'eslint.config.mts', 'eslint.config.cts',
}

local fallback_types = { markdown = true, json = true, jsonc = true, json5 = true }

local function parse(output, bufnr)
  -- Bun's JSON report is one line on stdout; stderr carries summaries and
  -- configuration errors. Capture both so a failed lint never looks clean.
  local report
  local errors = {}
  for line in output:gmatch('[^\r\n]+') do
    if line:match('^%s*%[') then
      local ok, decoded = pcall(vim.json.decode, line)
      if ok and type(decoded) == 'table' then
        report = line
      end
    end
    if line:match('^error:') then
      table.insert(errors, line)
    end
  end

  if #errors > 0 or not report then
    return {{
      bufnr = bufnr, lnum = 0, col = 0,
      severity = vim.diagnostic.severity.ERROR, source = 'bun lint',
      message = #errors > 0 and table.concat(errors, '\n')
        or ('Bun lint returned no JSON report: ' .. vim.trim(output)),
    }}
  end

  local diagnostics = require('lint.linters.eslint').parser(report, bufnr)
  for _, diagnostic in ipairs(diagnostics) do
    diagnostic.source = 'bun lint'
    -- ESLint-compatible reports also use UTF-16 columns.
    local line = vim.api.nvim_buf_get_lines(bufnr, diagnostic.lnum, diagnostic.lnum + 1, false)[1] or ''
    diagnostic.col = vim.str_byteindex(line, 'utf-16', diagnostic.col, false)
    if diagnostic.end_col then
      local end_lnum = diagnostic.end_lnum or diagnostic.lnum
      line = vim.api.nvim_buf_get_lines(bufnr, end_lnum, end_lnum + 1, false)[1] or ''
      diagnostic.end_col = vim.str_byteindex(line, 'utf-16', diagnostic.end_col, false)
    end
  end
  return diagnostics
end

function M.linter()
  local filename = vim.api.nvim_buf_get_name(0)
  local filetype = vim.bo.filetype
  local args = { 'lint', '--no-script', '--no-warn-ignored', '--format', 'json', '--stdin' }
  local env = vim.tbl_extend('force', vim.fn.environ(), { NO_COLOR = '1', FORCE_COLOR = '0' })
  if fallback_types[filetype]
    and not vim.fs.find(eslint_configs, { path = vim.fs.dirname(filename), upward = true })[1] then
    local config = vim.api.nvim_get_runtime_file('scripts/bun_lint.config.mjs', false)[1]
    assert(config, 'Missing scripts/bun_lint.config.mjs; reinstall this Neovim configuration')
    vim.list_extend(args, { '--config', config })
    -- Preserve the real filename for ignore patterns, while recognising JSONC
    -- files such as tsconfig.json by their buffer filetype.
    env.NVIM_BUN_FILETYPE = filetype
  end
  vim.list_extend(args, { '--stdin-filename', filename })
  return {
    cmd = 'bun', args = args, stdin = true,
    env = env,
    stream = 'both', ignore_exitcode = true, parser = parse,
  }
end

return M
