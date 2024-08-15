local Gladius = _G.Gladius
if not Gladius then
	DEFAULT_CHAT_FRAME:AddMessage(format("Module %s requires Gladius", "Class Icon"))
end
local L = Gladius.L
local LSM

-- Global Functions
local _G = _G
local pairs = pairs
local select = select
local strfind = string.find
local tonumber = tonumber
local tostring = tostring
local unpack = unpack

local CreateFrame = CreateFrame
local GetSpecializationInfoByID = GetSpecializationInfoByID
local GetSpellInfo = C_Spell.GetSpellInfo
local GetSpellName = C_Spell.GetSpellName
local GetTime = GetTime
local UnitAura = C_UnitAuras.GetAuraDataByIndex

local CLASS_BUTTONS = CLASS_ICON_TCOORDS

local IsWrathClassic = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC

local function GetDefaultAuraList()
	local auraTable = {
		-- Higher Number is More Priority
		[GetSpellName(167152) or ""]   = 10, -- Refreshment
		[GetSpellName(118358) or ""]   = 10, -- Drink
		[GetSpellName(1784) or ""]     = 10, -- Stealth
		[GetSpellName(5215) or ""]     = 10, -- Prowl
		[GetSpellName(198158) or ""]                     = 10.3, -- Mass Invisibility
		[GetSpellName(215769) or ""]   = 10, -- Spirit of the Redeemer
		[GetSpellName(45438) or ""]    = 10, -- Ice Block
		[GetSpellName(45182) or ""]                      = 10, -- Cheating Death
		[GetSpellName(116888) or ""]                     = 10, -- Purgatory
		[GetSpellName(269513) or ""]   = 10, -- Death from Above
		[GetSpellName(46924) or ""]    = 10, -- Bladestorm fury
		[GetSpellName(227847) or ""]   = 10, -- Bladestorm arms
		[GetSpellName(47585) or ""]    = 10, -- Dispersion
		[GetSpellName(642) or ""]      = 10, -- Divine Shield
		[GetSpellName(378441) or ""]   = 10.2, -- Time Stop
		[GetSpellName(228050) or ""]   = 10.1, -- Prot pala Party Bubble
		[GetSpellName(210918) or ""]   = 10, -- Ethereal Form
		[GetSpellName(27827) or ""]    = 10, -- Spirit of Redemption
		[GetSpellName(186265) or ""]   = 10, -- Aspect of the Turtle
		[GetSpellName(196555) or ""]   = 10, -- Netherwalk
		[GetSpellName(58984) or ""]    = 10, -- Shadowmeld

		[GetSpellName(2094) or ""]     = 9.1, -- Blind
		[GetSpellName(202274) or ""]   = 9.1, -- Brew Breath
		[GetSpellName(207167) or ""]   = 9,  -- Blinding Sleet
		[GetSpellName(33786) or ""]    = 9.1, -- Cyclone
		[GetSpellName(221527) or ""]                     = 9.1, -- Imprison talented
		[GetSpellName(605) or ""]      = 9,  -- Mind Control
		[GetSpellName(118699) or ""]   = 9,  -- Fear
		[GetSpellName(226943) or ""]                     = 9,  -- Mind Bomb disorient
		[GetSpellName(236748) or ""]   = 9,  -- disorienting roar
		[GetSpellName(2637) or ""]     = 9,  -- Hibernate
		[GetSpellName(3355) or ""]     = 9.1, -- Freezing Trap
		[GetSpellName(203337) or ""]   = 9.1, -- Freezing Trap (talented)
		[GetSpellName(51514) or ""]    = 9,  -- Hex
		[GetSpellName(211004) or ""]   = 9,  -- Hex
		[GetSpellName(210873) or ""]   = 9,  -- Hex
		[GetSpellName(211015) or ""]   = 9,  -- Hex
		[GetSpellName(211010) or ""]   = 9,  -- Hex
		[GetSpellName(277784) or ""]   = 9,  -- Hex
		[GetSpellName(277778) or ""]   = 9,  -- Hex
		[GetSpellName(269352) or ""]   = 9,  -- Hex
		[GetSpellName(5246) or ""]     = 9,  -- Intimidating Shout
		[GetSpellName(6789) or ""]     = 9,  -- Mortal Coil
		[GetSpellName(118) or ""]      = 9,  -- Polymorph
		[GetSpellName(277787) or ""]   = 9,  -- Polymorph direhorn
		[GetSpellName(277792) or ""]   = 9,  -- Polymorph bumblebee
		[GetSpellName(28272) or ""]    = 9,  -- Polymorph pig
		[GetSpellName(61305) or ""]    = 9,  -- Polymorph black cat
		[GetSpellName(61721) or ""]    = 9,  -- Polymorph rabbit
		[GetSpellName(161372) or ""]   = 9,  -- Polymorph peacock
		[GetSpellName(28271) or ""]    = 9,  -- Polymorph turtle
		[GetSpellName(161355) or ""]   = 9,  -- Polymorph penguin
		[GetSpellName(61780) or ""]    = 9,  -- Polymorph turkey
		[GetSpellName(126819) or ""]   = 9,  -- Polymorph porcupine
		[GetSpellName(161353) or ""]   = 9,  -- Polymorph bear cup
		[GetSpellName(161354) or ""]   = 9,  -- Polymorph monkey
		[GetSpellName(105421) or ""]   = 9,  -- Blinding Light
		[GetSpellName(213691) or ""]   = 9,  -- Scatter Shot
		[GetSpellName(8122) or ""]     = 9,  -- Psychic Scream
		[GetSpellName(20066) or ""]    = 9,  -- Repentance
		[GetSpellName(82691) or ""]    = 9,  -- Ring of Frost
		[GetSpellName(6770) or ""]     = 9.1, -- Sap
		[GetSpellName(107079) or ""]   = 9,  -- Quaking Palm
		[GetSpellName(6358) or ""]     = 9,  -- Seduction (Succubus)
		[GetSpellName(261589) or ""]   = 9,  -- Seduction (Player)
		[GetSpellName(1776) or ""]     = 9,  -- Gouge
		[GetSpellName(31661) or ""]    = 9,  -- Dragon's Breath
		[GetSpellName(360806) or ""]   = 9,  -- Sleep Walk

		[GetSpellName(207685) or ""]   = 8,  -- Sigil of Misery Disorient
		[GetSpellName(198909) or ""]   = 8,  -- Song of Chi-Ji
		[GetSpellName(221562) or ""]   = 8,  -- Asphyxiate blood
		[GetSpellName(108194) or ""]   = 8,  -- Asphyxiate frost/unholy
		[GetSpellName(210141) or ""]   = 8,  -- Zombie Explosion
		[GetSpellName(91797) or ""]    = 8,  -- transformed Gnaw
		[GetSpellName(91800) or ""]    = 8,  -- untransformed Gnaw
		[GetSpellName(89766) or ""]    = 8,  -- Axe Toss (Felguard)
		[GetSpellName(24394) or ""]    = 8,  -- Intimidation
		[GetSpellName(202244) or ""]   = 8,  -- Overrun bear stun
		[GetSpellName(1833) or ""]     = 8,  -- Cheap Shot
		[GetSpellName(205630) or ""]   = 8,  -- Illidan's Grasp 1
		[GetSpellName(208618) or ""]   = 8,  -- Illidan's Grasp 2
		[GetSpellName(213491) or ""]   = 8,  -- Demonic Trample knockdown
		[GetSpellName(199804) or ""]   = 8,  -- Between the Eyes
		[GetSpellName(235612) or ""]   = 8,  -- Frost DK stun
		[GetSpellName(287254) or ""]   = 8,  -- Remorseless Winter stun
		[GetSpellName(77505) or ""]                      = 8,  -- Earthquake
		[GetSpellName(213688) or ""]   = 8,  -- Fel Cleave
		[GetSpellName(853) or ""]      = 8,  -- Hammer of Justice
		[GetSpellName(200196) or ""]   = 8,  -- Holy Word: Chastise
		[GetSpellName(408) or ""]      = 8,  -- Kidney Shot
		[GetSpellName(372245) or ""]   = 8,  -- Terror of the Skies (Deep Breath)
		[GetSpellName(202346) or ""]   = 8,  -- Keg Stun
		[GetSpellName(200200) or ""]   = 8,  -- Holy Word: Chastise
		[GetSpellName(119381) or ""]   = 8.2, -- Leg Sweep
		[GetSpellName(179057) or ""]   = 8.1, -- Chaos Nova
		[GetSpellName(211881) or ""]   = 8,  -- Fel Eruption
		[GetSpellName(204399) or ""]   = 8,  -- Earthfury
		[GetSpellName(255723) or ""]   = 8,  -- Bull Rush
		[GetSpellName(204437) or ""]   = 8,  -- Lightning Lasso
		[GetSpellName(197214) or ""]   = 8,  -- Sundering
		[GetSpellName(203123) or ""]   = 8,  -- Maim stun
		[GetSpellName(64044) or ""]    = 8,  -- Psychic Horror
		[GetSpellName(199085) or ""]   = 8,  -- Heroic Leap Stun
		[GetSpellName(5211) or ""]     = 8,  -- Mighty Bash
		[GetSpellName(118345) or ""]   = 8,  -- Pulverize (Primal Earth Elemental)
		[GetSpellName(30283) or ""]    = 8,  -- Shadowfury
		[GetSpellName(22703) or ""]    = 8,  -- Summon Infernal stun
		[GetSpellName(132168) or ""]   = 8,  -- Shockwave
		[GetSpellName(118905) or ""]   = 8,  -- Lightning Surge Totem
		[GetSpellName(132169) or ""]   = 8,  -- Storm Bolt
		[GetSpellName(20549) or ""]    = 8,  -- War Stomp
		[GetSpellName(87204) or ""]    = 8,  -- Sin and Punishment
		[GetSpellName(117526) or ""]                     = 8,  -- Binding Shot
		[GetSpellName(163505) or ""]                     = 8,  -- Rake stun
		[GetSpellName(48792) or ""]    = 8, -- Icebound Fortitude
		[GetSpellName(287081) or ""]   = 8, -- Lichborne
		[GetSpellName(115078) or ""]   = 8.1, -- Paralysis
		[GetSpellName(217832) or ""]                     = 8,  -- Imprison
		[GetSpellName(236025) or ""]   = 8, -- Enraged Maim incap

		[GetSpellName(104773) or ""]   = 7.5, -- Unending Resolve affli/demo/destro
		[GetSpellName(77606) or ""]                      = 7.4, -- Dark Simulacrum
		[GetSpellName(122470) or ""]                     = 7,  -- Touch of Karma debuff
		[GetSpellName(125174) or ""]                     = 7,  -- Touch of Karma buff
		[GetSpellName(5277) or ""]     = 7.4, -- Evasion
		[GetSpellName(213602) or ""]   = 7.4, -- Greater Fade
		[GetSpellName(199027) or ""]   = 7.2, -- Evasion2 post stealth
		[GetSpellName(199754) or ""]   = 7.3, -- Riposte
		[GetSpellName(198144) or ""]   = 7.3, -- Ice Form
		[GetSpellName(188499) or ""]   = 7.3, -- Blade Dance
		[GetSpellName(210152) or ""]   = 7.3, -- Death Sweep
		[GetSpellName(212800) or ""]   = 7.2, -- Blur
		[GetSpellName(209426) or ""]   = 7.1, -- Darkness
		[GetSpellName(6940) or ""]                       = 7.2, -- Blessing of Sacrifice
		[GetSpellName(199448) or ""]                     = 7.2, -- Blessing of Sacrifice
		[GetSpellName(1022) or ""]     = 7.4, -- Hand of Protection
		[GetSpellName(18499) or ""]    = 7.3, -- Berserker Rage
		[GetSpellName(212704) or ""]   = 7.3, -- The Beast Within
		[GetSpellName(196364) or ""]                     = 7, -- Unstable Affliction silence
		[GetSpellName(1330) or ""]     = 7, -- Garrote (Silence)
		[GetSpellName(15487) or ""]    = 7, -- Silence
		[GetSpellName(204490) or ""]   = 7, -- Sigil of Silence
		[GetSpellName(217824) or ""]   = 7, -- Prot Pala Silence
		[GetSpellName(236077) or ""]   = 7, -- War Disarm
		[GetSpellName(207777) or ""]   = 7, -- Dismantle
		[GetSpellName(233759) or ""]   = 7, -- Grapple Weapon
		[GetSpellName(209749) or ""]   = 7, -- Faerie Swarm disarm
		[GetSpellName(202933) or ""]                     = 7,  -- Spider Sting
		[GetSpellName(47476) or ""]    = 7.5, -- Strangulate
		[GetSpellName(81261) or ""]    = 7, -- Solar Beam

		[GetSpellName(8178) or ""]     = 6.3, -- Grounding Totem Effect
		[GetSpellName(91807) or ""]    = 6, -- Shambling Rush (Ghoul)
		[GetSpellName(116706) or ""]                     = 6,  -- Disable
		[GetSpellName(157997) or ""]   = 6, -- Ice Nova
		[GetSpellName(228600) or ""]   = 6, -- Glacial Spike
		[GetSpellName(198121) or ""]   = 6, -- Frostbite
		[GetSpellName(233395) or ""]   = 6, -- Frozen Center
		[GetSpellName(64695) or ""]    = 6, -- Earthgrab Totem
		[GetSpellName(233582) or ""]   = 6, -- Destro root
		[GetSpellName(285515) or ""]   = 6, -- Frost Shock root (talent)
		[GetSpellName(339) or ""]      = 6, -- Entangling Roots
		[GetSpellName(162480) or ""]                     = 6,  -- Steel Trap root
		[GetSpellName(235963) or ""]   = 6, -- Entangling Roots undispellable
		[GetSpellName(170855) or ""]   = 6, -- Ironbark Entangling Roots
		[GetSpellName(45334) or ""]    = 6, -- Immobilized (Wild Charge - Bear)
		[GetSpellName(33395) or ""]    = 6, -- Freeze (Water Elemental)
		[GetSpellName(122) or ""]      = 6, -- Frost Nova
		[GetSpellName("358385") or ""] = 6, -- Landslide
		[GetSpellName(102359) or ""]   = 6, -- Mass Entanglement
		[GetSpellName(190927) or ""]   = 6, -- Harpoon
		[GetSpellName(212638) or ""]                     = 6,  -- Tracker's Net (miss atks)
		[GetSpellName(105771) or ""]   = 6, -- Charge root
		[GetSpellName(204085) or ""]                     = 6,  -- Deathchill root

		[GetSpellName(198222) or ""]                     = 5.9, -- System Shock 90% slow
		[GetSpellName(48707) or ""]    = 5.2, -- Anti-Magic Shell
		[GetSpellName(370984) or ""]   = 5.2, -- Emerald Communion
		[GetSpellName(204018) or ""]   = 5.3, -- Magic Bop
		[GetSpellName(212295) or ""]   = 5.2, -- Nether Ward
		[GetSpellName(221705) or ""]   = 5.1, -- Casting Circle
		[GetSpellName(234084) or ""]   = 5.1, -- Boomy 70% kick reduc
		[GetSpellName(196773) or ""]   = 5.1, -- inner focus
		[GetSpellName(290641) or ""]   = 5.1, -- Ancestral Gift
		[GetSpellName(289655) or ""]   = 5.1, -- Holy Word: Concentration
		[GetSpellName(209584) or ""]   = 5.1, -- Zen Focus Tea
		[GetSpellName(116849) or ""]   = 5, -- Life Cocoon
		[GetSpellName(110960) or ""]   = 5.1, -- Greater Invisibility
		[GetSpellName(113862) or ""]   = 5, -- Greater Invisibility
		[GetSpellName(108271) or ""]   = 5, -- Astral Shift
		[GetSpellName(22812) or ""]    = 5, -- Barkskin
		[GetSpellName(871) or ""]      = 5, -- Shield Wall
		[GetSpellName(232707) or ""]   = 5.4, -- Ray of Hope
		[GetSpellName(31224) or ""]    = 5.3, -- Cloak of Shadows
		[GetSpellName(118038) or ""]   = 5.1, -- Die by the Sword
		[GetSpellName(227744) or ""]   = 5, -- Ravager parry
		[GetSpellName(81256) or ""]    = 5, -- Dancing Rune weapon
		[GetSpellName(498) or ""]      = 5, -- Divine Protection
		[GetSpellName(236321) or ""]   = 5, -- War Banner
		[GetSpellName(199507) or ""]   = 5, -- Spreading The Word: Protection
		[GetSpellName(205191) or ""]   = 5.1, -- Eye for an Eye
		[GetSpellName(47788) or ""]    = 5, -- Guardian Spirit
		[GetSpellName(207498) or ""]   = 5, -- Ancestral Protection Totem
		[GetSpellName(66) or ""]       = 5, -- Invisibility
		[GetSpellName(32612) or ""]    = 5, -- Invisibility
		[GetSpellName(102342) or ""]   = 5, -- Ironbark
		[GetSpellName(199038) or ""]   = 5, -- Intercept 90% dmg reduc
		[GetSpellName(202748) or ""]   = 5, -- survival tactics
		[GetSpellName(210256) or ""]   = 5, -- Blessing of Sanctuary
		[GetSpellName(213610) or ""]   = 5, -- Holy Ward
		[GetSpellName(378464) or ""]   = 5, -- Nullification Shroud
		[GetSpellName(122783) or ""]   = 5.1, -- Diffuse Magic
		[GetSpellName(33206) or ""]    = 5, -- Pain Suppression
		[GetSpellName(53480) or ""]    = 5, -- Roar of Sacrifice
		[GetSpellName(192081) or ""]   = 5, -- Ironfur
		[GetSpellName(31850) or ""]    = 5, -- Ardent Defender
		[GetSpellName(86659) or ""]    = 5.3, -- Prot Pala Wall
		[GetSpellName(184364) or ""]   = 5, -- Enraged Regeneration
		[GetSpellName(207736) or ""]   = 5, -- Shadowy Duel
		[GetSpellName(236273) or ""]   = 5, -- Duel
		[GetSpellName(207756) or ""]   = 5, -- Shadowy Duel
		[GetSpellName(210294) or ""]   = 5, -- Divine Favor
		[GetSpellName(198111) or ""]   = 5, -- Temporal Shield
		[GetSpellName(23920) or ""]    = 5.1, -- Spell Reflection
		[GetSpellName(213915) or ""]   = 5.1, -- Mass Spell Reflection
		[GetSpellName(147833) or ""]   = 5.2, -- Intercepted Spell Redirect
		[GetSpellName(202248) or ""]   = 5.1, -- zen meditation
		[GetSpellName(248519) or ""]   = 5.1, -- Interlope (bm pet redirect)
		[GetSpellName(61336) or ""]    = 5, -- Survival Instincts
		[GetSpellName(363916) or ""]   = 5, -- Obsidian Scales
		[GetSpellName(357170) or ""]   = 5, -- Time Dilation
		[GetSpellName(374348) or ""]   = 5, -- Renewing Blaze

		[GetSpellName(206803) or ""]   = 4.1, -- Rain from Above
		[GetSpellName(206804) or ""]   = 4, -- Rain from Above
		[GetSpellName(1044) or ""]     = 4, -- Blessing of Freedom
		[GetSpellName(290500) or ""]   = 4, -- Wind Waker
		[GetSpellName(199545) or ""]   = 4, -- Steed of Glory
		[GetSpellName(48265) or ""]    = 4, -- Death's Advance
		[GetSpellName(201447) or ""]   = 4, -- Ride the Wind
		[GetSpellName(256948) or ""]   = 4, -- Spatial Rift
		[GetSpellName(213664) or ""]   = 4, -- Nimble Brew
		[GetSpellName(197003) or ""]   = 4, -- Maneuverability
		[GetSpellName(198065) or ""]   = 4, -- Prismatic Cloak
		[GetSpellName(54216) or ""]    = 4, -- Master's Call
		[GetSpellName(115192) or ""]   = 4.1, -- Subterfuge
		[GetSpellName(11327) or ""]    = 4, -- Vanish

		[GetSpellName(12042) or ""]    = 3, -- Arcane Power
		[GetSpellName(29166) or ""]    = 3, -- Innervate
		[GetSpellName(114050) or ""]   = 3, -- Ascendance ele
		[GetSpellName(208997) or ""]   = 3.1, -- Counterstrike Totem
		[GetSpellName(236696) or ""]                     = 3.1, -- Thorns boomy/feral
		[GetSpellName(114051) or ""]   = 3, -- Ascendance enha
		[GetSpellName(114052) or ""]   = 3, -- Ascendance resto
		[GetSpellName(47536) or ""]    = 3.1, -- Rapture
		[GetSpellName(198760) or ""]   = 3, -- Intercept 30% dmg reduc
		[GetSpellName(231895) or ""]   = 3, -- Crusade
		[GetSpellName(194249) or ""]   = 3, -- Voidform
		[GetSpellName(204362) or ""]   = 3.3, -- Heroism
		[GetSpellName(204361) or ""]   = 3.3, -- Bloodlust
		[GetSpellName(12472) or ""]    = 3, -- Icy Veins
		[GetSpellName(51690) or ""]    = 3.1, -- Killing Spree
		[GetSpellName(33891) or ""]    = 3.1, -- Incarnation: Treeform
		[GetSpellName(117679) or ""]   = 3, -- Incarnation: Tree of Life
		[GetSpellName(102560) or ""]   = 3, -- Incarnation: Chosen of Elune
		[GetSpellName(102543) or ""]   = 3, -- Incarnation: King of the Jungle
		[GetSpellName(102558) or ""]   = 3, -- Incarnation: Son of Ursoc
		[GetSpellName(19574) or ""]    = 3, -- Bestial Wrath
		[GetSpellName(190319) or ""]   = 3, -- Combustion
		[GetSpellName(266779) or ""]   = 3, -- Coordinated Assault
		[GetSpellName(1719) or ""]     = 3, -- Recklessness
		[GetSpellName(194223) or ""]   = 3, -- Celestial Alignment
		[GetSpellName(191427) or ""]                     = 3,  -- Metamorphosis talented
		[GetSpellName(162264) or ""]                     = 3,  -- Metamorphosis
		[GetSpellName(187827) or ""]                     = 3,  -- Metamorphosis (tank)
		[GetSpellName(152173) or ""]   = 3, -- Serenity

		[GetSpellName(185422) or ""]   = 2.3, -- Shadow Dance
		[GetSpellName(121471) or ""]   = 2.2, -- Shadow Blades
		[GetSpellName(197871) or ""]   = 2.5, -- Dark Archangel
		[GetSpellName(79140) or ""]    = 2.3, -- Vendetta
		[GetSpellName(198529) or ""]                     = 2.3, -- Plunder Armor
		[GetSpellName(51271) or ""]    = 2.1, -- Pillar of Frost
		[GetSpellName(107574) or ""]   = 2.1, -- Avatar
		[GetSpellName(13750) or ""]    = 2.1, -- Adrenaline Rush
		[GetSpellName(201318) or ""]   = 2.1, -- Fortifying Brew (WW)
		[GetSpellName(243435) or ""]   = 2.1, -- Fortifying Brew (MW)
		[GetSpellName(120954) or ""]   = 2.1, -- Fortifying Brew (BM)
		[GetSpellName(55233) or ""]    = 2.2, -- Vampiric Blood
		[GetSpellName(31884) or ""]    = 2.1, -- Avenging Wrath
		[GetSpellName(207289) or ""]   = 2.1, -- unholy frenzy
		[GetSpellName(216331) or ""]   = 2.1, -- Avenging Crusader
		[GetSpellName(370553) or ""]   = 2.1, -- Tip the Scales
		[GetSpellName(116014) or ""]   = 2, -- Rune of Power
		[GetSpellName(375087) or ""]   = 2, -- Dragonrage
		[GetSpellName(1966) or ""]     = 2.1, -- Feint
		[GetSpellName(288977) or ""]   = 2.1, -- Transfusion
		[GetSpellName(213871) or ""]   = 2.1, -- Bodyguard
		[GetSpellName(223658) or ""]   = 2.2, -- Safeguard dmg reduc
		[GetSpellName(202162) or ""]   = 2.2, -- Guard
		[GetSpellName(201633) or ""]   = 2.2, -- Earthen Totem
		[GetSpellName(122278) or ""]   = 2.2, -- Dampen Harm
		[GetSpellName(207498) or ""]   = 2.1, -- Ancestral Protection
		[GetSpellName(206649) or ""]   = 2, -- Eye of Leotheras

		[GetSpellName(116095) or ""]   = 1.1, -- Disable
		[GetSpellName(221886) or ""]   = 1.1, -- Divine Steed
		[GetSpellName(116841) or ""]   = 1, -- Tiger's Lust
		[GetSpellName(286349) or ""]   = 1, -- Gladiator's Maledict
		[GetSpellName(286342) or ""]                     = 1,  -- Gladiator's Safeguard
		[GetSpellName(277187) or ""]   = 1, -- Gladiator's Emblem
		[GetSpellName(97463) or ""]    = 1, -- Rallying Cry
		[GetSpellName(12975) or ""]    = 1.3, -- Last Stand
		[GetSpellName(202900) or ""]   = 1.3, -- scorpid sting
		[GetSpellName(212552) or ""]   = 1.1, -- Wraith Walk
		[GetSpellName(188501) or ""]   = 1, -- Spectral Sight
		[GetSpellName(5384) or ""]     = 1, -- Feign Death
		[GetSpellName(145629) or ""]   = 1, -- Anti-Magic Zone
		[GetSpellName(81782) or ""]    = 1, -- Disc Barrier
		[GetSpellName(204293) or ""]   = 1, -- Spirit Link
		[GetSpellName(98007) or ""]    = 1, -- Spirit Link Totem
		[GetSpellName(212183) or ""]   = 1, -- Smoke Bomb
		[GetSpellName(202797) or ""]   = 1, -- Viper Sting
		[GetSpellName(197690) or ""]   = 1, -- Defensive Stance
		[GetSpellName(783) or ""]      = 1.1, -- Travel form
		[GetSpellName(5487) or ""]     = 1.1, -- Bear form
		[GetSpellName(768) or ""]      = 1.1, -- Cat form
		[GetSpellName(197625) or ""]   = 1.1, -- Moonkin form 1
		[GetSpellName(24858) or ""]    = 1.1, -- Moonkin form 2
		[GetSpellName(199890) or ""]   = 1, -- Curse of Tongues
		[GetSpellName(199892) or ""]   = 1, -- Curse of Weakness
		[GetSpellName(199954) or ""]   = 1, -- Curse of Fragility
		[GetSpellName(290786) or ""]   = 1, -- Ultimate Retribution
		[GetSpellName(205369) or ""]                     = 1,  -- Mind Bomb pre disorient
		[GetSpellName(200587) or ""]   = 1.2, -- Fel Fissure
		[GetSpellName(198819) or ""]                     = 1.2, -- Sharpen Blade
		[GetSpellName(199845) or ""]                     = 1.2, -- Psyfiend
		[GetSpellName(199483) or ""]                     = 1.2, -- Camouflage
	}
	return auraTable
