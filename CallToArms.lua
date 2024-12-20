local format = format
local next = next
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local RequestLFDPlayerLockInfo = RequestLFDPlayerLockInfo
local GetLFGRoleShortageRewards = GetLFGRoleShortageRewards
local LFG_ROLE_NUM_SHORTAGE_TYPES = LFG_ROLE_NUM_SHORTAGE_TYPES
local BATTLEGROUND_HOLIDAY = BATTLEGROUND_HOLIDAY
local GetModifiedInstanceInfoFromMapID

if C_ModifiedInstance then
	GetModifiedInstanceInfoFromMapID = C_ModifiedInstance.GetModifiedInstanceInfoFromMapID
end

local Class = select(2, UnitClass("player"))
local Level = UnitLevel("player")
local RoleNames = {TANK, HEALER, DAMAGER}
local RoleIcons = {"Interface\\Icons\\Ability_warrior_defensivestance", "Interface\\Icons\\spell_chargepositive", "Interface\\Icons\\ability_throw"}
local UpdateInt = 60
local CombatTime = 0
local MAX_SHOWN = 10
local Locale = GetLocale()
local ID, Name, SubType, Min, Max, Timewalking, _
local ForAll, ForPlayer

local BlankTexture = "Interface\\AddOns\\CallToArms\\HydraUIBlank.tga"
local BarTexture = "Interface\\AddOns\\CallToArms\\HydraUI4.tga"
local Font = "Interface\\Addons\\CallToArms\\PTSans.ttf"

local Index = function(self, key)
	return key
end

local L = setmetatable({}, {__index = Index})

if (Locale == "deDE") then -- German
	L["|cffeaeaeaCall To Arms: %s %s bonus is active!|r"] = "|cffeaeaeaCall To Arms: %s %s bonus is active!|r"
	L["|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"] = "|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"
	L["|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"] = "|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"
	L["Set update interval (seconds)"] = "Set update interval (seconds)"
	L["Set window transparency"] = "Set window transparency"
	L["Announce bonuses beginning"] = "Announce bonuses beginning"
	L["Announce bonuses ending"] = "Announce bonuses ending"
	L["Filter roles you cannot perform"] = "Filter roles you cannot perform"
	L["Auto minimize in groups"] = "Auto minimize in groups"
	L["Play sound"] = "Play sound"
	L["Still scanning for dungeons. Try again in a moment."] = "Still scanning for dungeons. Try again in a moment."
elseif (Locale == "esES") then -- Spanish (Spain)
	L["|cffeaeaeaCall To Arms: %s %s bonus is active!|r"] = "|cffeaeaeaCall To Arms: %s %s bonus is active!|r"
	L["|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"] = "|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"
	L["|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"] = "|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"
	L["Set update interval (seconds)"] = "Set update interval (seconds)"
	L["Set window transparency"] = "Set window transparency"
	L["Announce bonuses beginning"] = "Announce bonuses beginning"
	L["Announce bonuses ending"] = "Announce bonuses ending"
	L["Filter roles you cannot perform"] = "Filter roles you cannot perform"
	L["Auto minimize in groups"] = "Auto minimize in groups"
	L["Play sound"] = "Play sound"
	L["Still scanning for dungeons. Try again in a moment."] = "Still scanning for dungeons. Try again in a moment."
elseif (Locale == "esMX") then -- Spanish (Mexico)
	L["|cffeaeaeaCall To Arms: %s %s bonus is active!|r"] = "|cffeaeaeaCall To Arms: %s %s bonus is active!|r"
	L["|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"] = "|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"
	L["|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"] = "|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"
	L["Set update interval (seconds)"] = "Set update interval (seconds)"
	L["Set window transparency"] = "Set window transparency"
	L["Announce bonuses beginning"] = "Announce bonuses beginning"
	L["Announce bonuses ending"] = "Announce bonuses ending"
	L["Filter roles you cannot perform"] = "Filter roles you cannot perform"
	L["Auto minimize in groups"] = "Auto minimize in groups"
	L["Play sound"] = "Play sound"
	L["Still scanning for dungeons. Try again in a moment."] = "Still scanning for dungeons. Try again in a moment."
elseif (Locale == "frFR") then -- French
	L["|cffeaeaeaCall To Arms: %s %s bonus is active!|r"] = "|cffeaeaeaCall To Arms: %s %s bonus is active!|r"
	L["|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"] = "|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"
	L["|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"] = "|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"
	L["Set update interval (seconds)"] = "Set update interval (seconds)"
	L["Set window transparency"] = "Set window transparency"
	L["Announce bonuses beginning"] = "Announce bonuses beginning"
	L["Announce bonuses ending"] = "Announce bonuses ending"
	L["Filter roles you cannot perform"] = "Filter roles you cannot perform"
	L["Auto minimize in groups"] = "Auto minimize in groups"
	L["Play sound"] = "Play sound"
	L["Still scanning for dungeons. Try again in a moment."] = "Still scanning for dungeons. Try again in a moment."
elseif (Locale == "itIT") then -- Italian
	L["|cffeaeaeaCall To Arms: %s %s bonus is active!|r"] = "|cffeaeaeaCall To Arms: %s %s bonus is active!|r"
	L["|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"] = "|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"
	L["|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"] = "|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"
	L["Set update interval (seconds)"] = "Set update interval (seconds)"
	L["Set window transparency"] = "Set window transparency"
	L["Announce bonuses beginning"] = "Announce bonuses beginning"
	L["Announce bonuses ending"] = "Announce bonuses ending"
	L["Filter roles you cannot perform"] = "Filter roles you cannot perform"
	L["Auto minimize in groups"] = "Auto minimize in groups"
	L["Play sound"] = "Play sound"
	L["Still scanning for dungeons. Try again in a moment."] = "Still scanning for dungeons. Try again in a moment."
elseif (Locale == "koKR") then -- Korean
	L["|cffeaeaeaCall To Arms: %s %s bonus is active!|r"] = "|cffeaeaeaCall To Arms: %s %s bonus is active!|r"
	L["|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"] = "|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"
	L["|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"] = "|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"
	L["Set update interval (seconds)"] = "Set update interval (seconds)"
	L["Set window transparency"] = "Set window transparency"
	L["Announce bonuses beginning"] = "Announce bonuses beginning"
	L["Announce bonuses ending"] = "Announce bonuses ending"
	L["Filter roles you cannot perform"] = "Filter roles you cannot perform"
	L["Auto minimize in groups"] = "Auto minimize in groups"
	L["Play sound"] = "Play sound"
	L["Still scanning for dungeons. Try again in a moment."] = "Still scanning for dungeons. Try again in a moment."

	Font = "Fonts\\2002.ttf"
elseif (Locale == "ptBR") then -- Portuguese (Brazil)
	L["|cffeaeaeaCall To Arms: %s %s bonus is active!|r"] = "|cffeaeaeaCall To Arms: %s %s bonus is active!|r"
	L["|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"] = "|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"
	L["|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"] = "|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"
	L["Set update interval (seconds)"] = "Set update interval (seconds)"
	L["Set window transparency"] = "Set window transparency"
	L["Announce bonuses beginning"] = "Announce bonuses beginning"
	L["Announce bonuses ending"] = "Announce bonuses ending"
	L["Filter roles you cannot perform"] = "Filter roles you cannot perform"
	L["Auto minimize in groups"] = "Auto minimize in groups"
	L["Play sound"] = "Play sound"
	L["Still scanning for dungeons. Try again in a moment."] = "Still scanning for dungeons. Try again in a moment."
elseif (Locale == "ruRU") then -- Russian
	L["|cffeaeaeaCall To Arms: %s %s bonus is active!|r"] = "|cffeaeaeaПризыв к оружию: %s Бонус %s активен!|r"
	L["|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"] = "|cffeaeaeaПризыв к оружию: %s Бонус %s закончился.|r"
	L["|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"] = "|cffeaeaeaПризыв к оружию: Ваш класс не может выполнять роль %s.|r"
	L["Set update interval (seconds)"] = "Установить интервал обновления (секунды)"
	L["Set window transparency"] = "Установить прозрачность окна"
	L["Announce bonuses beginning"] = "Сообщать о старте бонусов"
	L["Announce bonuses ending"] = "Сообщать об окончании бонусов"
	L["Filter roles you cannot perform"] = "Фильтр ролей, которые вы не можете выполнять"
	L["Auto minimize in groups"] = "Автоматическое сворачивание в группах"
	L["Play sound"] = "Воспроизвести звук"
	L["Still scanning for dungeons. Try again in a moment."] = "Все еще сканирую подземелья. Попробуйте еще раз через минуту."
elseif (Locale == "zhCN") then -- Chinese (Simplified)
	L["|cffeaeaeaCall To Arms: %s %s bonus is active!|r"] = "|cffeaeaeaCall To Arms: %s %s bonus is active!|r"
	L["|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"] = "|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"
	L["|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"] = "|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"
	L["Set update interval (seconds)"] = "Set update interval (seconds)"
	L["Set window transparency"] = "Set window transparency"
	L["Announce bonuses beginning"] = "Announce bonuses beginning"
	L["Announce bonuses ending"] = "Announce bonuses ending"
	L["Filter roles you cannot perform"] = "Filter roles you cannot perform"
	L["Auto minimize in groups"] = "Auto minimize in groups"
	L["Play sound"] = "Play sound"
	L["Still scanning for dungeons. Try again in a moment."] = "Still scanning for dungeons. Try again in a moment."

	Font = "Fonts\\ARHei.ttf"
