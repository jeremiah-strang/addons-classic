local BCT = LibStub("AceAddon-3.0"):GetAddon("BCT")
local SM = LibStub:GetLibrary("LibSharedMedia-3.0")
local fonts = SM:List("font")

local buffTypeArr = {
	[BCT.CONSUMABLE] = "auras_visible",
	[BCT.WORLDBUFF] = "auras_visible",
	[BCT.PLAYERBUFF] = "auras_visible",
	[BCT.ENCHANT] = "auras_enchants",
	[BCT.GOODDEBUFF] = "auras_debuffs",
	[BCT.SPECIAL] = "auras_hidden",
	[BCT.HOLIDAY] = "auras_visible",
}

local function GetSpacer(n)
	return {
		order = n,
		type = "description",
		name = "",
	}
end
	
local GetAuraSelect = {
	type = "select",
	order = 2,
	name = "Name",
	desc = "...",
	width = "double",
	values = function()
		local filters = {}
		local arr = BCT.session.db.auras[buffTypeArr[BCT.session.state.aurasTypeSelected]]
		
		for k, v in pairs(arr) do
			if v[6] == BCT.session.state.aurasTypeSelected then
				if BCT.session.state.aurasTypeSelected == BCT.SPECIAL or 
				BCT.session.state.aurasTypeSelected == BCT.PLAYERBUFF then
					filters[k] = arr[k][1]
				else
					filters[k] = arr[k][1] .. " (" .. k .. ")"
				end
			end
		end
		
		return filters
	end, 
	get = function()
		if BCT.session.state.aurasSelected[BCT.session.state.aurasTypeSelected] == nil then
			for k, v in pairs(BCT.session.db.auras[buffTypeArr[BCT.session.state.aurasTypeSelected]]) do
				if v[6] == BCT.session.state.aurasTypeSelected then
					BCT.session.state.aurasSelected[BCT.session.state.aurasTypeSelected] = k
					return k
				end
			end
		end
		return BCT.session.state.aurasSelected[BCT.session.state.aurasTypeSelected]
	end, 
	set = function(_, value)
		BCT.session.state.aurasSelected[BCT.session.state.aurasTypeSelected] = value
	end,
}

local GetAuraAdd = {
	order = 3, 
	name = "Add ID",
	desc = "...",
	type = 'input',
	get = function(info) return "" end,
	set = function(info, value)
		local arr = BCT.session.db.auras[buffTypeArr[BCT.session.state.aurasTypeSelected]]
		if BCT.session.state.aurasTypeSelected == BCT.ENCHANT then
			arr[tonumber(value)] = {"", "", BCT.HIDE, BCT.COUNT, BCT.WHITELISTED, BCT.ENCHANT, BCT.BUFF}
		else
			if GetSpellInfo(tonumber(value)) then
				local found = BCT.GetAura(GetSpellInfo(tonumber(value)))
					if found then
					print("BCT: Aura already exists.")
				else
					arr[tonumber(value)] = {GetSpellInfo(tonumber(value)), GetSpellInfo(tonumber(value)), BCT.HIDE, BCT.COUNT, BCT.WHITELISTED, BCT.session.state.aurasTypeSelected, BCT.BUFF}
				end
			end
		end
	end,
}

local GetListName = {
	order = 4,
	type = "input",
	name = "List Name",
	desc = "...",
	get = function(info) return BCT.session.db.auras[buffTypeArr[BCT.session.state.aurasTypeSelected]][BCT.session.state.aurasSelected[BCT.session.state.aurasTypeSelected]][1] end,
	set = function(info, value) 
		local arr = BCT.session.db.auras[buffTypeArr[BCT.session.state.aurasTypeSelected]]
		arr[BCT.session.state.aurasSelected[BCT.session.state.aurasTypeSelected]][1] = value
	end,
}

