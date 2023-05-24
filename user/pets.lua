local pets = require("pets")
local utils = require("pets.utils")

local M = {
  rocky = "rocky",
  timer_enabled = false,
}

function M.generate_name()
  local count = 1

  while true do
    local name = "pet_" .. count
    if not pets.pets[name] then
      return name
    end
    count = count + 1
  end
end

function M.spawn_rocky()
  if pets.pets[M.rocky] then
    return
  end

  local styles = utils.available_pets[M.rocky]
  local style = styles[math.random(#styles)]

  pets.create_pet(M.rocky, M.rocky, style)
end

function M.spawn()
  local pet_types = {
    -- "rocky",
    "crab",
    -- "rubber-duck",
    "cockatiel",
    "dog",
  }
  local pet = pet_types[math.random(#pet_types)]
  local styles = utils.available_pets[pet]
  local name = M.generate_name()
  local style = styles[math.random(#styles)]
  pets.create_pet(name, pet, style)
end

function M.kill()
  local function table_first_key(T)
    for k, _ in pairs(T) do
      if k ~= M.rocky then
        return k
      end
    end
  end

  local key = table_first_key(pets.pets)

  if key then
    pets.kill_pet(key)
  end
end

function M.timer()
  if not M.timer_enabled then
    return
  end

  local timer = vim.loop.new_timer()

  timer:start(
    5000,
    60000,
    vim.schedule_wrap(function()
      M.spawn_rocky()

      M.kill()
      M.spawn()
    end)
  )
end

function M.setup(opts)
  pets.setup(opts)

  vim.keymap.set("n", "<leader>ss", function()
    M.spawn()
  end, { desc = "Spawn Pet" })

  vim.keymap.set("n", "<leader>sd", function()
    M.kill()
  end, { desc = "Stub Pet" })

  vim.keymap.set("n", "<leader>sD", function()
    pets.kill_all()
  end, { desc = "Stub all Pets" })

  M.timer()
end

return M