elseif (Locale == "zhTW") then -- Chinese (Traditional/Taiwan)
	L["|cffeaeaeaCall To Arms: %s %s bonus is active!|r"] = "|cffeaeaeaCall To Arms: %s %s bonus is active!|r"
	L["|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"] = "|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"
	L["|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"] = "|cffeaeaeaCall To Arms: Your class cannot perform the role of %s.|r"
	L["Set update interval (seconds)"] = "Set update interval (seconds)"
	L["Set window transparency"] = "Set window transparency"
	L["Announce bonuses beginning"] = "Announce bonuses beginning"
	L["Announce bonuses ending"] = "Announce bonuses ending"
	L["Filter roles you cannot perform"] = "Filter roles you cannot perform"
	L["Auto minimize in groups"] = "Auto minimize in groups"
	L["Play sound"] = "Play sound"
	L["Still scanning for dungeons. Try again in a moment."] = "Still scanning for dungeons. Try again in a moment."

	Font = "Fonts\\bLEI00D.ttf"
end

local Settings = {
	AnnounceStart = false,
	AnnounceEndings = false,
	UpdateInterval = 45,
	WindowAlpha = 1,
	FilterRole = false,
	HideInGroup = true,
	MinimizeInGroup = false,
	PlaySound = true,
	Minimized = false,
	GrowDown = true,
}

local Rename = {
	[744] = PLAYER_DIFFICULTY_TIMEWALKER, -- Random Timewalking Dungeon (Burning Crusade) --> Timewalking
	[995] = PLAYER_DIFFICULTY_TIMEWALKER, -- Random Timewalking Dungeon (Wrath of the Lich King) --> Timewalking
	[1146] = PLAYER_DIFFICULTY_TIMEWALKER, -- Random Timewalking Dungeon (Cataclysm) --> Timewalking
	[1453] = PLAYER_DIFFICULTY_TIMEWALKER, -- Random Timewalking Dungeon (Mists of Pandaria) --> Timewalking
	[1971] = PLAYER_DIFFICULTY_TIMEWALKER, -- Random Timewalking Dungeon (Warlords of Draenor) --> Timewalking
	[2274] = PLAYER_DIFFICULTY_TIMEWALKER, -- Random Timewalking Dungeon (Legion) --> Timewalking
	[2350] = LFG_TYPE_RANDOM_DUNGEON, -- Random Dungeon (Dragonflight) --> Random Dungeon
	[2351] = LFG_TYPE_HEROIC_DUNGEON, -- Random Dungeon (Dragonflight) --> Heroic Dungeon
}

local ClassRoleMap = {-- CanTank, CanHeal
	DEATHKNIGHT = {true, false},
	DEMONHUNTER = {true, false},
	DRUID =       {true, true},
	EVOKER =      {false, true},
	HUNTER =      {false, false},
	MAGE =        {false, false},
	MONK =        {true, true},
	PALADIN =     {true, true},
	PRIEST =      {false, true},
	ROGUE =       {false, false},
	SHAMAN =      {false, true},
	WARLOCK =     {false, false},
	WARRIOR =     {true, false},
}

local Outline = {
	bgFile = BlankTexture,
	edgeFile = BlankTexture,
	edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local CallToArms = CreateFrame("Frame", "CallToArmsGlobal", UIParent)
CallToArms:SetSize(130, 18)
CallToArms:SetPoint("LEFT", UIParent, 8, 0)
CallToArms:SetMovable(true)
CallToArms:EnableMouse(true)
CallToArms:SetUserPlaced(true)
CallToArms:RegisterForDrag("LeftButton")
CallToArms:SetScript("OnDragStart", CallToArms.StartMoving)
CallToArms:SetScript("OnDragStop", CallToArms.StopMovingOrSizing)
CallToArms.Ready = false
CallToArms.Ela = 0
CallToArms.NumActive = 0
CallToArms.NumHeaders = 0
CallToArms.Headers = {}
CallToArms.HeaderIDs = {}

CallToArms.BG = CallToArms:CreateTexture(nil, "BORDER")
CallToArms.BG:SetPoint("TOPLEFT", CallToArms, -1, 1)
CallToArms.BG:SetPoint("BOTTOMRIGHT", CallToArms, 1, -1)
CallToArms.BG:SetTexture(BlankTexture)
CallToArms.BG:SetVertexColor(0, 0, 0)

CallToArms.Texture = CallToArms:CreateTexture(nil, "ARTWORK")
CallToArms.Texture:SetPoint("TOPLEFT", CallToArms, 0, 0)
CallToArms.Texture:SetPoint("BOTTOMRIGHT", CallToArms, 0, 0)
CallToArms.Texture:SetTexture(BarTexture)
CallToArms.Texture:SetVertexColor(0.25, 0.25, 0.25)

CallToArms.Text = CallToArms:CreateFontString(nil, "OVERLAY")
CallToArms.Text:SetPoint("LEFT", CallToArms, 4, -0.5)
CallToArms.Text:SetFont(Font, 12, "")
CallToArms.Text:SetJustifyH("LEFT")
CallToArms.Text:SetShadowColor(0, 0, 0)
CallToArms.Text:SetShadowOffset(1, -1)
CallToArms.Text:SetText(BATTLEGROUND_HOLIDAY)
CallToArms.Text:SetTextColor(0.92, 0.92, 0.92)

CallToArms.CloseButton = CreateFrame("Frame", nil, CallToArms)
CallToArms.CloseButton:SetPoint("TOPRIGHT", CallToArms, 0, 0)
CallToArms.CloseButton:SetSize(18, 18)
CallToArms.CloseButton:SetScript("OnEnter", function(self) self.Texture:SetVertexColor(1, 0, 0) end)
CallToArms.CloseButton:SetScript("OnLeave", function(self) self.Texture:SetVertexColor(0.92, 0.92, 0.92) end)
CallToArms.CloseButton:SetScript("OnMouseUp", function() CallToArms:Hide() end)

CallToArms.CloseButton.Texture = CallToArms.CloseButton:CreateTexture(nil, "OVERLAY")
CallToArms.CloseButton.Texture:SetPoint("CENTER", CallToArms.CloseButton, 0, 0)
CallToArms.CloseButton.Texture:SetTexture("Interface\\AddOns\\CallToArms\\HydraUIClose.tga")
CallToArms.CloseButton.Texture:SetVertexColor(0.92, 0.92, 0.92)

CallToArms.ToggleButton = CreateFrame("Frame", nil, CallToArms)
CallToArms.ToggleButton:SetPoint("RIGHT", CallToArms.CloseButton, "LEFT", 0, -0.5)
CallToArms.ToggleButton:SetSize(18, 18)
CallToArms.ToggleButton:SetScript("OnEnter", function(self) self.Texture:SetVertexColor(1, 0, 0) end)
CallToArms.ToggleButton:SetScript("OnLeave", function(self) self.Texture:SetVertexColor(0.92, 0.92, 0.92) end)
CallToArms.ToggleButton:SetScript("OnMouseUp", function() CallToArms:Toggle() end)

CallToArms.ToggleButton.Texture = CallToArms.ToggleButton:CreateTexture(nil, "OVERLAY")
CallToArms.ToggleButton.Texture:SetPoint("CENTER", CallToArms.ToggleButton, 0, -0.5)
CallToArms.ToggleButton.Texture:SetTexture("Interface\\AddOns\\CallToArms\\HydraUIArrowUp.tga")
CallToArms.ToggleButton.Texture:SetVertexColor(0.92, 0.92, 0.92)

CallToArms.VisualParent = CreateFrame("Frame", nil, CallToArms)

CallToArms.SoundThrottle = CreateFrame("Frame")
CallToArms.SoundThrottle.Ela = 0
CallToArms.SoundThrottle.CanPlaySound = true

local SoundThrottleOnUpdate = function(self, ela)
	self.Ela = self.Ela + ela

	if (self.Ela > 3) then
		self:SetScript("OnUpdate", nil)
		self.CanPlaySound = true
		self.Ela = 0
	end
end

function CallToArms:PlaySound()
	if (not Settings.PlaySound) or (not self.SoundThrottle.CanPlaySound) then
		return
	end

	PlaySound(SOUNDKIT.MAP_PING, "Master")

	self.SoundThrottle.CanPlaySound = false
	self.SoundThrottle:SetScript("OnUpdate", SoundThrottleOnUpdate)
end

local IsQueued = function(id)
	for i = 1, #LFGQueuedForList do
		for k, v in next, LFGQueuedForList[i] do
			if ((k == id) and v) then
				return true
			end
		end
	end

	return false
end

local UpdateQueueStatus = function(id)
	local Header

	for k, v in next, CallToArms.Headers do
		if (v.DungeonID == id) then
			Header = v

			break
		end
	end

	if (not Header) then
		return
	end

	if IsQueued(id) then
		Header.IsQueued:Show()
	else
		Header.IsQueued:Hide()
	end
end

function CallToArms:UpdateAllQueues()
	for k, v in next, self.Headers do
		UpdateQueueStatus(v.DungeonID)
	end
end

local OnUpdate = function(self, ela)
	self.Ela = self.Ela + ela

	if (self.Ela > UpdateInt) then
		RequestLFDPlayerLockInfo()
		self.Ela = 0
	end
end

function CallToArms:PLAYER_REGEN_ENABLED()
	self.Ela = self.Ela + (GetTime() - CombatTime)

	self:SetScript("OnUpdate", OnUpdate)
end

function CallToArms:PLAYER_REGEN_DISABLED()
	self:SetScript("OnUpdate", nil)

	CombatTime = GetTime()
end

function CallToArms:CreateModules()
	-- Find dungeons
	for i = 1, GetNumRandomDungeons() do
		ID, Name, SubType, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, Timewalking = GetLFGRandomDungeonInfo(i)
		ForAll, ForPlayer = IsLFGDungeonJoinable(ID)

		if ForPlayer then
			CallToArms:NewModule(ID, Rename[ID] or Name, LFG_SUBTYPEID_DUNGEON) -- SubType returns 6 (LE_LFG_CATEGORY_WORLDPVP) for some reason. Change to proper dungeon category LE_LFG_CATEGORY_LFD (which is 1) so that queueing works
		end
	end

	-- Find raids
	for i = 1, GetNumRFDungeons() do
		ID, Name, SubType, _, _, _, _, Min, Max, _, _, _, _, _, _, _, _, _, _, MapName, _, _, MapID = GetRFDungeonInfo(i)

		if (Level >= Min) and (Level <= Max) then
			if GetModifiedInstanceInfoFromMapID then
				CallToArms:NewModule(ID, Name, SubType, GetModifiedInstanceInfoFromMapID(MapID))
			else
				CallToArms:NewModule(ID, Name, SubType)
			end
		end
	end

	for i = 1, CallToArms.NumHeaders do
		if (CallToArmsSettings["Enable"..CallToArms.HeaderIDs[i].DungeonName] == nil) then -- This should fix new modules not loading unless toggled. If we don't have a setting for this dungeon, then enable it by default.
			CallToArmsSettings["Enable"..CallToArms.HeaderIDs[i].DungeonName] = true
		end

		if (Settings["Enable"..CallToArms.HeaderIDs[i].DungeonName] == true) then
			CallToArms.HeaderIDs[i]:Enable()
		else
			CallToArms.HeaderIDs[i]:Disable()
		end
	end

	CallToArms:UpdateAlpha(Settings.WindowAlpha)

	RequestLFDPlayerLockInfo()

	if CallToArms.Request then
		CallToArms:CreateConfig()
	end
end

function CallToArms:PLAYER_ENTERING_WORLD()
	C_Timer.After(5, self.CreateModules) -- GetNumRandomDungeons() returns 0 on PEW. I tried to find out if toggling the LFG frame or loading anything would populate the list, but just waiting seems to be the answer.
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function CallToArms:LFG_UPDATE_RANDOM_INFO()
	if (not self.Ready) then
		return
	end

	self:UpdateAllQueues()

	self.NumActive = 0

	for k, v in next, self.Headers do
		v:Update()
	end

	if (Settings.Minimized and self.NumActive > 0) then
		self.Text:SetText(BATTLEGROUND_HOLIDAY .. " (" .. self.NumActive .. ")")
	else
		self.Text:SetText(BATTLEGROUND_HOLIDAY)
	end

	if (not self.MinimizedCheck) then
		if Settings.Minimized then
			self:Minimize()
		end

		self.MinimizedCheck = true
	end

	if (not self:GetScript("OnUpdate") and (not InCombatLockdown())) then
		self:SetScript("OnUpdate", OnUpdate)
	end
end

function CallToArms:VARIABLES_LOADED()
	if (not CallToArmsSettings) then
		CallToArmsSettings = {}
	end

	for Key, Value in next, CallToArmsSettings do
		Settings[Key] = Value
	end

	self.Ready = true

	if Settings.MinimizeInGroup then
		self:RegisterEvent("GROUP_ROSTER_UPDATE")
	end
end

function CallToArms:GROUP_ROSTER_UPDATE()
	if self.Minimized then
		return
	end

	if (IsInGroup() or IsInRaid()) then
		self:Minimize()
	end
end

function CallToArms:LFG_UPDATE()
	self:UpdateAllQueues()
end

function CallToArms:SortHeaders()
	local LastHeader

	for k, v in next, self.Headers do
		if (not v.Disabled and v:IsVisible()) then
			v:ClearAllPoints()

			if Settings.GrowDown then
				if (not LastHeader) then
					v:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -1, -2)
				else
					v:SetPoint("TOPLEFT", LastHeader.LastShown, "BOTTOMLEFT", 0, -1)
				end
			else
				if (not LastHeader) then
					v:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -1, (v.NumShown * 20) + v.NumShown)
				else
					v:SetPoint("BOTTOMLEFT", LastHeader, "TOPLEFT", 0, (v.NumShown * 20) + (v.NumShown - 1))
				end
			end

			LastHeader = v
		end
	end
