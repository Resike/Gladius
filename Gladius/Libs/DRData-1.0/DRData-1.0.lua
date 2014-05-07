local major = "DRData-1.0"
local minor = 1033
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

-- Spells and providers by categories
--[[ Generic format:
	category = {
		-- When the debuff and the spell that applies it are the same:
		debuffId = true
		-- When the debuff and the spell that applies it differs:
		debuffId = spellId
		-- When several spells applies the debuff:
		debuffId = {spellId1, spellId2, ...}
	}
--]]
local spellsAndProvidersByCategory = {
	--[[ TAUNT ]]--
	taunt = {
		-- Death Knight
		[ 56222] = true, -- Dark Command
		[ 57603] = true, -- Death Grip
		-- I have also seen these two spellIDs used for the Death Grip debuff in MoP.
		-- I have not seen the first one here in any of my MoP testing, but it may still be valid.
		[ 49560] = true, -- Death Grip
		[ 51399] = true, -- Death Grip
		-- Druid
		[  6795] = true, -- Growl
		-- Hunter
		[ 20736] = true, -- Distracting Shot
		-- Monk
		[116189] = 115546, -- Provoke
		[118635] = 115546, -- Provoke via the Black Ox Statue -- NEED TESTING
		[118585] = 115543, -- Leer of the Ox -- NEED TESTING
		-- Paladin
		[ 62124] = true, -- Reckoning
		-- Warlock
		[ 17735] = true, -- Suffering (Voidwalker)
		-- Warrior
		[   355] = true, -- Taunt
		-- Shaman
		[ 36213] = true, -- Angered Earth (Earth Elemental)
	},

	--[[ MESMERIZES ]]--
	-- Note: reuse the previously-used "disorient" category to avoid breaking addons
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#4
	disorient = {
		-- Druid
		[  2637] = true, -- Hibernate
		-- Hunter
		[  3355] = {1499, 60192}, -- Freezing Trap
		[ 19386] = true, -- Wyvern Sting
		-- Mage
		[   118] = true, -- Polymorph
		[ 28272] = true, -- Polymorph (Pig)
		[ 28271] = true, -- Polymorph (Turtle)
		[ 61305] = true, -- Polymorph (Black Cat)
		[ 61025] = true, -- Polymorph (Serpent) -- FIXME: gone ?
		[ 61721] = true, -- Polymorph (Rabbit)
		[ 61780] = true, -- Polymorph (Turkey)
		[ 82691] = true, -- Ring of Frost
		-- Monk
		[115078] = true, -- Paralysis
		-- Paladin
		[ 20066] = true, -- Repentance
		-- Priest
		[  9484] = true, -- Shackle Undead
		-- Rogue
		[  1776] = true, -- Gouge
		[  6770] = true, -- Sap
		-- Shaman
		[ 76780] = true, -- Bind Elemental
		[ 51514] = true, -- Hex
		-- Warlock
		[   710] = true, -- Banish
		-- Pandaren
		[107079] = true, -- Quaking Palm
	},

	--[[ SHORT MESMERIZES ]]--
	-- Note: this category does not share diminishing returns with the above Mesmerize category.
	-- Called "Mesmerize". http://us.battle.net/wow/en/forum/topic/10195910192#4
	shortdisorient = {
		-- Druid
		[    99] = true, -- Disorienting Roar (Talent)
		-- Hunter
		[ 19503] = true, -- Scatter Shot
		-- Mage
		[ 31661] = true, -- Dragon's Breath
		-- Monk
		[123393] = true, -- Breath of Fire (Glyphed)
		-- Priest
		[ 88625] = true, -- Holy Word: Chastise
	},

	--[[ SILENCES ]]--
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#6
	silence = {
		-- Death Knight
		[108194] = true, -- Asphyxiate (If target is immune to stun)
		[ 47476] = true, -- Strangulate
		-- Druid
		[114237] = true, -- Glyph of Fae Silence
		-- Hunter
		[ 34490] = true, -- Silencing Shot
		-- Mage
		[102051] = true, -- Frostjaw
		[ 55021] = true, -- Counterspell
		-- Monk
		[137460] = 116844, -- Ring of Peace (Silence effect)
		[116709] = 116705, -- Spear Hand Strike
		-- Paladin
		[ 31935] = true, -- Avenger's Shield
		-- Priest
		[ 15487] = true, -- Silence
		-- Rogue
		[  1330] = true, -- Garrote
		-- Warlock
		[ 24259] = 19647, -- Spell Lock (Fel Hunter)
		[115782] = 115781, -- Optical Blast (Observer)
		-- Blood Elf
		[ 25046] = true, -- Arcane Torrent (Energy version)
		[ 28730] = true, -- Arcane Torrent (Mana version)
		[ 50613] = true, -- Arcane Torrent (Runic power version)
		[ 69179] = true, -- Arcane Torrent (Rage version)
		[ 80483] = true, -- Arcane Torrent (Focus version)
	},

	--[[ DISARMS ]]--
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#7
	disarm = {
		-- Hunter
		[ 50541] = true, -- Clench (Scorpid pet)
		[ 91644] = true, -- Snatch (Bird of Prey pet)
		-- Monk
		[117368] =   true, -- Grapple Weapon
		[126458] =   true, -- Grapple Weapon (Symbiosis)
		[137461] = 116844, -- Ring of Peace (Disarm effect)
		-- Priest
		[ 64058] = true, -- Psychic Horror (Disarm effect)
		-- Rogue
		[ 51722] = true, -- Dismantle
		-- Warlock
		[118093] = true, -- Disarm (Voidwalker/Voidlord)
		-- Warrior
		[   676] = true, -- Disarm
	},

	--[[ FEARS ]]--
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#5
	fear = {
		-- Druid
		[113004] = true, -- Intimidating Roar (Symbiosis Main target)
		[113056] = true, -- Intimidating Roar (Symbiosis Secondary targets)
		-- Hunter
		[  1513] = true, -- Scare Beast
		-- Paladin
		[105421] = true, -- Blinding Light
		[ 10326] = true, -- Turn Evil
		[145067] = true, -- Turn Evil (Evil is a Point of View)
		-- Priest
		[  8122] = true, -- Psychic Scream
		[113792] = true, -- Psychic Terror (Psyfiend)
		-- Rogue
		[  2094] = true, -- Blind
		-- Warlock
		[  5782] = true, -- Fear
		[118699] = 5782, -- Fear -- new SpellID in MoP, Blood Fear uses same ID
		[  5484] = true, -- Howl of Terror
		[115268] = true, -- Mesmerize (Shivarra)
		[  6358] = true, -- Seduction (Succubus)
		--[104045] = true, -- Sleep (Metamorphosis) -- FIXME: verify this is the correct category
		-- Warrior
		[  5246] = true, -- Intimidating Shout (Main target)
		[ 20511] = true, -- Intimidating Shout (Secondary targets)
	},

	--[[ STUNS ]]--
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#3
	ctrlstun = {
		-- Death Knight
		[108194] = true, -- Asphyxiate
		[ 91800] = true, -- Gnaw (Ghoul)
		[ 91797] = true, -- Monstrous Blow (Dark Transformation Ghoul)
		[115001] = true, -- Remorseless Winter
		-- Druid
		[102795] = true, -- Bear Hug
		[ 22570] = true, -- Maim
		[  5211] = true, -- Mighty Bash
		[  9005] = true, -- Pounce
		[102546] = true, -- Pounce (Incarnation)
		[113801] = true, -- Bash (Treants in feral spec) (Bugged by blizzard - it instantly applies all 3 levels of DR right now, making any target instantly immune to ctrlstuns)
		-- Hunter
		[117526] = 109248, -- Binding Shot
		[ 24394] = 19577, -- Intimidation
		[ 90337] = true, -- Bad Manner (Monkey pet)
		[126246] = true, -- Lullaby (Crane pet)
		[126423] = true, -- Petrifying Gaze (Basilisk pet)
		[126355] = true, -- Paralyzing Quill (Porcupine pet)
		[ 56626] = true, -- Sting (Wasp pet)
		[ 50519] = true, -- Sonic Blast (Bat pet)
		[ 96201] = true, -- Web Wrap (Shale Spider pet)
		-- Mage
		[118271] = true, -- Combustion
		[ 44572] = true, -- Deep Freeze
		-- Monk
		[119392] =   true, -- Charging Ox Wave
		[122242] = 122057, -- Clash
		[120086] = 113656, -- Fists of Fury
		[119381] =   true, -- Leg Sweep
		-- Paladin
		[115752] = true, -- Blinding Light (Glyphed)
		[   853] = true, -- Hammer of Justice
		[110698] = true, -- Hammer of Justice (Symbiosis)
		[119072] = true, -- Holy Wrath
		[105593] = true, -- Fist of Justice
		-- Rogue
		[  1833] = true, -- Cheap Shot
		[   408] = true, -- Kidney Shot
		-- Shaman
		[118345] = true, -- Pulverize (Primal Earth Elemental)
		[118905] = true, -- Static Charge (Capacitor Totem)
		-- Warlock
		[ 89766] = true, -- Axe Toss (Felguard)
		[ 30283] = true, -- Shadowfury
		[ 22703] = 1122, -- Summon Infernal
		-- Warrior
		[132168] = true, -- Shockwave
		[132169] = true, -- Storm Bolt
		-- Tauren
		[ 20549] = true, -- War Stomp
	},

	--[[ SHORT STUNS ]]--
	-- cf.  http://us.battle.net/wow/en/forum/topic/10195910192#3
	-- Notes: 1. this category does not share diminishing returns with the above Stuns category.
	-- 2. Reuse the previously-used true category to avoid breaking addons.
	rndstun = {
		-- Rogue
		[113953] = true, -- Paralysis (Stun effect of Paralytic Poison)
		-- Warrior
		[118895] = true, -- Dragon Roar (Talent)
		-- Shaman
		[ 77505] = true, -- Earthquake
		-- Warrior
		[   100] = true, -- Charge
		[118000] = true, -- Dragon Roar
	},

	--[[ ROOTS ]]--
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#2
	ctrlroot = {
		-- Death Knight
		[ 96294] = true, -- Chains of Ice (Chilblains Root)
		-- Druid
		[   339] = true, -- Entangling Roots
		[113275] = true, -- Entangling Roots (Symbiosis)
		[ 19975] = true, -- Nature's Grasp (Uses different spellIDs than Entangling Roots for the same spell)
		[102359] = true, -- Mass Entanglement (Talent)
		-- Hunter
		[ 53148] = 61685, -- Charge (Tenacity pet)
		[ 50245] = true, -- Pin (Crab)
		[  4167] = true, -- Web (Spider)
		[ 54706] = true, -- Venom Web Spray (Silithid)
		[ 90327] = true, -- Lock Jaw (Dog)
		[136634] = true, -- Narrow Escape (Talent)
		-- Mage
		[   122] = true, -- Frost Nova
		[110693] = true, -- Frost Nova (Symbiosis)
		[ 33395] = true, -- Freeze (Water Elemental)
		-- Monk
		[116706] = 116095, -- Disable
		-- Priest
		[ 87194] = true, -- Glyph of Mind Blast
		[114404] = true, -- Void Tendrils
		-- Rogue
		[115197] = true, -- Partial Paralysis (Shiv effect with Paralytic Poison)
		-- Shaman
		[ 63685] = true, -- Freeze (Frozen Power talent)
		-- Warrior
		[107566] = true, -- Staggering Shout (Talent)
	},

	--[[ SHORT ROOTS ]]--
	-- Note: this category does not share diminishing returns with the above Roots category.
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#2
	shortroot = {
		-- Hunter
		[135373] = true, -- Entrapment (Passive)
		-- Mage
		[111264] = true, -- Ice Ward -- ID NEED CONFIRMATION
		-- Monk
		[123407] = 115073, -- Spinning Fire Blossom
		-- Shaman
		[ 64695] = true, -- Earthgrab Totem
	},

	--[[ HORROR ]]--
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#5
	horror = {
		-- Priest
		[ 64044] = true, -- Psychic Horror (Horror effect)
		-- Warlock
		[111397] = true, -- Blood Horror
		[  6789] = true, -- Mortal Coil
	},

	--[[ MISC ]]--
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#9
	cyclone = {
		-- Druid
		[ 33786] = true, -- Cyclone
		[113506] = true, -- Cyclone (Symbiosis)
	},

	mc = {
		-- Priest
		[   605] = true, -- Dominate Mind
	},

	--[[ KNOCKBACK ]]--
	-- cf. http://us.battle.net/wow/en/forum/topic/10195910192#8
	knockback = {
		-- Death Knight
		[108199] = true, -- Gorefiend's Grasp
		-- Druid
		[102793] = true, -- Ursol's Vortex
		[132469] = true, -- Typhoon
		-- Hunter
		[119403] = true, -- Glyph of Explosive Trap
		-- Shaman
		[ 51490] = true, -- Thunderstorm
		-- Warlock
		[  6360] = true, -- Whiplash
		[115770] = true, -- Fellash
	},
}

