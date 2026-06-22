-- ewc_xsscythe.lua

local mod = get_mod("extended_weapon_customization_xsscythe")

local _item = "content/items/weapons/player"
local _item_melee = _item .. "/melee"

local plugin = {
	attachments = {},
	attachment_slots = {},
	fixes = {},
	kitbashs = {},
}

local force_staff_target = "forcestaff_p1_m1"

-- ----------------------------------------------------------------------
-- Icon display settings
-- ----------------------------------------------------------------------
local default_rot = {90, 30, 0}
local default_pos = {-.075, -2.25, 0.4}

-- ----------------------------------------------------------------------
-- Basic parameters for each blade group (for body01)
-- ----------------------------------------------------------------------
local blade_groups = {
	knife = {
		ids = {},
		fix = {
			position = Vector3Box(
				0,		-- left-right
				0.025,	-- back-forward
				0.29	-- height
			),
			rotation = Vector3Box(90, 0, 180),
			scale = Vector3Box(
				1.0,	-- blade thickness
				2.3,	-- blade width
				2.7		-- blade length
			),
		},
	},
	sword = {
		ids = {},
		fix = {
			position = Vector3Box(
				0,		-- left-right
				0.025,	-- back-forward
				0.28	-- height
			),
			rotation = Vector3Box(90, 0, 0),
			scale = Vector3Box(
				0.7,	-- blade thickness
				1.0,	-- blade width
				1.0		-- blade length
			),
		},
	},
	falchion = {
		ids = {},
		fix = {
			position = Vector3Box(
				0,		-- left-right
				0.025,	-- back-forward
				0.28	-- height
			),
			rotation = Vector3Box(90, 0, 0),
			scale = Vector3Box(
				0.7,	-- blade thickness
				1.2,	-- blade width
				1.1		-- blade length
			),
		},
	},
	sabre = {
		ids = {},
		fix = {
			position = Vector3Box(
				0,		-- left-right
				0.025,	-- back-forward
				0.285	-- height
			),
			rotation = Vector3Box(90, 0, 0),
			scale = Vector3Box(
				1.3,	-- blade thickness
				2.1,	-- blade width
				1.1		-- blade length
			),
		},
	},
}

-- ----------------------------------------------------------------------
-- Height adjustments (position.z) for each body
-- ----------------------------------------------------------------------
local body_height_adjustments = {
	knife = {
		["force_staff_full_01"] = 0.29,
		["force_staff_full_02"] = 0.24,
		["force_staff_full_03"] = 0.215,
		["force_staff_full_04"] = 0.26,
		["force_staff_full_05"] = 0.25,
		["force_staff_full_06"] = 0.18,
		["force_staff_full_07"] = 0.24,
		["force_staff_full_ml01"] = 0.24,
	},
	sword = {
		["force_staff_full_01"] = 0.28,
		["force_staff_full_02"] = 0.23,
		["force_staff_full_03"] = 0.205,
		["force_staff_full_04"] = 0.25,
		["force_staff_full_05"] = 0.24,
		["force_staff_full_06"] = 0.17,
		["force_staff_full_07"] = 0.23,
		["force_staff_full_ml01"] = 0.23,
	},
	falchion = {
		["force_staff_full_01"] = 0.28,
		["force_staff_full_02"] = 0.23,
		["force_staff_full_03"] = 0.205,
		["force_staff_full_04"] = 0.25,
		["force_staff_full_05"] = 0.24,
		["force_staff_full_06"] = 0.17,
		["force_staff_full_07"] = 0.23,
		["force_staff_full_ml01"] = 0.23,
	},
	sabre = {
		["force_staff_full_01"] = 0.285,
		["force_staff_full_02"] = 0.235,
		["force_staff_full_03"] = 0.21,
		["force_staff_full_04"] = 0.255,
		["force_staff_full_05"] = 0.245,
		["force_staff_full_06"] = 0.175,
		["force_staff_full_07"] = 0.235,
		["force_staff_full_ml01"] = 0.235,
	},
}

