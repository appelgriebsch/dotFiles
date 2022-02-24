local root_markers = {'pom.xml', '.git'}
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
    '/.local/share/nvim/jdtls/debug/server/com.microsoft.java.debug.plugin-*.jar',
    '/.local/share/nvim/jdtls/test/server/*.jar'
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

  jdtls_config.capabilities = lsp_config.capabilities;
  jdtls_config.on_attach = jdtls_on_attach;
  jdtls.start_or_attach(jdtls_config)

  table.insert(require('command_palette').CpMenu,
    {"Test",
      { "execute test suite", ":lua require('jdtls').test_class()" },
      { "execute test method", ":lua require('jdtls').test_nearest_method()" },
    }
  )
end

return M
