--FlameShock Module for Gladius 
--Mavvo
local Gladius = _G.Gladius
if not Gladius then
	DEFAULT_CHAT_FRAME:AddMessage(format("Module %s requires Gladius", "FlameShock"))
end
local L = Gladius.L
local LSM

-- global functions
local _G = _G
local pairs = pairs
local strfind = string.find
local strformat = string.format

local UnitName = UnitName
local UnitClass = UnitClass

local FlameShock = Gladius:NewModule("FlameShock", false, true, {
	FlameShockAttachTo = "Dispell",
	FlameShockAnchor = "TOPLEFT",
	FlameShockRelativePoint = "TOPRIGHT",
	FlameShockGridStyleIcon = false,
	FlameShockGridStyleIconColor = {r = 0, g = 1, b = 0, a = 1},
	FlameShockGridStyleIconUsedColor = {r = 1, g = 0, b = 0, a = 1},
	FlameShockAdjustSize = true,
	FlameShockSize = 52,
	FlameShockOffsetX = 1,
	FlameShockOffsetY = 0,
	FlameShockFrameLevel = 2,
	FlameShockIconCrop = false,
	FlameShockGloss = true,
	FlameShockGlossColor = {r = 1, g = 1, b = 1, a = 0.4},
	FlameShockCooldown = true,
	FlameShockCooldownReverse = false,
	FlameShockFaction = true,
},
{
	"Flame Shock icon",
	"Grid style health bar",
	"Grid style power bar",
})

function FlameShock:OnEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	LSM = Gladius.LSM
	if (not self.frame) then
		self.frame = { }
	end
end

function FlameShock:OnDisable()
	self:UnregisterAllEvents()
	for unit in pairs(self.frame) do
		self.frame[unit]:SetAlpha(0)
	end
end

function FlameShock:OnProfileChanged()
	if Gladius.dbi.profile.modules["FlameShock"] then
		Gladius:EnableModule("FlameShock")
	else
		Gladius:DisableModule("FlameShock")
	end
end

function FlameShock:GetAttachTo()
	return Gladius.db.FlameShockAttachTo
end

function FlameShock:GetFrame(unit)
	return self.frame[unit]
end

function FlameShock:SetTemplate(template)
	if template == 1 then
		-- reset width
		if (Gladius.db.targetBarAttachTo == "HealthBar" and not Gladius.db.healthBarAdjustWidth) then
			Gladius.db.healthBarAdjustWidth = true
		end
		-- reset to default
		for k, v in pairs(self.defaults) do
			Gladius.db[k] = v
		end
	elseif template == 2 then
		if Gladius.db.modules["HealthBar"] then
			if (Gladius.db.healthBarAdjustWidth) then
				Gladius.db.healthBarAdjustWidth = false
				Gladius.db.healthBarWidth = Gladius.db.barWidth - Gladius.db.healthBarHeight
			else
				Gladius.db.healthBarWidth = Gladius.db.healthBarWidth - Gladius.db.healthBarHeight
			end
			Gladius.db.FlameShockGridStyleIcon = true
			Gladius.db.FlameShockAdjustHeight = false
			Gladius.db.FlameShockHeight = Gladius.db.healthBarHeight
			Gladius.db.FlameShockAttachTo = "HealthBar"
			Gladius.db.FlameShockAnchor = "TOPLEFT"
			Gladius.db.FlameShockRelativePoint = "TOPRIGHT"
			Gladius.db.FlameShockOffsetX = 52
			Gladius.db.FlameShockOffsetY = 0
		end
	else
		if Gladius.db.modules["PowerBar"] then
			if (Gladius.db.powerBarAdjustWidth) then
				Gladius.db.powerBarAdjustWidth = false
				Gladius.db.powerBarWidth = Gladius.db.powerBarWidth - Gladius.db.powerBarHeight
			else
				Gladius.db.powerBarWidth = Gladius.db.powerBarWidth - Gladius.db.powerBarHeight
			end
			Gladius.db.FlameShockGridStyleIcon = true
			Gladius.db.FlameShockAdjustHeight = false
			Gladius.db.FlameShockHeight = Gladius.db.powerBarHeight
			Gladius.db.FlameShockAttachTo = "PowerBar"
			Gladius.db.FlameShockAnchor = "TOPLEFT"
			Gladius.db.FlameShockRelativePoint = "TOPRIGHT"
			Gladius.db.FlameShockOffsetX = 52
			Gladius.db.FlameShockOffsetY = 0
		end
	end
