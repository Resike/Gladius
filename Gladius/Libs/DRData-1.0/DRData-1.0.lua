local major = "DRData-1.0"
local minor = 1030
assert(LibStub, string.format("%s requires LibStub.", major))

local Data = LibStub:NewLibrary(major, minor)

if not Data then
	return
end

local L = {
	["Roots"] = "Roots",
	["Stuns"] = "Stuns",
	["Cyclone"] = "Cyclone",
	["Disarms"] = "Disarms",
	["Mesmerizes"] = "Mesmerizes",
	["Mesmerizes (short)"] = "Mesmerizes (short)",
	["Fears"] = "Fears",
	["Horrors"] = "Horrors",
	["Mind Control"] = "Mind Control",
	["Stuns (short)"] = "Stuns (short)",
	["Silences"] = "Silences",
	["Taunts"] = "Taunts",
	["Roots (short)"] = "Roots (short)",
	["Knockbacks"] = "Knockbacks",
}

local locale = GetLocale()

if locale == "deDE" then
	
elseif locale == "esES" then
	L["Cyclone"] = "Ciclón"
	L["Disarms"] = "Desarmes"
	L["Fears"] = "Miedos"
	L["Horrors"] = "Horrores"
	L["Knockbacks"] = "Derribos"
	L["Mesmerizes"] = "Hipnotizaciones"
	L["Mesmerizes (short)"] = "Hipnotizaciones (cortas)"
	L["Mind Control"] = "Control Mental"
	L["Roots"] = "Raíces"
	L["Roots (short)"] = "Raíces (cortas)"
	L["Silences"] = "SIlencios"
	L["Stuns"] = "Aturdimientos"
	L["Stuns (short)"] = "Aturdimientos (cortos)"
	L["Taunts"] = "Provocaciones"
elseif locale == "esMX" then
	L["Cyclone"] = "Ciclón"
	L["Disarms"] = "Desarmes"
	L["Fears"] = "Miedos"
	L["Horrors"] = "Horrores"
	L["Knockbacks"] = "Derribos"
	L["Mesmerizes"] = "Hipnotizaciones"
	L["Mesmerizes (short)"] = "Hipnotizaciones (cortas)"
	L["Mind Control"] = "Control Mental"
	L["Roots"] = "Raíces"
	L["Roots (short)"] = "Raíces (cortas)"
	L["Silences"] = "SIlencios"
	L["Stuns"] = "Aturdimientos"
	L["Stuns (short)"] = "Aturdimientos (cortos)"
	L["Taunts"] = "Provocaciones"
elseif locale == "frFR" then
	L["Cyclone"] = "Cyclone"
	L["Disarms"] = "Désarmements"
	L["Fears"] = "Peurs"
	L["Horrors"] = "Horreurs"
	L["Knockbacks"] = "Projections"
	L["Mesmerizes"] = "Désorientations"
	L["Mesmerizes (short)"] = "Désorientations (courtes)"
	L["Mind Control"] = "Contrôle mental"
	L["Roots"] = "Immobilisations"
	L["Roots (short)"] = "Immobilisations (courtes)"
	L["Silences"] = "Silences"
	L["Stuns"] = "Etourdissements"
	L["Stuns (short)"] = "Etourdissements (courts)"
	L["Taunts"] = "Provocations"
elseif locale == "itIT" then
	
elseif locale == "koKR" then
	
elseif locale == "ptBR" then
	
elseif locale == "ruRU" then
	
elseif locale == "zhCN" then
	
elseif locale == "zhTW" then
	L["Cyclone"] = "颶風術"
	L["Disarms"] = "繳械"
	L["Fears"] = "恐懼"
	L["Horrors"] = "恐慌"
	L["Knockbacks"] = "擊退"
	L["Mesmerizes"] = "迷惑"
	L["Mesmerizes (short)"] = "迷惑(短)"
	L["Mind Control"] = "心靈控制"
	L["Roots"] = "定身"
	L["Roots (short)"] = "定身(短)"
	L["Silences"] = "沉默"
	L["Stuns"] = "昏迷"
	L["Stuns (short)"] = "昏迷(短)"
	L["Taunts"] = "嘲諷"