-- ----------------------------------------------------------------------
-- Adding blades to the head slot
-- ----------------------------------------------------------------------
local function add_blade(attachment_id, group_key)
	local replacement_path = _item_melee .. "/blades/" .. attachment_id
	plugin.attachments[force_staff_target].head[attachment_id] = {
		replacement_path = replacement_path,
		icon_render_unit_rotation_offset = default_rot,
		icon_render_camera_position_offset = default_pos,
		custom_selection_group = "xs_" .. group_key .. "_blades",
		randomization_requirement = "mod_option_scythe_blades_randomization",
	}
	table.insert(blade_groups[group_key].ids, attachment_id)
end

plugin.attachments[force_staff_target] = { head = {} }

-- ---- Combat Knife (9 + ml01) ----
for i = 1, 9 do
	add_blade("combat_knife_blade_" .. string.format("%02d", i), "knife")
end
add_blade("combat_knife_blade_ml01", "knife")

-- ---- Combat Sword (01-07 + ml01) ----
for i = 1, 7 do
	add_blade("combat_sword_blade_" .. string.format("%02d", i), "sword")
end
add_blade("combat_sword_blade_ml01", "sword")

-- ---- Falchion (01-06 + ml01) ----
for i = 1, 6 do
	add_blade("falchion_blade_" .. string.format("%02d", i), "falchion")
end
add_blade("falchion_blade_ml01", "falchion")

-- ---- Sabre (01-07 + ml01) ----
for i = 1, 7 do
	add_blade("sabre_blade_" .. string.format("%02d", i), "sabre")
end
add_blade("sabre_blade_ml01", "sabre")

-- ----------------------------------------------------------------------
-- List of all possible staff bodies
-- ----------------------------------------------------------------------
local all_bodies = {
	"force_staff_full_01",
	"force_staff_full_02",
	"force_staff_full_03",
	"force_staff_full_04",
	"force_staff_full_05",
	"force_staff_full_06",
	"force_staff_full_07",
	"force_staff_full_ml01",
}

-- ----------------------------------------------------------------------
-- Generating fixes for each group and each body
-- ----------------------------------------------------------------------
plugin.fixes[force_staff_target] = {}

for group_key, group_data in pairs(blade_groups) do
	if #group_data.ids > 0 then
		local pattern = table.concat(group_data.ids, "|")
		-- create  fix for each body
		for _, body_name in ipairs(all_bodies) do
			-- copy the basic parameters of the group
			local fix_offset = {
				position = group_data.fix.position,
				rotation = group_data.fix.rotation,
				scale = group_data.fix.scale,
				node = 1,
			}
			-- if there is a height adjustment for this group and this body, we apply it
			local adjustments = body_height_adjustments[group_key]
			if adjustments and adjustments[body_name] then
				-- create a new Vector3Box with a modified height (z)
				local orig_pos = group_data.fix.position
				fix_offset.position = Vector3Box(orig_pos[1], orig_pos[2], adjustments[body_name])
			end

			local fix_entry = {
				attachment_slot = "head",
				requirements = {
					head = { has = pattern },
					body = { has = body_name },
				},
				fix = { offset = fix_offset },
			}
			table.insert(plugin.fixes[force_staff_target], fix_entry)
		end
	end
end

-- ----------------------------------------------------------------------
-- Copying to other marks of staffs (p2, p3, p4)
-- ----------------------------------------------------------------------
local other_marks = {"forcestaff_p2_m1", "forcestaff_p3_m1", "forcestaff_p4_m1"}
for _, mark in ipairs(other_marks) do
	plugin.attachments[mark] = plugin.attachments[force_staff_target]
	plugin.fixes[mark] = plugin.fixes[force_staff_target]
end