local GetDisplayName = {
	order = 5,
	type = "input",
	name = "Display Name",
	desc = "...",
	get = function(info) 
		local key = buffTypeArr[BCT.session.state.aurasTypeSelected]
		local id = BCT.session.state.aurasSelected[BCT.session.state.aurasTypeSelected]
		return BCT.session.db.auras[key][id][2] 
	end,
	set = function(info, value) 
		local arr = BCT.session.db.auras[buffTypeArr[BCT.session.state.aurasTypeSelected]]
		arr[BCT.session.state.aurasSelected[BCT.session.state.aurasTypeSelected]][2] = value
	end,
}

local GetTracked = {
	order = 6,
	type = "toggle",
	name = "Track",
	desc = "...",
	width = "normal",
	get = function(info) return BCT.session.db.auras[buffTypeArr[BCT.session.state.aurasTypeSelected]][BCT.session.state.aurasSelected[BCT.session.state.aurasTypeSelected]][3] end,
	set = function(info, value) 
		local arr = BCT.session.db.auras[buffTypeArr[BCT.session.state.aurasTypeSelected]]
		arr[BCT.session.state.aurasSelected[BCT.session.state.aurasTypeSelected]][3] = value
	end,
}

local GetBlacklisted = {
	order = 7,
	type = "toggle",
	name = "Blacklist",
	desc = "...",
	width = "full",
	get = function(info) return BCT.session.db.auras[buffTypeArr[BCT.session.state.aurasTypeSelected]][BCT.session.state.aurasSelected[BCT.session.state.aurasTypeSelected]][5] end,
	set = function(info, value) 
		local arr = BCT.session.db.auras[buffTypeArr[BCT.session.state.aurasTypeSelected]]
		arr[BCT.session.state.aurasSelected[BCT.session.state.aurasTypeSelected]][5] = value
		BCT.SetInCombatBlacklistingMacro()
	end,
}

local GetRemoveSpell = {
	order = 8,
	name = "Remove",
	desc = "...",
	type = 'execute',
	func = function()
		local arr = BCT.session.db.auras[buffTypeArr[BCT.session.state.aurasTypeSelected]]
		arr[BCT.session.state.aurasSelected[BCT.session.state.aurasTypeSelected]] = nil
		for k, v in pairs(arr) do
			if v[6] == BCT.session.state.aurasTypeSelected then
				BCT.session.state.aurasSelected[BCT.session.state.aurasTypeSelected] = k
			end
		end
	end,
}

local GetCounts = {
	order = 7,
	type = "toggle",
	name = "Count towards cap",
	desc = "...",
	width = "full",
	get = function(info) return BCT.session.db.auras[buffTypeArr[BCT.session.state.aurasTypeSelected]][BCT.session.state.aurasSelected[BCT.session.state.aurasTypeSelected]][4] end,
	set = function(info, value)
		local arr = BCT.session.db.auras[buffTypeArr[BCT.session.state.aurasTypeSelected]]
		arr[BCT.session.state.aurasSelected[BCT.session.state.aurasTypeSelected]][4] = value
		BCT.Refresh()
	end,
}

local consGroupArgs = {
	auraSelect = GetAuraSelect,
	auraAdd = GetAuraAdd,
	listName = GetListName,
	displayName = GetDisplayName,
	tracked = GetTracked,
	removeSpell = GetRemoveSpell,
}

local buffGroupArgs = {
	auraSelect = GetAuraSelect,
	auraAdd = GetAuraAdd,
	displayName = GetDisplayName,
	tracked = GetTracked,
	blacklisted = GetBlacklisted,
	removeSpell = GetRemoveSpell,
}

local holidayGroupArgs = {
	auraSelect = GetAuraSelect,
	auraAdd = GetAuraAdd,
	displayName = GetDisplayName,
	tracked = GetTracked,
	space = GetSpacer(7),
	removeSpell = GetRemoveSpell,
}

local debuffGroupArgs = {
	auraSelect = GetAuraSelect,
	auraAdd = GetAuraAdd,
	displayName = GetDisplayName,
	tracked = GetTracked,
	space = GetSpacer(7),
	removeSpell = GetRemoveSpell,
}

local enchantGroupArgs = {
	auraSelect = GetAuraSelect,
	auraAdd = GetAuraAdd,
	listName = GetListName,
	counts = GetCounts,
	removeSpell = GetRemoveSpell,
}