end
function FlameShock:GetActualUnit(unitGuid)
	local actualUnit

	if UnitGUID("arena1") == unitGuid then
		actualUnit = "arena1"
	elseif UnitGUID("arena2") == unitGuid then
		actualUnit = "arena2" 
	elseif UnitGUID("arena3") == unitGuid then
		actualUnit = "arena3" 
	elseif UnitGUID("arena4") == unitGuid then
		actualUnit = "arena4" 
	elseif UnitGUID("arena5") == unitGuid then
		actualUnit = "arena5" 
	else
		actualUnit = "noArena12345"
	end

	return actualUnit
end
function FlameShock:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local _, instanceType = IsInInstance()
	if instanceType ~= "arena" then
		return 
	end

	local unit = select(8, ...)  --destguid
	local spell = select(12, ...)
	local source= select(4, ...) --sourceguid
	
	if select(2, ...) == "SPELL_AURA_APPLIED" then
		if (spell ~= 8050 ) then return end 				--track only flame shock
		if (source ~= UnitGUID("player")) then return end 	--only casted by me
		local actualUnit = self:GetActualUnit(unit)
		if (actualUnit == "noArena12345") then return end 	--track only arena12345	
		for i=1,40 do 										--need duration now
			local _,_,_,_,_,duration,_,unitCaster,_,_,spellId = UnitDebuff(actualUnit,i)
			if (spellId == 8050 and UnitIsUnit(unitCaster,"player")) then --find flame shock casted by me
				self:UpdateFlameShock(actualUnit, duration)
				break
			end
		end
	elseif select(2, ...) == "SPELL_AURA_REMOVED" then 		--expires
		if (spell ~= 8050 ) then return end 				--track only flame shock
		if (source ~= UnitGUID("player")) then return end 	--only casted by me
		local actualUnit = self:GetActualUnit(unit)
		if (actualUnit == "noArena12345") then return end 	--track only arena12345	
		
		if (Gladius.db.announcements.FlameShock) then
				Gladius:Call(Gladius.modules.Announcements, "Send", strformat(L["FLAME SHOCK EXPIRED ON: %s (%s)"], UnitName(actualUnit) or "", UnitClass(actualUnit) or ""), 2, actualUnit)
		end
		-- reset cooldown
		self.frame[actualUnit].timeleft = 0					--needed to fix alpha on arena start
		self.frame[actualUnit]:SetScript("OnUpdate", nil)
		Gladius:Call(Gladius.modules.Timer, "HideTimer", self.frame[actualUnit])
		
		if (not Gladius.db.FlameShockGridStyleIcon) then
			self.frame[actualUnit]:SetAlpha(0.1)
		end
	elseif select(2, ...) == "SPELL_DISPEL" then 
		local extraSpellID = select(15,...)
		if (extraSpellID ~= 8050 ) then return end 			--track only flame shock dispels
		local actualUnit = self:GetActualUnit(unit)
		if (actualUnit == "noArena12345") then return end 	--track only arena12345	
					
		for i=1,40 do										--check if the dispelled flameshock was mine
			local _,_,_,_,_,duration,_,unitCaster,_,_,spellId = UnitDebuff(actualUnit,i)
			if (spellId == 8050 and UnitIsUnit(unitCaster,"player")) then
				return 										-- we still have a flameshock up on that unit
			end
		end

		if (Gladius.db.announcements.FlameShock) then
				Gladius:Call(Gladius.modules.Announcements, "Send", strformat(L["FLAME SHOCK DISPELLED ON: %s (%s)"], UnitName(actualUnit) or "", UnitClass(actualUnit) or ""), 2, actualUnit)
		end
		-- reset cooldown
		self.frame[actualUnit].timeleft = 0					--needed to fix alpha on arena start
		self.frame[actualUnit]:SetScript("OnUpdate", nil)
		Gladius:Call(Gladius.modules.Timer, "HideTimer", self.frame[actualUnit])
		
		if (not Gladius.db.FlameShockGridStyleIcon) then
			self.frame[actualUnit]:SetAlpha(0.1)
		end
	elseif select(2, ...) == "SPELL_AURA_REFRESH" then
		if (spell ~= 8050 ) then return end 				--track only flame shock
		if (source ~= UnitGUID("player")) then return end 	--only casted by me
		local actualUnit = self:GetActualUnit(unit)
		if (actualUnit == "noArena12345") then return end 	--track only arena12345			
		
		for i=1,40 do
			local _,_,_,_,_,duration,_,unitCaster,_,_,spellId = UnitDebuff(actualUnit,i)
			if (spellId == 8050 and UnitIsUnit(unitCaster,"player")) then				
				self:UpdateFlameShock(actualUnit, duration)
				break
			end
		end
	end
