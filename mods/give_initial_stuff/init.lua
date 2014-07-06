minetest.register_on_newplayer(function(player)
	minetest.log("action", player:get_player_name() .. " joined for the first time.")
	minetest.log("action", "Giving initial stuff to player " .. player:get_player_name() .. ".")
	player:get_inventory():add_item("main", "default:pick_wood")
	player:get_inventory():add_item("main", "default:torch 1")
	player:get_inventory():add_item("main", "dod:key1_1 99")
	player:get_inventory():add_item("main", "default:apple 10")
end)

