--- Parses a set of arguments
--- @param args string The arguments. For example "-f='/path/to/file' -f=/other/path other input"
--- @return table parsed_arguments For example { "other input", f = {'path/to/file', '/other/path' } }
local parse_args = function(args)
  local parsed_arguments = {}
  local current_key = nil

  table.insert(parsed_arguments, '')
  for token in args:gmatch('%S+') do
    local key, value = token:match('^%-(%w+)=(.+)')
    if key then
      if not parsed_arguments[key] then
        parsed_arguments[key] = {}
      end
      table.insert(parsed_arguments[key], value)
    elseif token:match('^%-(%w+)$') then
      current_key = token:match('^%-(%w+)$')
    else
      if current_key then
        if not parsed_arguments[current_key] then
          parsed_arguments[current_key] = {}
        end
        table.insert(parsed_arguments[current_key], token)
        current_key = nil
      else
        parsed_arguments[1] = parsed_arguments[1] .. token
      end
    end
  end

  return parsed_arguments
end

local load_files_context = function(params)
  local args = parse_args(params.args)
  local files_context = ''
  if args.f then
    for _, file_path in ipairs(args.f) do
      local full_path = vim.fn.expand('%:h') .. '/' .. file_path
      local content = vim.fn.readfile(full_path)
      local filetype = vim.filetype.match({ filename = full_path }) or ''
      files_context = files_context
        .. file_path
        .. ':\n```'
        .. filetype
        .. '\n'
        .. table.concat(content, '\n')
        .. '\n```\n\n'
    end
  end

  if files_context ~= '' then
    files_context = 'Consider the following files as context information:\n'
      .. files_context
  end

  return files_context
end

---@type LazySpec
local plugin = {
  'frankroeder/parrot.nvim',
  dependencies = { 'ibhagwan/fzf-lua', 'nvim-lua/plenary.nvim' },
  event = 'VeryLazy',
  config = function()
    require('parrot').setup({
      user_input_ui = 'buffer',
      providers = {
        pplx = {
          api_key = os.getenv('PERPLEXITY_API_KEY'),
        },
        openai = {
          api_key = os.getenv('OPENAI_API_KEY'),
        },
        anthropic = {
          api_key = os.getenv('ANTHROPIC_API_KEY'),
        },
        mistral = {
          api_key = os.getenv('MISTRAL_API_KEY'),
        },
      },
      hooks = {
        Test = function(prt, params)
          local files_context = load_files_context(params)

          local template = [[
          You in the file {{filename}}:

          ```{{filetype}}
          {{selection}}
          ```

          ]] .. files_context .. [[

          Generate tests.
          Wrap them in a describe with the function name and start each case with it('should.
          Each case should describe a specific scenario and might include multiple expects.
          For UI tests use react testing library, jest-dom and user-event.

          Respond exclusively with the code snippet! Do not wrap responses in quotes.
          ]]
          local model_obj = prt.get_model('command')
          prt.logger.info('Generate tests with model: ' .. model_obj.name)
          prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
        end,
        TestUpdate = function(prt, params)
          local files_context = load_files_context(params)

          local template = [[
          Consider the following content from {{filename}}:

          ```{{filetype}}
          {{selection}}
          ```

          ]] .. files_context .. [[

          Update the tests based on the changes made to the tested code.
          Wrap them in a describe with the function name and start each case with it('should.
          Each case should describe a specific scenario and might include multiple expects.
          For UI tests use react testing library, jest-dom and user-event.

          Respond exclusively with the code snippet! Do not wrap responses in quotes.
          ]]
          local model_obj = prt.get_model('command')
          prt.logger.info('Update tests with model: ' .. model_obj.name)
          prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
        end,
        TestAdd = function(prt, params)
          local files_context = load_files_context(params)

          local template = [[
          Consider the following content from {{filename}}:

          ```{{filetype}}
          {{selection}}
          ```

          ]] .. files_context .. [[

          Add only the missing tests cases.
          Start each case with it('should.
          Each case should describe a specific scenario and might include multiple expects.
          For UI tests use react testing library, jest-dom and user-event.

          Respond exclusively with the code snippet! Do not wrap responses in quotes.
          ]]
          local model_obj = prt.get_model('command')
          prt.logger.info('Add missing tests with model: ' .. model_obj.name)
          prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
        end,
        ProofRead = function(prt, params)
          local template = [[
          Correct the text in triple quotes below by fixing the grammar, punctuation and typos.
          Make your best effort.

          """
          {{selection}}
          """

          Do not return anything other than the corrected text. Do not wrap responses in quotes. Preserve all whitespace.
          ]]
          local model_obj = prt.get_model('command')
          prt.logger.info('Proofreading with model: ' .. model_obj.name)
          prt.Prompt(params, prt.ui.Target.rewrite, model_obj, nil, template)
        end,
      },
    })
  end,
}

return plugin