end

function CallToArms:Minimize()
	self.VisualParent:SetAlpha(0)

	Settings.Minimized = true
	CallToArms.Minimized = true

	self.ToggleButton.Texture:SetTexture("Interface\\AddOns\\CallToArms\\HydraUIArrowDown.tga")

	self.NumActive = 0

	for k, v in next, self.Headers do
		for i = 1, 3 do
			v[i]:EnableMouse(false)
		end

		v:Update()
	end

	self:SortHeaders()

	if (self.NumActive > 0) then
		self.Text:SetText(BATTLEGROUND_HOLIDAY .. " (" .. self.NumActive .. ")")
	else
		self.Text:SetText(BATTLEGROUND_HOLIDAY)
	end
end

function CallToArms:Maximize()
	self.VisualParent:SetAlpha(1)

	Settings.Minimized = false
	CallToArms.Minimized = false

	self.ToggleButton.Texture:SetTexture("Interface\\AddOns\\CallToArms\\HydraUIArrowUp.tga")

	self.NumActive = 0

	for k, v in next, self.Headers do
		for i = 1, 3 do
			v[i]:EnableMouse(true)
		end

		v:Update()
	end

	self:SortHeaders()

	self.Text:SetText(BATTLEGROUND_HOLIDAY)
end

function CallToArms:Toggle()
	if (self.VisualParent:GetAlpha() == 1) then
		self:Minimize()
	else
		self:Maximize()
	end
end

function CallToArms:UpdateAlpha(value)
	for k, v in next, self.Headers do
		v.Texture:SetAlpha(value)

		for i = 1, 3 do
			v[i].Texture:SetAlpha(value)
		end
	end
end

local OnEvent = function(self, event, ...)
	if self[event] then
		self[event](self, ...)
	end
end

CallToArms:RegisterEvent("PLAYER_ENTERING_WORLD")
CallToArms:RegisterEvent("LFG_UPDATE_RANDOM_INFO")
CallToArms:RegisterEvent("PLAYER_REGEN_ENABLED")
CallToArms:RegisterEvent("PLAYER_REGEN_DISABLED")
CallToArms:RegisterEvent("VARIABLES_LOADED")
CallToArms:RegisterEvent("CHAT_MSG_ADDON")
CallToArms:RegisterEvent("LFG_UPDATE")
CallToArms:SetScript("OnEvent", OnEvent)

local Update = function(self)
	if self.Disabled then
		return
	end

	self.TankActive = false
	self.HealerActive = false
	self.DamageActive = false

	for i = 1, LFG_ROLE_NUM_SHORTAGE_TYPES do
		local Eligable, ForTank, ForHealer, ForDamage, ItemCount = GetLFGRoleShortageRewards(self.DungeonID, i)

		if (ItemCount and ItemCount > 0) then
			if ForTank then
				self.TankActive = true
				CallToArms.NumActive = CallToArms.NumActive + 1
			end

			if ForHealer then
				self.HealerActive = true
				CallToArms.NumActive = CallToArms.NumActive + 1
			end

			if ForDamage then
				self.DamageActive = true
				CallToArms.NumActive = CallToArms.NumActive + 1
			end
		end
	end

	if self.TankActive then
		if self.AnnounceTank then
			if (Settings.FilterRole and not ClassRoleMap[Class][1]) then
				return
			end

			self[1]:Show()
			self:Sort()
			CallToArms:PlaySound()

			if Settings.AnnounceStart then
				print(format(L["|cffeaeaeaCall To Arms: %s %s bonus is active!|r"], self.DungeonName, RoleNames[1]))
			end

			self.AnnounceTank = false
		end
	else
		if (not self.AnnounceTank) then
			self[1]:Hide()
			self:Sort()

			if Settings.AnnounceEndings then
				if Settings.AnnounceStart then
					print(format(L["|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"], self.DungeonName, RoleNames[1]))
				end
			end

			self.AnnounceTank = true
		end
	end

	if self.HealerActive then
		if self.AnnounceHealer then
			if (Settings.FilterRole and not ClassRoleMap[Class][2]) then
				return
			end

			self[2]:Show()
			self:Sort()
			CallToArms:PlaySound()

			if Settings.AnnounceStart then
				print(format(L["|cffeaeaeaCall To Arms: %s %s bonus is active!|r"], self.DungeonName, RoleNames[2]))
			end

			self.AnnounceHealer = false
		end
	else
		if (not self.AnnounceHealer) then
			self[2]:Hide()
			self:Sort()

			if Settings.AnnounceEndings then
				if Settings.AnnounceStart then
					print(format(L["|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"], self.DungeonName, RoleNames[2]))
				end
			end

			self.AnnounceHealer = true
		end
	end

	if self.DamageActive then
		if self.AnnounceDPS then
			self[3]:Show()
			self:Sort()
			CallToArms:PlaySound()

			if Settings.AnnounceStart then
				print(format(L["|cffeaeaeaCall To Arms: %s %s bonus is active!|r"], self.DungeonName, RoleNames[3]))
			end

			self.AnnounceDPS = false
		end
	else
		if (not self.AnnounceDPS) then
			self[3]:Hide()
			self:Sort()

			if Settings.AnnounceEndings then
				if Settings.AnnounceStart then
					print(format(L["|cffeaeaeaCall To Arms: %s %s bonus has ended.|r"], self.DungeonName, RoleNames[3]))
				end
			end

			self.AnnounceDPS = true
		end
	end
