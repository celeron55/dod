local YMIN = -33000
local YMAX = 33000
local TOPMOST_FLOOR_Y = -15
local FLOOR_INTERVAL = 20
local STAIRCASE_INTERVAL = 40
local SI = STAIRCASE_INTERVAL

minetest.register_on_generated(function(minp, maxp, seed)
	if minp.y < YMIN or maxp.y > YMAX then
		return
	end

	local t1 = os.clock()
	local x1 = maxp.x
	local y1 = maxp.y
	local z1 = maxp.z
	local x0 = minp.x
	local y0 = minp.y
	local z0 = minp.z
	
	print ("[dod] chunk minp ("..x0.." "..y0.." "..z0..")")

	-- voxelmanip stuff
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip") -- min, max points for emerged area/voxelarea
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax} -- voxelarea helper for indexes
	local data = vm:get_data() -- get flat array of voxelarea content ids
	-- content ids
	local c_air = minetest.get_content_id("air")
	local c_water = minetest.get_content_id("default:water_source")
	local c_stone = minetest.get_content_id("default:stone")
	local c_cobble = minetest.get_content_id("default:cobble")
	local c_mossycobble = minetest.get_content_id("default:mossycobble")

	-- mapgen loop
	for z = z0, z1 do -- for each xy plane progressing northwards
		for y = y0 - 1, y1 do -- for each x row progressing upwards
			local vi = area:index(x0, y, z) -- voxelmanip index for first node in this x row
			local viu = area:index(x0, y-1, z) -- index for under node
			for x = x0, x1 do -- for each node do
				local si = x - x0 + 1 -- stable, under tables index

				-- Axis-oriented horizontal distance from (0,y,0)
				local hd = math.max(math.abs(x - 0), math.abs(z - 0))
				-- Staircase recurring horizontal distance
				local hd2 = math.max(
						math.abs(((x+SI/2)%SI)-SI/2),
						math.abs(((z+SI/2)%SI)-SI/2))

				-- Inverse pyramid at top
				if hd == 20 and data[vi] == c_water then
					data[vi] = c_mossycobble
				end
				if hd < 20 + y then
					if data[vi] ~= c_air then
						data[vi] = c_air
					end
				elseif hd == 20 + y and data[vi] == c_water then
					data[vi] = c_mossycobble
				end

				-- Staircases
				if y < TOPMOST_FLOOR_Y and hd2 <= 1 then
					data[vi] = c_air
					local rotation = {
						{-1, -1},
						{-1,  0},
						{-1,  1},
						{ 0,  1},
						{ 1,  1},
						{ 1,  0},
						{ 1, -1},
						{ 0, -1},
					}
					for i, rot in ipairs(rotation) do
						if
							((x+10) % SI)-10 == rot[1] and
							((z+10) % SI)-10 == rot[2] and
							(y-i) % 8 == 0
						then
							data[vi] = c_cobble
						end
					end
				end

				-- Level floors
				if y <= TOPMOST_FLOOR_Y then
					if (y - TOPMOST_FLOOR_Y) % FLOOR_INTERVAL == 0 then
						if (x + z) % 2 == 0 then
							data[vi] = minetest.get_content_id("dod:lock1_1")
						else
							-- Leave original node
						end
					end
					if (y - (TOPMOST_FLOOR_Y-1)) % FLOOR_INTERVAL == 0 then
						data[vi] = minetest.get_content_id("dod:base")
					end
					-- Space below each floor
					if
						x % STAIRCASE_INTERVAL == 0 or
						z % STAIRCASE_INTERVAL == 0
					then
						if (y - (TOPMOST_FLOOR_Y-2)) % FLOOR_INTERVAL == 0 then
							data[vi] = minetest.get_content_id("air")
						end
						if (y - (TOPMOST_FLOOR_Y-3)) % FLOOR_INTERVAL == 0 then
							data[vi] = minetest.get_content_id("air")
						end
					end
				end

				vi = vi + 1
				viu = viu + 1
			end
		end
	end

	-- voxelmanip stuff
	vm:set_data(data)
	vm:set_lighting({day=0, night=0})
	vm:calc_lighting()
	vm:write_to_map(data)
	
	local chugent = math.ceil((os.clock() - t1) * 1000) -- chunk generation time
	print ("[dod] "..chugent.." ms")
end)
