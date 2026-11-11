-- Run: nvim --headless -u NONE -i NONE -l tests/bun_tools.lua
local repo = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h')
local plugins = vim.fn.stdpath('data') .. '/plugged/'
vim.opt.runtimepath:prepend(repo)
for _, plugin in ipairs({ 'conform.nvim', 'nvim-lint' }) do
  vim.opt.runtimepath:append(plugins .. plugin)
end
vim.env.PATH = vim.fn.expand('~/.bun/bin') .. ':' .. vim.env.PATH
assert(vim.fn.executable('bun') == 1, 'Install Bun before running these tests')
local init = table.concat(vim.fn.readfile(repo .. '/init.vim'), '\n')
local blocks = 0
for code in init:gmatch('lua << EOF\n(.-)\nEOF') do
  assert(loadstring(code), 'Invalid Lua block')
  blocks = blocks + 1
end
print('PASS: syntax of ' .. blocks .. ' Lua blocks')
local code = assert(init:match('""" Linting and Formatting Configuration\nlua << EOF\n(.-)\nEOF'))
assert(loadstring(code))()
local conform = require('conform')
local lint = require('lint')
local root = vim.fn.tempname()
vim.fn.mkdir(root, 'p')
local count = 0
local function pass(label)
  count = count + 1
  print('PASS: ' .. label)
end
local function write(path, content)
  vim.fn.mkdir(vim.fs.dirname(path), 'p')
  vim.fn.writefile(vim.split(content, '\n', { plain = true }), path)
end
local function buffer(path, filetype, content)
  local bufnr = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_buf_set_name(bufnr, path)
  vim.bo[bufnr].filetype = filetype
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(content, '\n', { plain = true, trimempty = true }))
  return bufnr
