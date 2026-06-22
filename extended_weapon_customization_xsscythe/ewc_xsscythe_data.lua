-- ewc_xsscythe_data.lua

local mod = get_mod("extended_weapon_customization_xsscythe")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "group_randomization",
				type = "group",
				sub_widgets = {
					{
						setting_id = "mod_option_scythe_blades_randomization",
						type = "checkbox",
						default_value = true,
					},
				},
			},
		},
	},
}