end

local ClassIcon = Gladius:NewModule("ClassIcon", false, true, {
	classIconAttachTo = "Frame",
	classIconAnchor = "TOPRIGHT",
	classIconRelativePoint = "TOPLEFT",
	classIconAdjustSize = false,
	classIconSize = 40,
	classIconOffsetX = -1,
	classIconOffsetY = 0,
	classIconFrameLevel = 1,
	classIconGloss = true,
	classIconGlossColor = { r = 1, g = 1, b = 1, a = 0.4 },
	classIconImportantAuras = true,
	classIconCrop = false,
	classIconCooldown = false,
	classIconCooldownReverse = false,
	classIconShowSpec = false,
	classIconDetached = false,
	classIconAuras = GetDefaultAuraList(),
})

function ClassIcon:OnEnable()
	self:RegisterEvent("UNIT_AURA")
	self.version = 1
	LSM = Gladius.LSM
	if not self.frame then
		self.frame = {}
	end
	Gladius.db.auraVersion = self.version
end

function ClassIcon:OnDisable()
	self:UnregisterAllEvents()
	for unit in pairs(self.frame) do
		self.frame[unit]:SetAlpha(0)
	end
end

function ClassIcon:GetAttachTo()
	return Gladius.db.classIconAttachTo
end

function ClassIcon:IsDetached()
	return Gladius.db.classIconDetached