end


function FlameShock:UpdateFlameShock(unit, duration)
	
	-- grid style icon
	if (Gladius.db.FlameShockGridStyleIcon) then
		self.frame[unit].texture:SetVertexColor(Gladius.db.FlameShockGridStyleIconUsedColor.r, Gladius.db.FlameShockGridStyleIconUsedColor.g, Gladius.db.FlameShockGridStyleIconUsedColor.b, Gladius.db.FlameShockGridStyleIconUsedColor.a)
	else
		self.frame[unit]:SetAlpha(1)
	end
	-- announcement
	if (Gladius.db.announcements.FlameShock) then
		Gladius:Call(Gladius.modules.Announcements, "Send", strformat(L["FLAME SHOCK APPLIED ON: %s (%s)"], UnitName(unit) or "test", UnitClass(unit) or "test"), 2, unit)
	end
	
	self.frame[unit].timeleft = duration
	self.frame[unit]:SetScript("OnUpdate", function(f, elapsed)
		self.frame[unit].timeleft = self.frame[unit].timeleft - elapsed
		if (self.frame[unit].timeleft <= 0) then
			-- FlameShock
			if (Gladius.db.FlameShockGridStyleIcon) then
				self.frame[unit].texture:SetVertexColor(Gladius.db.FlameShockGridStyleIconColor.r, Gladius.db.FlameShockGridStyleIconColor.g, Gladius.db.FlameShockGridStyleIconColor.b, Gladius.db.FlameShockGridStyleIconColor.a)
			else
				self.frame[unit]:SetAlpha(0.1)
			end
			-- announcement
			if (Gladius.db.announcements.FlameShock) then
				Gladius:Call(Gladius.modules.Announcements, "Send", strformat(L["FLAME SHOCK GONE ON: %s (%s)"], UnitName(unit) or "", UnitClass(unit) or ""), 2, unit)
			end
			self.frame[unit]:SetScript("OnUpdate", nil)
		end
	end)
	
	-- cooldown
	Gladius:Call(Gladius.modules.Timer, "SetTimer", self.frame[unit], duration)
end

function FlameShock:UpdateColors(unit)
	if Gladius.db.FlameShockGridStyleIcon then
		self.frame[unit].texture:SetVertexColor(Gladius.db.FlameShockGridStyleIconUsedColor.r, Gladius.db.FlameShockGridStyleIconUsedColor.g, Gladius.db.FlameShockGridStyleIconUsedColor.b, Gladius.db.FlameShockGridStyleIconUsedColor.a)
	end
	self.frame[unit].normalTexture:SetVertexColor(Gladius.db.FlameShockGlossColor.r, Gladius.db.FlameShockGlossColor.g, Gladius.db.FlameShockGlossColor.b, Gladius.db.dispellGloss and Gladius.db.FlameShockGlossColor.a or 0)
end

function FlameShock:CreateFrame(unit)
	local button = Gladius.buttons[unit]
	if (not button) then
		return
	end
	-- create frame
	self.frame[unit] = CreateFrame("CheckButton", "Gladius"..self.name.."Frame"..unit, button, "ActionButtonTemplate")
	self.frame[unit]:EnableMouse(false)
	self.frame[unit]:SetNormalTexture("Interface\\AddOns\\Gladius\\Images\\Gloss")
	self.frame[unit].texture = _G[self.frame[unit]:GetName().."Icon"]
	self.frame[unit].normalTexture = _G[self.frame[unit]:GetName().."NormalTexture"]
	self.frame[unit].cooldown = _G[self.frame[unit]:GetName().."Cooldown"]