end

local FilterUpdate = function(self)
	self.TankActive = false
	self.HealerActive = false
	self.DamageActive = false

	for i = 1, LFG_ROLE_NUM_SHORTAGE_TYPES do
		local Eligable, ForTank, ForHealer, ForDamage, ItemCount = GetLFGRoleShortageRewards(self.DungeonID, i)

		if (ItemCount and ItemCount > 0) then
			if ForTank then
				self.TankActive = true
			end

			if ForHealer then
				self.HealerActive = true
			end
		end
	end

	if self.TankActive then
		if (Settings.FilterRole and not ClassRoleMap[Class][1]) then
			self[1]:Hide()
			self:Sort()
			self.AnnounceTank = true
		end
	end

	if self.HealerActive then
		if (Settings.FilterRole and not ClassRoleMap[Class][2]) then
			self[2]:Hide()
			self:Sort()
			self.AnnounceHealer = true
		end
	end
end

local OnClick = function(self, button)
	ClearAllLFGDungeons(self.SubTypeID)

	local Eligable, ForTank, ForHealer, ForDamage = GetLFGRoleShortageRewards(self.DungeonID, LFG_ROLE_SHORTAGE_RARE)
	local Leader = GetLFGRoles()

	-- Check if we can perform this role. A generic error message would come up anyways, but we'll make our own.
	if (self.RoleID == 1) then
		if (ForTank and not ClassRoleMap[Class][self.RoleID]) then
			print(YOUR_CLASS_MAY_NOT_PERFORM_ROLE)

			return
		end
	elseif (self.RoleID == 2) then
		if (ForHealer and not ClassRoleMap[Class][self.RoleID]) then
			print(YOUR_CLASS_MAY_NOT_PERFORM_ROLE)

			return
		end
	end

	SetLFGDungeon(self.SubTypeID, self.DungeonID)
	SetLFGRoles(Leader, self.RoleID == 1, self.RoleID == 2, self.RoleID == 3)

	if (self.SubTypeID == LE_LFG_CATEGORY_LFD) then
		LFDFrame_DisplayDungeonByID(self.DungeonID)
		LFDQueueFrame_UpdateRoleButtons()
	elseif (self.SubTypeID == LE_LFG_CATEGORY_RF) then
		LFG_UpdateQueuedList()
		LFG_UpdateAllRoleCheckboxes()
	end

	JoinLFG(self.SubTypeID)

	UpdateQueueStatus(self.DungeonID)
end

local OnEnter = function(self)
	self.MouseOver:SetAlpha(0.5)

	for i = 1, LFG_ROLE_NUM_SHORTAGE_TYPES do
		local Eligable, ForTank, ForHealer, ForDamage, ItemCount = GetLFGRoleShortageRewards(self.DungeonID, i)

		if (ItemCount and ItemCount > 0) then
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("TOP", self, "BOTTOM", 0, -8)

			GameTooltip:AddLine(BONUS_REWARDS)
			GameTooltip:AddLine(" ")

			for j = 1, ItemCount do
				local Name, Icon, NumRewards, _, RewardType, ID, Quality = GetLFGDungeonShortageRewardInfo(self.DungeonID, i, j)

				if (RewardType == "misc") then
					GameTooltip:AddLine(REWARD_ITEMS_ONLY)

					local DoneToday, Money, MoneyMod, XP, XPMod, NumRewards, SpellID = GetLFGDungeonRewards(self.DungeonID)

					if (XP > 0) then
						GameTooltip:AddLine(format(GAIN_EXPERIENCE, XP))
					end

					if (Money > 0) then
						SetTooltipMoney(GameTooltip, Money, nil)
					end
				elseif (RewardType == "reward") then
					GameTooltip:SetLFGDungeonReward(self.DungeonID, j)
				elseif (RewardType == "shortage") then
					GameTooltip:SetLFGDungeonShortageReward(self.DungeonID, j, i)
				elseif (RewardType == "item") then
					local Link = GetLFGDungeonShortageRewardLink(self.DungeonID, i, j)

					if Link then
						if (NumRewards > 1) then
							GameTooltip:AddLine(format("%s %s", NumRewards, Link))
						else
							GameTooltip:AddLine(Link)
						end
					end
				elseif (RewardType == "currency") then
					local CurrencyNum = select(3, CurrencyContainerUtil.GetCurrencyContainerInfo(ID, NumRewards, Name, Icon, Quality))
					local Link = C_CurrencyInfo.GetCurrencyLink(ID, CurrencyNum)
					local CurrencyInfo = C_CurrencyInfo.GetCurrencyInfo(ID)
					local Hex = ITEM_QUALITY_COLORS[CurrencyInfo.quality].hex or "ffffff"

					if CurrencyInfo then
						GameTooltip:AddLine(format("%s %s%s|r", NumRewards, Hex, CurrencyInfo.name), 1, 1, 1)
					end
				end
			end

			GameTooltip:Show()
		end
	end
end

local OnLeave = function(self)
	self.MouseOver:SetAlpha(0)
	GameTooltip:Hide()
end