end

function ClassIcon:GetFrame(unit)
	return self.frame[unit]
end

function ClassIcon:UNIT_AURA(event, unit)
	if not Gladius:IsValidUnit(unit) then
		return
	end

	-- important auras
	self:UpdateAura(unit)
end

function ClassIcon:UpdateColors(unit)
	self.frame[unit].normalTexture:SetVertexColor(Gladius.db.classIconGlossColor.r, Gladius.db.classIconGlossColor.g,
		Gladius.db.classIconGlossColor.b, Gladius.db.classIconGloss and Gladius.db.classIconGlossColor.a or 0)
end

function ClassIcon:UpdateAura(unit)
	local unitFrame = self.frame[unit]

	if not unitFrame then
		return
	end

	if not Gladius.db.classIconAuras then
		return
	end

	local aura

	for _, auraType in pairs({ 'HELPFUL', 'HARMFUL' }) do
		for i = 1, 40 do
			local name, icon, _, _, duration, expires, _, _, _, spellid = UnitAura(unit, i, auraType)

			if not name then
				break
			end
			local auraList = Gladius.db.classIconAuras
			local priority = auraList[name] or auraList[tostring(spellid)]

			if priority and (not aura or aura.priority < priority) then
				aura = {
					name = name,
					icon = icon,
					duration = duration,
					expires = expires,
					spellid = spellid,
					priority = priority
				}
			end
		end
	end

	if aura and (not unitFrame.aura or (unitFrame.aura.id ~= aura or unitFrame.aura.expires ~= aura.expires)) then
		self:ShowAura(unit, aura)
	elseif not aura then
		self.frame[unit].aura = nil
		self:SetClassIcon(unit)
	end