end

function FlameShock:Update(unit)
	-- create frame
	if (not self.frame[unit]) then
		self:CreateFrame(unit)
	end
	-- update frame
	self.frame[unit]:ClearAllPoints()
	-- anchor point 
	local parent = Gladius:GetParent(unit, Gladius.db.FlameShockAttachTo)
	self.frame[unit]:SetPoint(Gladius.db.FlameShockAnchor, parent, Gladius.db.FlameShockRelativePoint, Gladius.db.FlameShockOffsetX, Gladius.db.FlameShockOffsetY)
	-- frame level
	self.frame[unit]:SetFrameLevel(Gladius.db.FlameShockFrameLevel)
	if Gladius.db.FlameShockAdjustSize then
		if self:GetAttachTo() == "Frame" then
			local height = false
			-- need to rethink that
			--[[for _, module in pairs(Gladius.modules) do
				if (module:GetAttachTo() == self.name) then
					height = false
				end
			end]]
			if height then
				self.frame[unit]:SetWidth(Gladius.buttons[unit].height)
				self.frame[unit]:SetHeight(Gladius.buttons[unit].height)
			else
				self.frame[unit]:SetWidth(Gladius.buttons[unit].frameHeight)
				self.frame[unit]:SetHeight(Gladius.buttons[unit].frameHeight)
			end
		else
			self.frame[unit]:SetWidth(Gladius:GetModule(self:GetAttachTo()).frame[unit]:GetHeight() or 1)
			self.frame[unit]:SetHeight(Gladius:GetModule(self:GetAttachTo()).frame[unit]:GetHeight() or 1)
		end
	else
		self.frame[unit]:SetWidth(Gladius.db.FlameShockSize)
		self.frame[unit]:SetHeight(Gladius.db.FlameShockSize)
	end
	-- set frame mouse-interactable area
	if self:GetAttachTo() == "Frame" then
	local left, right, top, bottom = Gladius.buttons[unit]:GetHitRectInsets()
	if strfind(Gladius.db.FlameShockRelativePoint, "LEFT") then
		left = -self.frame[unit]:GetWidth() + Gladius.db.FlameShockOffsetX
	else
		right = -self.frame[unit]:GetWidth() + -Gladius.db.FlameShockOffsetX
	end
	-- top / bottom
	if self.frame[unit]:GetHeight() > Gladius.buttons[unit]:GetHeight() then
		bottom = - (self.frame[unit]:GetHeight() - Gladius.buttons[unit]:GetHeight()) + Gladius.db.FlameShockOffsetY
	end
		Gladius.buttons[unit]:SetHitRectInsets(left, right, 0, 0)
		Gladius.buttons[unit].secure:SetHitRectInsets(left, right, 0, 0)
	end
	-- style action button
	self.frame[unit].normalTexture:SetHeight(self.frame[unit]:GetHeight() + self.frame[unit]:GetHeight() * 0.4)
	self.frame[unit].normalTexture:SetWidth(self.frame[unit]:GetWidth() + self.frame[unit]:GetWidth() * 0.4)
	self.frame[unit].normalTexture:ClearAllPoints()
	self.frame[unit].normalTexture:SetPoint("CENTER", 0, 0)
	self.frame[unit]:SetNormalTexture("Interface\\AddOns\\Gladius\\Images\\Gloss")
	self.frame[unit].texture:ClearAllPoints()
	self.frame[unit].texture:SetPoint("TOPLEFT", self.frame[unit], "TOPLEFT")
	self.frame[unit].texture:SetPoint("BOTTOMRIGHT", self.frame[unit], "BOTTOMRIGHT")
	if not Gladius.db.FlameShockIconCrop and not Gladius.db.FlameShockGridStyleIcon then
		self.frame[unit].texture:SetTexCoord(0, 1, 0, 1)
	else
		self.frame[unit].texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	end
	self.frame[unit].normalTexture:SetVertexColor(Gladius.db.FlameShockGlossColor.r, Gladius.db.FlameShockGlossColor.g, Gladius.db.FlameShockGlossColor.b, Gladius.db.FlameShockGloss and Gladius.db.FlameShockGlossColor.a or 0)
	-- cooldown
	if Gladius.db.FlameShockCooldown then
		self.frame[unit].cooldown:Show()
	else
		self.frame[unit].cooldown:Hide()
	end
	self.frame[unit].cooldown:SetReverse(Gladius.db.FlameShockCooldownReverse)
	Gladius:Call(Gladius.modules.Timer, "RegisterTimer", self.frame[unit], Gladius.db.FlameShockCooldown)
	-- hide
	self.frame[unit]:SetAlpha(0)