--- List of spellID -> DR category
Data.spells = { }

--- List of spellID => ProviderID
Data.providers = { }

-- Dispatch the spells in the final tables
for category, spells in pairs(spellsAndProvidersByCategory) do
	for spell, provider in pairs(spells) do
		Data.spells[spell] = category
		if provider == true then
			Data.providers[spell] = spell
			spells[spell] = spell
		else
			Data.providers[spell] = provider
		end
	end
end

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

-- Provider list
function Data:GetProviders()
	return Data.providers
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

-- Next DR, if it's 1.0, next is 0.50, if it's 0.[50] = "ctrlroot", next is 0.[25] = "ctrlroot", and such
function Data:NextDR(diminished)
	if diminished == 1 then
		return 0.50
	elseif diminished == 0.50 then
		return 0.25
	end
	return 0
end

-- Iterate through the spells of a given category
-- Pass "nil" to iterate through all spells
do
	local function categoryIterator(id, category)
		local newCat
		repeat
			id, newCat = next(Data.spells, id)
			if id and newCat == category then
				return id, category
			end
		until not id
	end
	function Data:IterateSpells(category)
		if category then
			return categoryIterator, category
		else
			return next, Data.spells
		end
	end
end

-- Iterate through the spells and providers of a given category
-- Pass "nil" to iterate through all spells
function Data:IterateProviders(category)
	if category then
		return next, spellsAndProvidersByCategory[category]
	else
		return next, Data.providers
	end
end