end

function ClassIcon:ShowAura(unit, aura)
	local unitFrame = self.frame[unit]
	unitFrame.aura = aura

	-- display aura
	unitFrame.texture:SetTexture(aura.icon)
	if Gladius.db.classIconCrop then
		unitFrame.texture:SetTexCoord(0.075, 0.925, 0.075, 0.925)
	else
		unitFrame.texture:SetTexCoord(0, 1, 0, 1)
	end

	local start

	if aura.expires then
		local timeLeft = aura.expires > 0 and aura.expires - GetTime() or 0
		start = GetTime() - (aura.duration - timeLeft)
	end

	Gladius:Call(Gladius.modules.Timer, "SetTimer", unitFrame, aura.duration, start)
end

function ClassIcon:SetClassIcon(unit)
	if not self.frame[unit] then
		return
	end
	Gladius:Call(Gladius.modules.Timer, "HideTimer", self.frame[unit])
	-- get unit class
	local class
	local specIcon
	if not Gladius.test then
		local frame = Gladius:GetUnitFrame(unit)
		class = frame.class
		specIcon = frame.specIcon
	else
		class = Gladius.testing[unit].unitClass
		if not IsWrathClassic then
			local _, _, _, icon = GetSpecializationInfoByID(Gladius.testing[unit].unitSpecId)
			specIcon = icon
		end
	end
	if Gladius.db.classIconShowSpec and not IsWrathClassic then
		if specIcon then
			self.frame[unit].texture:SetTexture(specIcon)
			local left, right, top, bottom = 0, 1, 0, 1
			-- Crop class icon borders
			if Gladius.db.classIconCrop then
				left = left + (right - left) * 0.075
				right = right - (right - left) * 0.075
				top = top + (bottom - top) * 0.075
				bottom = bottom - (bottom - top) * 0.075
			end
			self.frame[unit].texture:SetTexCoord(left, right, top, bottom)
		end
	else
		if class then
			self.frame[unit].texture:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
			local left, right, top, bottom = unpack(CLASS_BUTTONS[class])
			-- Crop class icon borders
			if Gladius.db.classIconCrop then
				left = left + (right - left) * 0.075
				right = right - (right - left) * 0.075
				top = top + (bottom - top) * 0.075
				bottom = bottom - (bottom - top) * 0.075
			end
			self.frame[unit].texture:SetTexCoord(left, right, top, bottom)
		end
	end