end

function FlameShock:Show(unit)
	-- show frame
	if (Gladius.db.FlameShockGridStyleIcon) then
		self.frame[unit]:SetAlpha(1)
		self.frame[unit].texture:SetTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, "minimalist"))
		self.frame[unit].texture:SetVertexColor(Gladius.db.FlameShockGridStyleIconColor.r, Gladius.db.FlameShockGridStyleIconColor.g, Gladius.db.FlameShockGridStyleIconColor.b, Gladius.db.FlameShockGridStyleIconColor.a)
	else
		if (self.frame[unit].timeleft == nil or self.frame[unit].timeleft <= 0) then
			self.frame[unit]:SetAlpha(0.1)
		else
			self.frame[unit]:SetAlpha(1)
		end
		local FlameShockIcon = "Interface\\Icons\\spell_fire_flameshock"
	
		self.frame[unit].texture:SetTexture(FlameShockIcon)
		if (Gladius.db.FlameShockIconCrop) then
			self.frame[unit].texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		end
		self.frame[unit].texture:SetVertexColor(1, 1, 1, 1)
	end
end

function FlameShock:Reset(unit)
	if not self.frame[unit] then
		return
	end
	-- reset frame
	local FlameShockIcon
	FlameShockIcon = "Interface\\Icons\\spell_fire_flameshock"
	
	self.frame[unit].texture:SetTexture(FlameShockIcon)
	if Gladius.db.FlameShockIconCrop then
		self.frame[unit].texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	end
	-- reset cooldown
	self.frame[unit].timeleft = 0
	self.frame[unit]:SetScript("OnUpdate", nil)
	Gladius:Call(Gladius.modules.Timer, "HideTimer", self.frame[unit])
	-- hide
	self.frame[unit]:SetAlpha(0)
end

function FlameShock:Test(unit)
	-- test
	if (unit == "arena1") then
		self:UpdateFlameShock(unit, 30)
	end
	if (unit == "arena2") then
		self:UpdateFlameShock(unit, 24)
	end
	if (unit == "arena3") then
		self:UpdateFlameShock(unit, 15)
	end
	if (unit == "arena4") then
		self:UpdateFlameShock(unit, 5)
	end
end

-- Add the announcement toggle
function FlameShock:OptionsLoad()
	Gladius.options.args.Announcements.args.general.args.announcements.args.FlameShock = {
		type = "toggle",
		name = L["Flame Shock"],
		desc = L["Shows if the enemy has flame shock."],
		disabled = function()
			return not Gladius.db.modules[self.name]
		end,
	}
end

