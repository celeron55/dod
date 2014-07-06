local function num_to_digits(value)
	local result = {}
	local value_string = ""..value
	for i = 1, #value_string do
		local string_i = #value_string + 1 - i
		local digit_byte = value_string:byte(string_i)
		local digit = digit_byte - 48
		table.insert(result, digit)
	end
	return result
end

minetest.register_on_joinplayer(function(player)
	minetest.after(0.5, function()
		local levelnum_ids = {}
		for i = 1, 3 do
			table.insert(levelnum_ids, player:hud_add({
				hud_elem_type = "image",
				position = {x=0.98, y=0.02},
				text = "invisible.png",
				alignment = {x=-1.0, y=1.0},
				scale = {x=4, y=4},
    			offset = {x=-60*(i-1), y=0},
			}))
		end
		--local displayed_level = nil
		local function display_level(newlevel)
			if newlevel == displayed_level then
				return
			end
			displayed_level = newlevel
			print("DOD level: "..newlevel)

			local digits = num_to_digits(newlevel)
			for i = 1, 3 do
				if digits[i] == nil then
					print(""..i..": nil")
					player:hud_change(levelnum_ids[i], "text", "invisible.png")
				else
					print(""..i..": "..digits[i])
					player:hud_change(levelnum_ids[i], "text", "dod_"..digits[i]..".png")
				end
			end
		end
		local update_levelnum = nil
		update_levelnum = function()
			local p = player:getpos()
			local level = math.floor((dod.TOPMOST_FLOOR_Y - p.y) / dod.FLOOR_INTERVAL)
			level = math.max(0, level)
			--local level = 123
			--print("DOD level: "..level)
			display_level(level)
			minetest.after(0.5, function()
				update_levelnum()
			end)
		end
		update_levelnum()
	end)
end)


