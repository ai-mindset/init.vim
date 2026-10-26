local M = {}
local request_number = 0
local preview_window
local preview_buffer
local last_status = 'No hover requested yet'
local last_definition
local cache, cache_order = {}, {}
local helper = vim.fs.joinpath(
  vim.fs.dirname(vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))),
  'scripts', 'jac_hover_docs.py'
)

local function remember(key, value)
  if cache[key] == nil then
    cache_order[#cache_order + 1] = key
    if #cache_order > 128 then
      cache[table.remove(cache_order, 1)] = nil
    end
  end
  cache[key] = value
end

local function signature_only(result)
  local contents = result and result.contents
  if type(contents) ~= 'table' or contents.kind ~= 'plaintext'
    or not contents.value:match('^%(') then
    return false
  end
  local first = true
  for line in contents.value:gmatch('[^\n]+') do
    if first then
      first = false
    elseif not line:match('^placement:') and line:match('%S') then
      return false
    end
  end
  return true
end

function M.hover(options)
  local bufnr = vim.api.nvim_get_current_buf()
  if preview_buffer == bufnr and preview_window and vim.api.nvim_win_is_valid(preview_window) then
    vim.api.nvim_set_current_win(preview_window)
    return
  end
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = 'jac' })[1]
  if not client then
    last_status = 'No Jac language server is attached to this buffer'
    vim.lsp.buf.hover(options)
    return
  end
  request_number = request_number + 1
  local current_request = request_number
  local window = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(window)
  local tick = vim.api.nvim_buf_get_changedtick(bufnr)
  local params = vim.lsp.util.make_position_params(window, client.offset_encoding)
  local hover_buffer, hover_window
  last_status = 'Waiting for Jac hover response'
  last_definition = nil

  local function still_current()
    if current_request ~= request_number or not vim.api.nvim_buf_is_valid(bufnr)
      or not vim.api.nvim_win_is_valid(window)
      or vim.api.nvim_win_get_buf(window) ~= bufnr
      or (vim.api.nvim_get_current_win() ~= window and vim.api.nvim_get_current_win() ~= hover_window)
      or vim.api.nvim_get_mode().mode ~= 'n'
      or vim.api.nvim_buf_get_changedtick(bufnr) ~= tick then
      return false
    end
    local position = vim.api.nvim_win_get_cursor(window)
    return position[1] == cursor[1] and position[2] == cursor[2]
  end

  client:request('textDocument/hover', params, function(err, result)
    if not still_current() then
      return
    end
    if err or not result or not result.contents then
      last_status = err and ('Jac hover failed: ' .. tostring(err.message)) or 'Jac returned no hover'
      vim.notify('No hover information available', vim.log.levels.INFO)
      return
    end

    local finished = false
    local function display(doc)
      if not still_current() then
        return
      end
      if hover_window and (not vim.api.nvim_win_is_valid(hover_window) or not doc) then
        return
      end
      local contents = result.contents
      local plaintext = type(contents) == 'table' and contents.kind == 'plaintext'
      local lines = plaintext and vim.split(contents.value, '\n', { plain = true })
        or vim.lsp.util.convert_input_to_markdown_lines(contents)
      if doc and doc ~= '' then
        vim.list_extend(lines, { '', 'Python documentation:', '' })
        vim.list_extend(lines, vim.split(doc, '\n', { plain = true }))
      end
      if hover_window then
        -- Update the existing popup without stealing focus or reopening it.
        vim.bo[hover_buffer].modifiable = true
        vim.api.nvim_buf_set_lines(hover_buffer, 0, -1, false, lines)
        vim.bo[hover_buffer].modifiable = false
        local limit = (options or {}).max_height or math.max(1, vim.o.lines - 4)
        local height = vim.api.nvim_win_text_height(hover_window, {}).all
        vim.api.nvim_win_set_height(hover_window, math.max(1, math.min(limit, height)))
        return
      end
      local config = vim.tbl_extend('force', {}, options or {}, { focus_id = 'jac-hover' })
      hover_buffer, hover_window = vim.lsp.util.open_floating_preview(lines, plaintext and 'plaintext' or 'markdown', config)
      preview_window = hover_window
      preview_buffer = bufnr
    end

    local function complete(doc)
      if not finished then
        finished = true
        display(doc)
      end
    end

    if vim.g.jac_hover_python_docs == false or vim.g.jac_hover_python_docs == 0
      or not signature_only(result) then
      last_status = 'Showing Jac hover; Python lookup was not needed or is disabled'
      complete()
      return
    end
    -- Never wait for a definition lookup or Python startup to show the hover.
    display()
    vim.defer_fn(function()
      if not finished and still_current() then
        last_status = 'Python documentation lookup exceeded 8 seconds; showing Jac hover'
        complete()
      end
    end, 8000)
    last_status = 'Waiting for the Python definition'
    local sent = client:request('textDocument/definition', params, function(def_err, definition)
      if finished or not still_current() then
        return
      end
      if def_err or not definition then
        last_status = 'Jac returned no definition for the Python documentation lookup'
        complete()
        return
      end
      local location = definition.uri and definition or definition[1]
      local uri = location and (location.uri or location.targetUri)
      local range = location and (location.targetSelectionRange or location.range)
      if not uri or not range or not uri:match('^file:') then
        last_status = 'Jac did not return a local file definition'
        complete()
        return
      end
      local path = vim.uri_to_fname(uri)
      last_definition = path .. ':' .. (range.start.line + 1)
      if not path:match('%.pyi?$') then
        last_status = 'Definition is not Python; documentation must come from Jac'
        complete()
        return
      end
      local stat = vim.uv.fs_stat(path)
      local root = _G.Jac.root(bufnr)
      local key = table.concat({ path, range.start.line, root,
        stat and stat.mtime.sec or 0, stat and stat.mtime.nsec or 0 }, ':')
      if cache[key] ~= nil then
        last_status = cache[key] and 'Showing cached Python documentation' or 'No Python documentation was found (cached)'
        complete(cache[key] or nil)
        return
      end
      if vim.fn.filereadable(helper) ~= 1 then
        last_status = 'Missing documentation helper: ' .. helper .. '; run python3 scripts/install.py'
        complete()
        return
      end
      last_status = 'Reading Python documentation'
      local ok, failure = pcall(vim.system, { _G.Jac.executable(), 'run', helper }, {
        -- Project configuration must not turn this helper into an app launch.
        -- Its project search path comes from the JSON request instead.
        cwd = vim.fs.dirname(helper),
        stdin = vim.json.encode({ path = path, line = range.start.line, root = root }),
        text = true,
        timeout = 6000,
      }, function(output)
        vim.schedule(function()
          local decoded, value = pcall(vim.json.decode, output.stdout or '')
          local doc = output.code == 0 and decoded and type(value) == 'table'
            and type(value.documentation) == 'string' and value.documentation or nil
          if output.code == 0 and decoded and type(value) == 'table' and not value.error then
            remember(key, doc or false)
          end
          if finished or not still_current() then
            return
          end
          if doc then
            last_status = 'Showing Python documentation'
          elseif output.code ~= 0 then
            last_status = 'Documentation helper failed (exit ' .. output.code .. '): ' .. vim.trim(output.stderr or '')
          elseif not decoded then
            last_status = 'Documentation helper returned invalid JSON: ' .. tostring(value)
          else
            last_status = type(value) == 'table' and value.error or 'No Python documentation is available for this definition'
          end
          complete(doc)
        end)
      end)
      if not ok then
        last_status = 'Could not launch the documentation helper: ' .. tostring(failure)
        complete()
      end
    end, bufnr)
    if not sent then
      last_status = 'The Jac server did not accept the definition request'
      complete()
    end
  end, bufnr)
end

function M.info()
  return {
    module = debug.getinfo(1, 'S').source:sub(2),
    helper = helper,
    helper_available = vim.fn.filereadable(helper) == 1,
    last_definition = last_definition,
    status = last_status,
  }
end

return M