-- ----------------------------------------------------------------------
-- Localization
-- ----------------------------------------------------------------------
mod:add_global_localize_strings({
	loc_ewc_xs_knife_blades = {
		en = "xss - Knife Blades",
		ru = "xss - Клинки ножей",
		fr = "xss - Lames de couteau",
		["zh-tw"] = "xss - 刀片",
		["zh-cn"] = "xss - 刀片",
		de = "xss - Messerklingen",
		it = "xss - Lame da coltello",
		ja = "xss - ナイフの刃",
		ko = "xss - 나이프 칼날",
		pl = "xss - Ostrza noży",
		["pt-br"] = "xss - Lâminas de faca",
		es = "xss - Hojas de cuchillo",
	},
	loc_ewc_xs_sword_blades = {
		en = "xss - Sword Blades",
		ru = "xss - Клинки мечей",
		fr = "xss - Lames d'épée",
		["zh-tw"] = "xss - 劍刃",
		["zh-cn"] = "xss - 剑刃",
		de = "xss - Schwertklingen",
		it = "xss - Lame di spada",
		ja = "xss - 剣の刃",
		ko = "xss - 검 칼날",
		pl = "xss - Ostrza mieczy",
		["pt-br"] = "xss - Lâminas de espada",
		es = "xss - Hojas de espada",
	},
	loc_ewc_xs_falchion_blades = {
		en = "xss - Falchion Blades",
		ru = "xss - Клинки фальчионов",
		fr = "xss - Lames de braquemard",
		["zh-tw"] = "xss - 彎刀刀刃",
		["zh-cn"] = "xss - 弯刀刀刃",
		de = "xss - Falchionklingen",
		it = "xss - Lame di falcione",
		ja = "xss - ファルシオンの刃",
		ko = "xss - 팔시온 칼날",
		pl = "xss - Ostrza falchionów",
		["pt-br"] = "xss - Lâminas de falcão",
		es = "xss - Hojas de falchion",
	},
	loc_ewc_xs_sabre_blades = {
		en = "xss - Sabre Blades",
		ru = "xss - Клинки сабель",
		fr = "xss - Lames de sabre",
		["zh-tw"] = "xss - 軍刀刀刃",
		["zh-cn"] = "xss - 军刀刀刃",
		de = "xss - Säbelklingen",
		it = "xss - Lame di sciabola",
		ja = "xss - サーベルの刃",
		ko = "xss - 사브르 칼날",
		pl = "xss - Ostrza szabel",
		["pt-br"] = "xss - Lâminas de sabre",
		es = "xss - Hojas de sable",
	},
})

local blade_names = {
	"combat_knife_blade_01", "combat_knife_blade_02", "combat_knife_blade_03",
	"combat_knife_blade_04", "combat_knife_blade_05", "combat_knife_blade_06",
	"combat_knife_blade_07", "combat_knife_blade_08", "combat_knife_blade_09",
	"combat_knife_blade_ml01",
	"combat_sword_blade_01", "combat_sword_blade_02", "combat_sword_blade_03",
	"combat_sword_blade_04", "combat_sword_blade_05", "combat_sword_blade_06",
	"combat_sword_blade_07", "combat_sword_blade_ml01",
	"falchion_blade_01", "falchion_blade_02", "falchion_blade_03",
	"falchion_blade_04", "falchion_blade_05", "falchion_blade_06",
	"falchion_blade_ml01",
	"sabre_blade_01", "sabre_blade_02", "sabre_blade_03",
	"sabre_blade_04", "sabre_blade_05", "sabre_blade_06",
	"sabre_blade_07", "sabre_blade_ml01",
}

for _, name in ipairs(blade_names) do
	local pretty = name
		:gsub("_", " ")
		:gsub("combat knife", "Combat Knife")
		:gsub("combat sword", "Combat Sword")
		:gsub("falchion", "Falchion")
		:gsub("sabre", "Sabre")
		:gsub("ml01", "Mastery")
	mod:add_global_localize_strings({
		["loc_" .. name] = { en = pretty }
	})
end

-- ----------------------------------------------------------------------
-- Registering a plugin in EWC
-- ----------------------------------------------------------------------
mod.extended_weapon_customization_plugin = plugin
