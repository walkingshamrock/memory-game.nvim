-- plugin/memory_game.lua

vim.api.nvim_create_user_command("MemoryGame", function()
  require("memory_game").start()
end, {})