end
local function run_lint(bufnr, event)
  vim.api.nvim_exec_autocmds(event or 'BufReadPost', { buffer = bufnr })
  assert(vim.wait(15000, function() return #lint.get_running(bufnr) == 0 end, 10), 'Lint timeout')
  vim.wait(25)
  return vim.diagnostic.get(bufnr, { namespace = lint.get_namespace('bun') })
end
local function has_code(diags, expected)
  for _, diag in ipairs(diags) do
    if diag.code == expected then return diag end
  end
  error('Missing ' .. expected .. ': ' .. vim.inspect(diags))
end

write(root .. '/bad.ts', 'export const value = 1;')
local ts = buffer(root .. '/bad.ts', 'typescript', 'export const bad = typeof 1 === "strng";')
local diags = run_lint(ts)
local diag = has_code(diags, 'valid-typeof')
assert(diag.lnum == 0 and diag.source == 'bun lint', vim.inspect(diag))
pass('TypeScript lint reads unsaved buffer, with rule, location and source')

for _, ft in ipairs({ 'javascript', 'javascriptreact', 'typescriptreact' }) do
  local extension = ({ javascript = 'mjs', javascriptreact = 'jsx', typescriptreact = 'tsx' })[ft]
  local buf = buffer(root .. '/bad.' .. extension, ft, 'export const bad = typeof 1 === "strng";')
  has_code(run_lint(buf), 'valid-typeof')
end
pass('JS, JSX and TSX lint adapters')

local workflow_dir = root .. '/.github/workflows'
vim.fn.mkdir(workflow_dir, 'p')
local workflow_script = buffer(workflow_dir .. '/helper.js', 'javascript', 'export const bad = typeof 1 === "strng";')
has_code(run_lint(workflow_script), 'valid-typeof')
pass('Workflow helper scripts use Bun rather than actionlint')

local md = buffer(root .. '/notes.mdwn', 'markdown', '# Heading\n\n[Broken][missing]')
diag = has_code(run_lint(md), 'markdown/no-missing-label-refs')
assert(diag.lnum == 2 and diag.col == 9, vim.inspect(diag))
vim.api.nvim_buf_set_lines(md, 0, -1, false, { '# Heading', '', '[Broken][missing]', '', '[missing]: https://example.com' })
assert(#run_lint(md, 'BufWritePost') == 0)
pass('Markdown alias extensions, reference locations and stale diagnostic clearing')

local json = buffer(root .. '/data.json', 'json', '{"a":1,"\\u0061":2}')
has_code(run_lint(json), 'json/no-duplicate-keys')
pass('JSON duplicate keys, including escaped keys')

local jsonc = buffer(root .. '/tsconfig.json', 'jsonc', '{\n // retained\n "a": 1,\n}')
assert(#run_lint(jsonc) == 0)
pass('JSONC .json filenames accept comments and trailing commas')

local strict = buffer(root .. '/strict.json', 'json', '{"a":1,}')
diags = run_lint(strict)
assert(#diags > 0 and diags[1].severity == vim.diagnostic.severity.ERROR, vim.inspect(diags))
pass('Strict JSON still rejects trailing commas')

local json5 = buffer(root .. '/data.json5', 'json5', '{ a:1, a:2 }')
has_code(run_lint(json5), 'json/no-duplicate-keys')
pass('JSON5 native lint')

local project = root .. '/project'
vim.fn.mkdir(project, 'p')
write(project .. '/eslint.config.mjs', [[export default [{
 files: ['**/*.md'], plugins: {markdown: {meta: {name: '@eslint/markdown'}}},
 language: 'markdown/gfm', rules: {'markdown/no-empty-links': 'error'}
}];]])
local project_md = buffer(project .. '/readme.md', 'markdown', '# Heading\n\n[Broken][missing]\n\n[empty]()')
diags = run_lint(project_md)
has_code(diags, 'markdown/no-empty-links')
for _, d in ipairs(diags) do assert(d.code ~= 'markdown/no-missing-label-refs') end
pass('Project ESLint settings take precedence over fallback rules')

write(project .. '/eslint.config.mjs', 'export default [{ ignores: ["**/*.md"] }];')
assert(#run_lint(project_md) == 0)
pass('Project ignores do not leave stale diagnostics or editor warnings')

write(project .. '/eslint.config.mjs', 'throw new Error("CONFIG_TEST_FAILURE");')
diags = run_lint(project_md)
assert(#diags > 0 and diags[1].message:match('Cannot load'), vim.inspect(diags))
pass('Configuration failures become diagnostics')

local bunfig_project = root .. '/bunfig-project'
vim.fn.mkdir(bunfig_project, 'p')
write(bunfig_project .. '/bunfig.toml', '[lint.rules]\n"no-console" = "error"')
local js = buffer(bunfig_project .. '/main.js', 'javascript', 'console.log("hello");')
has_code(run_lint(js), 'no-console')
pass('Project bunfig.toml lint settings')

local format_project = root .. '/format-project'
vim.fn.mkdir(format_project, 'p')
write(format_project .. '/package.json', '{"scripts":{"fmt":"touch SHOULD_NOT_EXIST","lint":"touch SHOULD_NOT_EXIST"}}')
write(format_project .. '/.editorconfig', 'root = true\n[*]\nindent_style = space\nindent_size = 4')
write(format_project .. '/.prettierrc', '{"singleQuote":true,"semi":false}')
local formatted = buffer(format_project .. '/main.ts', 'typescript', 'export const x={a:"hello",b:1};')
local format_error
conform.format({ bufnr = formatted, async = false, timeout_ms = 10000 }, function(err) format_error = err end)
assert(not format_error, vim.inspect(format_error))
local content = table.concat(vim.api.nvim_buf_get_lines(formatted, 0, -1, false), '\n')
assert(content:match("'hello'") and not content:match(';$'), content)
assert(vim.fn.filereadable(format_project .. '/SHOULD_NOT_EXIST') == 0)
has_code(run_lint(buffer(format_project .. '/bad.ts', 'typescript', 'export const bad = typeof 1 === "strng";')), 'valid-typeof')
assert(vim.fn.filereadable(format_project .. '/SHOULD_NOT_EXIST') == 0)
pass('Formatting discovers project settings; fmt/lint scripts are bypassed')

local fixtures = {
  { 'javascript', 'sample.js', 'export const x={a:1};' },
  { 'javascriptreact', 'sample.jsx', 'export const x=<div a="b"/>;' },
  { 'typescript', 'sample.ts', 'export const x:number=1;' },
  { 'typescriptreact', 'sample.tsx', 'export const x=<div a="b"/>;' },
  { 'json', 'sample.json', '{"a":1}' },
  { 'jsonc', 'sample.jsonc', '{\n// keep\n"a":1,\n}' },
  { 'json5', 'sample.json5', '{a:1,}' },
  { 'markdown', 'sample.mkdn', '# Heading\n\n-   item' },
  { 'markdown.mdx', 'sample.mdx', '# Heading\n\n<Component a={1}/>' },
  { 'css', 'sample.css', 'a{color:red}' },
  { 'scss', 'sample.scss', '$x:red;a{color:$x}' },
  { 'less', 'sample.less', '@x:red;a{color:@x}' },
  { 'html', 'sample.html', '<div    class = "x">hello</div>' },
  { 'vue', 'sample.vue', '<template><div    a = "b">hello</div></template>' },
  { 'svelte', 'sample.svelte', '<div   a = "b">hello</div>' },
  { 'yaml', 'sample.yaml', 'a: [1,2]' },
  { 'toml', 'sample.toml', 'a=[1,2]' },
  { 'graphql', 'sample.graphql', 'query{user{id name}}' },
}
for _, fixture in ipairs(fixtures) do
  local buf = buffer(root .. '/' .. fixture[2], fixture[1], fixture[3])
  local err
  conform.format({ bufnr = buf, async = false, timeout_ms = 10000 }, function(e) err = e end)
  assert(not err, fixture[1] .. ': ' .. vim.inspect(err))
  local result = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n')
  assert(result ~= fixture[3], fixture[1] .. ' unchanged: ' .. result)
  if fixture[1] == 'jsonc' then assert(result:match('// keep') and result:match('1,'), result) end
end
pass('Actual formatting of all 18 configured Bun filetypes')

local range_buf = buffer(root .. '/range.ts', 'typescript', 'const first={a:1};\nconst second={b:2};')
local err
conform.format({ bufnr = range_buf, async = false, timeout_ms = 10000,
  range = { start = { 1, 0 }, ['end'] = { 1, 17 } } }, function(e) err = e end)
assert(not err, vim.inspect(err))
local lines = vim.api.nvim_buf_get_lines(range_buf, 0, -1, false)
assert(lines[1] == 'const first = { a: 1 };', vim.inspect(lines))
assert(lines[2] == 'const second={b:2};', vim.inspect(lines))
pass('Selection formatting leaves the other statement unchanged')

local invalid = buffer(root .. '/invalid.ts', 'typescript', 'const = ;')
local original = vim.api.nvim_buf_get_lines(invalid, 0, -1, false)
err = nil
conform.format({ bufnr = invalid, async = false, timeout_ms = 10000 }, function(e) err = e end)
assert(err and vim.deep_equal(original, vim.api.nvim_buf_get_lines(invalid, 0, -1, false)))
pass('Formatter syntax failures preserve the buffer')

local unicode_line = 'export const emoji = "😀"; export const bad = typeof 1 === "strng";'
local unicode_buf = buffer(root .. '/unicode.ts', 'typescript', unicode_line)
diag = has_code(run_lint(unicode_buf), 'valid-typeof')
assert(diag.col == unicode_line:find('"strng"', 1, true) - 1, vim.inspect(diag))
assert(diag.end_col == diag.col + #'"strng"', vim.inspect(diag))
pass('Unicode diagnostic columns convert from UTF-16 to bytes')

local unicode_range = buffer(root .. '/unicode-range.ts', 'typescript', 'const first = "😀";\nconst second={b:2};\nconst third={c:3};')
err = nil
conform.format({ bufnr = unicode_range, async = false, timeout_ms = 10000,
  range = { start = { 2, 0 }, ['end'] = { 2, #'const second={b:2};' } } }, function(e) err = e end)
assert(not err, vim.inspect(err))
lines = vim.api.nvim_buf_get_lines(unicode_range, 0, -1, false)
assert(lines[2] == 'const second = { b: 2 };' and lines[3] == 'const third={c:3};', vim.inspect(lines))
pass('Unicode selections format only the selected statement')

print('ALL PASSED: ' .. count .. ' integration groups')
vim.cmd('qa!')
