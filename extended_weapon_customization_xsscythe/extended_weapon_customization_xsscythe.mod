return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`extended_weapon_customization_xsscythe` encountered an error loading the Darktide Mod Framework.")
		new_mod("extended_weapon_customization_xsscythe", {
			mod_script		 = "extended_weapon_customization_xsscythe/ewc_xsscythe",
			mod_data		 = "extended_weapon_customization_xsscythe/ewc_xsscythe_data",
			mod_localization = "extended_weapon_customization_xsscythe/ewc_xsscythe_localization",
		})
	end,
	require = {
		"extended_weapon_customization",
		"master_item_community_patch",
	},
	load_after = {
		"extended_weapon_customization",
		"extended_weapon_customization_base_additions",
		"extended_weapon_customization_owo",
	},
	packages = {},
}