end

function ClassIcon:CreateFrame(unit)
	local button = Gladius.buttons[unit]
	if not button then
		return
	end
	-- create frame
	self.frame[unit] = CreateFrame("CheckButton", "Gladius" .. self.name .. "Frame" .. unit, button, "ActionButtonTemplate")
	self.frame[unit]:EnableMouse(false)
	self.frame[unit]:SetNormalTexture("Interface\\AddOns\\Gladius\\Images\\Gloss")
	self.frame[unit].texture = _G[self.frame[unit]:GetName() .. "Icon"]
	self.frame[unit].normalTexture = _G[self.frame[unit]:GetName() .. "NormalTexture"]
	self.frame[unit].cooldown = _G[self.frame[unit]:GetName() .. "Cooldown"]

	-- secure
	local secure = CreateFrame("Button", "Gladius" .. self.name .. "SecureButton" .. unit, button,
		"SecureActionButtonTemplate")
	secure:RegisterForClicks("AnyUp")
	self.frame[unit].secure = secure
end

function ClassIcon:Update(unit)
	-- TODO: check why we need this >_<
	self.frame = self.frame or {}

	-- create frame
	if not self.frame[unit] then
		self:CreateFrame(unit)
	end

	local unitFrame = self.frame[unit]

	-- update frame
	unitFrame:ClearAllPoints()
	local parent = Gladius:GetParent(unit, Gladius.db.classIconAttachTo)
	unitFrame:SetPoint(Gladius.db.classIconAnchor, parent, Gladius.db.classIconRelativePoint, Gladius.db.classIconOffsetX,
		Gladius.db.classIconOffsetY)
	-- frame level
	unitFrame:SetFrameLevel(Gladius.db.classIconFrameLevel)
	if Gladius.db.classIconAdjustSize then
		local height = false
		-- need to rethink that
		--[[for _, module in pairs(Gladius.modules) do
			if module:GetAttachTo() == self.name then
				height = false
			end
		end]]
		if height then
			unitFrame:SetWidth(Gladius.buttons[unit].height)
			unitFrame:SetHeight(Gladius.buttons[unit].height)
		else
			unitFrame:SetWidth(Gladius.buttons[unit].frameHeight)
			unitFrame:SetHeight(Gladius.buttons[unit].frameHeight)
		end
	else
		unitFrame:SetWidth(Gladius.db.classIconSize)
		unitFrame:SetHeight(Gladius.db.classIconSize)
	end

	-- Secure frame
	if self.IsDetached() then
		unitFrame.secure:SetAllPoints(unitFrame)
		unitFrame.secure:SetHeight(unitFrame:GetHeight())
		unitFrame.secure:SetWidth(unitFrame:GetWidth())
		unitFrame.secure:Show()
	else
		unitFrame.secure:Hide()
	end

	unitFrame.texture:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
	-- set frame mouse-interactable area
	local left, right, top, bottom = Gladius.buttons[unit]:GetHitRectInsets()
	if self:GetAttachTo() == "Frame" and not self:IsDetached() then
		if strfind(Gladius.db.classIconRelativePoint, "LEFT") then
			left = -unitFrame:GetWidth() + Gladius.db.classIconOffsetX
		else
			right = -unitFrame:GetWidth() + -Gladius.db.classIconOffsetX
		end
		-- search for an attached frame
		--[[for _, module in pairs(Gladius.modules) do
			if (module.attachTo and module:GetAttachTo() == self.name and module.frame and module.frame[unit]) then
				local attachedPoint = module.frame[unit]:GetPoint()
				if (strfind(Gladius.db.classIconRelativePoint, "LEFT") and (not attachedPoint or (attachedPoint and strfind(attachedPoint, "RIGHT")))) then
					left = left - module.frame[unit]:GetWidth()
				elseif (strfind(Gladius.db.classIconRelativePoint, "LEFT") and (not attachedPoint or (attachedPoint and strfind(attachedPoint, "LEFT")))) then
					right = right - module.frame[unit]:GetWidth()
				end
			end
		end]]
		-- top / bottom
		if unitFrame:GetHeight() > Gladius.buttons[unit]:GetHeight() then
			bottom = -(unitFrame:GetHeight() - Gladius.buttons[unit]:GetHeight()) + Gladius.db.classIconOffsetY
		end
		Gladius.buttons[unit]:SetHitRectInsets(left, right, 0, 0)
		Gladius.buttons[unit].secure:SetHitRectInsets(left, right, 0, 0)
	end
	-- style action button
	unitFrame.normalTexture:SetHeight(unitFrame:GetHeight() + unitFrame:GetHeight() * 0.4)
	unitFrame.normalTexture:SetWidth(unitFrame:GetWidth() + unitFrame:GetWidth() * 0.4)
	unitFrame.normalTexture:ClearAllPoints()
	unitFrame.normalTexture:SetPoint("CENTER", 0, 0)
	unitFrame:SetNormalTexture("Interface\\AddOns\\Gladius\\Images\\Gloss")
	unitFrame.texture:ClearAllPoints()
	unitFrame.texture:SetPoint("TOPLEFT", unitFrame, "TOPLEFT")
	unitFrame.texture:SetPoint("BOTTOMRIGHT", unitFrame, "BOTTOMRIGHT")
	unitFrame.normalTexture:SetVertexColor(Gladius.db.classIconGlossColor.r, Gladius.db.classIconGlossColor.g,
		Gladius.db.classIconGlossColor.b, Gladius.db.classIconGloss and Gladius.db.classIconGlossColor.a or 0)
	unitFrame.texture:SetTexCoord(left, right, top, bottom)

	-- cooldown
	unitFrame.cooldown.isDisabled = not Gladius.db.classIconCooldown
	unitFrame.cooldown:SetReverse(Gladius.db.classIconCooldownReverse)
	Gladius:Call(Gladius.modules.Timer, "RegisterTimer", unitFrame, Gladius.db.classIconCooldown)

	-- hide
	unitFrame:SetAlpha(0)
	self.frame[unit] = unitFrame
