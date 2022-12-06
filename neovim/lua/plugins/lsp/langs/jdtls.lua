local M = {}

-- specific jdtls setup
local status_jdtls, jdtls = pcall(require, "jdtls")
if not status_jdtls then
  return
end

-- Find root of project
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
  return
end

-- Determine OS
local workspace_folder = "/tmp/nvim/jdtls/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
if vim.fn.has "mac" == 1 then
  CONFIG = "mac"
elseif vim.fn.has "unix" == 1 then
  CONFIG = "linux"
else
  print "Unsupported system"
end

local lsp_config = require("plugins.lsp").make_config()

local function jdtls_attach(client, bufnr)
  local status_menu, menu = pcall(require, "which-key")
  if status_menu then
    menu.register({
      j = {
        name = "+java",
        o = { "<CMD>lua require(\"jdtls\").organize_imports()<CR>", "organize imports" },
        r = { "<CMD>lua require(\"jdtls.dap\").setup_dap_main_class_configs({ verbose = true })<CR>",
          "run configurations" },
        t = {
          name = "+test",
          c = { "<CMD>lua require(\"jdtls\").test_class()<CR>", "nearest class" },
          m = { "<CMD>lua require(\"jdtls\").test_nearest_method()<CR>", "nearest method" },
        },
        u = { "<CMD>lua require(\"jdtls\").update_project_config()<CR>", "update project configuration" },
        w = { "<CMD>JdtWipeDataAndRestart<CR>", "wipe and restart" }
      }
    }, {
      mode = "n", -- NORMAL mode
      prefix = "<leader>",
      buffer = bufnr, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = false, -- use `nowait` when creating keymaps
    })
  end

  lsp_config.on_attach(client, bufnr)
  jdtls.setup_dap({ hotcodereplace = "auto" })
  jdtls.setup.add_commands()
  jdtls.dap.setup_dap_main_class_configs()
end

local mason_registry = require("mason-registry")
local jdtls_pkg = mason_registry.get_package("jdtls")
local jdtls_path = jdtls_pkg:get_install_path()

local java_test_pkg = mason_registry.get_package("java-test")
local java_test_path = java_test_pkg:get_install_path()

local java_dbg_pkg = mason_registry.get_package("java-debug-adapter")
local java_dbg_path = java_dbg_pkg:get_install_path()

local jar_patterns = {
  java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
  java_test_path .. "/extension/server/*.jar"
}

local bundles = {}
for _, jar_pattern in ipairs(jar_patterns) do
  for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), '\n')) do
    if not vim.endswith(bundle, "com.microsoft.java.test.runner.jar") then
      table.insert(bundles, bundle)
    end
  end
end

function M.setup()
  local jdtls_config = {
    flags = lsp_config.flags,
    capabilities = lsp_config.capabilities,
    on_attach = jdtls_attach
  }

  jdtls_config.cmd = {
    "java",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "--add-opens",
    "java.base/sun.nio.fs=ALL-UNNAMED",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dfile.encoding=UTF-8",
    "-DwatchParentProcess=${watch_parent_process}",
    "-noverify",
    "-XX:+UseParallelGC",
    "-XX:GCTimeRatio=4",
    "-XX:AdaptiveSizePolicyWeight=90",
    "-Dsun.zip.disableMemoryMapping=true",
    "-Xmx2G",
    "-Xms100m",
    "-jar", vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration", jdtls_path .. "/config_" .. CONFIG,
    "-data", workspace_folder,
  }

  jdtls_config.flags.server_side_fuzzy_completion = true
  jdtls_config.settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = false, --Don"t automatically show implementations
      },
      referencesCodeLens = {
        enabled = false, --Don"t automatically show references
      },
      references = {
        includeDecompiledSources = true,
      },
    },
    signatureHelp = { enabled = true },
    inlayHints = {
      parameterNames = { enabled = "all" }
    },
    contentProvider = { preferred = "fernflower" },
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
    },
    sources = {
      organizeImports = {
        starThreshold = 9999;
        staticStarThreshold = 9999;
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
      },
      useBlocks = true,
    },
    flags = {
      allow_incremental_sync = true,
    },
  }

  local extendedClientCapabilities = jdtls.extendedClientCapabilities;
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true;
  extendedClientCapabilities.progressReportProvider = false;

  jdtls_config.init_options = {
    extendedClientCapabilities = extendedClientCapabilities;
    bundles = bundles;
  }

  jdtls.start_or_attach(jdtls_config)
end

return M
