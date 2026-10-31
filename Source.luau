local v0_1 = {}
v0_1.__index = v0_1
local v0_2 = {}
v0_2.__index = v0_2
local v0_3 = {}
v0_3.__index = v0_3
local v0_4 = game:GetService("UserInputService")
local v0_5 = game:GetService("TweenService")
local v0_6 = game:GetService("RunService")
local v0_7 = game:GetService("MarketplaceService")
local v0_8 = {
	Main = Color3.fromRGB(24, 24, 28),
	Sidebar = Color3.fromRGB(18, 18, 22),
	Card = Color3.fromRGB(30, 30, 35),
	Element = Color3.fromRGB(40, 40, 46),
	Hover = Color3.fromRGB(50, 50, 58),
	Danger = Color3.fromRGB(200, 60, 60),	Off = Color3.fromRGB(65, 65, 74),
	IconOff = Color3.fromRGB(160, 160, 170),
	IconOn = Color3.fromRGB(255, 255, 255),
	Accent = Color3.fromRGB(50, 90, 220),
	Text = Color3.fromRGB(255, 255, 255),
	SubText = Color3.fromRGB(200, 200, 210),
}
local v0_9 = 50
local v0_10 = 26
local v0_11 = 8
local function v0_12(v1_13, v1_14, v1_15, v1_16, v1_17)
	local v1_18 = v0_5:Create(
		v1_13,
		TweenInfo.new(v1_15 or 0.15, v1_16 or Enum.EasingStyle.Quad, v1_17 or Enum.EasingDirection.Out),
		v1_14
	)
	v1_18:Play()
	return v1_18
end
local function v0_19(v1_20)
	return v1_20.UserInputType == Enum.UserInputType.MouseButton1 or v1_20.UserInputType == Enum.UserInputType.Touch
end
local function v0_21(v1_22, v1_23, v1_24, v1_25)
	local v1_26 = Instance.new("UIScale")
	v1_26.Parent = v1_22
	v1_22.MouseEnter:Connect(function()
		if not (v1_25 and v1_25()) then
			v0_12(v1_22, { BackgroundColor3 = v1_24 }, 0.12)
		end
	end)
	v1_22.MouseLeave:Connect(function()
		v0_12(v1_26, { Scale = 1 }, 0.12)
		if not (v1_25 and v1_25()) then
			v0_12(v1_22, { BackgroundColor3 = v1_23 }, 0.15)
		end
	end)
	v1_22.InputBegan:Connect(function(v2_27)
		if v0_19(v2_27) then v0_12(v1_26, { Scale = 0.96 }, 0.08) end
	end)
	v1_22.InputEnded:Connect(function(v2_28)
		if v0_19(v2_28) then v0_12(v1_26, { Scale = 1 }, 0.18, Enum.EasingStyle.Back) end
	end)
end
local function v0_29(v1_30)
	return v1_30:find("^rbx") ~= nil or v1_30:find("^https?://") ~= nil
end
local function v0_31(v1_32, v1_33, v1_34)
	if v1_34 > 3 then return end
	for v2_35, v2_36 in pairs(v1_32) do
		local v2_37 = type(v2_35) == "string" and v2_35:lower() or ""
		local v2_38 = typeof(v2_36)
		if v2_38 == "string" then
			if v0_29(v2_36) then
				v1_33.image = v1_33.image or v2_36
			elseif v2_36:match("^%d+$") then
				v1_33.image = v1_33.image or ("rbxassetid://" .. v2_36)
			end
		elseif v2_38 == "number" then
			if v2_37 == "id" or v2_37 == "image" or v2_37 == "imageid" or v2_37 == "assetid" or v2_35 == 1 then
				if v2_36 > 1000 then v1_33.image = v1_33.image or ("rbxassetid://" .. v2_36) end
			end
		elseif v2_38 == "Vector2" then
			if v2_37:find("size") then
				v1_33.size = v1_33.size or v2_36
			elseif v2_37:find("pos") or v2_37:find("offset") then
				v1_33.offset = v1_33.offset or v2_36
			end
		elseif v2_38 == "table" then
			v0_31(v2_36, v1_33, v1_34 + 1)
		end
	end
end
local function v0_39(v1_40)
	local v1_41 = {}
	local v1_42 = typeof(v1_40)
	if v1_42 == "string" then
		if v0_29(v1_40) then
			v1_41.image = v1_40
		elseif v1_40:match("^%d+$") then
			v1_41.image = "rbxassetid://" .. v1_40
		end
	elseif v1_42 == "number" then
		v1_41.image = "rbxassetid://" .. v1_40
	elseif v1_42 == "table" then
		v0_31(v1_40, v1_41, 0)
	elseif v1_42 == "Instance" then
		local v2_43 = (v1_40:IsA("ImageLabel") or v1_40:IsA("ImageButton")) and v1_40
			or v1_40:FindFirstChildWhichIsA("ImageLabel", true)
		if v2_43 then
			v1_41.image, v1_41.size, v1_41.offset = v2_43.Image, v2_43.ImageRectSize, v2_43.ImageRectOffset
		end
	end
	if v1_41.image == "" then v1_41.image = nil end
	return v1_41
end
local function v0_44(v1_45, v1_46, v1_47, v1_48)
	local v1_49 = v0_39(v1_46)
	if not v1_49.image and typeof(v1_46) == "string" and v1_47 then
		local v2_50 = {
			function() return v1_47.GetIcon(v1_46) end,
			function() return v1_47:GetIcon(v1_46) end,
			function() return v1_47.Icons and v1_47.Icons[v1_46] end,
			function() return v1_47[v1_46] end,
		}
		for v3_51, v3_52 in ipairs(v2_50) do
			local v3_53, v3_54 = pcall(v3_52)
			if v3_53 and v3_54 ~= nil then
				local v4_55 = v0_39(v3_54)
				if v4_55.image then
					v1_49 = v4_55
					break
				end
			end
		end
	end
	if not v1_49.image then
		if not v1_48 then warn("[RobloxUI] icon not recognized:", typeof(v1_46), v1_46) end
		return false
	end
	v1_45.Image = v1_49.image
	v1_45.ImageRectSize = v1_49.size or Vector2.new(0, 0)
	v1_45.ImageRectOffset = v1_49.offset or Vector2.new(0, 0)
	return true
end
local function v0_56(v1_57)
	local v1_58 = pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(v1_57)
			v1_57.Parent = game:GetService("CoreGui")
		elseif gethui then
			v1_57.Parent = gethui()
		else
			v1_57.Parent = game:GetService("CoreGui")
		end
	end)
	if not v1_58 or not v1_57.Parent then
		local v2_59 = game:GetService("Players").LocalPlayer
		v1_57.Parent = v2_59 and v2_59:WaitForChild("PlayerGui")
	end
end
local function v0_60()
	local v1_61, v1_62 = pcall(function()
		return loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()
	end)
	if v1_61 and v1_62 then return v1_62 end
	warn("[RobloxUI] failed to load icon library:", v1_62)
	return nil
end
local function v0_63(v1_64, v1_65)
	local v1_66 = Instance.new("UICorner")
	v1_66.CornerRadius = UDim.new(0, v1_65 or 6)
	v1_66.Parent = v1_64
	return v1_66
end
local v0_67 = { translations = {}, code = nil, resolved = nil, dict = nil, windows = {} }
local function v0_68(v1_69)
	return (tostring(v1_69):lower():gsub("_", "-"))
end
local function v0_70()
	local v1_71
	pcall(function()
		v1_71 = game:GetService("Players").LocalPlayer.LocaleId
	end)
	if type(v1_71) ~= "string" or v1_71 == "" then
		pcall(function()
			v1_71 = game:GetService("LocalizationService").RobloxLocaleId
		end)
	end
	if type(v1_71) ~= "string" or v1_71 == "" then
		pcall(function()
			v1_71 = game:GetService("LocalizationService").SystemLocaleId
		end)
	end
	if type(v1_71) == "string" and v1_71 ~= "" then return v1_71 end
	return "en-us"
end
local function v0_72(v1_73)
	local v1_74 = v0_68(v1_73)
	local v1_75 = v1_74:match("^[^-]+")
	local v1_76 = {}
	for v2_77 in pairs(v0_67.translations) do table.insert(v1_76, v2_77) end
	table.sort(v1_76)
	local v1_78
	for v2_79, v2_80 in ipairs(v1_76) do
		local v2_81 = v0_68(v2_80)
		if v2_81 == v1_74 then return v2_80 end
		if not v1_78 and v2_81:match("^[^-]+") == v1_75 then v1_78 = v2_80 end
	end
	return v1_78
end
local function v0_82(v1_83)
	if type(v1_83) ~= "string" then return v1_83 end
	local v1_84 = v0_67.dict
	return v1_84 and v1_84[v1_83] or v1_83
end
function v0_1:T(v1_85)
	return v0_82(v1_85)
end
function v0_1:_track(v1_86, v1_87, v1_88)
	v1_86[v1_87] = v0_82(v1_88)
	local v1_89 = { obj = v1_86, prop = v1_87, key = v1_88 }
	table.insert(self._i18n, v1_89)
	return v1_89
end
function v0_1:_onLang(v1_90, v1_91)
	table.insert(self._i18n, { obj = v1_90, fn = v1_91 })
end
local function v0_92(v1_93)
	local v1_94 = v1_93._i18n
	for v2_95 = #v1_94, 1, -1 do
		local v2_96 = v1_94[v2_95]
		if not v2_96.obj:IsDescendantOf(v1_93.ScreenGui) then
			table.remove(v1_94, v2_95)
		elseif v2_96.fn then
			pcall(v2_96.fn)
		else
			v2_96.obj[v2_96.prop] = v0_82(v2_96.key)
		end
	end
end
function v0_1:AddTranslations(v1_97)
	for v2_98, v2_99 in pairs(v1_97 or {}) do
		local v2_100 = v0_67.translations[v2_98]
		if not v2_100 then
			v2_100 = {}
			v0_67.translations[v2_98] = v2_100
		end
		for v3_101, v3_102 in pairs(v2_99) do v2_100[v3_101] = v3_102 end
	end
	if v0_67.code then v0_1:SetLang(v0_67.code) end
end
function v0_1:SetLang(v1_103)
	if v1_103 == nil or v1_103 == "auto" then v1_103 = v0_70() end
	v0_67.code = v1_103
	v0_67.resolved = v0_72(v1_103)
	v0_67.dict = v0_67.resolved and v0_67.translations[v0_67.resolved] or nil
	for v2_104 = #v0_67.windows, 1, -1 do
		local v2_105 = v0_67.windows[v2_104]
		if v2_105._destroyed then
			table.remove(v0_67.windows, v2_104)
		else
			v0_92(v2_105)
		end
	end
	return v0_67.resolved
end
function v0_1:GetLang()
	return v0_67.resolved, v0_67.code
