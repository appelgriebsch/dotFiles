local status_jdtls, jdtls = pcall(require, "jdtls")
if not status_jdtls then
  return
end

local function local_keymap(desc) return { silent = true, buffer = true, desc = desc } end

-- Find root of project
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
  return
end

-- Determine OS
local home = os.getenv "HOME"
local workspace_folder = "/tmp/nvim/jdtls/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
if vim.fn.has "mac" == 1 then
  CONFIG = "mac"
elseif vim.fn.has "unix" == 1 then
  CONFIG = "linux"
else
  print "Unsupported system"
end

local lsp_setup = require("plugins.lsp").make_config()

local function jdtls_attach(client, bufnr)
  lsp_setup.on_attach(client, bufnr)

  vim.keymap.set("n", "<leader>jts", "<CMD>lua require('jdtls').test_class()<CR>", local_keymap("Run Test suite"))
  vim.keymap.set("n", "<leader>jtm", "<CMD>lua require('jdtls').test_nearest_method()<CR>", local_keymap("Run Test method"))
  vim.keymap.set("n", "<leader>jc", "<CMD>lua require('jdtls').update_project_config()<CR>", local_keymap("Update Project configs"))
  vim.keymap.set("n", "<leader>jr", "<CMD>lua require('jdtls.dap').setup_dap_main_class_configs({ verbose = true })<CR>", local_keymap("Update Run configs"))
  vim.keymap.set("n", "<leader>jo", "<CMD>lua require'jdtls'.organize_imports()<CR>", local_keymap("Organize imports"))

  jdtls.setup_dap({ hotcodereplace = "auto" })
  jdtls.setup.add_commands()
  jdtls.dap.setup_dap_main_class_configs()
end

local jdtls_config = {
  flags = lsp_setup.flags,
  capabilities = lsp_setup.capabilities,
  on_attach = jdtls_attach
}

jdtls_config.cmd = {
  "java",
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.protocol=true",
  "-Dlog.level=ALL",
  "-Xms2g",
  "-jar", vim.fn.glob(home .. "/.local/share/nvim/lsp_servers/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
  "-configuration", home .. "/.local/share/nvim/lsp_servers/jdtls/config_" .. CONFIG,
  "-data", workspace_folder,
  "--add-modules=ALL-SYSTEM",
  "--add-opens", "java.base/java.util=ALL-UNNAMED",
  "--add-opens", "java.base/java.lang=ALL-UNNAMED",
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

local jar_patterns = {
  "/.local/share/nvim/dap_adapters/jdtls/debug/server/com.microsoft.java.debug.plugin-*.jar",
  "/.local/share/nvim/dap_adapters/jdtls/test/server/*.jar"
}

local bundles = {}
for _, jar_pattern in ipairs(jar_patterns) do
  for _, bundle in ipairs(vim.split(vim.fn.glob(home .. jar_pattern), '\n')) do
    if not vim.endswith(bundle, "com.microsoft.java.test.runner.jar") then
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
jdtls.start_or_attach(jdtls_config)

local status_menu, menu = pcall(require, "key-menu")
if not status_menu then
  return
end

menu.set("n", "<leader>j", { desc = "Java" })
menu.set("n", "<leader>jt", { desc = "Test" })