end

-- How long before DR resets
-- While everyone will tell you it's 15 seconds, it's actually 16 - 20 seconds with 18 being a decent enough average
Data.RESET_TIME = 18

-- List of spellID -> DR category
Data.spells = {
	--[[ TAUNTS ]]--
	-- Death Knight
	[ 56222] = "taunt", -- Dark Command
	[ 57603] = "taunt", -- Death Grip
	-- I have also seen these two spellIDs used for the Death Grip debuff in MoP.
	-- I have not seen the first one here in any of my MoP testing, but it may still be valid.
	[ 49560] = "taunt", -- Death Grip
	[ 51399] = "taunt", -- Death Grip
	-- Druid
	[  6795] = "taunt", -- Growl
	-- Hunter
	[ 20736] = "taunt", -- Distracting Shot
	-- Monk
	[116189] = "taunt", -- Provoke
	-- Paladin
	[ 62124] = "taunt", -- Reckoning
	-- Warlock
	[ 17735] = "taunt", -- Suffering (Voidwalker)
	-- Warrior
	[   355] = "taunt", -- Taunt
	-- Shaman
	[ 36213] = "taunt", -- Angered Earth (Earth Elemental)

	--[[ MESMERIZES ]]--
	-- Note: reuse the previously-used "disorient" category to avoid breaking addons
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#4

	-- Druid
	[  2637] = "disorient", -- Hibernate
	-- Hunter
	[  3355] = "disorient", -- Freezing Trap
	[ 19386] = "disorient", -- Wyvern Sting
	-- Mage
	[   118] = "disorient", -- Polymorph
	[120091] = "disorient", -- Polymorph (Glyphed)
	[ 82691] = "disorient", -- Ring of Frost
	-- Monk
	[115078] = "disorient", -- Paralysis
	-- Paladin
	[ 20066] = "disorient", -- Repentance
	-- Priest
	[  9484] = "disorient", -- Shackle Undead
	-- Rogue
	[  1776] = "disorient", -- Gouge
	[  6770] = "disorient", -- Sap
	-- Shaman
	[ 76780] = "disorient", -- Bind Elemental
	[ 51514] = "disorient", -- Hex
	-- Warlock
	[   710] = "disorient", -- Banish
	-- Pandaren
	[107079] = "disorient", -- Quaking Palm

	--[[ SHORT MESMERIZES ]]--
	-- Note: this category does not share diminishing returns with the above Mesmerize category.
	-- Called "Mesmerize". http://us.battle.net/wow/en/forum/topic/10195910192#4

	-- Druid
	[    99] = "shortdisorient", -- Disorienting Roar (Talent)
	-- Hunter
	[ 19503] = "shortdisorient", -- Scatter Shot
	-- Mage
	[ 31661] = "shortdisorient", -- Dragon's Breath
	-- Monk
	[123393] = "shortdisorient", -- Breath of Fire (Glyphed)
	-- Priest
	[ 88625] = "shortdisorient", -- Holy Word: Chastise

	--[[ SILENCES ]]--
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#6

	-- Death Knight
	[108194] = "silence", -- Asphyxiate (If target is immune to stun)
	[ 47476] = "silence", -- Strangulate
	-- Druid
	[114238] = "silence", -- Fae Silence (Glyphed)
	-- Hunter
	[ 34490] = "silence", -- Silencing Shot
	-- Mage
	[102051] = "silence", -- Frostjaw
	[ 55021] = "silence", -- Counterspell
	-- Monk
	[137460] = "silence", -- Ring of Peace (Silence effect)
	[116709] = "silence", -- Spear Hand Strike
	-- Paladin
	[ 31935] = "silence", -- Avenger's Shield
	-- Priest
	[ 15487] = "silence", -- Silence
	-- Rogue
	[  1330] = "silence", -- Garrote
	-- Warlock
	[ 24259] = "silence", -- Spell Lock (Fel Hunter)
	[115782] = "silence", -- Optical Blast (Observer)
	-- Blood Elf
	[ 25046] = "silence", -- Arcane Torrent (Energy version)
	[ 28730] = "silence", -- Arcane Torrent (Mana version)
	[ 50613] = "silence", -- Arcane Torrent (Runic Power version)
	[ 69179] = "silence", -- Arcane Torrent (Rage version)
	[ 80483] = "silence", -- Arcane Torrent (Focus version)

	--[[ DISARMS ]]--
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#7

	-- Hunter
	[ 50541] = "disarm", -- Clench (Scorpid pet)
	[ 91644] = "disarm", -- Snatch (Bird of Prey pet)
	-- Monk
	[117368] = "disarm", -- Grapple Weapon
	[126458] = "disarm", -- Grapple Weapon (Symbiosis)
	[137461] = "disarm", -- Ring of Peace (Disarm effect)
	-- Priest
	[ 64058] = "disarm", -- Psychic Horror (Disarm effect)
	-- Rogue
	[ 51722] = "disarm", -- Dismantle
	-- Warlock
	[118093] = "disarm", -- Disarm (Voidwalker/Voidlord)
	-- Warrior
	[   676] = "disarm", -- Disarm

	--[[ FEARS ]]--
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#5

	-- Druid
	[113004] = "fear", -- Intimidating Roar (Symbiosis)
	[113056] = "fear", -- Intimidating Roar (Symbiosis)
	-- Hunter
	[  1513] = "fear", -- Scare Beast
	-- Paladin
	[105421] = "fear", -- Blinding Light
	[ 10326] = "fear", -- Turn Evil
	[145067] = "fear", -- Turn Evil (Evil is a Point of View)
	-- Priest
	[  8122] = "fear", -- Psychic Scream
	[113792] = "fear", -- Psychic Terror (Psyfiend)
	-- Rogue
	[  2094] = "fear", -- Blind
	-- Warlock
	[118699] = "fear", -- Fear
	[  5484] = "fear", -- Howl of Terror
	[115268] = "fear", -- Mesmerize (Shivarra)
	[  6358] = "fear", -- Seduction (Succubus)
	--[104045] = "fear", -- Sleep (Metamorphosis)
	-- Warrior
	[  5246] = "fear", -- Intimidating Shout (Main target)
	[ 20511] = "fear", -- Intimidating Shout (Secondary targets)

	--[[ STUNS ]]--
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#3

	-- Death Knight
	[108194] = "ctrlstun", -- Asphyxiate
	[ 91800] = "ctrlstun", -- Gnaw (Ghoul)
	[ 91797] = "ctrlstun", -- Monstrous Blow (Dark Transformation Ghoul)
	[115001] = "ctrlstun", -- Remorseless Winter
	-- Druid
	[ 22570] = "ctrlstun", -- Maim
	[  5211] = "ctrlstun", -- Mighty Bash
	[  9005] = "ctrlstun", -- Pounce
	[102546] = "ctrlstun", -- Pounce (Incarnation)
	[113801] = "ctrlstun", -- Bash (Treants in feral spec) (Bugged by blizzard - it instantly applies all 3 levels of DR right now, making any target instantly immune to ctrlstuns)
	[126451] = "ctrlstun", -- Clash (Symbiosis)
	-- Hunter
	[117526] = "ctrlstun", -- Binding Shot
	[ 24394] = "ctrlstun", -- Intimidation
	[ 90337] = "ctrlstun", -- Bad Manner (Monkey pet)
	[126246] = "ctrlstun", -- Lullaby (Crane pet)
	[126423] = "ctrlstun", -- Petrifying Gaze (Basilisk pet)
	[126355] = "ctrlstun", -- Paralyzing Quill (Porcupine pet)
	[ 56626] = "ctrlstun", -- Sting (Wasp pet)
	[ 50519] = "ctrlstun", -- Sonic Blast (Bat pet)
	[ 96201] = "ctrlstun", -- Web Wrap (Shale Spider pet)
	-- Mage
	[118271] = "ctrlstun", -- Combustion
	[ 44572] = "ctrlstun", -- Deep Freeze
	-- Monk
	[102795] = "ctrlstun", -- Bear Hug (Symbiosis)
	[119392] = "ctrlstun", -- Charging Ox Wave
	[122242] = "ctrlstun", -- Clash
	[120086] = "ctrlstun", -- Fists of Fury
	[119381] = "ctrlstun", -- Leg Sweep
	-- Paladin
	[115752] = "ctrlstun", -- Blinding Light (Glyph)
	[   853] = "ctrlstun", -- Hammer of Justice
	[110698] = "ctrlstun", -- Hammer of Justice (Symbiosis)
	[119072] = "ctrlstun", -- Holy Wrath
	[105593] = "ctrlstun", -- Fist of Justice
	-- Rogue
	[  1833] = "ctrlstun", -- Cheap Shot
	[   408] = "ctrlstun", -- Kidney Shot
	-- Shaman
	[118345] = "ctrlstun", -- Pulverize (Primal Earth Elemental)
	[118905] = "ctrlstun", -- Static Charge (Capacitor Totem)
	-- Warlock
	[ 89766] = "ctrlstun", -- Axe Toss (Felguard)
	[ 30283] = "ctrlstun", -- Shadowfury
	[ 22703] = "ctrlstun", -- Summon Infernal
	-- Warrior
	[46968] = "ctrlstun", -- Shockwave
	[132169] = "ctrlstun", -- Storm Bolt
	-- Tauren
	[ 20549] = "ctrlstun", -- War Stomp

	--[[ SHORT STUNS ]]--
	-- cf.  http://us.battle.net/wow/en/forum/topic/10195910192#3
	-- Notes: 1. this category does not share diminishing returns with the above Stuns category.
	-- 2. Reuse the previously-used "rndstun" category to avoid breaking addons.

	-- Rogue
	[113953] = "rndstun", -- Paralysis (Stun effect of Paralytic Poison)
	-- Shaman
	[ 77505] = "rndstun", -- Earthquake
	-- Warrior
	[  7922] = "rndstun", -- Charge Stun
	[118895] = "rndstun", -- Dragon Roar

	--[[ ROOTS ]]--
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#2

	-- Death Knight
	[ 96294] = "ctrlroot", -- Chains of Ice (Chilblains Root)
	-- Druid
	[   339] = "ctrlroot", -- Entangling Roots
	[113275] = "ctrlroot", -- Entangling Roots (Symbiosis)
	[ 19975] = "ctrlroot", -- Entangling Roots (Nature's Grasp)
	[113770] = "ctrlroot", -- Entangling Roots (Force of Nature)
	[102359] = "ctrlroot", -- Mass Entanglement
	-- Hunter
	[ 61685] = "ctrlroot", -- Charge (Tenacity pet)
	[ 50245] = "ctrlroot", -- Pin (Crab)
	[  4167] = "ctrlroot", -- Web (Spider)
	[ 54706] = "ctrlroot", -- Venom Web Spray (Silithid)
	[ 90327] = "ctrlroot", -- Lock Jaw (Dog)
	[136634] = "ctrlroot", -- Narrow Escape (Talent)
	-- Mage
	[   122] = "ctrlroot", -- Frost Nova
	[110693] = "ctrlroot", -- Frost Nova (Symbiosis)
	[ 33395] = "ctrlroot", -- Freeze (Water Elemental)
	-- Monk
	[116706] = "ctrlroot", -- Disable
	-- Priest
	[ 87194] = "ctrlroot", -- Mind Blast (Glyphed)
	[114404] = "ctrlroot", -- Void Tendrils
	-- Rogue
	[115197] = "ctrlroot", -- Partial Paralysis (Shiv effect with Paralytic Poison)
	-- Shaman
	[ 63685] = "ctrlroot", -- Freeze (Frozen Power Talent)
	-- Warrior
	[107566] = "ctrlroot", -- Staggering Shout (Talent)

	--[[ SHORT ROOTS ]]--
	-- Note: this category does not share diminishing returns with the above Roots category.
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#2

	-- Death Knight
	[91807]	= "shortroot", -- Shambling Rush (Ghoul)
	-- Hunter
	[ 64803] = "shortroot", -- Entrapment
	-- Mage
	[111340] = "shortroot", -- Ice Ward
	-- Monk
	[123407] = "shortroot", -- Spinning Fire Blossom
	-- Shaman
	[ 64695] = "shortroot", -- Earthgrab Totem
	-- Warrior
	[105771] = "shortroot", -- Warbringer (Talent)

	--[[ HORROR ]]--
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#5

	-- Priest
	[ 64044] = "horror", -- Psychic Horror (Horror effect)
	-- Warlock
	[137143] = "horror", -- Blood Horror
	[  6789] = "horror", -- Mortal Coil

	--[[ MISC ]]--
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#9

	-- Druid
	[ 33786] = "cyclone", -- Cyclone
	-- Priest
	[   605] = "mc", -- Dominate Mind
	[113506] = "cyclone", -- Cyclone (Symbiosis)

	--[[ KNOCKBACKS ]]--
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#8

	-- Death Knight
	[108199] = "knockback", -- Gorefiend's Grasp
	-- Druid
	[102793] = "knockback", -- Ursol's Vortex
	[132469] = "knockback", -- Typhoon
	-- Hunter
	[119403] = "knockback", -- Explosive Trap (Glyphed)
	-- Shaman
	[ 51490] = "knockback", -- Thunderstorm
	-- Warlock
	[  6360] = "knockback", -- Whiplash
	[115770] = "knockback", -- Fellash
}

-- DR Category names
Data.categoryNames = {
	["ctrlroot"] = L["Roots"],
	["shortroot"] = L["Roots (short)"],
	["ctrlstun"] = L["Stuns"],
	["cyclone"] = L["Cyclone"],
	["disarm"] = L["Disarms"],
	["disorient"] = L["Mesmerizes"],
	["shortdisorient"] = L["Mesmerizes (short)"],
	["fear"] = L["Fears"],
	["horror"] = L["Horrors"],
	["mc"] = L["Mind Control"],
	["rndstun"] = L["Stuns (short)"],
	["silence"] = L["Silences"],
	["taunt"] = L["Taunts"],
	["knockback"] = L["Knockbacks"], -- NEEDS PROPER TESTING WITH DEPENDENT ADDONS
}

-- Categories that have DR in PvE as well as PvP
Data.pveDR = {
	["ctrlstun"] = true,
	["rndstun"] = true,
	["taunt"] = true,
	["cyclone"] = true,
}

-- Public APIs
-- Category name in something usable
function Data:GetCategoryName(cat)
	return cat and Data.categoryNames[cat] or nil
end

-- Spell list
function Data:GetSpells()
	return Data.spells
end

-- Seconds before DR resets
function Data:GetResetTime()
	return Data.RESET_TIME
end

-- Get the category of the spellID
function Data:GetSpellCategory(spellID)
	return spellID and Data.spells[spellID] or nil
end

-- Does this category DR in PvE?
function Data:IsPVE(cat)
	return cat and Data.pveDR[cat] or nil
end

-- List of categories
function Data:GetCategories()
	return Data.categoryNames
end

-- Next DR, if it's 1.0, next is 0.50, if it's 0.[50] = "ctrlroot",next is 0.[25] = "ctrlroot",and such
function Data:NextDR(diminished)
	if diminished == 1 then
		return 0.50
	elseif diminished == 0.50 then
		return 0.25
	end
	return 0
end