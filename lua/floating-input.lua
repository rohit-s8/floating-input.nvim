local M = {}

function M.window_center(input_width)
  return {
    relative = "win",
    row = vim.api.nvim_win_get_height(0) / 2 - 1,
    col = vim.api.nvim_win_get_width(0) / 2 - input_width / 2,
  }
end

function M.under_cursor(_)
  return {
    relative = "cursor",
    row = 1,
    col = 0,
  }
end

function M.input(opts, on_confirm, win_config)
  vim.validate {
    opts = { opts, "table" },
    on_confirm = { on_confirm, "function" }
  }

  local prompt = opts.prompt or "Input: "
  local default = opts.default or ""

  -- Calculate a minimal width with a bit buffer
  local default_width = vim.str_utfindex(default) + 10
  local prompt_width = vim.str_utfindex(prompt) + 10
  local input_width = default_width > prompt_width and default_width or prompt_width

  local default_win_config = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    width = input_width,
    height = 1,
    title = prompt,
  }

  -- Place the window near cursor or at the center of the window.
  if prompt == "New Name: " then
    default_win_config = vim.tbl_deep_extend("force", default_win_config, M.under_cursor(input_width))
  else
    default_win_config = vim.tbl_deep_extend("force", default_win_config, M.window_center(input_width))
  end

  -- Apply user's window config.
  win_config = vim.tbl_deep_extend("force", default_win_config, win_config)

  -- Create floating window.
  local buffer = vim.api.nvim_create_buf(false, true)
  local window = vim.api.nvim_open_win(buffer, true, win_config)
  vim.api.nvim_buf_set_text(buffer, 0, 0, 0, 0, { default })

  -- Put cursor at the end of the default value
  vim.cmd('startinsert')
  vim.api.nvim_win_set_cursor(window, { 1, vim.str_utfindex(default) + 1 })

  local function close_window(input)
    on_confirm(input)
    vim.api.nvim_win_close(window, true)
  end

  -- Enter to confirm
  vim.keymap.set({ 'n', 'i', 'v' }, '<cr>', function()
    local lines = vim.api.nvim_buf_get_lines(buffer, 0, 1, false)
    close_window(lines[1])
    vim.cmd('stopinsert')
  end, { buffer = buffer })

  -- Esc or q to close
  vim.keymap.set("n", "<esc>", close_window, { buffer = buffer })
  vim.keymap.set("n", "q", close_window, { buffer = buffer })
end

-- Deprecated. No need to call setup, will be removed soon.
function M.setup()
end

return M
