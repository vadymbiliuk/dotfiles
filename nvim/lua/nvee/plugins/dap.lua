local function define_colors()
  local lackluster = require "lackluster"
  vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = lackluster.color.red })
  vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = lackluster.color.blue })
  vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = lackluster.color.green, bold = true })

  vim.fn.sign_define("DapBreakpoint", {
    text = "",
    numhl = "DapBreakpoint",
  })
  vim.fn.sign_define("DapBreakpointCondition", {
    text = "",
    linehl = "DapBreakpoint",
    numhl = "DapBreakpoint",
  })
  vim.fn.sign_define("DapBreakpointRejected", {
    text = "",
    linehl = "DapBreakpoint",
    numhl = "DapBreakpoint",
  })
  vim.fn.sign_define("DapStopped", {
    text = "",
    linehl = "DapStopped",
    numhl = "DapStopped",
  })
  vim.fn.sign_define("DapLogPoint", {
    text = "",
    linehl = "DapLogPoint",
    numhl = "DapLogPoint",
  })
end

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      types = true,
    },
    "nvim-neotest/nvim-nio",
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {
        enabled = true,
      },
    },
  },
  config = function()
    local dap = require "dap"
    local dapui = require "dapui"
    dapui.setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
      -- require("edgy").close()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    define_colors()
    vim.keymap.set("n", "<F6>", function()
      dap.step_over()
    end)
    vim.keymap.set("n", "<F7>", function()
      dap.step_into()
    end)
    vim.keymap.set("n", "<F8>", function()
      dap.step_out()
    end)
    vim.keymap.set("n", "<leader>b", function()
      dap.toggle_breakpoint()
    end)
    vim.keymap.set("n", "<F10>", function()
      dap.terminate()
    end)

    dap.adapters.haskell = {
      type = "executable",
      command = "haskell-debug-adapter",
      args = { "--hackage-version=0.0.33.0" },
    }

    dap.configurations.haskell = {
      {
        type = "haskell",
        request = "launch",
        name = "Debug",
        workspace = "${workspaceFolder}",
        startup = "${file}",
        stopOnEntry = true,
        logFile = vim.fn.stdpath "data" .. "/haskell-dap.log",
        logLevel = "WARNING",
        ghciEnv = vim.empty_dict(),
        ghciPrompt = "λ: ",
        ghciInitialPrompt = "λ: ",
        ghciCmd = "stack ghci --test --no-load --no-build --main-is TARGET --ghci-options -fprint-evld-with-show",
      },
    }

    vim.keymap.set("n", "<F5>", function()
      setup_default_configurations()
      -- when debug is called firstly try to read and/or update launch.json configuration
      -- from the local project which will override all the default configurations
      if vim.fn.filereadable ".vscode/launch.json" then
        require("dap.ext.vscode").load_launchjs(nil, { lldb = { "rust", "c", "cpp" } })
      else
        -- If not possible stick to the default prebuilt configurations
        setup_default_configurations()
      end

      require("dap").continue()
    end)
  end,
}