local hiddenGroupArgs = {
	auraSelect = GetAuraSelect,
	counts = GetCounts,
}

local groups = {
	[BCT.CONSUMABLE] = consGroupArgs,
	[BCT.WORLDBUFF] = buffGroupArgs,
	[BCT.PLAYERBUFF] = buffGroupArgs,
	[BCT.GOODDEBUFF] = debuffGroupArgs,
	[BCT.ENCHANT] = enchantGroupArgs,
	[BCT.SPECIAL] = hiddenGroupArgs,
	[BCT.HOLIDAY] = holidayGroupArgs,
}

local function GetOptionsTable()
	local optionsTbl = {
		type = "group",
		name = "BCT",
		args = {
			General = {
				name = "General",
				desc = "General Settings",
				type = "group",
				order = 1,
				args = {
					intro = {
						name = "BCT",
						type = "description",
						order = 1,
					},	
				}, 	
			},
			Setup = {
				order = 2,
				type = "group",
				name = "General",
				desc = "",
				childGroups = "tab",
				get = function(info) end,
				set = function(info, value) end,
				args = {
					lock = {
						order = 2,
						type = "execute",
						name = function()
							if BCT.session.db.window.lock then
								return "Toggle Anchor"
							else
								return "Hide Anchor"
							end
						end,
						desc = "...",
						width = "normal",
						func = function()
							BCT.session.db.window.lock = not BCT.session.db.window.lock
						end,
					},
					reset = {
						name = "Reposition Window",
						desc = "Resets Window Position",
						type = 'execute',
						order = 1,					
						width = "normal",					
						func = function()
							BCT.Anchor:SetUserPlaced(false)
							BCT.Anchor:SetPoint("CENTER", WorldFrame, "CENTER", 0,0)
							C_UI.Reload()
						end,
						confirmText = "Resets Window Position (Reloads UI)",
						confirm = true
					},
					enable = {
						name = function()
							if BCT.session.db.window.enable then
								return "Disable"
							else
								return "Enable"
							end
						end,
						desc = "",
						type = 'execute',
						order = 3,	
						width = "normal",					
						func = function()
							BCT.session.db.window.enable = not BCT.session.db.window.enable
						end,
					},
					txt = {
						order = 4,
						type = "group",
						name = "General",
						args = {
							titleGroup = {
								name = "Title",
								desc = "",
								type = 'group',
								order = 1,					
								guiInline = true,
								args = {
									Text = {
										name = "Text",
										type = "input",
										order = 3,
										desc = "...",
										width = "normal",	
										get = function(info) return BCT.session.db.window.anchor.value end,
										set = function(info, value) 
											BCT.session.db.window.anchor.value = value
										end,
									},	
									counter = {
										type = "select",
										order = 4,
										name = "Counter",
										desc = "...",
										
										values = {
											["None"] = "None",
											["3/32"] = "3/32",
											["3"] = "3",
										},	
										get = function(_, value) return BCT.session.db.window.anchor.counter end, 
										set = function(_, value) 
											BCT.session.db.window.anchor.counter = value
										end,
									},
									--header = {
									--	name = "",
									--	type = "header",
									--	order = 13,
									--},	
									fontSize = {
										order = 1,
										name = "Font Size",
										desc = "",
										type = "range",
										min = 4, max = 32, step = 1,
										get = function(info) return tonumber(BCT.session.db.window.anchor.font_size) end,
										set = function(info, value) 
											local inp = tonumber(value)
											if 'number' == type(inp) and inp > 0 then
												BCT.session.db.window.anchor.font_size = inp
												BCT.UpdateFont()
											else
												print("BCT: You must input a positive number higher than 0")
											end
										end,
									},
									font = {
										type = "select",
										order = 2,
										name = "Font",
										desc = "...",
										values = fonts,
										get = function()
											for info, value in next, fonts do
												if value == BCT.session.db.window.anchor.font then
													return info
												end
											end
										end, 
										set = function(_, value)
											BCT.session.db.window.anchor.font = fonts[value]
											BCT.UpdateFont()
										end,
									},
									fontStyle = {
										type = "select",
										order = 3,
										name = "Font Outline",
										values = {
											["None"] = "None",
											["MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
											["OUTLINE"] = "OUTLINE",
											["THICKOUTLINE"] = "THICKOUTLINE",
										},
										get = function() return BCT.session.db.window.anchor.font_style end,
										set = function(info, value) 
											BCT.session.db.window.anchor.font_style = value
											BCT.UpdateFont()
										end,
									},
								},
							},
							bodyGroup = {
								name = "Body",
								desc = "",
								type = 'group',
								order = 2,					
								guiInline = true,
								args = {
									fontSize = {
										order = 1,
										name = "Font Size",
										desc = "",
										type = "range",
										min = 4, max = 32, step = 1,
										get = function(info) return tonumber(BCT.session.db.window.body.font_size) end,
										set = function(info, value) 
											local inp = tonumber(value)
											if 'number' == type(inp) and inp > 0 then
												BCT.session.db.window.body.font_size = inp
												BCT.UpdateFont()
											else
												print("BCT: You must input a positive number higher than 0")
											end
										end,
									},
									font = {
										type = "select",
										order = 2,
										name = "Font",
										desc = "...",
										values = fonts,
										get = function()
											for info, value in next, fonts do
												if value == BCT.session.db.window.body.font then
													return info
												end
											end
										end, 
										set = function(_, value)
											BCT.session.db.window.body.font = fonts[value]
											BCT.UpdateFont()
										end,
									},
									fontStyle = {
										type = "select",
										order = 3,
										name = "Font Outline",
										values = {
											["None"] = "None",
											["MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
											["OUTLINE"] = "OUTLINE",
											["THICKOUTLINE"] = "THICKOUTLINE",
										},
										get = function() return BCT.session.db.window.body.font_style end,
										set = function(info, value) 
											BCT.session.db.window.body.font_style = value
											BCT.UpdateFont()
										end,
									},
									mouseover = {
										name = "Mouse Over",
										desc = "",
										type = 'toggle',
										order = 4,					
										width = "normal",			
										get = function(info) return BCT.session.db.window.body.mouseover end,
										set = function(info, value) 
											BCT.session.db.window.body.mouseover = not BCT.session.db.window.body.mouseover
										end,
									},
									growup = {
										name = "Grow Up",
										desc = "",
										type = 'toggle',
										order = 5,					
										width = "normal",			
										get = function(info) return BCT.session.db.window.body.growup end,
										set = function(info, value) 
											BCT.session.db.window.body.growup = not BCT.session.db.window.body.growup
										end,
									},
									grouplines = {
										name = "Group Tracking",
										desc = "",
										type = 'toggle',
										order = 6,					
										width = "normal",			
										get = function(info) return BCT.session.db.window.body.group_lines end,
										set = function(info, value) 
											BCT.session.db.window.body.group_lines = not BCT.session.db.window.body.group_lines
										end,
									},
									xoff = {
										order = 7,
										name = "X Offset",
										desc = "",
										type = "range",
										min = -2140, max = 2140, step = 1,
										get = function(info) return BCT.session.db.window.body.x_offset end,
										set = function(info, value) 
											BCT.session.db.window.body.x_offset = tonumber(value)
										end,
									},
									yoff = {
										order = 8,
										name = "Y Offset",
										desc = "",
										type = "range",
										min = -2140, max = 2140, step = 1,
										get = function(info) return BCT.session.db.window.body.y_offset end,
										set = function(info, value) 
											BCT.session.db.window.body.y_offset = tonumber(value)
										end,
									},
								},
							},
							text = {
								name = "Text",
								desc = "",
								type = 'multiselect',
								order = 3,
								values = {
									["enchants"] = "Enchants",
									["buffs"] = "Buffs",
									["nextone"] = "Next",
									["tracking"] = "Tracking",
									--["nextfive"] = "Next Five",
									["profile"] = "Profile",
								},	
								get = function(_, value) return BCT.session.db.window.text[value] end, 
								set = function(_, value, state) 
									BCT.session.db.window.text[value] = state
								end,
							},
						},
					},
					announce = {
						order = 5,
						type = "group",
						name = "Announcements",
						args = {
							announceBl = {
								name = "Blacklisted",
								desc = "",
								type = 'toggle',
								order = 1,					
								width = "normal",			
								get = function(info) return BCT.session.db.announcer.enabledBl end,
								set = function(info, value) 
									BCT.session.db.announcer.enabledBl = not BCT.session.db.announcer.enabledBl
								end,
							},
							announceTrck = {
								name = "Tracked",
								desc = "",
								type = 'toggle',
								order = 2,					
								width = "double",			
								get = function(info) return BCT.session.db.announcer.enabledTrck end,
								set = function(info, value) 
									BCT.session.db.announcer.enabledTrck = not BCT.session.db.announcer.enabledTrck
								end,
							},
							fontSize = {
								order = 3,
								name = "Font Size",
								desc = "",
								type = "range",
								min = 4, max = 60, step = 1,
								get = function(info) return tonumber(BCT.session.db.announcer.font_size) end,
								set = function(info, value) 
									local inp = tonumber(value)
									if 'number' == type(inp) and inp > 0 then
										BCT.session.db.announcer.font_size = inp
										BCT.UpdateFontAnnouncer()
									else
										print("BCT: You must input a positive number higher than 0")
									end
								end,
							},
							font = {
								type = "select",
								order = 4,
								name = "Font",
								desc = "...",
								values = fonts,
								get = function()
									for info, value in next, fonts do
										if value == BCT.session.db.announcer.font then
											return info
										end
									end
								end, 
								set = function(_, value)
									BCT.session.db.announcer.font = fonts[value]
									BCT.UpdateFontAnnouncer()
								end,
							},
							fontStyle = {
								type = "select",
								order = 8,
								name = "Font Outline",
								values = {
									["None"] = "None",
									["MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
									["OUTLINE"] = "OUTLINE",
									["THICKOUTLINE"] = "THICKOUTLINE",
								},
								get = function() return BCT.session.db.announcer.font_style end,
								set = function(info, value) 
									BCT.session.db.announcer.font_style = value
									BCT.UpdateFontAnnouncer()
								end,
							},
						},
					},
					loading = {
						order = 6,
						type = "group",
						name = "Loading",
						args = {
							State = {
								name = "Group Type",
								desc = "Group Type",
								type = 'multiselect',
								order = 18,					
								values = {
									["Solo"] = "Solo",
									["Group"] = "Group",
									["Raid"] = "Raid",
									["Battleground"] = "Battleground",
								},	
								get = function(_, value) return BCT.session.db.loading.groupState[value] end, 
								set = function(_, value, state) 
									BCT.session.db.loading.groupState[value] = state
								end,
							},
							instanceState = {
								name = "Instance Type",
								desc = "Instance Type",
								type = 'multiselect',
								order = 19,	
								values = {
									[0] = "Outside",
									[5] = "5 Man Instance",
									[10] = "10 Man Instance",
									[20] = "20 Man Instance",
									[40] = "40 Man Instance",
								},	
								get = function(_, value) return BCT.session.db.loading.instanceState[value] end, 
								set = function(_, value, state) 
									BCT.session.db.loading.instanceState[value] = state
								end,
							},
						},
					},
				},
			},
			Blacklisting = {
				order = 2,
				type = "group",
				name = "Blacklisting",
				desc = "Blacklisting",
				args = {
					outofcombat = {
						name = "Passive",
						type = "header",
						order = 0,
					},	
					--introo = {
					--	name = "Out-of-combat auto-removal will automatically remove any blacklisted buffs if enabled, and if the buffer is breached." ..
					--		"\n\nSet the buffer to 32 if you want to disallow blacklisted buffs permanently out-of-combat.",
					--	type = "description",
					--	order = 1,
					--},	
					introo = {
						name = "WHEN: The passive auto-removal works out-of-combat ONLY.\n\nHOW: When the amount of buffs plus the buffer exceeds 32, one buff at a time will be removed until the buffer is no longer breached. \n\nSet the buffer to 32 if you want to disallow blacklisted buffs permanently out-of-combat.",
						type = "description",
						order = 1,
					},	
					buffer = {
						name = "Buffer",
						type = "input",
						order = 2,
						desc = "...",
						width = .6,	
						get = function(info) return tostring(BCT.session.db.blacklisting.buffer) end,
						set = function(info, value) 
							local inp = tonumber(value)
							if 'number' == type(inp) and inp > 0 then
								BCT.session.db.blacklisting.buffer = inp
							else
								print("BCT: You must input a positive number higher than 0")
							end
						end,
					},	
					enableOut = {
						order = 3,
						type = "toggle",
						name = "Enable",
						desc = "...",
						width = "double",
						get = function(info) return BCT.session.db.blacklisting.enabledOut end,
						set = function(info, value) 
							BCT.session.db.blacklisting.enabledOut = not BCT.session.db.blacklisting.enabledOut
							BCT.SetInCombatBlacklistingMacro()
						end,
					},
					incombat = {
						name = "Active",
						type = "header",
						order = 7,
					},	
					--intro = {
					--	name = "Because of protected API in-combat auto-removal ONLY works through macro usage." ..
					--		"\n\nPlease be aware that it is not possible to consecutively remove unwanted buffs in-combat, instead the macro will attempt to remove ALL blacklisted buffs when clicked." ..
					--		"\n\nTo use in-combat auto-removal add the following line to one or more spell macros that you spam in combat:",
					--	type = "description",
					--	order = 8,
					--},	
					intro = {
						name = "WHEN: The active auto-removal works both in- and out-of-combat.\n\nHOW: Before combat is entered a hidden button is created with a list on cancelaura lines. A macro which simulates a click on this button is then placed in an often used keybinding. \n\nTo use in-combat auto-removal add the following line to one or more spell macros that you spam in combat:",
						type = "description",
						order = 8,
					},	
					macro = {
						name = "Macro",
						type = "input",
						order = 9,
						desc = "...",
						width = .6,	
						get = function(info) return "/click BCT" end,
						set = function(info, value) end,
					},	
					enableIn = {
						order = 10,
						type = "toggle",
						name = "Enable",
						desc = "...",
						width = "normal",
						get = function(info) return BCT.session.db.blacklisting.enabledIn end,
						set = function(info, value) 
							BCT.session.db.blacklisting.enabledIn = not BCT.session.db.blacklisting.enabledIn
							BCT.SetInCombatBlacklistingMacro()
						end,
					},
				},
			},
			Auras = {
				order = 4,
				type = "group",
				name = "Auras",
				desc = "Auras",
				args = {
					intro = {
						name = "All visible auras are automatically counted and does not have to be added. Only bother adding an aura if you want to blacklist or track it." ..
						"\n\nEnchants are only counted if added and toggled." ..
						"\n\nDebuffs are never counted but can be added for tracking.",
						type = "description",
						order = 0,
					},	
					auraType = {
						type = "select",
						order = 1,
						name = "Type",
						desc = "...",
						values = function()
							return BCT.AURAS
						end,
						get = function()
							return BCT.session.state.aurasTypeSelected
						end, 
						set = function(key, value)
							BCT.session.state.aurasTypeSelected = value
						end,
					},
					auraGroup = {
						order = 2,
						type = "group",
						name = " ",
						guiInline = true,
						args = groups[BCT.session.state.aurasTypeSelected]
					},	
				},
			},
			Profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(BCT.db)
		},
	}

	return optionsTbl
end

LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("BCT", GetOptionsTable)
BCT.optionsFrames.BCT = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BCT", "BCT", nil, "General")
BCT.optionsFrames.Setup = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BCT", "Setup", "BCT", "Setup")
BCT.optionsFrames.Blacklisting = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BCT", "Blacklisting", "BCT", "Blacklisting")
BCT.optionsFrames.Auras = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BCT", "Auras", "BCT", "Auras")
BCT.optionsFrames.Profiles = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BCT", "Profiles", "BCT", "Profiles")