return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      -- Show harpoon marks in lualine:
      -- https://twitter.com/dillon_mulroy/status/1658310366919643137?s=20
      local harpoon = require("harpoon.mark")
      local noice = require("noice")

      local function harpoon_component()
        local total_marks = harpoon.get_length()

        if total_marks == 0 then
          return ""
        end

        local current_mark = "-"

        local mark_idx = harpoon.get_current_index()
        if mark_idx ~= nil then
          current_mark = tostring(mark_idx)
        end

        return string.format("󱡅 %s/%d", current_mark, total_marks)
      end

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { { harpoon_component } },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = " ",
                warn = " ",
                info = " ",
                hint = " ",
              },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
          },
          lualine_x = {
            {
              function()
                return noice.api.status.command["get"]()
              end,
              cond = function()
                return package.loaded["noice"] and noice.api.status.command["has"]()
              end,
              -- color = util.ui.fg("Statement"),
            },
            {
              function()
                return noice.api.status.mode["get"]()
              end,
              cond = function()
                return package.loaded["noice"] and noice.api.status.mode["has"]()
              end,
              -- color = util.ui.fg("Constant"),
            },
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              -- color = util.ui.fg("Debug"),
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              -- color = util.ui.fg("Special"),
            },
            {
              "diff",
              symbols = {
                added = " ",
                modified = " ",
                removed = " ",
              },
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            --   function()
            --     return " " .. os.date("%R")
            --   end,
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
        {
          filter = {
            event = "notify",
            find = "Client %d+ quit with exit code 1 and signal 0",
          },
          opts = { stop = true },
        },
      },
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      show_dirname = false,
      show_basename = false,
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        buffer_close_icon = "",
        separator_style = "thin",
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      local presets = require("which-key.plugins.presets")
      presets.operators["d"] = nil
    end,
  },
  {
    "rasulomaroff/reactive.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("reactive").setup({
        builtin = {
          cursorline = true,
          cursor = true,
          modemsg = true,
        },
      })
    end,
  },
}