function CallToArms:NewModule(id, name, subtypeid, fated)
	local Header = CreateFrame("Frame", nil, self.VisualParent, "BackdropTemplate")
	Header:SetSize(132, 20)
	Header:SetPoint("LEFT", UIParent, 8, 0)
	Header.Ela = 0
	Header:Hide()
	Header.DungeonID = id
	Header.DungeonName = name
	Header.Update = Update
	Header.FilterUpdate = FilterUpdate
	Header.Disabled = false

	Header:SetBackdrop(Outline)
	Header:SetBackdropColor(0, 0, 0, 0)
	Header:SetBackdropBorderColor(0, 0, 0)

	Header.Texture = Header:CreateTexture(nil, "ARTWORK")
	Header.Texture:SetPoint("TOPLEFT", Header, 1, -1)
	Header.Texture:SetPoint("BOTTOMRIGHT", Header, -1, 1)
	Header.Texture:SetTexture(BarTexture)
	Header.Texture:SetVertexColor(0.25, 0.25, 0.25)

	Header.Text = Header:CreateFontString(nil, "OVERLAY")
	Header.Text:SetPoint("LEFT", Header, 4, -0.5)
	Header.Text:SetSize(124, 12)
	Header.Text:SetFont(Font, 12, "")
	Header.Text:SetJustifyH("LEFT")
	Header.Text:SetShadowColor(0, 0, 0)
	Header.Text:SetShadowOffset(1, -1)
	Header.Text:SetText(name)
	Header.Text:SetTextColor(0.92, 0.92, 0.08)

	if fated then
		Header.Fated = Header:CreateTexture(nil, "ARTWORK")
		Header.Fated:SetPoint("RIGHT", Header, -3, 0)
		Header.Fated:SetAtlas("ui-ej-icon-empoweredraid-small", true)
	end

	Header.IsQueued = Header:CreateTexture(nil, "OVERLAY")
	Header.IsQueued:SetSize(Header:GetWidth() - 12, 12)
	Header.IsQueued:SetPoint("BOTTOM", Header, 0, 1)
	Header.IsQueued:SetTexture("Interface\\AddOns\\CallToArms\\RenHorizonUp.tga")
	Header.IsQueued:SetVertexColor(0.92, 0.92, 0.08, 0.4)
	Header.IsQueued:Hide()

	Header.TankActive = false
	Header.HealerActive = false
	Header.DamageActive = false
	Header.AnnounceTank = true
	Header.AnnounceHealer = true
	Header.AnnounceDPS = true

	Header.Reset = function(self)
		self.TankActive = false
		self.HealerActive = false
		self.DamageActive = false
		self.AnnounceTank = true
		self.AnnounceHealer = true
		self.AnnounceDPS = true

		self:Hide()

		for i = 1, 3 do
			self[i]:Hide()
		end
	end

	Header.Enable = function(self)
		self.Disabled = false

		self:Update()
		CallToArms:SortHeaders()

		if Settings.Minimized then
			CallToArms.NumActive = 0

			for k, v in next, CallToArms.Headers do
				v:Update()
			end

			if (CallToArms.NumActive > 0) then
				CallToArms.Text:SetText(BATTLEGROUND_HOLIDAY .. " (" .. CallToArms.NumActive .. ")")
			else
				CallToArms.Text:SetText(BATTLEGROUND_HOLIDAY)
			end
		end
	end

	Header.Disable = function(self)
		self.Disabled = true

		self:Reset()
		CallToArms:SortHeaders()

		if Settings.Minimized then
			CallToArms.NumActive = 0

			if (CallToArms.NumActive > 0) then
				CallToArms.Text:SetText(BATTLEGROUND_HOLIDAY .. " (" .. CallToArms.NumActive .. ")")
			else
				CallToArms.Text:SetText(BATTLEGROUND_HOLIDAY)
			end
		end
	end

	Header.Sort = function(self)
		self.LastShown = self
		local NumShown = 0

		for i = 1, 3 do
			self[i]:ClearAllPoints()

			if self[i]:IsVisible() then
				self[i]:SetPoint("TOPLEFT", self.LastShown, "BOTTOMLEFT", 0, 1)

				self.LastShown = self[i]

				NumShown = NumShown + 1
			end
		end

		self.NumShown = NumShown

		if (NumShown > 0) then
			self:Show()
		else
			self:Hide()
		end

		if (not Settings.Minimized) then
			CallToArms:SortHeaders()
		end
	end

	for i = 1, 3 do
		local Bar = CreateFrame("Button", nil, self.VisualParent, "BackdropTemplate")
		Bar:SetSize(132, 20)
		Bar:Hide()
		Bar.Ela = 0
		Bar.RoleID = i
		Bar.DungeonID = id
		Bar.SubTypeID = subtypeid

		Bar:SetBackdrop(Outline)
		Bar:SetBackdropColor(0, 0, 0, 0)
		Bar:SetBackdropBorderColor(0, 0, 0)

		Bar.Texture = Bar:CreateTexture(nil, "ARTWORK")
		Bar.Texture:SetPoint("TOPLEFT", Bar, 1, -1)
		Bar.Texture:SetPoint("BOTTOMRIGHT", Bar, -1, 1)
		Bar.Texture:SetTexture(BlankTexture)
		Bar.Texture:SetVertexColor(0.3, 0.3, 0.3)

		Bar.IconBG = Bar:CreateTexture(nil, "ARTWORK")
		Bar.IconBG:SetSize(20, 20)
		Bar.IconBG:SetPoint("LEFT", Bar, "LEFT", 0, 0)
		Bar.IconBG:SetTexture(BlankTexture)
		Bar.IconBG:SetVertexColor(0, 0, 0)

		Bar.Icon = Bar:CreateTexture(nil, "OVERLAY")
		Bar.Icon:SetSize(18, 18)
		Bar.Icon:SetPoint("LEFT", Bar, "LEFT", 1, 0)
		Bar.Icon:SetTexture(RoleIcons[i])
		Bar.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

		Bar.MouseOver = Bar:CreateTexture(nil, "OVERLAY")
		Bar.MouseOver:SetSize(111, 18)
		Bar.MouseOver:SetPoint("RIGHT", Bar, "RIGHT", -1, 0)
		Bar.MouseOver:SetTexture(BarTexture)
		Bar.MouseOver:SetVertexColor(0.8, 0.8, 0.8, 0.5)
		Bar.MouseOver:SetAlpha(0)

		Bar.Flash = Bar:CreateTexture(nil, "OVERLAY")
		Bar.Flash:SetSize(130, 18)
		Bar.Flash:SetPoint("CENTER", Bar, "CENTER", 0, 0)
		Bar.Flash:SetTexture(BarTexture)
		Bar.Flash:SetVertexColor(0.8, 0.8, 0.8)
		Bar.Flash:SetAlpha(0)

		Bar.Text = Bar:CreateFontString(nil, "OVERLAY")
		Bar.Text:SetPoint("LEFT", Bar, 24, -0.5)
		Bar.Text:SetFont(Font, 12, "")
		Bar.Text:SetJustifyH("LEFT")
		Bar.Text:SetShadowColor(0, 0, 0)
		Bar.Text:SetShadowOffset(1, -1)
		Bar.Text:SetText(RoleNames[i])
		Bar.Text:SetTextColor(0.92, 0.92, 0.92)

		Bar:RegisterForClicks("AnyUp")
		Bar:SetScript("OnClick", OnClick)
		Bar:SetScript("OnEnter", OnEnter)
		Bar:SetScript("OnLeave", OnLeave)

		if Settings.GrowDown then
			if (i == 1) then
				Bar:SetPoint("TOPLEFT", Header, "BOTTOMLEFT", 0, -1)
			else
				Bar:SetPoint("TOP", Header[i-1], "BOTTOM", 0, -1)
			end
		else
			if (i == 1) then
				Bar:SetPoint("BOTTOMLEFT", Header, "TOPLEFT", 0, 1)
			else
				Bar:SetPoint("BOTTOM", Header[i-1], "TOP", 0, 1)
			end
		end

		Header[i] = Bar
	end

	if (CallToArmsSettings["Enable"..name] == false) then
		Header:Disable()
	end

	self.NumHeaders = self.NumHeaders + 1
	self.Headers[name] = Header
	--self.HeaderIDs[self.NumHeaders] = Header
	self.HeaderIDs[#self.HeaderIDs + 1] = Header
end

local EditBoxOnEnterPressed = function(self)
	self:SetAutoFocus(false)
	self:ClearFocus()

	local Value = tonumber(self:GetText())

	if (Value > self.Max) then
		Value = self.Max
	elseif (Value < self.Min) then
		Value = self.Min
	end

	self:SetText(Value)
	self.Hook(Value)
end

local EditBoxOnMouseDown = function(self)
	self:SetAutoFocus(true)
end

local EditBoxOnEditFocusLost = function(self)
	self:SetAutoFocus(false)
end

local EditBoxOnMouseWheel = function(self, delta)
	local Value = tonumber(self:GetText())

	if (delta > 0) then
		Value = Value + self.Step

		if (Value > self.Max) then
			Value = self.Max
		end
	else
		Value = Value - self.Step

		if (Value < self.Min) then
			Value = self.Min
		end
	end

	self:SetText(Value)
	self.Hook(Value)
end

local Scroll = function(self)
	local First = false

	for i = 1, #self.Widgets do
		if (i >= self.Offset) and (i <= self.Offset + MAX_SHOWN - 1) then
			if (not First) then
				self.Widgets[i]:SetPoint("TOPLEFT", self.ButtonParent, 3, -3)
				First = true
			else
				self.Widgets[i]:SetPoint("TOPLEFT", self.Widgets[i-1], "BOTTOMLEFT", 0, -2)
			end

			self.Widgets[i]:Show()
		else
			self.Widgets[i]:Hide()
		end
	end
end

local ConfigOnMouseWheel = function(self, delta)
	if (delta == 1) then -- up
		self.Offset = self.Offset - 1

		if (self.Offset <= 1) then
			self.Offset = 1
		end
	else -- down
		self.Offset = self.Offset + 1

		if (self.Offset > (#self.Widgets - (MAX_SHOWN - 1))) then
			self.Offset = self.Offset - 1
		end
	end

	Scroll(self)
	self.ScrollBar:SetValue(self.Offset)
end

local ScrollBarOnValueChanged = function(self, value)
	local Value = floor(value + 0.5)

	self.Parent.Offset = Value

	Scroll(self.Parent)
end

function CallToArms:CreateConfig()
	if (self.NumHeaders == 0) then
		print(L["Still scanning for dungeons. Settings will load in a moment."])
		self.Request = true

		return
	end

	self.Request = false

	local Config = CreateFrame("Frame", "CallToArmsConfig", UIParent)
	Config:SetSize(210, 18)
	Config:SetPoint("CENTER", UIParent, 0, 160)
	Config:SetMovable(true)
	Config:EnableMouse(true)
	Config:SetUserPlaced(true)
	Config:RegisterForDrag("LeftButton")
	Config:SetScript("OnDragStart", Config.StartMoving)
	Config:SetScript("OnDragStop", Config.StopMovingOrSizing)

	Config.BG = Config:CreateTexture(nil, "BORDER")
	Config.BG:SetPoint("TOPLEFT", Config, -1, 1)
	Config.BG:SetPoint("BOTTOMRIGHT", Config, 1, -1)
	Config.BG:SetTexture(BlankTexture)
	Config.BG:SetVertexColor(0, 0, 0)

	Config.Texture = Config:CreateTexture(nil, "OVERLAY")
	Config.Texture:SetPoint("TOPLEFT", Config, 0, 0)
	Config.Texture:SetPoint("BOTTOMRIGHT", Config, 0, 0)
	Config.Texture:SetTexture(BarTexture)
	Config.Texture:SetVertexColor(0.25, 0.25, 0.25)

	Config.Text = Config:CreateFontString(nil, "OVERLAY")
	Config.Text:SetPoint("LEFT", Config, 3, -0.5)
	Config.Text:SetFont(Font, 12, "")
	Config.Text:SetJustifyH("LEFT")
	Config.Text:SetShadowColor(0, 0, 0)
	Config.Text:SetShadowOffset(1, -1)
	Config.Text:SetText(BATTLEGROUND_HOLIDAY .. " " .. (C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata)("CallToArms", "Version"))

	Config.CloseButton = CreateFrame("Frame", nil, Config)
	Config.CloseButton:SetPoint("TOPRIGHT", Config, 0, 0)
	Config.CloseButton:SetSize(18, 18)
	Config.CloseButton:SetScript("OnEnter", function(self) self.Label:SetVertexColor(1, 0, 0) end)
	Config.CloseButton:SetScript("OnLeave", function(self) self.Label:SetVertexColor(1, 1, 1) end)
	Config.CloseButton:SetScript("OnMouseUp", function() Config:Hide() end)

	Config.CloseButton.Label = Config.CloseButton:CreateTexture(nil, "OVERLAY")
	Config.CloseButton.Label:SetPoint("CENTER", Config.CloseButton, 0, -0.5)
	Config.CloseButton.Label:SetTexture("Interface\\AddOns\\CallToArms\\HydraUIClose.tga")

	local ConfigWindow = CreateFrame("Frame", "CallToArmsConfigWindow", Config)
	ConfigWindow:SetSize(210, 240)
	ConfigWindow:SetPoint("TOPLEFT", Config, "BOTTOMLEFT", 0, -4)
	ConfigWindow.Offset = 1

	ConfigWindow.Widgets = {}

	ConfigWindow:EnableMouseWheel(true)
	ConfigWindow:SetScript("OnMouseWheel", ConfigOnMouseWheel)

	ConfigWindow.Backdrop = ConfigWindow:CreateTexture(nil, "BORDER")
	ConfigWindow.Backdrop:SetPoint("TOPLEFT", ConfigWindow, -1, 1)
	ConfigWindow.Backdrop:SetPoint("BOTTOMRIGHT", ConfigWindow, 1, -1)
	ConfigWindow.Backdrop:SetTexture(BlankTexture)
	ConfigWindow.Backdrop:SetVertexColor(0, 0, 0)

	ConfigWindow.Inside = ConfigWindow:CreateTexture(nil, "BORDER")
	ConfigWindow.Inside:SetAllPoints()
	ConfigWindow.Inside:SetTexture(BlankTexture)
	ConfigWindow.Inside:SetVertexColor(0.3, 0.3, 0.3)

	ConfigWindow.ButtonParent = CreateFrame("Frame", nil, ConfigWindow)
	ConfigWindow.ButtonParent:SetAllPoints()
	ConfigWindow.ButtonParent:SetFrameLevel(ConfigWindow:GetFrameLevel() + 4)
	ConfigWindow.ButtonParent:SetFrameStrata("HIGH")
	ConfigWindow.ButtonParent:EnableMouse(true)

	ConfigWindow.Backdrop = CreateFrame("Frame", nil, ConfigWindow, "BackdropTemplate")
	ConfigWindow.Backdrop:SetPoint("TOPLEFT", Config, -4, 4)
	ConfigWindow.Backdrop:SetPoint("BOTTOMRIGHT", ConfigWindow, 4, -4)
	ConfigWindow.Backdrop:SetBackdrop(Outline)
	ConfigWindow.Backdrop:SetBackdropColor(0.25, 0.25, 0.25)
	ConfigWindow.Backdrop:SetBackdropBorderColor(0, 0, 0)
	ConfigWindow.Backdrop:SetFrameStrata("LOW")

	-- Main header
	local GeneralHeader = CreateFrame("Frame", nil, ConfigWindow.ButtonParent)
	GeneralHeader:SetSize(188, 20)

	GeneralHeader.BG = GeneralHeader:CreateTexture(nil, "BORDER")
	GeneralHeader.BG:SetTexture(BlankTexture)
	GeneralHeader.BG:SetVertexColor(0, 0, 0)
	GeneralHeader.BG:SetPoint("TOPLEFT", GeneralHeader, 0, 0)
	GeneralHeader.BG:SetPoint("BOTTOMRIGHT", GeneralHeader, 0, 0)

	GeneralHeader.Tex = GeneralHeader:CreateTexture(nil, "OVERLAY")
	GeneralHeader.Tex:SetTexture(BarTexture)
	GeneralHeader.Tex:SetPoint("TOPLEFT", GeneralHeader, 1, -1)
	GeneralHeader.Tex:SetPoint("BOTTOMRIGHT", GeneralHeader, -1, 1)
	GeneralHeader.Tex:SetVertexColor(0.25, 0.25, 0.25)

	GeneralHeader.Text = GeneralHeader:CreateFontString(nil, "OVERLAY")
	GeneralHeader.Text:SetFont(Font, 12, "")
	GeneralHeader.Text:SetPoint("LEFT", GeneralHeader, 3, 0)
	GeneralHeader.Text:SetJustifyH("LEFT")
	GeneralHeader.Text:SetShadowColor(0, 0, 0)
	GeneralHeader.Text:SetShadowOffset(1, -1)
	GeneralHeader.Text:SetText(GENERAL)

	tinsert(ConfigWindow.Widgets, GeneralHeader)

	-- Update intervals
	local UpdateIntOption = CreateFrame("Frame", nil, ConfigWindow.ButtonParent)
	UpdateIntOption:SetSize(40, 20)
	UpdateIntOption:SetPoint("TOPLEFT", ConfigWindow.ButtonParent, 3, -3)

	UpdateIntOption.BG = UpdateIntOption:CreateTexture(nil, "BORDER")
	UpdateIntOption.BG:SetTexture(BlankTexture)
	UpdateIntOption.BG:SetVertexColor(0, 0, 0)
	UpdateIntOption.BG:SetPoint("TOPLEFT", UpdateIntOption, 0, 0)
	UpdateIntOption.BG:SetPoint("BOTTOMRIGHT", UpdateIntOption, 0, 0)

	UpdateIntOption.Tex = UpdateIntOption:CreateTexture(nil, "OVERLAY")
	UpdateIntOption.Tex:SetTexture(BarTexture)
	UpdateIntOption.Tex:SetPoint("TOPLEFT", UpdateIntOption, 1, -1)
	UpdateIntOption.Tex:SetPoint("BOTTOMRIGHT", UpdateIntOption, -1, 1)
	UpdateIntOption.Tex:SetVertexColor(0.25, 0.25, 0.25)

	UpdateIntOption.Text = UpdateIntOption:CreateFontString(nil, "OVERLAY")
	UpdateIntOption.Text:SetFont(Font, 12, "")
	UpdateIntOption.Text:SetPoint("LEFT", UpdateIntOption, "RIGHT", 3, 0)
	UpdateIntOption.Text:SetJustifyH("LEFT")
	UpdateIntOption.Text:SetShadowColor(0, 0, 0)
	UpdateIntOption.Text:SetShadowOffset(1, -1)
	UpdateIntOption.Text:SetText("Set update interval (seconds)")

	UpdateIntOption.EditBox = CreateFrame("EditBox", nil, UpdateIntOption)
	UpdateIntOption.EditBox:SetFont(Font, 12, "")
	UpdateIntOption.EditBox:SetShadowColor(0, 0, 0)
	UpdateIntOption.EditBox:SetShadowOffset(1, -1)
	UpdateIntOption.EditBox:SetPoint("TOPLEFT", UpdateIntOption, 4, -2)
	UpdateIntOption.EditBox:SetPoint("BOTTOMRIGHT", UpdateIntOption, -2, 2)
	UpdateIntOption.EditBox:SetMaxLetters(3)
	UpdateIntOption.EditBox:SetAutoFocus(false)
	UpdateIntOption.EditBox:EnableKeyboard(true)
	UpdateIntOption.EditBox:EnableMouse(true)
	UpdateIntOption.EditBox:EnableMouseWheel(true)
	UpdateIntOption.EditBox:SetText(Settings.UpdateInterval)
	UpdateIntOption.EditBox:SetScript("OnMouseWheel", EditBoxOnMouseWheel)
	UpdateIntOption.EditBox:SetScript("OnMouseDown", EditBoxOnMouseDown)
	UpdateIntOption.EditBox:SetScript("OnEscapePressed", EditBoxOnEnterPressed)
	UpdateIntOption.EditBox:SetScript("OnEnterPressed", EditBoxOnEnterPressed)
	UpdateIntOption.EditBox:SetScript("OnEditFocusLost", EditBoxOnEditFocusLost)
	UpdateIntOption.EditBox.Min = 20
	UpdateIntOption.EditBox.Max = 120
	UpdateIntOption.EditBox.Step = 1

	UpdateIntOption.EditBox.Hook = function(value)
		UpdateInt = value
		Settings.UpdateInterval = value
		CallToArmsSettings.UpdateInterval = value
	end

	tinsert(ConfigWindow.Widgets, UpdateIntOption)

	-- Window alpha
	local WindowAlphaOption = CreateFrame("Frame", nil, ConfigWindow.ButtonParent)
	WindowAlphaOption:SetSize(40, 20)
	WindowAlphaOption:SetPoint("TOPLEFT", UpdateIntOption, "BOTTOMLEFT", 0, -2)

	WindowAlphaOption.BG = WindowAlphaOption:CreateTexture(nil, "BORDER")
	WindowAlphaOption.BG:SetTexture(BlankTexture)
	WindowAlphaOption.BG:SetVertexColor(0, 0, 0)
	WindowAlphaOption.BG:SetPoint("TOPLEFT", WindowAlphaOption, 0, 0)
	WindowAlphaOption.BG:SetPoint("BOTTOMRIGHT", WindowAlphaOption, 0, 0)

	WindowAlphaOption.Tex = WindowAlphaOption:CreateTexture(nil, "OVERLAY")
	WindowAlphaOption.Tex:SetTexture(BarTexture)
	WindowAlphaOption.Tex:SetPoint("TOPLEFT", WindowAlphaOption, 1, -1)
	WindowAlphaOption.Tex:SetPoint("BOTTOMRIGHT", WindowAlphaOption, -1, 1)
	WindowAlphaOption.Tex:SetVertexColor(0.25, 0.25, 0.25)

	WindowAlphaOption.Text = WindowAlphaOption:CreateFontString(nil, "OVERLAY")
	WindowAlphaOption.Text:SetFont(Font, 12, "")
	WindowAlphaOption.Text:SetPoint("LEFT", WindowAlphaOption, "RIGHT", 3, 0)
	WindowAlphaOption.Text:SetJustifyH("LEFT")
	WindowAlphaOption.Text:SetShadowColor(0, 0, 0)
	WindowAlphaOption.Text:SetShadowOffset(1, -1)
	WindowAlphaOption.Text:SetText("Set window transparency")

	WindowAlphaOption.EditBox = CreateFrame("EditBox", nil, WindowAlphaOption)
	WindowAlphaOption.EditBox:SetFont(Font, 12, "")
	WindowAlphaOption.EditBox:SetShadowColor(0, 0, 0)
	WindowAlphaOption.EditBox:SetShadowOffset(1, -1)
	WindowAlphaOption.EditBox:SetPoint("TOPLEFT", WindowAlphaOption, 4, -2)
	WindowAlphaOption.EditBox:SetPoint("BOTTOMRIGHT", WindowAlphaOption, -2, 2)
	WindowAlphaOption.EditBox:SetMaxLetters(3)
	WindowAlphaOption.EditBox:SetAutoFocus(false)
	WindowAlphaOption.EditBox:EnableKeyboard(true)
	WindowAlphaOption.EditBox:EnableMouse(true)
	WindowAlphaOption.EditBox:EnableMouseWheel(true)
	WindowAlphaOption.EditBox:SetText(Settings.WindowAlpha)
	WindowAlphaOption.EditBox:SetScript("OnMouseWheel", EditBoxOnMouseWheel)
	WindowAlphaOption.EditBox:SetScript("OnMouseDown", EditBoxOnMouseDown)
	WindowAlphaOption.EditBox:SetScript("OnEscapePressed", EditBoxOnEnterPressed)
	WindowAlphaOption.EditBox:SetScript("OnEnterPressed", EditBoxOnEnterPressed)
	WindowAlphaOption.EditBox:SetScript("OnEditFocusLost", EditBoxOnEditFocusLost)
	WindowAlphaOption.EditBox.Min = 0
	WindowAlphaOption.EditBox.Max = 1
	WindowAlphaOption.EditBox.Step = 0.1

	WindowAlphaOption.EditBox.Hook = function(value)
		Settings.WindowAlpha = value
		CallToArmsSettings.WindowAlpha = value

		CallToArms:UpdateAlpha(value)
	end

	tinsert(ConfigWindow.Widgets, WindowAlphaOption)

	ConfigWindow.Boxes = {}

	for i = 1, 6 do
		local Checkbox = CreateFrame("Frame", nil, ConfigWindow.ButtonParent)
		Checkbox:SetSize(20, 20)

		Checkbox.BG = Checkbox:CreateTexture(nil, "BORDER")
		Checkbox.BG:SetTexture(BlankTexture)
		Checkbox.BG:SetVertexColor(0, 0, 0)
		Checkbox.BG:SetPoint("TOPLEFT", Checkbox, 0, 0)
		Checkbox.BG:SetPoint("BOTTOMRIGHT", Checkbox, 0, 0)

		Checkbox.Tex = Checkbox:CreateTexture(nil, "OVERLAY")
		Checkbox.Tex:SetTexture(BarTexture)
		Checkbox.Tex:SetPoint("TOPLEFT", Checkbox, 1, -1)
		Checkbox.Tex:SetPoint("BOTTOMRIGHT", Checkbox, -1, 1)

		Checkbox.Text = Checkbox:CreateFontString(nil, "OVERLAY")
		Checkbox.Text:SetFont(Font, 12, "")
		Checkbox.Text:SetPoint("LEFT", Checkbox, "RIGHT", 3, 0)
		Checkbox.Text:SetJustifyH("LEFT")
		Checkbox.Text:SetShadowColor(0, 0, 0)
		Checkbox.Text:SetShadowOffset(1, -1)

		if (i == 1) then
			Checkbox:SetPoint("TOPLEFT", WindowAlphaOption, "BOTTOMLEFT", 0, -2)
		else
			Checkbox:SetPoint("TOPLEFT", ConfigWindow.Boxes[i-1], "BOTTOMLEFT", 0, -2)
		end

		tinsert(ConfigWindow.Widgets, Checkbox)

		ConfigWindow.Boxes[i] = Checkbox
	end

	if Settings.AnnounceStart then
		ConfigWindow.Boxes[1].Tex:SetVertexColor(0, 0.8, 0)
	else
		ConfigWindow.Boxes[1].Tex:SetVertexColor(0.8, 0, 0)
	end

	if Settings.AnnounceEndings then
		ConfigWindow.Boxes[2].Tex:SetVertexColor(0, 0.8, 0)
	else
		ConfigWindow.Boxes[2].Tex:SetVertexColor(0.8, 0, 0)
	end

	if Settings.FilterRole then
		ConfigWindow.Boxes[3].Tex:SetVertexColor(0, 0.8, 0)
	else
		ConfigWindow.Boxes[3].Tex:SetVertexColor(0.8, 0, 0)
	end

	if Settings.MinimizeInGroup then
		ConfigWindow.Boxes[4].Tex:SetVertexColor(0, 0.8, 0)
	else
		ConfigWindow.Boxes[4].Tex:SetVertexColor(0.8, 0, 0)
	end

	if Settings.PlaySound then
		ConfigWindow.Boxes[5].Tex:SetVertexColor(0, 0.8, 0)
	else
		ConfigWindow.Boxes[5].Tex:SetVertexColor(0.8, 0, 0)
	end

	if Settings.GrowDown then
		ConfigWindow.Boxes[6].Tex:SetVertexColor(0, 0.8, 0)
	else
		ConfigWindow.Boxes[6].Tex:SetVertexColor(0.8, 0, 0)
	end

	ConfigWindow.Boxes[1].Text:SetText("Announce bonuses beginning")
	ConfigWindow.Boxes[1]:SetScript("OnMouseUp", function(self)
		if Settings.AnnounceStart then
			CallToArmsSettings.AnnounceStart = false
			Settings.AnnounceStart = false

			self.Tex:SetVertexColor(0.8, 0, 0)
		else
			CallToArmsSettings.AnnounceStart = true
			Settings.AnnounceStart = true

			self.Tex:SetVertexColor(0, 0.8, 0)
		end
	end)

	ConfigWindow.Boxes[2].Text:SetText("Announce bonuses ending")
	ConfigWindow.Boxes[2]:SetScript("OnMouseUp", function(self)
		if Settings.AnnounceEndings then
			CallToArmsSettings.AnnounceEndings = false
			Settings.AnnounceEndings = false

			self.Tex:SetVertexColor(0.8, 0, 0)
		else
			CallToArmsSettings.AnnounceEndings = true
			Settings.AnnounceEndings = true

			self.Tex:SetVertexColor(0, 0.8, 0)
		end
	end)

	ConfigWindow.Boxes[3].Text:SetText("Filter roles you cannot perform")
	ConfigWindow.Boxes[3]:SetScript("OnMouseUp", function(self)
		if Settings.FilterRole then
			CallToArmsSettings.FilterRole = false
			Settings.FilterRole = false

			self.Tex:SetVertexColor(0.8, 0, 0)

			CallToArms:LFG_UPDATE_RANDOM_INFO()
		else
			CallToArmsSettings.FilterRole = true
			Settings.FilterRole = true

			self.Tex:SetVertexColor(0, 0.8, 0)

			for k, v in next, CallToArms.Headers do
				v:FilterUpdate()
			end
		end

		if (not Settings.Minimized) then
			CallToArms:SortHeaders()
		end
	end)

	ConfigWindow.Boxes[4].Text:SetText("Auto minimize in groups")
	ConfigWindow.Boxes[4]:SetScript("OnMouseUp", function(self)
		if Settings.MinimizeInGroup then
			CallToArmsSettings.MinimizeInGroup = false
			Settings.MinimizeInGroup = false

			self.Tex:SetVertexColor(0.8, 0, 0)

			CallToArms:RegisterEvent("GROUP_ROSTER_UPDATE")
		else
			CallToArmsSettings.MinimizeInGroup = true
			Settings.MinimizeInGroup = true

			self.Tex:SetVertexColor(0, 0.8, 0)

			CallToArms:UnregisterEvent("GROUP_ROSTER_UPDATE")
		end
	end)

	ConfigWindow.Boxes[5].Text:SetText("Play sound")
	ConfigWindow.Boxes[5]:SetScript("OnMouseUp", function(self)
		if Settings.PlaySound then
			CallToArmsSettings.PlaySound = false
			Settings.PlaySound = false

			self.Tex:SetVertexColor(0.8, 0, 0)
		else
			CallToArmsSettings.PlaySound = true
			Settings.PlaySound = true

			self.Tex:SetVertexColor(0, 0.8, 0)
		end
	end)

	ConfigWindow.Boxes[6].Text:SetText("Grow down")
	ConfigWindow.Boxes[6]:SetScript("OnMouseUp", function(self)
		if Settings.GrowDown then
			CallToArmsSettings.GrowDown = false
			Settings.GrowDown = false

			self.Tex:SetVertexColor(0.8, 0, 0)
		else
			CallToArmsSettings.GrowDown = true
			Settings.GrowDown = true

			self.Tex:SetVertexColor(0, 0.8, 0)
		end

		if (not Settings.Minimized) then
			CallToArms:SortHeaders()
		end
	end)

	-- Modules header
	local ModulesHeader = CreateFrame("Frame", nil, ConfigWindow.ButtonParent)
	ModulesHeader:SetSize(188, 20)

	ModulesHeader.BG = ModulesHeader:CreateTexture(nil, "BORDER")
	ModulesHeader.BG:SetTexture(BlankTexture)
	ModulesHeader.BG:SetVertexColor(0, 0, 0)
	ModulesHeader.BG:SetPoint("TOPLEFT", ModulesHeader, 0, 0)
	ModulesHeader.BG:SetPoint("BOTTOMRIGHT", ModulesHeader, 0, 0)

	ModulesHeader.Tex = ModulesHeader:CreateTexture(nil, "OVERLAY")
	ModulesHeader.Tex:SetTexture(BarTexture)
	ModulesHeader.Tex:SetPoint("TOPLEFT", ModulesHeader, 1, -1)
	ModulesHeader.Tex:SetPoint("BOTTOMRIGHT", ModulesHeader, -1, 1)
	ModulesHeader.Tex:SetVertexColor(0.25, 0.25, 0.25)

	ModulesHeader.Text = ModulesHeader:CreateFontString(nil, "OVERLAY")
	ModulesHeader.Text:SetFont(Font, 12, "")
	ModulesHeader.Text:SetPoint("LEFT", ModulesHeader, 3, 0)
	ModulesHeader.Text:SetJustifyH("LEFT")
	ModulesHeader.Text:SetShadowColor(0, 0, 0)
	ModulesHeader.Text:SetShadowOffset(1, -1)
	ModulesHeader.Text:SetText(DUNGEONS)

	tinsert(ConfigWindow.Widgets, ModulesHeader)

	local ModuleEnables = {}

	for i = 1, self.NumHeaders do
		local DungeonName = self.HeaderIDs[i].DungeonName

		local Checkbox = CreateFrame("Frame", nil, ConfigWindow.ButtonParent)
		Checkbox:SetSize(20, 20)
		Checkbox.DungeonName = DungeonName
		Checkbox.Index = i

		Checkbox.BG = Checkbox:CreateTexture(nil, "BORDER")
		Checkbox.BG:SetTexture(BlankTexture)
		Checkbox.BG:SetVertexColor(0, 0, 0)
		Checkbox.BG:SetPoint("TOPLEFT", Checkbox, 0, 0)
		Checkbox.BG:SetPoint("BOTTOMRIGHT", Checkbox, 0, 0)

		Checkbox.Tex = Checkbox:CreateTexture(nil, "OVERLAY")
		Checkbox.Tex:SetTexture(BarTexture)
		Checkbox.Tex:SetPoint("TOPLEFT", Checkbox, 1, -1)
		Checkbox.Tex:SetPoint("BOTTOMRIGHT", Checkbox, -1, 1)

		Checkbox.Text = Checkbox:CreateFontString(nil, "OVERLAY")
		Checkbox.Text:SetFont(Font, 12, "")
		Checkbox.Text:SetPoint("LEFT", Checkbox, "RIGHT", 3, 0)
		Checkbox.Text:SetSize(ConfigWindow:GetWidth() - 49, 12)
		Checkbox.Text:SetJustifyH("LEFT")
		Checkbox.Text:SetShadowColor(0, 0, 0)
		Checkbox.Text:SetShadowOffset(1, -1)
		Checkbox.Text:SetText(DungeonName)

		if (CallToArmsSettings["Enable"..DungeonName] == true) then
			Checkbox.Tex:SetVertexColor(0, 0.8, 0)
		else
			Checkbox.Tex:SetVertexColor(0.8, 0, 0)
		end

		Checkbox:SetScript("OnMouseUp", function(self)
			if (CallToArmsSettings["Enable"..self.DungeonName] == true) then
				CallToArmsSettings["Enable"..self.DungeonName] = false

				CallToArms.HeaderIDs[self.Index]:Disable()

				self.Tex:SetVertexColor(0.8, 0, 0)
			else
				CallToArmsSettings["Enable"..self.DungeonName] = true

				CallToArms.HeaderIDs[self.Index]:Enable()

				self.Tex:SetVertexColor(0, 0.8, 0)
			end
		end)

		if (i == 1) then
			Checkbox:SetPoint("TOPLEFT", ConfigWindow.Boxes[4], "BOTTOMLEFT", 0, -7)
		else
			Checkbox:SetPoint("TOPLEFT", ModuleEnables[i-1], "BOTTOMLEFT", 0, -2)
		end

		tinsert(ConfigWindow.Widgets, Checkbox)

		ModuleEnables[i] = Checkbox
	end

	-- Scroll bar
	ConfigWindow.ScrollBar = CreateFrame("Slider", nil, ConfigWindow.ButtonParent, "BackdropTemplate")
	ConfigWindow.ScrollBar:SetPoint("TOPRIGHT", ConfigWindow, -3, -3)
	ConfigWindow.ScrollBar:SetPoint("BOTTOMRIGHT", ConfigWindow, -3, 3)
	ConfigWindow.ScrollBar:SetWidth(14)
	ConfigWindow.ScrollBar:SetThumbTexture(BlankTexture)
	ConfigWindow.ScrollBar:SetOrientation("VERTICAL")
	ConfigWindow.ScrollBar:SetValueStep(1)
	ConfigWindow.ScrollBar:SetBackdrop(Outline)
	ConfigWindow.ScrollBar:SetBackdropColor(0.25, 0.25, 0.25)
	ConfigWindow.ScrollBar:SetBackdropBorderColor(0, 0, 0)
	ConfigWindow.ScrollBar:SetMinMaxValues(1, (#ConfigWindow.Widgets - (MAX_SHOWN - 1)))
	ConfigWindow.ScrollBar:SetValue(1)
	ConfigWindow.ScrollBar:EnableMouse(true)
	ConfigWindow.ScrollBar:SetScript("OnValueChanged", ScrollBarOnValueChanged)
	ConfigWindow.ScrollBar.Parent = ConfigWindow

	ConfigWindow.ScrollBar:SetFrameStrata("HIGH")
	ConfigWindow.ScrollBar:SetFrameLevel(22)

	local Thumb = ConfigWindow.ScrollBar:GetThumbTexture()
	Thumb:SetSize(14, 20)
	Thumb:SetTexture(BarTexture)
	Thumb:SetVertexColor(0, 0, 0)

	ConfigWindow.ScrollBar.NewTexture = ConfigWindow.ScrollBar:CreateTexture(nil, "BORDER")
	ConfigWindow.ScrollBar.NewTexture:SetPoint("TOPLEFT", Thumb, 0, 0)
	ConfigWindow.ScrollBar.NewTexture:SetPoint("BOTTOMRIGHT", Thumb, 0, 0)
	ConfigWindow.ScrollBar.NewTexture:SetTexture(BlankTexture)
	ConfigWindow.ScrollBar.NewTexture:SetVertexColor(0, 0, 0)

	ConfigWindow.ScrollBar.NewTexture2 = ConfigWindow.ScrollBar:CreateTexture(nil, "OVERLAY")
	ConfigWindow.ScrollBar.NewTexture2:SetPoint("TOPLEFT", ConfigWindow.ScrollBar.NewTexture, 1, -1)
	ConfigWindow.ScrollBar.NewTexture2:SetPoint("BOTTOMRIGHT", ConfigWindow.ScrollBar.NewTexture, -1, 1)
	ConfigWindow.ScrollBar.NewTexture2:SetTexture(BarTexture)
	ConfigWindow.ScrollBar.NewTexture2:SetVertexColor(0.2, 0.2, 0.2)

	local Height

	if (self.NumHeaders > 6) then
		Height = (MAX_SHOWN * 22) + 4

		Scroll(ConfigWindow)
	else
		Height = ((6 + self.NumHeaders) * 22) + 4
	end

	ConfigWindow:SetHeight(Height)

	Scroll(ConfigWindow)
end

local SlashCommand = function(cmd)
	if (cmd == "toggle") then
		if CallToArms:IsShown() then
			CallToArms:Hide()
		else
			CallToArms:Show()
		end
	elseif (cmd == "reset") then
		CallToArms:ClearAllPoints()
		CallToArms:SetPoint("CENTER", UIParent, 0, 0)
	else
		if (not CallToArmsConfig) then
			CallToArms:CreateConfig()

			return
		end

		if CallToArmsConfig:IsShown() then
			CallToArmsConfig:Hide()
		else
			CallToArmsConfig:Show()
		end
	end
end

SLASH_CALLTOARMS1 = "/cta"
SLASH_CALLTOARMS2 = "/ctaa"
SlashCmdList["CALLTOARMS"] = SlashCommand