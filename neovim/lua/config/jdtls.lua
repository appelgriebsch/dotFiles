local root_markers = { 'pom.xml', '.git' }
local root_dir = require('jdtls.setup').find_root(root_markers)
local home = os.getenv('HOME')
local cfg_folder = jit.os == 'OSX' and 'config_mac' or 'config_linux'
local workspace_folder = "/tmp/nvim/jdtls/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local jdtls = require("jdtls")
local lsp_setup = require("config.lsp-setup")
local lsp_config = lsp_setup.make_config()

local function jdtls_on_attach(client, bufnr)
  lsp_config.on_attach(client, bufnr)
  jdtls.setup_dap({ hotcodereplace = 'auto' })
  jdtls.setup.add_commands()
end

local function progress_report(_, result, ctx)
  local lsp = vim.lsp
  local info = {
    client_id = ctx.client_id,
  }

  local kind = "report"
  if result.complete then
    kind = "end"
  elseif result.workDone == 0 then
    kind = "begin"
  elseif result.workDone > 0 and result.workDone < result.totalWork then
    kind = "report"
  else
    kind = "end"
  end

  local percentage = 0
  if result.totalWork > 0 and result.workDone >= 0 then
    percentage = result.workDone / result.totalWork * 100
  end

  local msg = {
    token = result.id,
    value = {
      kind = kind,
      percentage = percentage,
      title = result.subTask,
      message = result.subTask,
    },
  }

  lsp.handlers["$/progress"](nil, msg, info)

end

local M = {}

function M.setup()
  local jdtls_config = {
    flags = lsp_config.flags
  }

  jdtls_config.cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms2g',
    '-jar', vim.fn.glob(home .. '/.local/share/nvim/lsp_servers/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration', home .. '/.local/share/nvim/lsp_servers/jdtls/' .. cfg_folder,
    '-data', workspace_folder,
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
  }

  jdtls_config.flags.server_side_fuzzy_completion = true
  jdtls_config.settings = {
    java = {
      signatureHelp = { enabled = true };
      contentProvider = { preferred = 'fernflower' };
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.assertj.core.api.Assertions",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*"
        }
      };
      sources = {
        organizeImports = {
          starThreshold = 9999;
          staticStarThreshold = 9999;
        };
      };
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
        }
      };
    };
  }

  local jar_patterns = {
    '/.local/share/nvim/dap_adapters/jdtls/debug/server/com.microsoft.java.debug.plugin-*.jar',
    '/.local/share/nvim/dap_adapters/jdtls/test/server/*.jar'
  }

  local bundles = {}
  for _, jar_pattern in ipairs(jar_patterns) do
    for _, bundle in ipairs(vim.split(vim.fn.glob(home .. jar_pattern), '\n')) do
      if not vim.endswith(bundle, 'com.microsoft.java.test.runner.jar') then
        table.insert(bundles, bundle)
      end
    end
  end

  local extendedClientCapabilities = jdtls.extendedClientCapabilities;
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true;
  jdtls_config.init_options = {
    extendedClientCapabilities = extendedClientCapabilities;
    bundles = bundles;
  }
  jdtls_config.handlers = {
    ["language/progressReport"] = progress_report,
    ["language/status"] = function() end
  }
  jdtls_config.capabilities = lsp_config.capabilities;
  jdtls_config.on_attach = jdtls_on_attach;
  jdtls.start_or_attach(jdtls_config)

end

return M
