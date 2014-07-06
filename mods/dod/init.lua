-- Minetest 0.4 mod: dod

dod = {}

dod.TOPMOST_FLOOR_Y = -15
dod.FLOOR_INTERVAL = 20

dofile(minetest.get_modpath("dod").."/nodes.lua")
dofile(minetest.get_modpath("dod").."/mapgen.lua")
dofile(minetest.get_modpath("dod").."/player.lua")