end

function ClassIcon:Show(unit)
	local testing = Gladius.test
	-- show frame
	self.frame[unit]:SetAlpha(1)
	-- set class icon
	self:UpdateAura(unit)
end

function ClassIcon:Reset(unit)
	-- reset frame
	self.frame[unit].aura = nil
	self.frame[unit]:SetScript("OnUpdate", nil)
	-- reset cooldown
	self.frame[unit].cooldown:SetCooldown(0, 0)
	-- reset texture
	self.frame[unit].texture:SetTexture("")
	-- hide
	self.frame[unit]:SetAlpha(0)
end

function ClassIcon:ResetModule()
	Gladius.db.classIconAuras = {}
	Gladius.db.classIconAuras = GetDefaultAuraList()
	local newAura = Gladius.options.args[self.name].args.auraList.args.newAura
	Gladius.options.args[self.name].args.auraList.args = {
		newAura = newAura,
	}
	for aura, priority in pairs(Gladius.db.classIconAuras) do
		if priority then
			local isNum = tonumber(aura) ~= nil
			local name = isNum and GetSpellInfo(aura) or aura
			Gladius.options.args[self.name].args.auraList.args[aura] = self:SetupAura(aura, priority, name)
		end
	end
end

function ClassIcon:Test(unit)
	if not Gladius.db.classIconImportantAuras then
		return
	end
	if unit == "arena1" then
		self:ShowAura(unit, {
			icon = select(3, GetSpellInfo(45438)),
			duration = 10
		})
	elseif unit == "arena2" then
		self:ShowAura(unit, {
			icon = select(3, GetSpellInfo(19263)),
			duration = 5
		})
	end