function FlameShock:GetOptions()
	return {
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
						FlameShockGridStyleIcon = {
							type = "toggle",
							name = L["Flame shock Grid Style Icon"],
							desc = L["Toggle flame shock grid style icon"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 7,
						},
						FlameShockGridStyleIconColor = {
							type = "color",
							name = L["Flame shock Grid Style Icon Color"],
							desc = L["Color of the flame shock grid style icon"],
							hasAlpha = true,
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							disabled = function()
								return not Gladius.dbi.profile.FlameShockGridStyleIcon or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 10,
						}, 
						FlameShockGridStyleIconUsedColor = {
							type = "color",
							name = L["Flame shock Grid Style Icon Used Color"],
							desc = L["Color of the flame shock grid style icon when it's on cooldown"],
							hasAlpha = true,
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							disabled = function()
								return not Gladius.dbi.profile.FlameShockGridStyleIcon or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 12,
						},
						sep1 = {
							type = "description",
							name = "",
							width = "full",
							order = 13,
						},
						FlameShockCooldown = {
							type = "toggle",
							name = L["Flame shock Cooldown Spiral"],
							desc = L["Display the cooldown spiral for important auras"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 15,
						},
						FlameShockCooldownReverse = {
							type = "toggle",
							name = L["Flame shock Cooldown Reverse"],
							desc = L["Invert the dark/bright part of the cooldown spiral"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 20,
						},
						sep2 = {
							type = "description",
							name = "",
							width = "full",
							order = 23,
						},
						FlameShockGloss = {
							type = "toggle",
							name = L["Flame shock Gloss"],
							desc = L["Toggle gloss on the flame shock icon"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 25,
						},
						FlameShockGlossColor = {
							type = "color",
							name = L["Flame shock Gloss Color"],
							desc = L["Color of the flame shock icon gloss"],
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
							order = 30,
						},
						sep3 = {
							type = "description",
							name = "",
							width = "full",
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 33,
						},
						FlameShockIconCrop = {
							type = "toggle",
							name = L["Flame shock Icon Border Crop"],
							desc = L["Toggle if the borders of the flame shock icon should be cropped"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 35,
						},
						FlameShockFaction = {
							type = "toggle",
							name = L["Flame shock Icon Faction"],
							desc = L["Toggle if the flame shock icon should be changing based on the opponents faction"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 40,
						},
						sep3 = {
							type = "description",
							name = "",
							width = "full",
							order = 43,
						},
						FlameShockFrameLevel = {
							type = "range",
							name = L["Flame shock Frame Level"],
							desc = L["Frame level of the flame shock"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							min = 1, max = 5, step = 1,
							width = "double",
							order = 45,
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
						FlameShockAdjustSize = {
							type = "toggle",
							name = L["Flame shock Adjust Size"],
							desc = L["Adjust flame shock size to the frame size"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						FlameShockSize = {
							type = "range",
							name = L["Flame shock Size"],
							desc = L["Size of the flame shock"],
							min = 10, max = 100, step = 1,
							disabled = function()
								return Gladius.dbi.profile.FlameShockAdjustSize or not Gladius.dbi.profile.modules[self.name]
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
						FlameShockAttachTo = {
							type = "select",
							name = L["Flame shock Attach To"],
							desc = L["Attach flame shock to the given frame"],
							values = function()
								return Gladius:GetModules(self.name)
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							arg = "general",
							order = 5,
						},
						FlameShockPosition = {
							type = "select",
							name = L["Flame shock Position"],
							desc = L["Position of the flame shock"],
							values={["LEFT"] = L["Left"], ["RIGHT"] = L["Right"]},
							get = function()
								return strfind(Gladius.db.FlameShockAnchor, "RIGHT") and "LEFT" or "RIGHT"
							end,
							set = function(info, value)
								if (value == "LEFT") then
									Gladius.db.FlameShockAnchor = "TOPRIGHT"
									Gladius.db.FlameShockRelativePoint = "TOPLEFT"
								else
									Gladius.db.FlameShockAnchor = "TOPLEFT"
									Gladius.db.FlameShockRelativePoint = "TOPRIGHT"
								end
								Gladius:UpdateFrame(info[1])
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return Gladius.db.advancedOptions
							end,
							order = 6,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 7,
						},
						FlameShockAnchor = {
							type = "select",
							name = L["Flame shock Anchor"],
							desc = L["Anchor of the flame shock"],
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
						FlameShockRelativePoint = {
							type = "select",
							name = L["Flame shock Relative Point"],
							desc = L["Relative point of the flame shock"],
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
						FlameShockOffsetX = {
							type = "range",
							name = L["Flame shock Offset X"],
							desc = L["X offset of the flame shock"],
							min = - 100, max = 100, step = 1,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 20,
						},
						FlameShockOffsetY = {
							type = "range",
							name = L["Flame shock Offset Y"],
							desc = L["Y offset of the flame shock"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							min = - 50, max = 50, step = 1,
							order = 25,
						},
					},
				},
			},
		},
	}
end