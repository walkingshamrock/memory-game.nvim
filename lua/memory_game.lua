-- lua/memory_game.lua

local M = {}

local board = {}
local state = {}
local size = 4
local revealed = {}
local attempts = 0
local is_processing = false

local function shuffle(tbl)
  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

local function get_card_display(y, x)
  local s = state[y][x]
  if s == "matched" or s == "revealed" then
    return board[y][x]
  else
    return "X"
  end
end

local function update_attempts_display()
  local line = "Attempts: " .. attempts
  vim.api.nvim_buf_set_lines(0, size, size + 1, false, {line})
end

function M.render()
  local lines = {}
  for y = 1, size do
    local row = {}
    for x = 1, size do
      table.insert(row, get_card_display(y, x))
    end
    table.insert(lines, table.concat(row, ""))
  end
  vim.api.nvim_buf_set_lines(0, 0, size, false, lines)
  update_attempts_display()
end

local function all_matched()
  for y = 1, size do
    for x = 1, size do
      if state[y][x] ~= "matched" then
        return false
      end
    end
  end
  return true
end

local function check_win()
  if all_matched() then
    vim.schedule(function()
      vim.cmd("echo 'You win!'")
    end)
  end
end

local function flip_card()
  if is_processing then return end

  local pos = vim.api.nvim_win_get_cursor(0)
  local row = pos[1]
  local col = pos[2]

  if row < 1 or row > size or col < 0 or col > size - 1 then
    return
  end

  if state[row][col + 1] ~= "hidden" then return end

  state[row][col + 1] = "revealed"
  table.insert(revealed, { y = row, x = col + 1 })
  M.render()

  if #revealed == 2 then
    attempts = attempts + 1
    update_attempts_display()

    local a = revealed[1]
    local b = revealed[2]
    if board[a.y][a.x] == board[b.y][b.x] then
      state[a.y][a.x] = "matched"
      state[b.y][b.x] = "matched"
      revealed = {}
      check_win()
      M.render()
    else
      is_processing = true
      vim.defer_fn(function()
        if state[a.y][a.x] == "revealed" and state[b.y][b.x] == "revealed" then
          state[a.y][a.x] = "hidden"
          state[b.y][b.x] = "hidden"
        end
        revealed = {}
        is_processing = false
        M.render()
      end, 1000)
    end
  end
end

local function map(buf, key, func)
  vim.keymap.set("n", key, func, {
    buffer = buf,
    nowait = true,
    silent = true,
    noremap = true,
  })
end

function M.start()
  math.randomseed(os.time())

  local symbols = {}
  for i = 65, 72 do
    local char = string.char(i)
    table.insert(symbols, char)
    table.insert(symbols, char)
  end
  shuffle(symbols)

  local idx = 1
  for y = 1, size do
    board[y] = {}
    state[y] = {}
    for x = 1, size do
      board[y][x] = symbols[idx]
      state[y][x] = "hidden"
      idx = idx + 1
    end
  end

  revealed = {}

  vim.cmd("new")
  local buf = vim.api.nvim_get_current_buf()

  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.bo.modifiable = true

  map(buf, "<CR>", flip_card)
  map(buf, "q", function() vim.cmd("bd!") end)

  M.render()
end

return M