end
function v0_1.new(v1_106)
	v1_106 = v1_106 or {}
	local v1_107 = setmetatable({}, v0_1)
	v1_107.Tabs = {}
	v1_107.ActiveTab = nil
	v1_107.Icons = v1_106.Icons or v0_60()
	v1_107.IconGlow = v1_106.IconGlow == true
	v1_107._i18n = {}
	if v1_106.Translations then v0_1:AddTranslations(v1_106.Translations) end
	if v1_106.Lang ~= nil then v0_1:SetLang(v1_106.Lang) end
	table.insert(v0_67.windows, v1_107)
	v1_107._dialogs = {}
	v1_107._binds = {}
	v1_107._cleanups = {}
	v1_107._listening = nil
	v1_107._toggleKey = v1_106.ToggleKey
	v1_107._connections = {}
	local v1_108 = Instance.new("ScreenGui")
	v1_108.Name = "Interface"
	v1_108.ResetOnSpawn = false
	v1_108.IgnoreGuiInset = true
	v1_108.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	v0_56(v1_108)
	local v1_109 = v1_106.Size or UDim2.new(0, 600, 0, 400)
	local v1_110 = Instance.new("CanvasGroup")
	v1_110.Name = "Main"
	v1_110.Size = v1_109
	v1_110.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_110.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_110.BackgroundColor3 = v0_8.Main
	v1_110.BorderSizePixel = 0
	v1_110.ClipsDescendants = true
	v1_110.GroupTransparency = 1
	v1_110.Parent = v1_108
	v0_63(v1_110, v0_11)
	local v1_111 = Instance.new("UIScale")
	v1_111.Scale = 0.9
	v1_111.Parent = v1_110
	local function v1_112()
		local v2_113 = v1_108.AbsoluteSize
		if v2_113.X <= 0 or v2_113.Y <= 0 then
			local v3_114 = workspace.CurrentCamera
			v2_113 = v3_114 and v3_114.ViewportSize or Vector2.new(1280, 720)
		end
		local v2_115, v2_116 = v1_109.X.Offset, v1_109.Y.Offset
		if v1_109.X.Scale == 0 then v2_115 = math.min(v2_115, math.max(v2_113.X - 20, 120)) end
		if v1_109.Y.Scale == 0 then v2_116 = math.min(v2_116, math.max(v2_113.Y - 20, 120)) end
		v1_110.Size = UDim2.new(v1_109.X.Scale, v2_115, v1_109.Y.Scale, v2_116)
		v1_110.Position = UDim2.new(0.5, 0, 0.5, 0)
	end
	v1_112()
	table.insert(v1_107._connections, v1_108:GetPropertyChangedSignal("AbsoluteSize"):Connect(v1_112))
	do
		local v2_117, v2_118, v2_119 = false, nil, nil
		local v2_120 = 50
		table.insert(v1_107._connections, v1_110.InputBegan:Connect(function(v3_121)
			if v3_121.UserInputType == Enum.UserInputType.MouseButton1 or v3_121.UserInputType == Enum.UserInputType.Touch then
				v2_117 = true
				v2_118 = v3_121.Position
				v2_119 = v1_110.AbsolutePosition + v1_110.AbsoluteSize / 2
				v3_121.Changed:Connect(function()
					if v3_121.UserInputState == Enum.UserInputState.End then v2_117 = false end
				end)
			end
		end))
		table.insert(v1_107._connections, v0_4.InputChanged:Connect(function(v3_122)
			if not v2_117 then return end
			if v3_122.UserInputType ~= Enum.UserInputType.MouseMovement and v3_122.UserInputType ~= Enum.UserInputType.Touch then
				return
			end
			local v3_123 = v3_122.Position - v2_118
			local v3_124 = v1_108.AbsoluteSize
			local v3_125 = v1_110.AbsoluteSize / 2
			local v3_126 = math.clamp(v2_119.X + v3_123.X, -v3_125.X + v2_120, v3_124.X + v3_125.X - v2_120)
			local v3_127 = math.clamp(v2_119.Y + v3_123.Y, v3_125.Y, math.max(v3_124.Y + v3_125.Y - v2_120, v3_125.Y))
			v1_110.Position = UDim2.fromOffset(v3_126, v3_127)
		end))
	end
	local v1_128 = Instance.new("Frame")
	v1_128.Name = "Sidebar"
	v1_128.Size = UDim2.new(0, v0_9, 1, 0)
	v1_128.BackgroundColor3 = v0_8.Sidebar
	v1_128.BorderSizePixel = 0
	v1_128.Parent = v1_110
	v0_63(v1_128, v0_11)
	local v1_129 = Instance.new("Frame")
	v1_129.Name = "SidebarFix"
	v1_129.Size = UDim2.new(0, v0_11, 1, 0)
	v1_129.Position = UDim2.new(0, v0_9 - v0_11, 0, 0)
	v1_129.BackgroundColor3 = v0_8.Sidebar
	v1_129.BorderSizePixel = 0
	v1_129.Parent = v1_110
	local v1_130 = Instance.new("UIPadding")
	v1_130.PaddingTop = UDim.new(0, 12)
	v1_130.Parent = v1_128
	local v1_131 = Instance.new("UIListLayout")
	v1_131.Padding = UDim.new(0, 8)
	v1_131.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_131.SortOrder = Enum.SortOrder.LayoutOrder
	v1_131.Parent = v1_128
	local v1_132 = v1_106.Footer ~= false and v0_10 or 0
	local v1_133 = Instance.new("Frame")
	v1_133.Name = "Content"
	v1_133.Size = UDim2.new(1, -v0_9, 1, -v1_132)
	v1_133.Position = UDim2.new(0, v0_9, 0, 0)
	v1_133.BackgroundTransparency = 1
	v1_133.BorderSizePixel = 0
	v1_133.ClipsDescendants = true
	v1_133.Parent = v1_110
	do
		local v2_134 = Instance.new("CanvasGroup")
		v2_134.Name = "ScrollHint"
		v2_134.AnchorPoint = Vector2.new(0.5, 1)
		v2_134.Position = UDim2.new(0.5, -1, 1, -6)
		v2_134.Size = UDim2.new(0, 22, 0, 22)
		v2_134.BackgroundTransparency = 1
		v2_134.BorderSizePixel = 0
		v2_134.GroupTransparency = 1
		v2_134.Visible = false
		v2_134.Active = false
		v2_134.ZIndex = 10
		v2_134.Parent = v1_133
		local v2_135 = Instance.new("ImageLabel")
		v2_135.Name = "Icon"
		v2_135.AnchorPoint = Vector2.new(0.5, 0.5)
		v2_135.Position = UDim2.new(0.5, 0, 0.5, -3)
		v2_135.Size = UDim2.new(0, 16, 0, 16)
		v2_135.BackgroundTransparency = 1
		v2_135.BorderSizePixel = 0
		v2_135.ImageColor3 = v0_8.SubText
		v2_135.ScaleType = Enum.ScaleType.Fit
		v2_135.Active = false
		v2_135.Parent = v2_134
		local v2_136 = Instance.new("TextLabel")
		v2_136.Name = "IconFallback"
		v2_136.Size = UDim2.new(1, 0, 1, 0)
		v2_136.BackgroundTransparency = 1
		v2_136.Text = "▼"
		v2_136.TextColor3 = v0_8.SubText
		v2_136.Font = Enum.Font.Gotham
		v2_136.TextSize = 11
		v2_136.Parent = v2_135
		v2_136.Visible = not v0_44(v2_135, "chevron-down", v1_107.Icons)
		local v2_137 = v0_5:Create(
			v2_135,
			TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
			{ Position = UDim2.new(0.5, 0, 0.5, 3) }
		)
		local v2_138 = Instance.new("TextButton")
		v2_138.Name = "Click"
		v2_138.Size = UDim2.new(1, 0, 1, 0)
		v2_138.BackgroundTransparency = 1
		v2_138.BorderSizePixel = 0
		v2_138.Text = ""
		v2_138.AutoButtonColor = false
		v2_138.ZIndex = 2
		v2_138.Parent = v2_134
		local v2_139 = UDim2.new(0.5, -1, 1, -34)
		local v2_140 = UDim2.new(0.5, -1, 1, -27)
		local v2_141 = Instance.new("CanvasGroup")
		v2_141.Name = "ScrollHintText"
		v2_141.AnchorPoint = Vector2.new(0.5, 1)
		v2_141.Position = v2_140
		v2_141.Size = UDim2.new(0, 0, 0, 0)
		v2_141.AutomaticSize = Enum.AutomaticSize.XY
		v2_141.BackgroundColor3 = v0_8.Sidebar
		v2_141.BorderSizePixel = 0
		v2_141.GroupTransparency = 1
		v2_141.Visible = false
		v2_141.Active = false
		v2_141.ZIndex = 10
		v2_141.Parent = v1_133
		v0_63(v2_141, 6)
		local v2_142 = Instance.new("UIStroke")
		v2_142.Color = v0_8.Element
		v2_142.Thickness = 1
		v2_142.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		v2_142.Parent = v2_141
		local v2_143 = Instance.new("UIPadding")
		v2_143.PaddingTop = UDim.new(0, 6)
		v2_143.PaddingBottom = UDim.new(0, 6)
		v2_143.PaddingLeft = UDim.new(0, 10)
		v2_143.PaddingRight = UDim.new(0, 10)
		v2_143.Parent = v2_141
		local v2_144 = Instance.new("TextLabel")
		v2_144.Name = "Text"
		v2_144.Size = UDim2.new(0, 0, 0, 0)
		v2_144.AutomaticSize = Enum.AutomaticSize.XY
		v2_144.BackgroundTransparency = 1
		v2_144.BorderSizePixel = 0
		v1_107:_track(v2_144, "Text", "Scroll To See More Features.")
		v2_144.TextColor3 = v0_8.Text
		v2_144.Font = Enum.Font.Gotham
		v2_144.TextSize = 12
		v2_144.Parent = v2_141
		local v2_145, v2_146, v2_147 = false, nil, nil
		local function v2_148(v3_149)
			if v2_146 and v2_146 ~= coroutine.running() then
				pcall(task.cancel, v2_146)
			end
			v2_146 = nil
			if not v2_145 then return end
			v2_145 = false
			if v2_147 then v2_147:Cancel() end
			if v3_149 then
				v2_141.GroupTransparency = 1
				v2_141.Visible = false
				return
			end
			local v3_150 = v0_12(v2_141, { GroupTransparency = 1, Position = v2_140 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			v2_147 = v3_150
			v3_150.Completed:Connect(function(v4_151)
				if v4_151 == Enum.PlaybackState.Completed and not v2_145 then
					v2_141.Visible = false
				end
			end)
		end
		local function v2_152()
			if v2_145 then return end
			v2_145 = true
			if v2_147 then v2_147:Cancel() end
			if not v2_141.Visible then
				v2_141.Position = v2_140
				v2_141.Visible = true
			end
			v2_147 = v0_12(v2_141, { GroupTransparency = 0, Position = v2_139 }, 0.25, Enum.EasingStyle.Quint)
			v2_146 = task.spawn(function()
				task.wait(3.5)
				v2_146 = nil
				v2_148()
			end)
		end
		v2_138.MouseButton1Click:Connect(function()
			if v2_145 then v2_148() else v2_152() end
		end)
		v1_107._hint = { Frame = v2_134, Icon = v2_135, Bounce = v2_137, Shown = false, HideTip = v2_148 }
	end
	if v1_132 > 0 then
		local v2_153 = Instance.new("Frame")
		v2_153.Name = "Footer"
		v2_153.AnchorPoint = Vector2.new(0, 1)
		v2_153.Position = UDim2.new(0, 0, 1, 0)
		v2_153.Size = UDim2.new(1, 0, 0, v1_132)
		v2_153.BackgroundColor3 = v0_8.Sidebar
		v2_153.BorderSizePixel = 0
		v2_153.Parent = v1_110
		local v2_154 = Instance.new("Frame")
		v2_154.Name = "Divider"
		v2_154.Size = UDim2.new(1, 0, 0, 1)
		v2_154.BackgroundColor3 = v0_8.Element
		v2_154.BorderSizePixel = 0
		v2_154.Parent = v2_153
		local function v2_155(v3_156, v3_157, v3_158, v3_159, v3_160)
			local v3_161 = Instance.new("TextLabel")
			v3_161.Name = v3_156
			v3_161.AnchorPoint = v3_160
			v3_161.Position = v3_158
			v3_161.Size = v3_159
			v3_161.BackgroundTransparency = 1
			v3_161.BorderSizePixel = 0
			v3_161.Text = ""
			v3_161.TextColor3 = v0_8.SubText
			v3_161.Font = Enum.Font.Gotham
			v3_161.TextSize = 12
			v3_161.TextXAlignment = v3_157
			v3_161.TextTruncate = Enum.TextTruncate.AtEnd
			v3_161.Parent = v2_153
			return v3_161
		end
		local v2_162 = v2_155("Time", Enum.TextXAlignment.Left, UDim2.new(0, 12, 0, 0), UDim2.new(0, 100, 1, 0), Vector2.new(0, 0))
		local v2_163 = v2_155("Game", Enum.TextXAlignment.Center, UDim2.new(0, 112, 0, 0), UDim2.new(1, -224, 1, 0), Vector2.new(0, 0))
		local v2_164 = v2_155("Executor", Enum.TextXAlignment.Right, UDim2.new(1, -12, 0, 0), UDim2.new(0, 100, 1, 0), Vector2.new(1, 0))
		if type(v1_106.FooterLeft) == "string" then
			v2_162.Text = v1_106.FooterLeft
		else
			local function v3_165()
				local v4_166 = os.date("%I:%M %p")
				if v2_162.Text ~= v4_166 then v2_162.Text = v4_166 end
			end
			v3_165()
			v1_107._clock = task.spawn(function()
				while not v1_107._destroyed do
					task.wait(60 - (os.time() % 60) + 0.1)
					v3_165()
				end
			end)
		end
		if type(v1_106.FooterCenter) == "string" then
			v2_163.Text = v1_106.FooterCenter
		else
			v2_163.Text = v0_82("Loading...")
			task.spawn(function()
				local v4_167, v4_168 = pcall(function()
					return v0_7:GetProductInfo(game.PlaceId)
				end)
				if v1_107._destroyed then return end
				v2_163.Text = (v4_167 and v4_168 and v4_168.Name) or tostring(game.Name)
			end)
		end
		if type(v1_106.FooterRight) == "string" then
			v2_164.Text = v1_106.FooterRight
		else
			local v3_169
			if type(identifyexecutor) == "function" then
				local v4_170, v4_171 = pcall(identifyexecutor)
				if v4_170 and v4_171 then v3_169 = tostring(v4_171) end
			end
			v2_164.Text = v3_169 or "Roblox"
		end
	end
	if v1_106.Resizable ~= false then
		local v2_172 = v1_106.MinSize or Vector2.new(380, 260)
		local v2_173 = v1_106.MaxSize
		local v2_174 = Instance.new("TextButton")
		v2_174.Name = "ResizeGrip"
		v2_174.AnchorPoint = Vector2.new(1, 1)
		v2_174.Position = UDim2.new(1, -6, 1, -6 - v1_132)
		v2_174.Size = UDim2.new(0, 22, 0, 22)
		v2_174.BackgroundColor3 = v0_8.Main
		v2_174.BackgroundTransparency = 0.25
		v2_174.BorderSizePixel = 0
		v2_174.Text = ""
		v2_174.AutoButtonColor = false
		v2_174.Parent = v1_110
		v0_63(v2_174, 6)
		local v2_175 = Instance.new("ImageLabel")
		v2_175.Name = "Icon"
		v2_175.AnchorPoint = Vector2.new(0.5, 0.5)
		v2_175.Position = UDim2.new(0.5, 0, 0.5, 0)
		v2_175.Size = UDim2.new(0, 14, 0, 14)
		v2_175.BackgroundTransparency = 1
		v2_175.BorderSizePixel = 0
		v2_175.ImageColor3 = v0_8.IconOff
		v2_175.ScaleType = Enum.ScaleType.Fit
		v2_175.Parent = v2_174
		local v2_176 = Instance.new("TextLabel")
		v2_176.Name = "IconFallback"
		v2_176.Size = UDim2.new(1, 0, 1, 0)
		v2_176.BackgroundTransparency = 1
		v2_176.Text = "⤢"
		v2_176.TextColor3 = v0_8.IconOff
		v2_176.Font = Enum.Font.GothamBold
		v2_176.TextSize = 14
		v2_176.Parent = v2_175
		v2_176.Visible = not v0_44(v2_175, "expand", v1_107.Icons)
		local v2_177 = Instance.new("UIScale")
		v2_177.Parent = v2_174
		local v2_178, v2_179, v2_180 = false, false, nil
		local function v2_181()
			local v3_182 = v2_178 or v2_179
			local v3_183 = v3_182 and v0_8.IconOn or v0_8.IconOff
			v0_12(v2_175, { ImageColor3 = v3_183 }, 0.15)
			v0_12(v2_176, { TextColor3 = v3_183 }, 0.15)
			v0_12(v2_174, { BackgroundColor3 = v3_182 and v0_8.Hover or v0_8.Main }, 0.15)
		end
		local function v2_184()
			if v2_180 then
				for v5_185, v5_186 in ipairs(v2_180) do v5_186:Disconnect() end
				v2_180 = nil
			end
			if v2_179 then
				v2_179 = false
				v2_181()
				v0_12(v2_177, { Scale = v2_178 and 1.1 or 1 }, 0.18, Enum.EasingStyle.Back)
			end
		end
		local function v2_187(v3_188)
			v2_184()
			v2_179 = true
			v2_181()
			v0_12(v2_177, { Scale = 0.9 }, 0.08)
			local v3_189 = v1_111.Scale
			local v3_190 = v3_188.Position
			local v3_191 = v1_110.AbsoluteSize / v3_189
			local v3_192 = v1_110.AbsolutePosition
			v2_180 = {
				v0_4.InputChanged:Connect(function(v4_193)
					if v4_193.UserInputType ~= Enum.UserInputType.MouseMovement and v4_193 ~= v3_188 then return end
					local v4_194 = v4_193.Position - v3_190
					local v4_195 = v1_108.AbsoluteSize
					local v4_196 = math.max(v2_172.X, v4_195.X - v3_192.X - 4)
					local v4_197 = math.max(v2_172.Y, v4_195.Y - v3_192.Y - 4)
					if v2_173 then
						v4_196 = math.max(v2_172.X, math.min(v4_196, v2_173.X))
						v4_197 = math.max(v2_172.Y, math.min(v4_197, v2_173.Y))
					end
					local v4_198 = math.clamp(v3_191.X + v4_194.X / v3_189, v2_172.X, v4_196)
					local v4_199 = math.clamp(v3_191.Y + v4_194.Y / v3_189, v2_172.Y, v4_197)
					v1_109 = UDim2.fromOffset(v4_198, v4_199)
					v1_110.Size = v1_109
					v1_110.Position = UDim2.fromOffset(v3_192.X + v4_198 * v3_189 / 2, v3_192.Y + v4_199 * v3_189 / 2)
				end),
				v0_4.InputEnded:Connect(function(v4_200)
					if v4_200 == v3_188 or v4_200.UserInputType == Enum.UserInputType.MouseButton1 then
						v2_184()
					end
				end),
			}
		end
		v2_174.InputBegan:Connect(function(v3_201)
			if v0_19(v3_201) then v2_187(v3_201) end
		end)
		v2_174.MouseEnter:Connect(function()
			v2_178 = true
			v2_181()
			if not v2_179 then v0_12(v2_177, { Scale = 1.1 }, 0.12) end
		end)
		v2_174.MouseLeave:Connect(function()
			v2_178 = false
			v2_181()
			if not v2_179 then v0_12(v2_177, { Scale = 1 }, 0.12) end
		end)
		v1_107._cleanups[v2_174] = v2_184
	end
	v1_107.ScreenGui, v1_107.Main, v1_107.Sidebar, v1_107.Content = v1_108, v1_110, v1_128, v1_133
	if v1_106.Icon ~= nil then
		v1_107:SetIcon(v1_106.Icon, v1_106.IconColor)
	end
	v1_107._scale = v1_111
	v1_107._visible = false
	if v1_106.Watermark ~= false then
		v1_107:_buildWatermark(v1_106.Title or v1_106.Name or "RobloxUI")
	end
	table.insert(v1_107._connections, v0_4.InputBegan:Connect(function(v2_202, v2_203)
		local v2_204 = v1_107._listening
		if v2_204 then
			if v2_202.UserInputType == Enum.UserInputType.Keyboard then
				if not v0_4:GetFocusedTextBox() then
					v2_204:_capture(v2_202.KeyCode)
				end
			elseif v0_19(v2_202) and not v2_203 then
				v2_204:_stopListening()
			end
			return
		end
		if v2_203 or v2_202.UserInputType ~= Enum.UserInputType.Keyboard then return end
		local v2_205 = v2_202.KeyCode
		if #v1_107._dialogs > 0 then
			if v2_205 == Enum.KeyCode.Escape then
				local v4_206 = v1_107._dialogs[#v1_107._dialogs]
				if v4_206.Dismissable then v4_206.Close() end
			end
			return
		end
		if v1_107._toggleKey and v2_205 == v1_107._toggleKey then
			v1_107:Toggle()
			return
		end
		for v3_207, v3_208 in ipairs(table.clone(v1_107._binds)) do
			if v3_208._key == v2_205 and not v3_208._destroyed then
				v3_208._onPress()
			end
		end
	end))
	if v1_106.StartHidden then
		v1_110.Visible = false
		v1_107:_updateWatermark()
	else
		v1_107:Show()
	end
	return v1_107
end
function v0_1:SetIcon(v1_209, v1_210)
	local v1_211 = self._logo
	if not v1_211 then
		local v2_212 = Instance.new("Frame")
		v2_212.Name = "Logo"
		v2_212.Size = UDim2.new(0, 36, 0, 36)
		v2_212.BackgroundTransparency = 1
		v2_212.BorderSizePixel = 0
		v2_212.LayoutOrder = 0
		v2_212.Visible = false
		v2_212.Parent = self.Sidebar
		local v2_213 = Instance.new("ImageLabel")
		v2_213.Name = "Icon"
		v2_213.AnchorPoint = Vector2.new(0.5, 0.5)
		v2_213.Position = UDim2.new(0.5, 0, 0.5, 0)
		v2_213.Size = UDim2.new(0, 26, 0, 26)
		v2_213.BackgroundTransparency = 1
		v2_213.BorderSizePixel = 0
		v2_213.ScaleType = Enum.ScaleType.Fit
		v2_213.Parent = v2_212
		v1_211 = { Holder = v2_212, Img = v2_213 }
		self._logo = v1_211
	end
	if v1_209 == nil then
		v1_211.Holder.Visible = false
		return false
	end
	local v1_214 = v0_44(v1_211.Img, v1_209, self.Icons)
	v1_211.Holder.Visible = v1_214
	if v1_214 then
		local v2_215 = type(v1_209) == "string" and not v1_209:find("^rbx") and not v1_209:find("^https?://") and not v1_209:match("^%d+$")
		v1_211.Img.ImageColor3 = v1_210 or (v2_215 and v0_8.Accent or Color3.new(1, 1, 1))
	end
	return v1_214
end
function v0_1.CreateWindow(v1_216, v1_217)
	return v0_1.new(v1_216 == v0_1 and v1_217 or v1_216)
end
function v0_1:Destroy()
	for v2_218, v2_219 in ipairs(self._connections) do
		v2_219:Disconnect()
	end
	self._connections = {}
	self._destroyed = true
	if self._hint then pcall(self._hint.HideTip, true) end
	if self._clock then pcall(task.cancel, self._clock) end
	for v2_220, v2_221 in ipairs(table.clone(self._notifs or {})) do pcall(v2_221) end
	for v2_222, v2_223 in pairs(self._cleanups) do pcall(v2_223) end
	self._cleanups = {}
	self._binds = {}
	self._listening = nil
	self.ScreenGui:Destroy()
end
local v0_224, v0_225 = 0.35, 0.2
function v0_1:_cancelAnim()
	if self._anim then
		for v3_226, v3_227 in ipairs(self._anim) do v3_227:Cancel() end
		self._anim = nil
	end
end
function v0_1:Show()
	if self._destroyed then return end
	self._visible = true
	self:_cancelAnim()
	self.Main.Visible = true
	self._anim = {
		v0_12(self.Main, { GroupTransparency = 0 }, v0_224, Enum.EasingStyle.Quint),
		v0_12(self._scale, { Scale = 1 }, v0_224, Enum.EasingStyle.Back),
	}
	self:_updateWatermark()
end
function v0_1:Hide()
	if self._destroyed or not self._visible then return end
	self._visible = false
	self:_cancelAnim()
	local v1_228 = v0_4:GetFocusedTextBox()
	if v1_228 and v1_228:IsDescendantOf(self.Main) then v1_228:ReleaseFocus() end
	local v1_229 = v0_12(self.Main, { GroupTransparency = 1 }, v0_225, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local v1_230 = v0_12(self._scale, { Scale = 0.92 }, v0_225, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	self._anim = { v1_229, v1_230 }
	v1_229.Completed:Connect(function(v2_231)
		if v2_231 == Enum.PlaybackState.Completed and not self._visible and not self._destroyed then
			self.Main.Visible = false
		end
	end)
	self:_updateWatermark()
end
function v0_1:Toggle()
	if self._visible then self:Hide() else self:Show() end
end
function v0_1:IsVisible()
	return self._visible == true
end
function v0_1:_updateScrollHint()
	local v1_232 = self._hint
	if not v1_232 or self._destroyed then return end
	local v1_233 = self.ActiveTab and self.ActiveTab.Page
	local v1_234 = false
	if v1_233 and v1_233.Visible then
		local v2_235 = v1_233.AbsoluteCanvasSize.Y - (v1_233.CanvasPosition.Y + v1_233.AbsoluteWindowSize.Y)
		v1_234 = v2_235 > 4
	end
	if v1_234 == v1_232.Shown then return end
	v1_232.Shown = v1_234
	if v1_232.Fade then v1_232.Fade:Cancel() end
	if v1_234 then
		v1_232.Frame.Visible = true
		v1_232.Icon.Position = UDim2.new(0.5, 0, 0.5, -3)
		v1_232.Bounce:Play()
		v1_232.Fade = v0_12(v1_232.Frame, { GroupTransparency = 0.15 }, 0.2)
	else
		v1_232.HideTip()
		local v2_236 = v0_12(v1_232.Frame, { GroupTransparency = 1 }, 0.2)
		v1_232.Fade = v2_236
		v2_236.Completed:Connect(function(v3_237)
			if v3_237 == Enum.PlaybackState.Completed and not v1_232.Shown then
				v1_232.Bounce:Cancel()
				v1_232.Frame.Visible = false
			end
		end)
	end
end
function v0_1:_keyTaken(v1_238, v1_239)
	if not v1_238 then return false end
	if v1_238 == self._toggleKey then return true end
	for v2_240, v2_241 in ipairs(self._binds) do
		if v2_241 ~= v1_239 and v2_241._key == v1_238 then return true end
	end
	return false
end
local v0_242, v0_243 = 280, 5
function v0_1:_getNotifyContainer()
	if self._notifyContainer and self._notifyContainer.Parent then
		return self._notifyContainer
	end
	local v1_244 = self.ScreenGui.AbsoluteSize
	local v1_245 = v1_244.X > 0 and math.min(v0_242, v1_244.X - 20) or v0_242
	local v1_246 = Instance.new("Frame")
	v1_246.Name = "Notifications"
	v1_246.AnchorPoint = Vector2.new(0.5, 0)
	v1_246.Position = UDim2.new(0.5, 0, 0, self._wm and 48 or 10)
	v1_246.Size = UDim2.new(0, v1_245, 0, 0)
	v1_246.AutomaticSize = Enum.AutomaticSize.Y
	v1_246.BackgroundTransparency = 1
	v1_246.BorderSizePixel = 0
	v1_246.Parent = self.ScreenGui
	local v1_247 = Instance.new("UIListLayout")
	v1_247.Padding = UDim.new(0, 6)
	v1_247.SortOrder = Enum.SortOrder.LayoutOrder
	v1_247.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_247.Parent = v1_246
	self._notifyContainer = v1_246
	return v1_246
end
function v0_1:Notify(v1_248)
	if self._destroyed then return end
	if type(v1_248) == "string" then v1_248 = { Content = v1_248 } end
	v1_248 = v1_248 or {}
	local v1_249 = tonumber(v1_248.Duration) or 4
	local v1_250 = self:_getNotifyContainer()
	self._notifyCount = (self._notifyCount or 0) + 1
	self._notifs = self._notifs or {}
	local v1_251 = false
	local v1_252 = Instance.new("Frame")
	v1_252.Name = "Notification"
	v1_252.Size = UDim2.new(1, 0, 0, 0)
	v1_252.BackgroundTransparency = 1
	v1_252.BorderSizePixel = 0
	v1_252.LayoutOrder = self._notifyCount
	v1_252.Parent = v1_250
	local v1_253 = Instance.new("CanvasGroup")
	v1_253.Name = "Card"
	v1_253.Size = UDim2.new(1, 0, 0, 0)
	v1_253.AutomaticSize = Enum.AutomaticSize.Y
	v1_253.BackgroundColor3 = v0_8.Sidebar
	v1_253.BorderSizePixel = 0
	v1_253.GroupTransparency = 1
	v1_253.Parent = v1_252
	v0_63(v1_253, 8)
	local v1_254 = Instance.new("UIStroke")
	v1_254.Color = v0_8.Element
	v1_254.Thickness = 1
	v1_254.Transparency = 1
	v1_254.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_254.Parent = v1_253
	local v1_255 = Instance.new("Frame")
	v1_255.Name = "Body"
	v1_255.Size = UDim2.new(1, 0, 0, 0)
	v1_255.AutomaticSize = Enum.AutomaticSize.Y
	v1_255.BackgroundTransparency = 1
	v1_255.BorderSizePixel = 0
	v1_255.Parent = v1_253
	local v1_256 = Instance.new("UIPadding")
	v1_256.PaddingTop = UDim.new(0, 8)
	v1_256.PaddingBottom = UDim.new(0, 8)
	v1_256.PaddingLeft = UDim.new(0, 12)
	v1_256.PaddingRight = UDim.new(0, 12)
	v1_256.Parent = v1_255
	local v1_257 = Instance.new("UISizeConstraint")
	v1_257.MinSize = Vector2.new(0, 30)
	v1_257.Parent = v1_255
	local v1_258 = Instance.new("Frame")
	v1_258.Name = "Texts"
	v1_258.Position = UDim2.new(0, 0, 0, 0)
	v1_258.Size = UDim2.new(1, 0, 0, 0)
	v1_258.AutomaticSize = Enum.AutomaticSize.Y
	v1_258.BackgroundTransparency = 1
	v1_258.BorderSizePixel = 0
	v1_258.Parent = v1_255
	local v1_259 = Instance.new("UIListLayout")
	v1_259.Padding = UDim.new(0, 2)
	v1_259.SortOrder = Enum.SortOrder.LayoutOrder
	v1_259.Parent = v1_258
	local function v1_260(v2_261, v2_262, v2_263, v2_264, v2_265)
		local v2_266 = Instance.new("TextLabel")
		v2_266.Size = UDim2.new(1, 0, 0, 0)
		v2_266.AutomaticSize = Enum.AutomaticSize.Y
		v2_266.BackgroundTransparency = 1
		v2_266.BorderSizePixel = 0
		v2_266.Text = v2_261
		v2_266.TextColor3 = v2_264
		v2_266.Font = v2_262
		v2_266.TextSize = v2_263
		v2_266.TextWrapped = true
		v2_266.TextXAlignment = Enum.TextXAlignment.Left
		v2_266.TextYAlignment = Enum.TextYAlignment.Top
		v2_266.LayoutOrder = v2_265
		v2_266.Parent = v1_258
		return v2_266
	end
	if v1_248.Title and v1_248.Title ~= "" then
		v1_260(self:T(tostring(v1_248.Title)), Enum.Font.GothamBold, 13, v0_8.Text, 1).Name = "Title"
	end
	if v1_248.Content and v1_248.Content ~= "" then
		v1_260(self:T(tostring(v1_248.Content)), Enum.Font.Gotham, 12, v0_8.SubText, 2).Name = "Content"
	end
	local v1_267 = Instance.new("TextLabel")
	v1_267.Name = "Countdown"
	v1_267.AnchorPoint = Vector2.new(1, 0.5)
	v1_267.Position = UDim2.new(1, 0, 0.5, 0)
	v1_267.Size = UDim2.new(0, 18, 0, 18)
	v1_267.BackgroundTransparency = 1
	v1_267.BorderSizePixel = 0
	v1_267.Text = tostring(math.ceil(v1_249))
	v1_267.TextColor3 = v0_8.SubText
	v1_267.Font = Enum.Font.GothamBold
	v1_267.TextSize = 13
	v1_267.TextXAlignment = Enum.TextXAlignment.Right
	v1_267.Visible = v1_249 > 0
	v1_267.Parent = v1_255
	if v1_249 > 0 then
		v1_258.Size = UDim2.new(1, -24, 0, 0)
	end
	local v1_268 = Instance.new("TextButton")
	v1_268.Name = "Click"
	v1_268.Size = UDim2.new(1, 0, 1, 0)
	v1_268.BackgroundTransparency = 1
	v1_268.BorderSizePixel = 0
	v1_268.Text = ""
	v1_268.AutoButtonColor = false
	v1_268.Parent = v1_253
	local v1_269, v1_270 = nil, nil
	local v1_271 = {}
	local function v1_272()
		if v1_251 then return end
		v1_251 = true
		local v2_273 = table.find(self._notifs, v1_272)
		if v2_273 then table.remove(self._notifs, v2_273) end
		if v1_269 and v1_269 ~= coroutine.running() then
			pcall(task.cancel, v1_269)
		end
		v1_269 = nil
		if v1_270 then
			v1_270:Disconnect()
			v1_270 = nil
		end
		for v3_274, v3_275 in ipairs(v1_271) do v3_275:Cancel() end
		v1_271 = {}
		if self._destroyed then return end
		v0_12(v1_254, { Transparency = 1 }, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local v2_276 = v0_12(v1_253, {
			Position = UDim2.new(0, 0, 0, -20),
			GroupTransparency = 1,
		}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v2_276.Completed:Connect(function()
			local v3_277 = v0_12(v1_252, { Size = UDim2.new(1, 0, 0, 0) }, 0.2, Enum.EasingStyle.Quint)
			v3_277.Completed:Connect(function()
				v1_252:Destroy()
			end)
		end)
	end
	v1_268.MouseButton1Click:Connect(v1_272)
	table.insert(self._notifs, v1_272)
	while #self._notifs > v0_243 do
		self._notifs[1]()
	end
	local v1_278 = false
	v1_270 = v1_253:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if v1_251 then return end
		local v2_279 = v1_253.AbsoluteSize.Y
		if v2_279 <= 0 then return end
		if not v1_278 then
			v1_278 = true
			table.insert(v1_271, v0_12(v1_252, { Size = UDim2.new(1, 0, 0, v2_279) }, 0.3, Enum.EasingStyle.Quint))
		else
			v1_252.Size = UDim2.new(1, 0, 0, v2_279)
		end
	end)
	v1_253.Position = UDim2.new(0, 0, 0, -(v1_250.AbsolutePosition.Y + v1_250.AbsoluteSize.Y + 90))
	v1_271 = {
		v0_12(v1_253, { Position = UDim2.new(0, 0, 0, 0) }, 0.45, Enum.EasingStyle.Back),
		v0_12(v1_253, { GroupTransparency = 0 }, 0.25),
		v0_12(v1_254, { Transparency = 0 }, 0.25),
	}
	if v1_249 > 0 then
		v1_269 = task.spawn(function()
			local v3_280 = os.clock()
			local v3_281 = math.ceil(v1_249)
			while not v1_251 and not self._destroyed do
				local v4_282 = v1_249 - (os.clock() - v3_280)
				local v4_283 = math.max(math.ceil(v4_282), 0)
				if v4_283 ~= v3_281 then
					v3_281 = v4_283
					v1_267.Text = tostring(v4_283)
					v1_267.TextTransparency = 0.6
					v0_12(v1_267, { TextTransparency = 0 }, 0.2)
				end
				if v4_282 <= 0 then
					v1_269 = nil
					v1_272()
					return
				end
				task.wait(v4_282 - (v4_283 - 1))
			end
		end)
	end
	return { Dismiss = v1_272 }
end
function v0_1:Dialog(v1_284)
	if self._destroyed then return end
	v1_284 = v1_284 or {}
	local v1_285 = v1_284.Buttons
	if type(v1_285) ~= "table" or #v1_285 == 0 then
		v1_285 = { { Title = "OK", Primary = true } }
	end
	local v1_286 = false
	local v1_287 = {}
	local v1_288 = { Dismissable = v1_284.Dismissable ~= false }
	local v1_289 = Instance.new("Frame")
	v1_289.Name = "DialogOverlay"
	v1_289.Size = UDim2.new(1, 0, 1, 0)
	v1_289.BackgroundTransparency = 1
	v1_289.BorderSizePixel = 0
	v1_289.ZIndex = 100 + #self._dialogs
	v1_289.Parent = self.ScreenGui
	local v1_290 = Instance.new("TextButton")
	v1_290.Name = "Backdrop"
	v1_290.Size = UDim2.new(1, 0, 1, 0)
	v1_290.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	v1_290.BackgroundTransparency = 1
	v1_290.BorderSizePixel = 0
	v1_290.Text = ""
	v1_290.AutoButtonColor = false
	v1_290.Parent = v1_289
	local v1_291 = Instance.new("CanvasGroup")
	v1_291.Name = "Dialog"
	v1_291.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_291.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_291.Size = UDim2.new(0.9, 0, 0, 0)
	v1_291.AutomaticSize = Enum.AutomaticSize.Y
	v1_291.BackgroundColor3 = v0_8.Sidebar
	v1_291.BorderSizePixel = 0
	v1_291.GroupTransparency = 1
	v1_291.Active = true
	v1_291.ZIndex = 2
	v1_291.Parent = v1_289
	v0_63(v1_291, 8)
	local v1_292 = Instance.new("UISizeConstraint")
	v1_292.MinSize = Vector2.new(200, 0)
	v1_292.MaxSize = Vector2.new(320, math.huge)
	v1_292.Parent = v1_291
	local v1_293 = Instance.new("UIScale")
	v1_293.Scale = 0.92
	v1_293.Parent = v1_291
	local v1_294 = Instance.new("UIStroke")
	v1_294.Color = v0_8.Element
	v1_294.Thickness = 1
	v1_294.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_294.Parent = v1_291
	local v1_295 = Instance.new("Frame")
	v1_295.Name = "Body"
	v1_295.Size = UDim2.new(1, 0, 0, 0)
	v1_295.AutomaticSize = Enum.AutomaticSize.Y
	v1_295.BackgroundTransparency = 1
	v1_295.BorderSizePixel = 0
	v1_295.Parent = v1_291
	local v1_296 = Instance.new("UIPadding")
	v1_296.PaddingTop = UDim.new(0, 14)
	v1_296.PaddingBottom = UDim.new(0, 14)
	v1_296.PaddingLeft = UDim.new(0, 14)
	v1_296.PaddingRight = UDim.new(0, 14)
	v1_296.Parent = v1_295
	local v1_297 = Instance.new("UIListLayout")
	v1_297.Padding = UDim.new(0, 8)
	v1_297.SortOrder = Enum.SortOrder.LayoutOrder
	v1_297.Parent = v1_295
	local function v1_298(v2_299, v2_300, v2_301, v2_302, v2_303, v2_304)
		local v2_305 = Instance.new("TextLabel")
		v2_305.Name = v2_299
		v2_305.Size = UDim2.new(1, 0, 0, 0)
		v2_305.AutomaticSize = Enum.AutomaticSize.Y
		v2_305.BackgroundTransparency = 1
		v2_305.BorderSizePixel = 0
		v2_305.Text = v2_300
		v2_305.TextColor3 = v2_303
		v2_305.Font = v2_301
		v2_305.TextSize = v2_302
		v2_305.TextWrapped = true
		v2_305.TextXAlignment = Enum.TextXAlignment.Left
		v2_305.TextYAlignment = Enum.TextYAlignment.Top
		v2_305.LayoutOrder = v2_304
		v2_305.Parent = v1_295
		return v2_305
	end
	if v1_284.Title and v1_284.Title ~= "" then
		v1_298("Title", self:T(tostring(v1_284.Title)), Enum.Font.GothamBold, 15, v0_8.Text, 1)
	end
	if v1_284.Content and v1_284.Content ~= "" then
		v1_298("Content", self:T(tostring(v1_284.Content)), Enum.Font.Gotham, 13, v0_8.SubText, 2)
	end
	local v1_306 = Instance.new("Frame")
	v1_306.Name = "Buttons"
	v1_306.Size = UDim2.new(1, 0, 0, 30)
	v1_306.BackgroundTransparency = 1
	v1_306.BorderSizePixel = 0
	v1_306.LayoutOrder = 3
	v1_306.Parent = v1_295
	local v1_307 = Instance.new("UIListLayout")
	v1_307.FillDirection = Enum.FillDirection.Horizontal
	v1_307.HorizontalAlignment = Enum.HorizontalAlignment.Right
	v1_307.VerticalAlignment = Enum.VerticalAlignment.Center
	v1_307.Padding = UDim.new(0, 8)
	v1_307.SortOrder = Enum.SortOrder.LayoutOrder
	v1_307.Parent = v1_306
	local function v1_308()
		if v1_286 then return end
		v1_286 = true
		local v2_309 = table.find(self._dialogs, v1_288)
		if v2_309 then table.remove(self._dialogs, v2_309) end
		for v3_310, v3_311 in ipairs(v1_287) do v3_311:Cancel() end
		v1_287 = {}
		if self._destroyed or not v1_289.Parent then return end
		v0_12(v1_290, { BackgroundTransparency = 1 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v0_12(v1_293, { Scale = 0.94 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local v2_312 = v0_12(v1_291, { GroupTransparency = 1 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v2_312.Completed:Connect(function()
			v1_289:Destroy()
		end)
	end
	v1_288.Close = v1_308
	for v2_313, v2_314 in ipairs(v1_285) do
		local v2_315 = v2_314.Primary == true
		local v2_316 = v2_315 and v0_8.Accent or v0_8.Element
		local v2_317 = v2_315 and v0_8.Accent:Lerp(v0_8.Text, 0.15) or v0_8.Hover
		local v2_318 = Instance.new("TextButton")
		v2_318.Name = "Button"
		v2_318.Size = UDim2.new(0, 0, 0, 30)
		v2_318.AutomaticSize = Enum.AutomaticSize.X
		v2_318.BackgroundColor3 = v2_316
		v2_318.BorderSizePixel = 0
		v2_318.Text = self:T(tostring(v2_314.Title or "OK"))
		v2_318.TextColor3 = v0_8.Text
		v2_318.Font = Enum.Font.Gotham
		v2_318.TextSize = 13
		v2_318.AutoButtonColor = false
		v2_318.LayoutOrder = v2_313
		v2_318.Parent = v1_306
		v0_63(v2_318, 6)
		local v2_319 = Instance.new("UIPadding")
		v2_319.PaddingLeft = UDim.new(0, 14)
		v2_319.PaddingRight = UDim.new(0, 14)
		v2_319.Parent = v2_318
		v0_21(v2_318, v2_316, v2_317)
		v2_318.MouseButton1Click:Connect(function()
			if v1_286 then return end
			v1_308()
			if v2_314.Callback then v2_314.Callback() end
		end)
	end
	v1_290.MouseButton1Click:Connect(function()
		if v1_288.Dismissable then v1_308() end
	end)
	table.insert(self._dialogs, v1_288)
	v1_287 = {
		v0_12(v1_290, { BackgroundTransparency = 0.45 }, 0.2),
		v0_12(v1_291, { GroupTransparency = 0 }, 0.22),
		v0_12(v1_293, { Scale = 1 }, 0.3, Enum.EasingStyle.Back),
	}
	return { Close = v1_308 }
end
function v0_1:_buildWatermark(v1_320)
	local v1_321 = Instance.new("Frame")
	v1_321.Name = "Watermark"
	v1_321.AnchorPoint = Vector2.new(0.5, 0)
	v1_321.Position = UDim2.new(0.5, 0, 0, -40)
	v1_321.Size = UDim2.new(0, 0, 0, 30)
	v1_321.AutomaticSize = Enum.AutomaticSize.X
	v1_321.BackgroundColor3 = v0_8.Sidebar
	v1_321.BorderSizePixel = 0
	v1_321.Parent = self.ScreenGui
	v0_63(v1_321, 8)
	local v1_322 = Instance.new("UIStroke")
	v1_322.Color = v0_8.Element
	v1_322.Thickness = 1
	v1_322.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_322.Parent = v1_321
	local v1_323 = Instance.new("UIPadding")
	v1_323.PaddingLeft = UDim.new(0, 10)
	v1_323.PaddingRight = UDim.new(0, 4)
	v1_323.Parent = v1_321
	local v1_324 = Instance.new("UIListLayout")
	v1_324.FillDirection = Enum.FillDirection.Horizontal
	v1_324.VerticalAlignment = Enum.VerticalAlignment.Center
	v1_324.Padding = UDim.new(0, 8)
	v1_324.SortOrder = Enum.SortOrder.LayoutOrder
	v1_324.Parent = v1_321
	local v1_325 = Instance.new("TextLabel")
	v1_325.Name = "Title"
	v1_325.Size = UDim2.new(0, 0, 1, 0)
	v1_325.AutomaticSize = Enum.AutomaticSize.X
	v1_325.BackgroundTransparency = 1
	v1_325.BorderSizePixel = 0
	self:_track(v1_325, "Text", v1_320)
	v1_325.TextColor3 = v0_8.SubText
	v1_325.Font = Enum.Font.GothamBold
	v1_325.TextSize = 13
	v1_325.LayoutOrder = 1
	v1_325.Parent = v1_321
	local v1_326 = Instance.new("TextButton")
	v1_326.Name = "ToggleButton"
	v1_326.Size = UDim2.new(0, 22, 0, 22)
	v1_326.BackgroundColor3 = v0_8.Element
	v1_326.BorderSizePixel = 0
	v1_326.Text = ""
	v1_326.AutoButtonColor = false
	v1_326.LayoutOrder = 2
	v1_326.Parent = v1_321
	v0_63(v1_326, 6)
	local v1_327 = Instance.new("ImageLabel")
	v1_327.Name = "Icon"
	v1_327.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_327.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_327.Size = UDim2.new(0, 14, 0, 14)
	v1_327.BackgroundTransparency = 1
	v1_327.BorderSizePixel = 0
	v1_327.ImageColor3 = v0_8.IconOn
	v1_327.ScaleType = Enum.ScaleType.Fit
	v1_327.Parent = v1_326
	local v1_328 = Instance.new("TextLabel")
	v1_328.Name = "IconFallback"
	v1_328.Size = UDim2.new(1, 0, 1, 0)
	v1_328.BackgroundTransparency = 1
	v1_328.TextColor3 = v0_8.IconOn
	v1_328.Font = Enum.Font.GothamBold
	v1_328.TextSize = 12
	v1_328.Visible = false
	v1_328.Parent = v1_327
	local v1_329 = Instance.new("UIScale")
	v1_329.Parent = v1_326
	v1_326.MouseEnter:Connect(function() v0_12(v1_329, { Scale = 1.1 }, 0.12) end)
	v1_326.MouseLeave:Connect(function() v0_12(v1_329, { Scale = 1 }, 0.12) end)
	v1_326.InputBegan:Connect(function(v2_330)
		if v0_19(v2_330) then v0_12(v1_329, { Scale = 0.9 }, 0.08) end
	end)
	v1_326.InputEnded:Connect(function(v2_331)
		if v0_19(v2_331) then v0_12(v1_329, { Scale = 1.1 }, 0.15, Enum.EasingStyle.Back) end
	end)
	v1_326.MouseButton1Click:Connect(function()
		self:Toggle()
	end)
	local v1_332, v1_333, v1_334 = false, nil, nil
	v1_325.InputBegan:Connect(function(v2_335)
		if v0_19(v2_335) then
			v1_332 = true
			v1_333 = v2_335.Position
			v1_334 = v1_321.AbsolutePosition + Vector2.new(v1_321.AbsoluteSize.X / 2, 0)
			v2_335.Changed:Connect(function()
				if v2_335.UserInputState == Enum.UserInputState.End then v1_332 = false end
			end)
		end
	end)
	table.insert(self._connections, v0_4.InputChanged:Connect(function(v2_336)
		if not v1_332 then return end
		if v2_336.UserInputType ~= Enum.UserInputType.MouseMovement and v2_336.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local v2_337 = v2_336.Position - v1_333
		local v2_338 = self.ScreenGui.AbsoluteSize
		local v2_339 = v1_321.AbsoluteSize.X / 2
		local v2_340 = math.clamp(v1_334.X + v2_337.X, v2_339, math.max(v2_338.X - v2_339, v2_339))
		local v2_341 = math.clamp(v1_334.Y + v2_337.Y, 0, math.max(v2_338.Y - v1_321.AbsoluteSize.Y, 0))
		v1_321.Position = UDim2.fromOffset(v2_340, v2_341)
	end))
	self._wm = { Frame = v1_321, Button = v1_326, Icon = v1_327, Fallback = v1_328 }
	v0_12(v1_321, { Position = UDim2.new(0.5, 0, 0, 10) }, 0.5, Enum.EasingStyle.Back)
end
function v0_1:_updateWatermark()
	local v1_342 = self._wm
	if not v1_342 then return end
	local v1_343 = self._visible == true
	v0_12(v1_342.Button, { BackgroundColor3 = v1_343 and v0_8.Accent or v0_8.Element }, 0.2)
	local v1_344 = v0_44(v1_342.Icon, v1_343 and "eye" or "eye-off", self.Icons)
	if not v1_344 then v1_342.Icon.Image = "" end
	v1_342.Fallback.Visible = not v1_344
	v1_342.Fallback.Text = v1_343 and "●" or "○"
	v1_342.Icon.ImageTransparency = 1
	v0_12(v1_342.Icon, { ImageTransparency = 0 }, 0.2)
end
local function v0_345(v1_346, v1_347)
	local v1_348 = v1_346.Glow
	if not v1_348 then return end
	for v2_349, v2_350 in ipairs(v1_348.Layers) do
		v0_12(v2_350.Obj, { [v2_350.Prop] = v1_347 and v2_350.On or 1 }, 0.25, Enum.EasingStyle.Quad)
	end
end
local function v0_351(v1_352, v1_353)
	v0_12(v1_352.Icon, { ImageColor3 = v1_353 }, 0.2)
	if v1_352.Fallback then
		v0_12(v1_352.Fallback, { TextColor3 = v1_353 }, 0.2)
	end
end
function v0_1:AddTab(v1_354)
	v1_354 = v1_354 or {}
	local v1_355 = Instance.new("TextButton")
	v1_355.Name = "TabButton"
	v1_355.Size = UDim2.new(0, 36, 0, 36)
	v1_355.BackgroundColor3 = v0_8.Card
	v1_355.BorderSizePixel = 0
	v1_355.Text = ""
	v1_355.AutoButtonColor = false
	v1_355.LayoutOrder = #self.Tabs + 1
	v1_355.Parent = self.Sidebar
	v0_63(v1_355, 6)
	local v1_356 = Instance.new("ImageLabel")
	v1_356.Name = "Icon"
	v1_356.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_356.Size = UDim2.new(0, 20, 0, 20)
	v1_356.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_356.BackgroundTransparency = 1
	v1_356.BorderSizePixel = 0
	v1_356.ImageColor3 = v0_8.IconOff
	v1_356.ScaleType = Enum.ScaleType.Fit
	v1_356.Parent = v1_355
	local v1_357
	if not v0_44(v1_356, v1_354.Icon, self.Icons) then
		v1_357 = Instance.new("TextLabel")
		v1_357.Name = "IconFallback"
		v1_357.Size = UDim2.new(1, 0, 1, 0)
		v1_357.BackgroundTransparency = 1
		v1_357.Text = string.upper(string.sub(tostring(v1_354.Name or v1_354.Icon or "?"), 1, 1))
		v1_357.TextColor3 = v0_8.IconOff
		v1_357.Font = Enum.Font.GothamBold
		v1_357.TextSize = 16
		v1_357.Parent = v1_356
	end
	local v1_358
	if self.IconGlow then
		v1_355.BackgroundTransparency = 1
		v1_356.ZIndex = 2
		v1_358 = { Layers = {} }
		if v1_356.Image ~= "" then
			for v4_359, v4_360 in ipairs({ { 26, 0.55 }, { 33, 0.82 } }) do
				local v4_361 = Instance.new("ImageLabel")
				v4_361.Name = "Glow"
				v4_361.AnchorPoint = Vector2.new(0.5, 0.5)
				v4_361.Position = UDim2.new(0.5, 0, 0.5, 0)
				v4_361.Size = UDim2.new(0, v4_360[1], 0, v4_360[1])
				v4_361.BackgroundTransparency = 1
				v4_361.BorderSizePixel = 0
				v4_361.Image = v1_356.Image
				v4_361.ImageRectSize = v1_356.ImageRectSize
				v4_361.ImageRectOffset = v1_356.ImageRectOffset
				v4_361.ImageColor3 = v0_8.Accent
				v4_361.ImageTransparency = 1
				v4_361.ScaleType = Enum.ScaleType.Fit
				v4_361.ZIndex = 1
				v4_361.Parent = v1_355
				table.insert(v1_358.Layers, { Obj = v4_361, Prop = "ImageTransparency", On = v4_360[2] })
			end
		elseif v1_357 then
			local v3_362 = Instance.new("UIStroke")
			v3_362.Color = v0_8.Accent
			v3_362.Thickness = 1
			v3_362.Transparency = 1
			v3_362.Parent = v1_357
			table.insert(v1_358.Layers, { Obj = v3_362, Prop = "Transparency", On = 0.45 })
		end
	end
	local v1_363 = Instance.new("ScrollingFrame")
	v1_363.Name = "Page"
	v1_363.Size = UDim2.new(1, 0, 1, 0)
	v1_363.BackgroundTransparency = 1
	v1_363.BorderSizePixel = 0
	v1_363.ScrollBarThickness = 3
	v1_363.ScrollBarImageColor3 = v0_8.IconOff
	v1_363.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_363.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_363.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_363.Visible = false
	v1_363.Parent = self.Content
	local v1_364 = Instance.new("Frame")
	v1_364.Name = "Inner"
	v1_364.Size = UDim2.new(1, 0, 0, 0)
	v1_364.AutomaticSize = Enum.AutomaticSize.Y
	v1_364.BackgroundTransparency = 1
	v1_364.BorderSizePixel = 0
	v1_364.Parent = v1_363
	local v1_365 = Instance.new("UIPadding")
	v1_365.PaddingTop = UDim.new(0, 12)
	v1_365.PaddingBottom = UDim.new(0, 12)
	v1_365.Parent = v1_364
	local v1_366 = Instance.new("Frame")
	v1_366.Name = "Split"
	v1_366.Position = UDim2.new(0, 12, 0, 0)
	v1_366.Size = UDim2.new(1, -26, 0, 0)
	v1_366.AutomaticSize = Enum.AutomaticSize.Y
	v1_366.BackgroundTransparency = 1
	v1_366.BorderSizePixel = 0
	v1_366.Parent = v1_364
	local v1_367 = Instance.new("UIListLayout")
	v1_367.FillDirection = Enum.FillDirection.Horizontal
	v1_367.Padding = UDim.new(0, 8)
	v1_367.SortOrder = Enum.SortOrder.LayoutOrder
	v1_367.Parent = v1_366
	local function v1_368(v2_369)
		local v2_370 = Instance.new("Frame")
		v2_370.Name = v2_369 == 1 and "Left" or "Right"
		v2_370.Size = UDim2.new(0.5, -4, 0, 0)
		v2_370.AutomaticSize = Enum.AutomaticSize.Y
		v2_370.BackgroundTransparency = 1
		v2_370.BorderSizePixel = 0
		v2_370.LayoutOrder = v2_369
		v2_370.Parent = v1_366
		local v2_371 = Instance.new("UIListLayout")
		v2_371.Padding = UDim.new(0, 8)
		v2_371.SortOrder = Enum.SortOrder.LayoutOrder
		v2_371.Parent = v2_370
		return v2_370
	end
	local v1_372 = setmetatable({
		Page = v1_363,
		Button = v1_355,
		Icon = v1_356,
		Fallback = v1_357,
		Glow = v1_358,
		Inner = v1_364,
		_icons = self.Icons,
		_lib = self,
		Left = v1_368(1),
		Right = v1_368(2),
		_sectionCount = 0,
	}, v0_2)
	table.insert(self.Tabs, v1_372)
	for v2_373, v2_374 in ipairs({ "CanvasPosition", "AbsoluteCanvasSize", "AbsoluteWindowSize" }) do
		table.insert(self._connections, v1_363:GetPropertyChangedSignal(v2_374):Connect(function()
			if self.ActiveTab == v1_372 then self:_updateScrollHint() end
		end))
	end
	if self.IconGlow then
		v1_355.MouseEnter:Connect(function()
			if self.ActiveTab ~= v1_372 then v0_351(v1_372, v0_8.SubText) end
		end)
		v1_355.MouseLeave:Connect(function()
			if self.ActiveTab ~= v1_372 then v0_351(v1_372, v0_8.IconOff) end
		end)
	end
	v0_21(v1_355, v0_8.Card, v0_8.Element, function()
		return self.ActiveTab == v1_372
	end)
	v1_355.MouseButton1Click:Connect(function()
		self:SelectTab(v1_372)
	end)
	if not self.ActiveTab then self:SelectTab(v1_372) end
	return v1_372
end
function v0_1:SelectTab(v1_375)
	if self.ActiveTab == v1_375 then return end
	local v1_376 = self.ActiveTab
	self.ActiveTab = v1_375
	if v1_376 then
		v1_376.Page.Visible = false
		if self.IconGlow then
			v0_345(v1_376, false)
		else
			v0_12(v1_376.Button, { BackgroundColor3 = v0_8.Card }, 0.2)
		end
		v0_351(v1_376, v0_8.IconOff)
	end
	v1_375.Inner.Position = UDim2.new(0, 0, 0, 14)
	v1_375.Page.Visible = true
	v0_12(v1_375.Inner, { Position = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quint)
	if self.IconGlow then
		v0_345(v1_375, true)
	else
		v0_12(v1_375.Button, { BackgroundColor3 = v0_8.Accent }, 0.2)
	end
	v0_351(v1_375, v0_8.IconOn)
	self:_updateScrollHint()
end
function v0_2:AddSection(v1_377, v1_378, v1_379)
	local v1_380 = (v1_378 == "right") and self.Right or self.Left
	local v1_381 = self._lib
	self._sectionCount += 1
	local v1_382 = Instance.new("Frame")
	v1_382.Name = "Section"
	v1_382.Size = UDim2.new(1, 0, 0, 0)
	v1_382.AutomaticSize = Enum.AutomaticSize.Y
	v1_382.BackgroundColor3 = v0_8.Card
	v1_382.BorderSizePixel = 0
	v1_382.LayoutOrder = self._sectionCount
	v1_382.Parent = v1_380
	v0_63(v1_382, 6)
	local v1_383 = Instance.new("UIPadding")
	v1_383.PaddingTop = UDim.new(0, 8)
	v1_383.PaddingBottom = UDim.new(0, 8)
	v1_383.PaddingLeft = UDim.new(0, 8)
	v1_383.PaddingRight = UDim.new(0, 8)
	v1_383.Parent = v1_382
	local v1_384 = Instance.new("UIListLayout")
	v1_384.Padding = UDim.new(0, 6)
	v1_384.SortOrder = Enum.SortOrder.LayoutOrder
	v1_384.Parent = v1_382
	local v1_385 = Instance.new("Frame")
	v1_385.Name = "Body"
	v1_385.Size = UDim2.new(1, 0, 0, 0)
	v1_385.AutomaticSize = Enum.AutomaticSize.Y
	v1_385.BackgroundTransparency = 1
	v1_385.BorderSizePixel = 0
	v1_385.LayoutOrder = 1
	v1_385.Parent = v1_382
	local v1_386 = Instance.new("UIListLayout")
	v1_386.Padding = UDim.new(0, 6)
	v1_386.SortOrder = Enum.SortOrder.LayoutOrder
	v1_386.Parent = v1_385
	local v1_387 = false
	local v1_388 = {}
	local v1_389, v1_390
	local function v1_391()
		local v2_392 = v1_381._scale and v1_381._scale.Scale or 1
		return math.max(v1_386.AbsoluteContentSize.Y / (v2_392 > 0 and v2_392 or 1), 0)
	end
	local function v1_393()
		v1_385.AutomaticSize = Enum.AutomaticSize.Y
		v1_385.Size = UDim2.new(1, 0, 0, 0)
		v1_385.ClipsDescendants = false
	end
	local function v1_394(v2_395, v2_396)
		if v2_395 == v1_387 and not v2_396 then return end
		v1_387 = v2_395
		for v3_397, v3_398 in ipairs(v1_388) do v3_398:Cancel() end
		v1_388 = {}
		if v1_389 then
			if v2_396 then
				v1_389.Rotation = v2_395 and -90 or 0
			else
				v0_12(v1_389, { Rotation = v2_395 and -90 or 0 }, 0.22, Enum.EasingStyle.Quint)
			end
		end
		if v2_396 then
			v1_385.Visible = not v2_395
			v1_384.Padding = UDim.new(0, v2_395 and 0 or 6)
			v1_393()
			return
		end
		v1_385.ClipsDescendants = true
		if v2_395 then
			if v1_385.AutomaticSize ~= Enum.AutomaticSize.None then
				local v4_399 = v1_391()
				v1_385.AutomaticSize = Enum.AutomaticSize.None
				v1_385.Size = UDim2.new(1, 0, 0, v4_399)
			end
			local v3_400 = v0_12(v1_385, { Size = UDim2.new(1, 0, 0, 0) }, 0.25, Enum.EasingStyle.Quint)
			v1_388 = { v3_400, v0_12(v1_384, { Padding = UDim.new(0, 0) }, 0.25, Enum.EasingStyle.Quint) }
			v3_400.Completed:Connect(function(v4_401)
				if v4_401 == Enum.PlaybackState.Completed and v1_387 then
					v1_385.Visible = false
					v1_385.ClipsDescendants = false
				end
			end)
		else
			v1_385.Visible = true
			local v3_402 = v1_391()
			if v3_402 <= 0 then
				v1_384.Padding = UDim.new(0, 6)
				v1_393()
				return
			end
			if v1_385.AutomaticSize ~= Enum.AutomaticSize.None then
				v1_385.AutomaticSize = Enum.AutomaticSize.None
				v1_385.Size = UDim2.new(1, 0, 0, 0)
			end
			local v3_403 = v0_12(v1_385, { Size = UDim2.new(1, 0, 0, v3_402) }, 0.28, Enum.EasingStyle.Quint)
			v1_388 = { v3_403, v0_12(v1_384, { Padding = UDim.new(0, 6) }, 0.28, Enum.EasingStyle.Quint) }
			v3_403.Completed:Connect(function(v4_404)
				if v4_404 == Enum.PlaybackState.Completed and not v1_387 then
					v1_393()
				end
			end)
		end
	end
	if v1_377 then
		local v2_405 = Instance.new("TextButton")
		v2_405.Name = "Header"
		v2_405.Size = UDim2.new(1, 0, 0, 16)
		v2_405.BackgroundTransparency = 1
		v2_405.BorderSizePixel = 0
		v2_405.Text = ""
		v2_405.AutoButtonColor = false
		v2_405.LayoutOrder = 0
		v2_405.Parent = v1_382
		local v2_406 = Instance.new("TextLabel")
		v2_406.Name = "Title"
		v2_406.Size = UDim2.new(1, -22, 1, 0)
		v2_406.BackgroundTransparency = 1
		v2_406.BorderSizePixel = 0
		v1_381:_track(v2_406, "Text", v1_377)
		v2_406.TextColor3 = v0_8.SubText
		v2_406.Font = Enum.Font.GothamBold
		v2_406.TextSize = 13
		v2_406.TextXAlignment = Enum.TextXAlignment.Left
		v2_406.TextTruncate = Enum.TextTruncate.AtEnd
		v2_406.Parent = v2_405
		v1_389 = Instance.new("ImageLabel")
		v1_389.Name = "Chevron"
		v1_389.AnchorPoint = Vector2.new(1, 0.5)
		v1_389.Position = UDim2.new(1, 0, 0.5, 0)
		v1_389.Size = UDim2.new(0, 14, 0, 14)
		v1_389.BackgroundTransparency = 1
		v1_389.BorderSizePixel = 0
		v1_389.ImageColor3 = v0_8.SubText
		v1_389.ScaleType = Enum.ScaleType.Fit
		v1_389.Parent = v2_405
		v1_390 = Instance.new("TextLabel")
		v1_390.Name = "ChevronFallback"
		v1_390.Size = UDim2.new(1, 0, 1, 0)
		v1_390.BackgroundTransparency = 1
		v1_390.Text = "▼"
		v1_390.TextColor3 = v0_8.SubText
		v1_390.Font = Enum.Font.Gotham
		v1_390.TextSize = 9
		v1_390.Parent = v1_389
		v1_390.Visible = not v0_44(v1_389, "chevron-down", self._icons)
		v2_405.MouseEnter:Connect(function()
			v0_12(v2_406, { TextColor3 = v0_8.Text }, 0.12)
			v0_12(v1_389, { ImageColor3 = v0_8.Text }, 0.12)
			v0_12(v1_390, { TextColor3 = v0_8.Text }, 0.12)
		end)
		v2_405.MouseLeave:Connect(function()
			v0_12(v2_406, { TextColor3 = v0_8.SubText }, 0.15)
			v0_12(v1_389, { ImageColor3 = v0_8.SubText }, 0.15)
			v0_12(v1_390, { TextColor3 = v0_8.SubText }, 0.15)
		end)
		v2_405.MouseButton1Click:Connect(function()
			v1_394(not v1_387)
		end)
	end
	local v1_407 = setmetatable({
		Holder = v1_385,
		Card = v1_382,
		_count = 0,
		_icons = self._icons,
		_lib = self._lib,
		_setCollapsed = v1_394,
		_isCollapsed = function() return v1_387 end,
	}, v0_3)
	if v1_377 and v1_379 == true then
		v1_394(true, true)
	end
	return v1_407
end
function v0_3:SetCollapsed(v1_408)
	self._setCollapsed(v1_408 == true)
end
function v0_3:ToggleCollapsed()
	self._setCollapsed(not self._isCollapsed())
end
function v0_3:IsCollapsed()
	return self._isCollapsed()
end
local function v0_409(v1_410)
	if typeof(v1_410) == "EnumItem" and v1_410.EnumType == Enum.KeyCode then return v1_410 end
	if type(v1_410) == "string" then
		local v2_411, v2_412 = pcall(function() return Enum.KeyCode[v1_410] end)
		if v2_411 then return v2_412 end
	end
	return nil
end
local function v0_413(v1_414, v1_415, v1_416, v1_417, v1_418)
	v1_416 = v1_416 or {}
	local v1_419 = v1_416.CanBeChanged ~= false
	local v1_420 = {}
	local v1_421 = { _key = nil, _onPress = v1_418, _isListening = false, _destroyed = false }
	local v1_422 = Instance.new("TextButton")
	v1_422.Name = "Keybind"
	v1_422.AnchorPoint = Vector2.new(1, 0.5)
	v1_422.Position = v1_417
	v1_422.Size = UDim2.new(0, 0, 0, 20)
	v1_422.AutomaticSize = Enum.AutomaticSize.X
	v1_422.BackgroundColor3 = v0_8.Card
	v1_422.BorderSizePixel = 0
	v1_422.Text = v0_82("None")
	v1_422.TextColor3 = v0_8.SubText
	v1_422.Font = Enum.Font.Gotham
	v1_422.TextSize = 12
	v1_422.TextTruncate = Enum.TextTruncate.AtEnd
	v1_422.AutoButtonColor = false
	v1_422.Parent = v1_415
	v0_63(v1_422, 5)
	v1_421.Instance = v1_422
	local v1_423 = Instance.new("UIPadding")
	v1_423.PaddingLeft = UDim.new(0, 7)
	v1_423.PaddingRight = UDim.new(0, 7)
	v1_423.Parent = v1_422
	local v1_424 = Instance.new("UISizeConstraint")
	v1_424.MinSize = Vector2.new(30, 20)
	v1_424.MaxSize = Vector2.new(96, 20)
	v1_424.Parent = v1_422
	local function v1_425()
		if v1_421._isListening then
			v1_422.Text = "..."
		else
			v1_422.Text = v1_421._key and v1_421._key.Name or v0_82("None")
		end
	end
	v1_414:_onLang(v1_422, v1_425)
	local function v1_426()
		v1_422.BackgroundColor3 = v0_8.Danger
		v0_12(v1_422, { BackgroundColor3 = v0_8.Card }, 0.45)
	end
	function v1_421:Set(v2_427, v2_428)
		v2_427 = v0_409(v2_427)
		if v2_427 and v1_414:_keyTaken(v2_427, v1_421) then
			warn("[RobloxUI] key already in use:", v2_427.Name)
			v1_426()
			return false
		end
		v1_421._key = v2_427
		v1_425()
		if not v2_428 and v1_416.Callback then v1_416.Callback(v2_427) end
		return true
	end
	function v1_421:Get()
		return v1_421._key
	end
	function v1_421:_startListening()
		if v1_414._listening and v1_414._listening ~= v1_421 then
			v1_414._listening:_stopListening()
		end
		v1_414._listening = v1_421
		v1_421._isListening = true
		v0_12(v1_422, { BackgroundColor3 = v0_8.Accent }, 0.15)
		v1_425()
	end
	function v1_421:_stopListening()
		if v1_414._listening == v1_421 then v1_414._listening = nil end
		v1_421._isListening = false
		v0_12(v1_422, { BackgroundColor3 = v0_8.Card }, 0.15)
		v1_425()
	end
	function v1_421:_capture(v2_429)
		if v2_429 == Enum.KeyCode.Unknown then return end
		v1_421:_stopListening()
		if v2_429 == Enum.KeyCode.Escape then return end
		if v2_429 == Enum.KeyCode.Backspace or v2_429 == Enum.KeyCode.Delete then
			v1_421:Set(nil)
		else
			v1_421:Set(v2_429)
		end
	end
	function v1_421:Destroy()
		if v1_421._destroyed then return end
		v1_421._destroyed = true
		if v1_414._listening == v1_421 then v1_414._listening = nil end
		local v2_430 = table.find(v1_414._binds, v1_421)
		if v2_430 then table.remove(v1_414._binds, v2_430) end
		v1_414._cleanups[v1_421] = nil
		for v3_431, v3_432 in ipairs(v1_420) do v3_432:Disconnect() end
		v1_420 = {}
		v1_422:Destroy()
	end
	if v1_419 then
		v0_21(v1_422, v0_8.Card, v0_8.Sidebar, function() return v1_421._isListening end)
		table.insert(v1_420, v1_422.MouseButton1Click:Connect(function()
			if v1_421._isListening then v1_421:_stopListening() else v1_421:_startListening() end
		end))
		table.insert(v1_420, v1_422.MouseButton2Click:Connect(function()
			if v1_421._isListening then v1_421:_stopListening() end
			v1_421:Set(nil)
		end))
	end
	if v1_416.Key ~= nil then
		v1_421:Set(v1_416.Key, true)
	end
	table.insert(v1_414._binds, v1_421)
	v1_414._cleanups[v1_421] = function() v1_421:Destroy() end
	return v1_421
end
local function v0_433(v1_434, v1_435, v1_436)
	local v1_437 = v1_435.Instance
	local function v1_438()
		local v2_439 = math.clamp(v1_437.TextBounds.X + 14, 30, 96)
		v1_434.Size = UDim2.new(1, -(v1_436 + v2_439 + 6), 1, 0)
	end
	v1_438()
	v1_437:GetPropertyChangedSignal("TextBounds"):Connect(v1_438)
end
function v0_3:AddButton(v1_440)
	v1_440 = v1_440 or {}
	self._count += 1
	local v1_441 = Instance.new("TextButton")
	v1_441.Name = "Button"
	v1_441.Size = UDim2.new(1, 0, 0, 32)
	v1_441.BackgroundColor3 = v0_8.Element
	v1_441.BorderSizePixel = 0
	self._lib:_track(v1_441, "Text", v1_440.Name or "Button")
	v1_441.TextColor3 = v0_8.Text
	v1_441.Font = Enum.Font.Gotham
	v1_441.TextSize = 14
	v1_441.TextTruncate = Enum.TextTruncate.AtEnd
	v1_441.AutoButtonColor = false
	v1_441.LayoutOrder = self._count
	v1_441.Parent = self.Holder
	v0_63(v1_441, 6)
	local v1_442 = Instance.new("UIPadding")
	v1_442.PaddingLeft = UDim.new(0, 8)
	v1_442.PaddingRight = UDim.new(0, 8)
	v1_442.Parent = v1_441
	v0_21(v1_441, v0_8.Element, v0_8.Hover)
	v1_441.MouseButton1Click:Connect(function()
		v1_441.BackgroundColor3 = v0_8.Accent
		v0_12(v1_441, { BackgroundColor3 = v0_8.Hover }, 0.3)
		if v1_440.Callback then v1_440.Callback() end
	end)
	return v1_441
end
function v0_3:AddToggle(v1_443)
	v1_443 = v1_443 or {}
	self._count += 1
	local v1_444 = v1_443.Default == true
	local v1_445 = self
	local v1_446 = Instance.new("TextButton")
	v1_446.Name = "Toggle"
	v1_446.Size = UDim2.new(1, 0, 0, 32)
	v1_446.BackgroundColor3 = v0_8.Element
	v1_446.BorderSizePixel = 0
	v1_446.Text = ""
	v1_446.AutoButtonColor = false
	v1_446.LayoutOrder = self._count
	v1_446.Parent = self.Holder
	v0_63(v1_446, 6)
	v0_21(v1_446, v0_8.Element, v0_8.Hover)
	local v1_447 = Instance.new("TextLabel")
	v1_447.Name = "Label"
	v1_447.Position = UDim2.new(0, 8, 0, 0)
	v1_447.Size = UDim2.new(1, -60, 1, 0)
	v1_447.BackgroundTransparency = 1
	v1_447.BorderSizePixel = 0
	self._lib:_track(v1_447, "Text", v1_443.Name or "Toggle")
	v1_447.TextColor3 = v0_8.Text
	v1_447.Font = Enum.Font.Gotham
	v1_447.TextSize = 14
	v1_447.TextXAlignment = Enum.TextXAlignment.Left
	v1_447.TextTruncate = Enum.TextTruncate.AtEnd
	v1_447.Parent = v1_446
	local v1_448 = Instance.new("Frame")
	v1_448.Name = "Track"
	v1_448.AnchorPoint = Vector2.new(1, 0.5)
	v1_448.Position = UDim2.new(1, -8, 0.5, 0)
	v1_448.Size = UDim2.new(0, 34, 0, 18)
	v1_448.BackgroundColor3 = v0_8.Off
	v1_448.BorderSizePixel = 0
	v1_448.Parent = v1_446
	v0_63(v1_448, 9)
	local v1_449 = Instance.new("Frame")
	v1_449.Name = "Knob"
	v1_449.AnchorPoint = Vector2.new(0, 0.5)
	v1_449.Position = UDim2.new(0, 2, 0.5, 0)
	v1_449.Size = UDim2.new(0, 14, 0, 14)
	v1_449.BackgroundColor3 = v0_8.Text
	v1_449.BorderSizePixel = 0
	v1_449.Parent = v1_448
	v0_63(v1_449, 7)
	local function v1_450(v2_451)
		local v2_452 = TweenInfo.new(v2_451 and 0.15 or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		v0_5:Create(v1_448, v2_452, { BackgroundColor3 = v1_444 and v0_8.Accent or v0_8.Off }):Play()
		v0_5:Create(v1_449, v2_452, {
			Position = v1_444 and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		}):Play()
	end
	v1_450(false)
	local v1_453 = { Instance = v1_446 }
	function v1_453:Set(v2_454, v2_455)
		v1_444 = v2_454 and true or false
		v1_450(true)
		if not v2_455 and v1_443.Callback then v1_443.Callback(v1_444) end
	end
	function v1_453:Get()
		return v1_444
	end
	v1_446.MouseButton1Click:Connect(function()
		v1_453:Set(not v1_444)
	end)
	function v1_453:AddKeybind(v2_456)
		if v1_453.Keybind then
			warn("[RobloxUI] this toggle already has a keybind")
			return v1_453.Keybind
		end
		local v2_457 = v0_413(v1_445._lib, v1_446, v2_456, UDim2.new(1, -48, 0.5, 0), function()
			v1_453:Set(not v1_444)
		end)
		v0_433(v1_447, v2_457, 60)
		local v2_458 = v2_457.Destroy
		function v2_457:Destroy()
			v2_458(v2_457)
			v1_453.Keybind = nil
			v1_447.Size = UDim2.new(1, -60, 1, 0)
		end
		v1_453.Keybind = v2_457
		return v2_457
	end
	function v1_453:Destroy()
		if v1_453._destroyed then return end
		v1_453._destroyed = true
		if v1_453.Keybind then v1_453.Keybind:Destroy() end
		v1_446:Destroy()
	end
	return v1_453
end
function v0_3:AddParagraph(v1_459)
	v1_459 = v1_459 or {}
	self._count += 1
	local v1_460 = v1_459.Title and tostring(v1_459.Title) or ""
	local v1_461 = v1_459.Content and tostring(v1_459.Content) or ""
	local v1_462 = Instance.new("Frame")
	v1_462.Name = "Paragraph"
	v1_462.Size = UDim2.new(1, 0, 0, 0)
	v1_462.AutomaticSize = Enum.AutomaticSize.Y
	v1_462.BackgroundColor3 = v0_8.Element
	v1_462.BorderSizePixel = 0
	v1_462.LayoutOrder = self._count
	v1_462.Parent = self.Holder
	v0_63(v1_462, 6)
	local v1_463 = Instance.new("UIPadding")
	v1_463.PaddingTop = UDim.new(0, 8)
	v1_463.PaddingBottom = UDim.new(0, 8)
	v1_463.PaddingLeft = UDim.new(0, 8)
	v1_463.PaddingRight = UDim.new(0, 8)
	v1_463.Parent = v1_462
	local v1_464 = Instance.new("UIListLayout")
	v1_464.Padding = UDim.new(0, 3)
	v1_464.SortOrder = Enum.SortOrder.LayoutOrder
	v1_464.Parent = v1_462
	local function v1_465(v2_466, v2_467, v2_468, v2_469, v2_470)
		local v2_471 = Instance.new("TextLabel")
		v2_471.Name = v2_466
		v2_471.Size = UDim2.new(1, 0, 0, 0)
		v2_471.AutomaticSize = Enum.AutomaticSize.Y
		v2_471.BackgroundTransparency = 1
		v2_471.BorderSizePixel = 0
		v2_471.TextColor3 = v2_469
		v2_471.Font = v2_467
		v2_471.TextSize = v2_468
		v2_471.TextWrapped = true
		v2_471.RichText = v1_459.RichText == true
		v2_471.TextXAlignment = Enum.TextXAlignment.Left
		v2_471.TextYAlignment = Enum.TextYAlignment.Top
		v2_471.LayoutOrder = v2_470
		v2_471.Parent = v1_462
		return v2_471
	end
	local v1_472 = v1_465("Title", Enum.Font.GothamBold, 14, v0_8.Text, 1)
	local v1_473 = v1_465("Content", Enum.Font.Gotham, 13, v0_8.SubText, 2)
	local v1_474 = self._lib:_track(v1_472, "Text", "")
	local v1_475 = self._lib:_track(v1_473, "Text", "")
	local function v1_476(v2_477)
		v1_474.key = v1_460
		v1_472.Text = v0_82(v1_460)
		v1_472.Visible = v1_460 ~= ""
		v1_475.key = v1_461
		v1_473.Text = v0_82(v1_461)
		v1_473.Visible = v1_461 ~= ""
		if v2_477 then
			v1_472.TextTransparency = 1
			v1_473.TextTransparency = 1
			v0_12(v1_472, { TextTransparency = 0 }, 0.2)
			v0_12(v1_473, { TextTransparency = 0 }, 0.2)
		end
	end
	v1_476(false)
	local v1_478 = { Instance = v1_462 }
	function v1_478:SetTitle(v2_479)
		v1_460 = v2_479 and tostring(v2_479) or ""
		v1_476(true)
	end
	function v1_478:SetContent(v2_480)
		v1_461 = v2_480 and tostring(v2_480) or ""
		v1_476(true)
	end
	function v1_478:Set(v2_481)
		v2_481 = v2_481 or {}
		if v2_481.Title ~= nil then v1_460 = tostring(v2_481.Title) end
		if v2_481.Content ~= nil then v1_461 = tostring(v2_481.Content) end
		v1_476(true)
	end
	function v1_478:Get()
		return v1_460, v1_461
	end
	function v1_478:Destroy()
		v1_462:Destroy()
	end
	return v1_478
end
function v0_3:AddTextbox(v1_482)
	v1_482 = v1_482 or {}
	self._count += 1
	local v1_483 = v1_482.Numeric == true
	local v1_484 = tonumber(v1_482.MaxLength)
	local v1_485 = v1_482.Name ~= nil and v1_482.Name ~= ""
	local v1_486, v1_487, v1_488 = false, false, false
	local function v1_489(v2_490)
		if v1_482.Min then v2_490 = math.max(v2_490, v1_482.Min) end
		if v1_482.Max then v2_490 = math.min(v2_490, v1_482.Max) end
		return v2_490
	end
	local v1_491
	if v1_483 then
		v1_491 = tonumber(v1_482.Default)
		if v1_491 then v1_491 = v1_489(v1_491) end
	else
		v1_491 = tostring(v1_482.Default or "")
	end
	local function v1_492(v2_493)
		return v2_493 == nil and "" or tostring(v2_493)
	end
	local function v1_494(v2_495)
		local v2_496 = v2_495:sub(1, 1) == "-"
		v2_495 = v2_495:gsub("[^%d%.]", "")
		local v2_497 = v2_495:find(".", 1, true)
		if v2_497 then
			local v3_498 = v2_495:sub(v2_497 + 1):gsub("%.", "")
			v2_495 = v2_495:sub(1, v2_497) .. v3_498
		end
		return (v2_496 and "-" or "") .. v2_495
	end
	local v1_499 = Instance.new("Frame")
	v1_499.Name = "Textbox"
	v1_499.Size = UDim2.new(1, 0, 0, 32)
	v1_499.BackgroundColor3 = v0_8.Element
	v1_499.BorderSizePixel = 0
	v1_499.LayoutOrder = self._count
	v1_499.Parent = self.Holder
	v0_63(v1_499, 6)
	if v1_485 then
		local v2_500 = Instance.new("TextLabel")
		v2_500.Name = "Label"
		v2_500.Position = UDim2.new(0, 8, 0, 0)
		v2_500.Size = UDim2.new(0.4, -8, 1, 0)
		v2_500.BackgroundTransparency = 1
		v2_500.BorderSizePixel = 0
		self._lib:_track(v2_500, "Text", v1_482.Name)
		v2_500.TextColor3 = v0_8.Text
		v2_500.Font = Enum.Font.Gotham
		v2_500.TextSize = 14
		v2_500.TextXAlignment = Enum.TextXAlignment.Left
		v2_500.TextTruncate = Enum.TextTruncate.AtEnd
		v2_500.Parent = v1_499
	end
	local v1_501 = Instance.new("Frame")
	v1_501.Name = "BoxHolder"
	v1_501.AnchorPoint = Vector2.new(1, 0.5)
	v1_501.Position = UDim2.new(1, -6, 0.5, 0)
	v1_501.Size = v1_485 and UDim2.new(0.6, -10, 0, 22) or UDim2.new(1, -12, 0, 22)
	v1_501.BackgroundColor3 = v0_8.Card
	v1_501.BorderSizePixel = 0
	v1_501.Parent = v1_499
	v0_63(v1_501, 5)
	local v1_502 = Instance.new("UIStroke")
	v1_502.Color = v0_8.Accent
	v1_502.Thickness = 1
	v1_502.Transparency = 1
	v1_502.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_502.Parent = v1_501
	local v1_503 = Instance.new("TextBox")
	v1_503.Name = "Input"
	v1_503.Size = UDim2.new(1, 0, 1, 0)
	v1_503.BackgroundTransparency = 1
	v1_503.BorderSizePixel = 0
	v1_503.Text = v1_492(v1_491)
	self._lib:_track(v1_503, "PlaceholderText", v1_482.Placeholder or "")
	v1_503.PlaceholderColor3 = v0_8.IconOff
	v1_503.TextColor3 = v0_8.Text
	v1_503.Font = Enum.Font.Gotham
	v1_503.TextSize = 13
	v1_503.TextXAlignment = Enum.TextXAlignment.Left
	v1_503.ClearTextOnFocus = v1_482.ClearTextOnFocus == true
	v1_503.ClipsDescendants = true
	v1_503.Parent = v1_501
	local v1_504 = Instance.new("UIPadding")
	v1_504.PaddingLeft = UDim.new(0, 6)
	v1_504.PaddingRight = UDim.new(0, 6)
	v1_504.Parent = v1_503
	local function v1_505()
		v0_12(v1_501, { BackgroundColor3 = (v1_487 and not v1_486) and v0_8.Sidebar or v0_8.Card }, 0.12)
		v0_12(v1_502, { Transparency = v1_486 and 0 or 1 }, 0.15)
	end
	v1_503:GetPropertyChangedSignal("Text"):Connect(function()
		if v1_488 then return end
		local v2_506 = v1_503.Text
		if v1_483 then v2_506 = v1_494(v2_506) end
		if v1_484 and #v2_506 > v1_484 then v2_506 = v2_506:sub(1, v1_484) end
		if v2_506 ~= v1_503.Text then
			v1_488 = true
			v1_503.Text = v2_506
			v1_488 = false
		end
	end)
	v1_503.Focused:Connect(function()
		v1_486 = true
		v1_505()
	end)
	v1_503.FocusLost:Connect(function(v2_507)
		v1_486 = false
		v1_505()
		if v1_483 then
			local v3_508 = tonumber(v1_503.Text)
			if v3_508 == nil then
				v1_503.Text = v1_492(v1_491)
				return
			end
			v3_508 = v1_489(v3_508)
			v1_491 = v3_508
			v1_503.Text = v1_492(v3_508)
		else
			v1_491 = v1_503.Text
		end
		if v1_482.Callback then v1_482.Callback(v1_491, v2_507) end
	end)
	v1_501.MouseEnter:Connect(function()
		v1_487 = true
		v1_505()
	end)
	v1_501.MouseLeave:Connect(function()
		v1_487 = false
		v1_505()
	end)
	local v1_509 = { Instance = v1_499 }
	function v1_509:Set(v2_510, v2_511)
		if v1_483 then
			local v3_512 = tonumber(v2_510)
			if v3_512 == nil then return end
			v1_491 = v1_489(v3_512)
		else
			v1_491 = tostring(v2_510 == nil and "" or v2_510)
			if v1_484 then v1_491 = v1_491:sub(1, v1_484) end
		end
		v1_503.Text = v1_492(v1_491)
		if not v2_511 and v1_482.Callback then v1_482.Callback(v1_491, false) end
	end
	function v1_509:Get()
		return v1_491
	end
	function v1_509:Focus()
		v1_503:CaptureFocus()
	end
	function v1_509:Destroy()
		if v1_503:IsFocused() then v1_503:ReleaseFocus() end
		v1_499:Destroy()
	end
	return v1_509
end
function v0_3:AddKeybind(v1_513)
	v1_513 = v1_513 or {}
	self._count += 1
	local v1_514 = Instance.new("Frame")
	v1_514.Name = "KeybindRow"
	v1_514.Size = UDim2.new(1, 0, 0, 32)
	v1_514.BackgroundColor3 = v0_8.Element
	v1_514.BorderSizePixel = 0
	v1_514.LayoutOrder = self._count
	v1_514.Parent = self.Holder
	v0_63(v1_514, 6)
	local v1_515 = Instance.new("TextLabel")
	v1_515.Name = "Label"
	v1_515.Position = UDim2.new(0, 8, 0, 0)
	v1_515.Size = UDim2.new(1, -60, 1, 0)
	v1_515.BackgroundTransparency = 1
	v1_515.BorderSizePixel = 0
	self._lib:_track(v1_515, "Text", v1_513.Name or "Keybind")
	v1_515.TextColor3 = v0_8.Text
	v1_515.Font = Enum.Font.Gotham
	v1_515.TextSize = 14
	v1_515.TextXAlignment = Enum.TextXAlignment.Left
	v1_515.TextTruncate = Enum.TextTruncate.AtEnd
	v1_515.Parent = v1_514
	local v1_516 = v0_413(self._lib, v1_514, v1_513, UDim2.new(1, -8, 0.5, 0), function()
		if v1_513.OnPress then v1_513.OnPress() end
	end)
	v0_433(v1_515, v1_516, 16)
	v1_516.Row = v1_514
	local v1_517 = v1_516.Destroy
	function v1_516:Destroy()
		v1_517(v1_516)
		v1_514:Destroy()
	end
	return v1_516
end
function v0_3:AddSlider(v1_518)
	v1_518 = v1_518 or {}
	self._count += 1
	local v1_519 = self._lib
	local function v1_520(v2_521)
		return #(tostring(v2_521):match("%.(%d+)") or "")
	end
	local v1_522 = tonumber(v1_518.Min) or 0
	local v1_523 = tonumber(v1_518.Max) or 100
	if v1_523 < v1_522 then v1_522, v1_523 = v1_523, v1_522 end
	local v1_524 = tonumber(v1_518.Increment) or 1
	if v1_524 <= 0 then v1_524 = 1 end
	local v1_525 = math.max(v1_520(v1_524), v1_520(v1_522))
	local v1_526 = v1_518.ValueName
	local function v1_527(v2_528)
		v2_528 = math.clamp(v2_528, v1_522, v1_523)
		v2_528 = v1_522 + math.floor((v2_528 - v1_522) / v1_524 + 0.5) * v1_524
		v2_528 = math.clamp(v2_528, v1_522, v1_523)
		local v2_529 = 10 ^ v1_525
		return math.floor(v2_528 * v2_529 + 0.5) / v2_529
	end
	local function v1_530(v2_531)
		return v1_523 > v1_522 and (v2_531 - v1_522) / (v1_523 - v1_522) or 0
	end
	local function v1_532(v2_533)
		local v2_534 = v1_525 > 0 and string.format("%." .. v1_525 .. "f", v2_533) or tostring(v2_533)
		if v1_526 and v1_526 ~= "" then v2_534 = v2_534 .. " " .. v0_82(tostring(v1_526)) end
		return v2_534
	end
	local v1_535 = v1_527(tonumber(v1_518.Default) or v1_522)
	local v1_536, v1_537 = false, false
	local v1_538 = nil
	local v1_539 = Instance.new("Frame")
	v1_539.Name = "Slider"
	v1_539.Size = UDim2.new(1, 0, 0, 46)
	v1_539.BackgroundColor3 = v0_8.Element
	v1_539.BorderSizePixel = 0
	v1_539.LayoutOrder = self._count
	v1_539.Parent = self.Holder
	v0_63(v1_539, 6)
	local v1_540 = Instance.new("TextLabel")
	v1_540.Name = "Name"
	v1_540.Position = UDim2.new(0, 8, 0, 6)
	v1_540.Size = UDim2.new(0.6, -8, 0, 16)
	v1_540.BackgroundTransparency = 1
	v1_540.BorderSizePixel = 0
	v1_519:_track(v1_540, "Text", v1_518.Name or "Slider")
	v1_540.TextColor3 = v0_8.Text
	v1_540.Font = Enum.Font.Gotham
	v1_540.TextSize = 14
	v1_540.TextXAlignment = Enum.TextXAlignment.Left
	v1_540.TextTruncate = Enum.TextTruncate.AtEnd
	v1_540.Parent = v1_539
	local v1_541 = Instance.new("TextLabel")
	v1_541.Name = "Value"
	v1_541.Position = UDim2.new(0.6, 0, 0, 6)
	v1_541.Size = UDim2.new(0.4, -8, 0, 16)
	v1_541.BackgroundTransparency = 1
	v1_541.BorderSizePixel = 0
	v1_541.Text = v1_532(v1_535)
	v1_541.TextColor3 = v0_8.SubText
	v1_541.Font = Enum.Font.GothamBold
	v1_541.TextSize = 13
	v1_541.TextXAlignment = Enum.TextXAlignment.Right
	v1_541.TextTruncate = Enum.TextTruncate.AtEnd
	v1_541.Parent = v1_539
	v1_519:_onLang(v1_541, function() v1_541.Text = v1_532(v1_535) end)
	local v1_542 = Instance.new("Frame")
	v1_542.Name = "Track"
	v1_542.Position = UDim2.new(0, 8, 0, 31)
	v1_542.Size = UDim2.new(1, -16, 0, 6)
	v1_542.BackgroundColor3 = v0_8.Off
	v1_542.BorderSizePixel = 0
	v1_542.Parent = v1_539
	local v1_543 = Instance.new("Frame")
	v1_543.Name = "Fill"
	v1_543.Size = UDim2.new(v1_530(v1_535), 0, 1, 0)
	v1_543.BackgroundColor3 = v0_8.Accent
	v1_543.BorderSizePixel = 0
	v1_543.Parent = v1_542
	local v1_544 = v0_8.Accent
	local v1_545 = v0_8.Accent:Lerp(v0_8.Text, 0.25)
	local v1_546 = Instance.new("TextButton")
	v1_546.Name = "Hit"
	v1_546.Size = UDim2.new(1, 0, 1, 0)
	v1_546.BackgroundTransparency = 1
	v1_546.BorderSizePixel = 0
	v1_546.Text = ""
	v1_546.AutoButtonColor = false
	v1_546.Parent = v1_539
	local function v1_547()
		local v2_548 = v1_536 or v1_537
		v0_12(v1_539, { BackgroundColor3 = v2_548 and v0_8.Hover or v0_8.Element }, 0.12)
		v0_12(v1_543, { BackgroundColor3 = v2_548 and v1_545 or v1_544 }, 0.12)
	end
	local function v1_549(v2_550)
		local v2_551 = v1_530(v1_535)
		v0_12(v1_543, { Size = UDim2.new(v2_551, 0, 1, 0) }, v2_550)
		v1_541.Text = v1_532(v1_535)
	end
	local function v1_552(v2_553, v2_554, v2_555)
		v2_553 = v1_527(v2_553)
		local v2_556 = v2_553 ~= v1_535
		v1_535 = v2_553
		v1_549(v2_555)
		if v2_556 then
			v1_541.TextColor3 = v0_8.Text
			v0_12(v1_541, { TextColor3 = v0_8.SubText }, 0.3)
			if not v2_554 and v1_518.Callback then v1_518.Callback(v1_535) end
		end
	end
	local function v1_557(v2_558)
		local v2_559 = v1_542.AbsoluteSize.X
		if v2_559 <= 0 then return end
		v1_552(v1_522 + ((v2_558 - v1_542.AbsolutePosition.X) / v2_559) * (v1_523 - v1_522), false, 0.08)
	end
	local function v1_560()
		if v1_538 then
			for v4_561, v4_562 in ipairs(v1_538) do v4_562:Disconnect() end
			v1_538 = nil
		end
		if v1_537 then
			v1_537 = false
			v1_547()
		end
	end
	local function v1_563(v2_564)
		v1_560()
		v1_537 = true
		v1_547()
		v1_557(v2_564.Position.X)
		v1_538 = {
			v0_4.InputChanged:Connect(function(v3_565)
				if v3_565.UserInputType == Enum.UserInputType.MouseMovement or v3_565 == v2_564 then
					v1_557(v3_565.Position.X)
				end
			end),
			v0_4.InputEnded:Connect(function(v3_566)
				if v3_566 == v2_564 or v3_566.UserInputType == Enum.UserInputType.MouseButton1 then
					v1_560()
				end
			end),
		}
	end
	v1_546.InputBegan:Connect(function(v2_567)
		if v0_19(v2_567) then v1_563(v2_567) end
	end)
	v1_546.MouseEnter:Connect(function()
		v1_536 = true
		v1_547()
	end)
	v1_546.MouseLeave:Connect(function()
		v1_536 = false
		v1_547()
	end)
	local v1_568 = { Instance = v1_539 }
	function v1_568:Set(v2_569, v2_570)
		v1_552(tonumber(v2_569) or v1_535, v2_570, 0.2)
	end
	function v1_568:Get()
		return v1_535
	end
	function v1_568:Destroy()
		v1_560()
		v1_519._cleanups[v1_568] = nil
		v1_539:Destroy()
	end
	v1_519._cleanups[v1_568] = v1_560
	return v1_568
end
function v0_3:AddDropdown(v1_571)
	v1_571 = v1_571 or {}
	self._count += 1
	local v1_572 = v1_571.Options or {}
	local v1_573 = v1_571.Multi == true
	local v1_574 = 130
	local v1_575, v1_576 = 26, 4
	local v1_577 = nil
	local v1_578 = {}
	local v1_579 = {}
	local v1_580 = false
	local v1_581 = 0
	local v1_582 = nil
	local v1_583 = Instance.new("Frame")
	v1_583.Name = "Dropdown"
	v1_583.Size = UDim2.new(1, 0, 0, 32)
	v1_583.AutomaticSize = Enum.AutomaticSize.Y
	v1_583.BackgroundTransparency = 1
	v1_583.BorderSizePixel = 0
	v1_583.LayoutOrder = self._count
	v1_583.Parent = self.Holder
	local v1_584 = Instance.new("UIListLayout")
	v1_584.Padding = UDim.new(0, 4)
	v1_584.SortOrder = Enum.SortOrder.LayoutOrder
	v1_584.Parent = v1_583
	local v1_585 = Instance.new("TextButton")
	v1_585.Name = "Header"
	v1_585.Size = UDim2.new(1, 0, 0, 32)
	v1_585.BackgroundColor3 = v0_8.Element
	v1_585.BorderSizePixel = 0
	v1_585.Text = ""
	v1_585.AutoButtonColor = false
	v1_585.LayoutOrder = 1
	v1_585.Parent = v1_583
	v0_63(v1_585, 6)
	v0_21(v1_585, v0_8.Element, v0_8.Hover)
	local v1_586 = Instance.new("TextLabel")
	v1_586.Name = "Name"
	v1_586.Position = UDim2.new(0, 8, 0, 0)
	v1_586.Size = UDim2.new(0.5, -8, 1, 0)
	v1_586.BackgroundTransparency = 1
	v1_586.BorderSizePixel = 0
	self._lib:_track(v1_586, "Text", v1_571.Name or "Dropdown")
	v1_586.TextColor3 = v0_8.Text
	v1_586.Font = Enum.Font.Gotham
	v1_586.TextSize = 14
	v1_586.TextXAlignment = Enum.TextXAlignment.Left
	v1_586.TextTruncate = Enum.TextTruncate.AtEnd
	v1_586.Parent = v1_585
	local v1_587 = Instance.new("TextLabel")
	v1_587.Name = "Value"
	v1_587.Position = UDim2.new(0.5, 0, 0, 0)
	v1_587.Size = UDim2.new(0.5, -28, 1, 0)
	v1_587.BackgroundTransparency = 1
	v1_587.BorderSizePixel = 0
	v1_587.Text = v0_82("None")
	v1_587.TextColor3 = v0_8.SubText
	v1_587.Font = Enum.Font.Gotham
	v1_587.TextSize = 13
	v1_587.TextXAlignment = Enum.TextXAlignment.Right
	v1_587.TextTruncate = Enum.TextTruncate.AtEnd
	v1_587.Parent = v1_585
	local v1_588 = Instance.new("ImageLabel")
	v1_588.Name = "Arrow"
	v1_588.AnchorPoint = Vector2.new(1, 0.5)
	v1_588.Position = UDim2.new(1, -8, 0.5, 0)
	v1_588.Size = UDim2.new(0, 16, 0, 16)
	v1_588.BackgroundTransparency = 1
	v1_588.BorderSizePixel = 0
	v1_588.ImageColor3 = v0_8.SubText
	v1_588.ScaleType = Enum.ScaleType.Fit
	v1_588.Parent = v1_585
	local v1_589 = Instance.new("TextLabel")
	v1_589.Name = "ArrowFallback"
	v1_589.Size = UDim2.new(1, 0, 1, 0)
	v1_589.BackgroundTransparency = 1
	v1_589.Text = "▼"
	v1_589.TextColor3 = v0_8.SubText
	v1_589.Font = Enum.Font.Gotham
	v1_589.TextSize = 9
	v1_589.Visible = false
	v1_589.Parent = v1_588
	local function v1_590(v2_591)
		local v2_592 = v0_44(v1_588, v2_591 and "chevron-up" or "chevron-down", self._icons)
		if not v2_592 then v1_588.Image = "" end
		v1_589.Visible = not v2_592
		v1_589.Text = v2_591 and "▲" or "▼"
		v1_588.ImageTransparency = 1
		v1_589.TextTransparency = 1
		v0_12(v1_588, { ImageTransparency = 0 }, 0.18)
		v0_12(v1_589, { TextTransparency = 0 }, 0.18)
	end
	v1_590(false)
	local v1_593 = Instance.new("ScrollingFrame")
	v1_593.Name = "List"
	v1_593.Size = UDim2.new(1, 0, 0, 0)
	v1_593.BackgroundColor3 = v0_8.Sidebar
	v1_593.BorderSizePixel = 0
	v1_593.ScrollBarThickness = 3
	v1_593.ScrollBarImageColor3 = v0_8.IconOff
	v1_593.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_593.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_593.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_593.Visible = false
	v1_593.LayoutOrder = 2
	v1_593.Parent = v1_583
	v0_63(v1_593, 6)
	local v1_594 = Instance.new("UIPadding")
	v1_594.PaddingTop = UDim.new(0, 4)
	v1_594.PaddingBottom = UDim.new(0, 4)
	v1_594.Parent = v1_593
	local v1_595 = Instance.new("UIListLayout")
	v1_595.Padding = UDim.new(0, v1_576)
	v1_595.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_595.SortOrder = Enum.SortOrder.LayoutOrder
	v1_595.Parent = v1_593
	local function v1_596(v2_597)
		if v1_573 then return v1_578[v2_597] == true end
		return v1_577 == v2_597
	end
	local function v1_598()
		local v2_599 = {}
		for v3_600, v3_601 in ipairs(v1_572) do
			if v1_578[v3_601] then table.insert(v2_599, v3_601) end
		end
		return v2_599
	end
	local function v1_602()
		for v3_603, v3_604 in pairs(v1_579) do
			local v3_605 = v1_596(v3_603)
			v3_604.BackgroundColor3 = v3_605 and v0_8.Accent or v0_8.Element
			v3_604.TextColor3 = v3_605 and v0_8.IconOn or v0_8.SubText
		end
		if v1_573 then
			local v3_606 = {}
			for v4_607, v4_608 in ipairs(v1_598()) do table.insert(v3_606, v0_82(tostring(v4_608))) end
			v1_587.Text = #v3_606 > 0 and table.concat(v3_606, ", ") or v0_82("None")
		else
			v1_587.Text = v1_577 ~= nil and v0_82(tostring(v1_577)) or v0_82("None")
		end
	end
	self._lib:_onLang(v1_587, v1_602)
	local function v1_609(v2_610)
		if v1_580 == v2_610 then return end
		v1_580 = v2_610
		if v1_582 then v1_582:Cancel() end
		v1_590(v2_610)
		if v2_610 then
			v1_593.Visible = true
			v1_582 = v0_12(v1_593, { Size = UDim2.new(1, 0, 0, v1_581) }, 0.22, Enum.EasingStyle.Quint)
		else
			local v3_611 = v0_12(v1_593, { Size = UDim2.new(1, 0, 0, 0) }, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			v1_582 = v3_611
			v3_611.Completed:Connect(function(v4_612)
				if v4_612 == Enum.PlaybackState.Completed and not v1_580 then
					v1_593.Visible = false
				end
			end)
		end
	end
	local v1_613 = { Instance = v1_583 }
	local function v1_614()
		if v1_571.Callback then
			v1_571.Callback(v1_573 and v1_598() or v1_577)
		end
	end
	local function v1_615()
		for v3_616, v3_617 in pairs(v1_579) do v3_617:Destroy() end
		v1_579 = {}
		for v3_618, v3_619 in ipairs(v1_572) do
			local v3_620 = Instance.new("TextButton")
			v3_620.Name = "Option"
			v3_620.Size = UDim2.new(1, -8, 0, v1_575)
			v3_620.BackgroundColor3 = v0_8.Element
			v3_620.BorderSizePixel = 0
			self._lib:_track(v3_620, "Text", tostring(v3_619))
			v3_620.TextColor3 = v0_8.SubText
			v3_620.Font = Enum.Font.Gotham
			v3_620.TextSize = 13
			v3_620.TextTruncate = Enum.TextTruncate.AtEnd
			v3_620.AutoButtonColor = true
			v3_620.LayoutOrder = v3_618
			v3_620.Parent = v1_593
			v0_63(v3_620, 5)
			v3_620.MouseButton1Click:Connect(function()
				if v1_573 then
					v1_578[v3_619] = not v1_578[v3_619] or nil
					v1_602()
					v1_614()
				else
					v1_577 = v3_619
					v1_602()
					v1_609(false)
					v1_614()
				end
			end)
			v1_579[v3_619] = v3_620
		end
		local v2_621 = #v1_572
		local v2_622 = v2_621 > 0 and (v2_621 * v1_575 + (v2_621 - 1) * v1_576 + 8) or 0
		v1_581 = math.min(v2_622, v1_574)
		v1_593.Size = UDim2.new(1, 0, 0, v1_580 and v1_581 or 0)
		v1_602()
	end
	function v1_613:Set(v2_623, v2_624)
		if v1_573 then
			v1_578 = {}
			for v4_625, v4_626 in ipairs(typeof(v2_623) == "table" and v2_623 or { v2_623 }) do
				v1_578[v4_626] = true
			end
		else
			v1_577 = v2_623
		end
		v1_602()
		if not v2_624 then v1_614() end
	end
	function v1_613:Get()
		return v1_573 and v1_598() or v1_577
	end
	function v1_613:Refresh(v2_627, v2_628)
		v1_572 = v2_627 or {}
		if v2_628 then
			local v3_629 = {}
			for v4_630, v4_631 in ipairs(v1_572) do v3_629[v4_631] = true end
			if v1_573 then
				for v5_632 in pairs(v1_578) do
					if not v3_629[v5_632] then v1_578[v5_632] = nil end
				end
			elseif not v3_629[v1_577] then
				v1_577 = nil
			end
		else
			v1_578, v1_577 = {}, nil
		end
		v1_615()
	end
	function v1_613:Open() v1_609(true) end
	function v1_613:Close() v1_609(false) end
	v1_585.MouseButton1Click:Connect(function()
		v1_609(not v1_580)
	end)
	v1_615()
	if v1_571.Default ~= nil then
		v1_613:Set(v1_571.Default, true)
	end
	return v1_613
end
return v0_1
