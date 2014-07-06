minetest.register_node("dod:base", {
	description = "Ancient floor",
	tiles = {"dod_base.png"},
	groups = {},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("dod:lock1_1", {
	description = "Ancient floor lock",
	tiles = {"dod_lock1_1.png"},
	groups = {},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("dod:key1_1", {
	description = "Ancient floor key",
	tiles = {"dod_key1_1.png"},
	groups = {oddly_breakable_by_hand=2},
	sounds = default.node_sound_stone_defaults(),
    on_place = function(itemstack, placer, pointed_thing)
		local itemstack, success = minetest.item_place(itemstack, placer, pointed_thing)
		if not success then
			return false
		end
		local p0 = pointed_thing.above
		
		-- Check if lock and key matches
		local dirs = {
			{-1,  0},
			{ 1,  0},
			{ 0,  1},
			{ 0, -1},
		}
		for i, dir in ipairs(dirs) do
			local p1 = {x=p0.x+dir[1], y=p0.y, z=p0.z+dir[2]}
			local n1 = minetest.get_node(p1)
			if n1.name ~= "dod:lock1_1" then
				-- Incorrect position; don't unlock
				return itemstack
			end
		end

		-- Start sound and unlock
		minetest.sound_play({name="dod_stone_drag", gain=1.0})
		minetest.after(1.0, function()
			minetest.set_node({x=p0.x, y=p0.y, z=p0.z}, {name="air"})
			minetest.set_node({x=p0.x, y=p0.y-1, z=p0.z}, {name="air"})
			minetest.set_node({x=p0.x, y=p0.y-2, z=p0.z}, {name="air"})
			for dy = -3, -2 do
				for dx = -1, 1 do
					for dz = -1, 1 do
						local p = {x=p0.x+dx, y=p0.y+dy, z=p0.z+dz}
						minetest.set_node(p, {name="air"})
					end
				end
			end
			minetest.set_node({x=p0.x, y=p0.y-4, z=p0.z}, {name="dod:base"})
		end)
		return itemstack
	end,
})