end

function ClassIcon:GetOptions()
	local options = {
		general = {
			type = "group",
			name = L["General"],
			order = 1,
			args = {
				widget = {
					type = "group",
					name = L["Widget"],
					desc = L["Widget settings"],
					inline = true,
					order = 1,
					args = {
						classIconImportantAuras = {
							type = "toggle",
							name = L["Class Icon Important Auras"],
							desc = L["Show important auras instead of the class icon"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						classIconCrop = {
							type = "toggle",
							name = L["Class Icon Crop Borders"],
							desc = L["Toggle if the class icon borders should be cropped or not."],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 6,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 7,
						},
						classIconCooldown = {
							type = "toggle",
							name = L["Class Icon Cooldown Spiral"],
							desc = L["Display the cooldown spiral for important auras"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 10,
						},
						classIconCooldownReverse = {
							type = "toggle",
							name = L["Class Icon Cooldown Reverse"],
							desc = L["Invert the dark/bright part of the cooldown spiral"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 15,
						},
						classIconShowSpec = {
							type = "toggle",
							name = L["Class Icon Spec Icon"],
							desc = L["Shows the specialization icon instead of the class icon"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 16,
						},
						sep2 = {
							type = "description",
							name = "",
							width = "full",
							order = 17,
						},
						classIconGloss = {
							type = "toggle",
							name = L["Class Icon Gloss"],
							desc = L["Toggle gloss on the class icon"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 20,
						},
						classIconGlossColor = {
							type = "color",
							name = L["Class Icon Gloss Color"],
							desc = L["Color of the class icon gloss"],
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							hasAlpha = true,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 25,
						},
						sep3 = {
							type = "description",
							name = "",
							width = "full",
							order = 27,
						},
						classIconFrameLevel = {
							type = "range",
							name = L["Class Icon Frame Level"],
							desc = L["Frame level of the class icon"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							min = 1,
							max = 5,
							step = 1,
							width = "double",
							order = 30,
						},
					},
				},
				size = {
					type = "group",
					name = L["Size"],
					desc = L["Size settings"],
					inline = true,
					order = 2,
					args = {
						classIconAdjustSize = {
							type = "toggle",
							name = L["Class Icon Adjust Size"],
							desc = L["Adjust class icon size to the frame size"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						classIconSize = {
							type = "range",
							name = L["Class Icon Size"],
							desc = L["Size of the class icon"],
							min = 10,
							max = 100,
							step = 1,
							disabled = function()
								return Gladius.dbi.profile.classIconAdjustSize or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 10,
						},
					},
				},
				position = {
					type = "group",
					name = L["Position"],
					desc = L["Position settings"],
					inline = true,
					order = 3,
					args = {
						classIconAttachTo = {
							type = "select",
							name = L["Class Icon Attach To"],
							desc = L["Attach class icon to given frame"],
							values = function()
								return Gladius:GetModules(self.name)
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 5,
						},
						classIconDetached = {
							type = "toggle",
							name = L["Detached from frame"],
							desc = L["Detach the cast bar from the frame itself"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 6,
						},
						classIconPosition = {
							type = "select",
							name = L["Class Icon Position"],
							desc = L["Position of the class icon"],
							values = { ["LEFT"] = L["Left"], ["RIGHT"] = L["Right"] },
							get = function()
								return strfind(Gladius.db.classIconAnchor, "RIGHT") and "LEFT" or "RIGHT"
							end,
							set = function(info, value)
								if (value == "LEFT") then
									Gladius.db.classIconAnchor = "TOPRIGHT"
									Gladius.db.classIconRelativePoint = "TOPLEFT"
								else
									Gladius.db.classIconAnchor = "TOPLEFT"
									Gladius.db.classIconRelativePoint = "TOPRIGHT"
								end
								Gladius:UpdateFrame()
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return Gladius.db.advancedOptions
							end,
							order = 7,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 8,
						},
						classIconAnchor = {
							type = "select",
							name = L["Class Icon Anchor"],
							desc = L["Anchor of the class icon"],
							values = function()
								return Gladius:GetPositions()
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 10,
						},
						classIconRelativePoint = {
							type = "select",
							name = L["Class Icon Relative Point"],
							desc = L["Relative point of the class icon"],
							values = function()
								return Gladius:GetPositions()
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 15,
						},
						sep2 = {
							type = "description",
							name = "",
							width = "full",
							order = 17,
						},
						classIconOffsetX = {
							type = "range",
							name = L["Class Icon Offset X"],
							desc = L["X offset of the class icon"],
							min = -100,
							max = 100,
							step = 1,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 20,
						},
						classIconOffsetY = {
							type = "range",
							name = L["Class Icon Offset Y"],
							desc = L["Y offset of the class icon"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							min = -50,
							max = 50,
							step = 1,
							order = 25,
						},
					},
				},
			},
		},
		auraList = {
			type = "group",
			name = L["Auras"],
			childGroups = "tree",
			order = 3,
			args = {
				newAura = {
					type = "group",
					name = L["New Aura"],
					desc = L["New Aura"],
					inline = true,
					order = 1,
					args = {
						name = {
							type = "input",
							name = L["Name"],
							desc = L["Name of the aura"],
							get = function()
								return self.newAuraName or ""
							end,
							set = function(info, value)
								self.newAuraName = value
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.classIconImportantAuras
							end,
							order = 1,
						},
						priority = {
							type = "range",
							name = L["Priority"],
							desc = L["Select what priority the aura should have - higher equals more priority"],
							get = function()
								return self.newAuraPriority or 0
							end,
							set = function(info, value)
								self.newAuraPriority = value
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.classIconImportantAuras
							end,
							min = 0,
							max = 20,
							step = 1,
							order = 2,
						},
						add = {
							type = "execute",
							name = L["Add new Aura"],
							func = function(info)
								if not self.newAuraName or self.newAuraName == "" then
									return
								end
								if not self.newAuraPriority then
									self.newAuraPriority = 0
								end
								local isNum = tonumber(self.newAuraName) ~= nil
								local name = isNum and GetSpellInfo(self.newAuraName) or self.newAuraName
								Gladius.options.args[self.name].args.auraList.args[self.newAuraName] = self:SetupAura(self.newAuraName,
									self.newAuraPriority, name)
								Gladius.db.classIconAuras[self.newAuraName] = self.newAuraPriority
								self.newAuraName = ""
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.classIconImportantAuras or
										not self.newAuraName or self.newAuraName == ""
							end,
							order = 3,
						},
					},
				},
			},
		},
	}
	for aura, priority in pairs(Gladius.db.classIconAuras) do
		if priority then
			local isNum = tonumber(aura) ~= nil
			local name = isNum and GetSpellInfo(aura) or aura
			options.auraList.args[aura] = self:SetupAura(aura, priority, name)
		end
	end
	return options
end

local function setAura(info, value)
	if info[#(info)] == "name" then
		if info[#(info) - 1] == value then
			return
		end
		-- create new aura
		Gladius.db.classIconAuras[value] = Gladius.db.classIconAuras[info[#(info) - 1]]
		-- delete old aura
		Gladius.db.classIconAuras[info[#(info) - 1]] = nil
		local newAura = Gladius.options.args["ClassIcon"].args.auraList.args.newAura
		Gladius.options.args["ClassIcon"].args.auraList.args = {
			newAura = newAura,
		}
		for aura, priority in pairs(Gladius.db.classIconAuras) do
			if priority then
				local isNum = tonumber(aura) ~= nil
				local name = isNum and GetSpellInfo(aura) or aura
				Gladius.options.args["ClassIcon"].args.auraList.args[aura] = ClassIcon:SetupAura(aura, priority, name)
			end
		end
	else
		Gladius.dbi.profile.classIconAuras[info[#(info) - 1]] = value
	end
end

local function getAura(info)
	if info[#(info)] == "name" then
		return info[#(info) - 1]
	else
		return Gladius.dbi.profile.classIconAuras[info[#(info) - 1]]
	end
end

function ClassIcon:SetupAura(aura, priority, name)
	local name = name or aura
	return {
		type = "group",
		name = name,
		desc = name,
		get = getAura,
		set = setAura,
		args = {
			name = {
				type = "input",
				name = L["Name or ID"],
				desc = L["Name or ID of the aura"],
				order = 1,
				disabled = function()
					return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.classIconImportantAuras
				end,
			},
			priority = {
				type = "range",
				name = L["Priority"],
				desc = L["Select what priority the aura should have - higher equals more priority"],
				min = 0,
				max = 20,
				step = 1,
				order = 2,
				disabled = function()
					return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.classIconImportantAuras
				end,
			},
			delete = {
				type = "execute",
				name = L["Delete"],
				func = function(info)
					local defaults = GetDefaultAuraList()
					if defaults[info[#(info) - 1]] then
						Gladius.db.classIconAuras[info[#(info) - 1]] = false
					else
						Gladius.db.classIconAuras[info[#(info) - 1]] = nil
					end
					local newAura = Gladius.options.args[self.name].args.auraList.args.newAura
					Gladius.options.args[self.name].args.auraList.args = {
						newAura = newAura,
					}
					for aura, priority in pairs(Gladius.db.classIconAuras) do
						if priority then
							local isNum = tonumber(aura) ~= nil
							local name = isNum and GetSpellInfo(aura).name or aura
							Gladius.options.args[self.name].args.auraList.args[aura] = self:SetupAura(aura, priority, name)
						end
					end
				end,
				disabled = function()
					return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.classIconImportantAuras
				end,
				order = 3,
			},
			reset = {
				type = "execute",
				name = L["Reset Auras"],
				func = function(info)
					self:ResetModule()
				end,
				disabled = function()
					return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.classIconImportantAuras
				end,
				order = 4,
			},
		},
	}
end
