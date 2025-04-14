# Memory Game

## Description
Memory Game is a simple and interactive game designed to test and improve your memory skills. The game is implemented in Lua and can be extended or integrated into other projects.

## Features
- Fun and engaging gameplay.
- Easy to customize and extend.
- Lightweight and efficient.

## Installation
1. Ensure you have [Neovim](https://neovim.io/) installed.
2. Install [lazy.nvim](https://github.com/folke/lazy.nvim) if not already installed.
3. Add the following configuration to your `lazy.nvim` setup:
   ```lua
   {
       "walkingshamrock/memory-game.nvim",
       config = function()
           require("memory_game").setup()
       end
   }
   ```
4. Restart Neovim and run `:Lazy sync` to install the plugin.

## Usage
1. Run the game using your preferred Lua environment:
   ```bash
   lua lua/memory_game.lua
   ```
2. Follow the on-screen instructions to play the game.

## License
This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

## Contributing
Contributions are welcome! Feel free to submit issues or pull requests to improve the game.

## Acknowledgments
Special thanks to all contributors and the open-source community for their support.