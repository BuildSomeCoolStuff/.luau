--[[
	RobloxUI Library
	- icon-only sidebar, no title bar
	- split layout (left / right columns per tab)
	- Tab:AddSection(name, "left" | "right") -> Section:AddButton({Name, Callback})

	local Library = loadstring(...)()
	local Window  = Library.new({ Size = UDim2.new(0, 600, 0, 400), Icons = IconsV2 })
	local Tab     = Window:AddTab({ Icon = "house" })      -- name (needs Icons), asset id, or GetIcon() result
	local Sec     = Tab:AddSection("Main", "left")
	Sec:AddButton({ Name = "Hello", Callback = function() end })
]]

local Library = {}
Library.__index = Library

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

local UserInputService = game:GetService("UserInputService")

local Theme = {
	Main = Color3.fromRGB(24, 24, 28),
	Sidebar = Color3.fromRGB(18, 18, 22),
	Card = Color3.fromRGB(30, 30, 35),
	Element = Color3.fromRGB(40, 40, 46),
	IconOff = Color3.fromRGB(160, 160, 170),
	IconOn = Color3.fromRGB(255, 255, 255),
	Accent = Color3.fromRGB(50, 90, 220),
	Text = Color3.fromRGB(255, 255, 255),
	SubText = Color3.fromRGB(200, 200, 210),
}

local SIDEBAR_WIDTH = 50
local CORNER_RADIUS = 8

--// ================= ICON HANDLING =================
-- Scans whatever the icon library returns (string / number / array / dict / nested / Instance)
-- and pulls out: image id, sprite rect size, sprite rect offset.
local function isImageString(s)
	return s:find("^rbx") ~= nil or s:find("^https?://") ~= nil
end

local function scan(t, out, depth)
	if depth > 3 then return end
	for k, v in pairs(t) do
		local key = type(k) == "string" and k:lower() or ""
		local tv = typeof(v)
		if tv == "string" then
			if isImageString(v) then
				out.image = out.image or v
			elseif v:match("^%d+$") then
				out.image = out.image or ("rbxassetid://" .. v)
			end
		elseif tv == "number" then
			if key == "id" or key == "image" or key == "imageid" or key == "assetid" or k == 1 then
				if v > 1000 then out.image = out.image or ("rbxassetid://" .. v) end
			end
		elseif tv == "Vector2" then
			if key:find("size") then
				out.size = out.size or v
			elseif key:find("pos") or key:find("offset") then
				out.offset = out.offset or v
			end
		elseif tv == "table" then
			scan(v, out, depth + 1)
		end
	end
end

-- Turns any supported icon value into { image, size, offset }.
-- Plain icon NAMES (e.g. "house") are NOT image ids, so they yield no image here.
local function extract(icon)
	local out = {}
	local t = typeof(icon)

	if t == "string" then
		if isImageString(icon) then
			out.image = icon
		elseif icon:match("^%d+$") then
			out.image = "rbxassetid://" .. icon
		end
	elseif t == "number" then
		out.image = "rbxassetid://" .. icon
	elseif t == "table" then
		scan(icon, out, 0)
	elseif t == "Instance" then
		local img = (icon:IsA("ImageLabel") or icon:IsA("ImageButton")) and icon
			or icon:FindFirstChildWhichIsA("ImageLabel", true)
		if img then
			out.image, out.size, out.offset = img.Image, img.ImageRectSize, img.ImageRectOffset
		end
	end

	if out.image == "" then out.image = nil end
	return out
end

-- Returns true if an icon was applied.
local function applyIcon(imageObj, icon, provider)
	local out = extract(icon)

	-- icon name -> ask the icon provider. Supports both IconsV2.GetIcon(name) and IconsV2:GetIcon(name)
	if not out.image and typeof(icon) == "string" and provider then
		local attempts = {
			function() return provider.GetIcon(icon) end,
			function() return provider:GetIcon(icon) end,
			function() return provider.Icons and provider.Icons[icon] end,
			function() return provider[icon] end,
		}
		for _, attempt in ipairs(attempts) do
			local ok, res = pcall(attempt)
			if ok and res ~= nil then
				local o = extract(res)
				if o.image then
					out = o
					break
				end
			end
		end
	end

	if not out.image then
		warn("[RobloxUI] icon not recognized:", typeof(icon), icon)
		return false
	end

	imageObj.Image = out.image
	imageObj.ImageRectSize = out.size or Vector2.new(0, 0)
	imageObj.ImageRectOffset = out.offset or Vector2.new(0, 0)
	return true
end

local function protectGui(gui)
	local ok = pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(gui)
			gui.Parent = game:GetService("CoreGui")
		elseif gethui then
			gui.Parent = gethui()
		else
			gui.Parent = game:GetService("CoreGui")
		end
	end)
	-- fallback if CoreGui isn't accessible
	if not ok or not gui.Parent then
		local player = game:GetService("Players").LocalPlayer
		gui.Parent = player and player:WaitForChild("PlayerGui")
	end
end

local function corner(obj, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 6)
	c.Parent = obj
	return c
end

--// ================= WINDOW =================
function Library.new(config)
	config = config or {}
	local self = setmetatable({}, Library)
	self.Tabs = {}
	self.ActiveTab = nil
	self.Icons = config.Icons -- optional icon provider with .GetIcon(name)
	self._connections = {}

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "Interface"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	protectGui(ScreenGui)

	local desiredSize = config.Size or UDim2.new(0, 600, 0, 400)

	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Size = desiredSize
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.BackgroundColor3 = Theme.Main
	Main.BorderSizePixel = 0
	Main.ClipsDescendants = true
	Main.Parent = ScreenGui
	corner(Main, CORNER_RADIUS)

	-- shrink the window if the screen is smaller than the requested size
	local function fitToScreen()
		local vp = ScreenGui.AbsoluteSize
		if vp.X <= 0 or vp.Y <= 0 then
			local cam = workspace.CurrentCamera
			vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
		end
		local w, h = desiredSize.X.Offset, desiredSize.Y.Offset
		if desiredSize.X.Scale == 0 then w = math.min(w, math.max(vp.X - 20, 120)) end
		if desiredSize.Y.Scale == 0 then h = math.min(h, math.max(vp.Y - 20, 120)) end
		Main.Size = UDim2.new(desiredSize.X.Scale, w, desiredSize.Y.Scale, h)
		Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	end
	fitToScreen()
	table.insert(self._connections, ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitToScreen))

	-- drag from body (no title bar), clamped so the window can't be lost off-screen
	do
		local dragging, dragStart, startCenter = false, nil, nil
		local KEEP_VISIBLE = 50

		table.insert(self._connections, Main.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startCenter = Main.AbsolutePosition + Main.AbsoluteSize / 2
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then dragging = false end
				end)
			end
		end))

		table.insert(self._connections, UserInputService.InputChanged:Connect(function(input)
			if not dragging then return end
			if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			local delta = input.Position - dragStart
			local vp = ScreenGui.AbsoluteSize
			local half = Main.AbsoluteSize / 2
			local cx = math.clamp(startCenter.X + delta.X, -half.X + KEEP_VISIBLE, vp.X + half.X - KEEP_VISIBLE)
			local cy = math.clamp(startCenter.Y + delta.Y, half.Y, math.max(vp.Y + half.Y - KEEP_VISIBLE, half.Y))
			Main.Position = UDim2.fromOffset(cx, cy)
		end))
	end

	-- icon-only sidebar
	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, SIDEBAR_WIDTH, 1, 0)
	Sidebar.BackgroundColor3 = Theme.Sidebar
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = Main
	corner(Sidebar, CORNER_RADIUS)

	-- Squares off the sidebar's right-hand rounded corners.
	-- FIX: this must NOT be a child of Sidebar, because Sidebar has a UIListLayout and
	-- would treat it as a full-height list item, pushing every tab button out of view.
	local SidebarFix = Instance.new("Frame")
	SidebarFix.Name = "SidebarFix"
	SidebarFix.Size = UDim2.new(0, CORNER_RADIUS, 1, 0)
	SidebarFix.Position = UDim2.new(0, SIDEBAR_WIDTH - CORNER_RADIUS, 0, 0)
	SidebarFix.BackgroundColor3 = Theme.Sidebar
	SidebarFix.BorderSizePixel = 0
	SidebarFix.Parent = Main

	local SidebarPad = Instance.new("UIPadding")
	SidebarPad.PaddingTop = UDim.new(0, 12)
	SidebarPad.Parent = Sidebar

	local SidebarLayout = Instance.new("UIListLayout")
	SidebarLayout.Padding = UDim.new(0, 8)
	SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SidebarLayout.Parent = Sidebar

	local Content = Instance.new("Frame")
	Content.Name = "Content"
	Content.Size = UDim2.new(1, -SIDEBAR_WIDTH, 1, 0)
	Content.Position = UDim2.new(0, SIDEBAR_WIDTH, 0, 0)
	Content.BackgroundTransparency = 1
	Content.BorderSizePixel = 0
	Content.ClipsDescendants = true
	Content.Parent = Main

	self.ScreenGui, self.Main, self.Sidebar, self.Content = ScreenGui, Main, Sidebar, Content
	return self
end

function Library:Destroy()
	for _, c in ipairs(self._connections) do
		c:Disconnect()
	end
	self._connections = {}
	self.ScreenGui:Destroy()
end

--// ================= TAB =================
local function setTabIconColor(tab, color)
	tab.Icon.ImageColor3 = color
	if tab.Fallback then
		tab.Fallback.TextColor3 = color
	end
end

function Library:AddTab(config)
	config = config or {}

	-- tab button: plain frame-style button + separate ImageLabel for the icon
	local TabButton = Instance.new("TextButton")
	TabButton.Name = "TabButton"
	TabButton.Size = UDim2.new(0, 36, 0, 36)
	TabButton.BackgroundColor3 = Theme.Card
	TabButton.BorderSizePixel = 0
	TabButton.Text = ""
	TabButton.AutoButtonColor = false
	TabButton.LayoutOrder = #self.Tabs + 1
	TabButton.Parent = self.Sidebar
	corner(TabButton, 6)

	local Icon = Instance.new("ImageLabel")
	Icon.Name = "Icon"
	Icon.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.Size = UDim2.new(0, 20, 0, 20)
	Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
	Icon.BackgroundTransparency = 1
	Icon.BorderSizePixel = 0
	Icon.ImageColor3 = Theme.IconOff
	Icon.ScaleType = Enum.ScaleType.Fit
	Icon.Parent = TabButton

	-- if the icon can't be resolved, show a letter instead of an empty button
	local Fallback
	if not applyIcon(Icon, config.Icon, self.Icons) then
		Fallback = Instance.new("TextLabel")
		Fallback.Name = "IconFallback"
		Fallback.Size = UDim2.new(1, 0, 1, 0)
		Fallback.BackgroundTransparency = 1
		Fallback.Text = string.upper(string.sub(tostring(config.Name or config.Icon or "?"), 1, 1))
		Fallback.TextColor3 = Theme.IconOff
		Fallback.Font = Enum.Font.GothamBold
		Fallback.TextSize = 16
		Fallback.Parent = Icon
	end

	local Page = Instance.new("ScrollingFrame")
	Page.Name = "Page"
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.BackgroundTransparency = 1
	Page.BorderSizePixel = 0
	Page.ScrollBarThickness = 3
	Page.ScrollBarImageColor3 = Theme.IconOff
	Page.ScrollingDirection = Enum.ScrollingDirection.Y
	Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Page.CanvasSize = UDim2.new(0, 0, 0, 0)
	Page.Visible = false
	Page.Parent = self.Content

	-- FIX: UIPadding directly on a ScrollingFrame doesn't shrink the width that scale-sized
	-- children use, so the right column overflowed the window. Pad an inner Frame instead.
	local Inner = Instance.new("Frame")
	Inner.Name = "Inner"
	Inner.Size = UDim2.new(1, 0, 0, 0)
	Inner.AutomaticSize = Enum.AutomaticSize.Y
	Inner.BackgroundTransparency = 1
	Inner.BorderSizePixel = 0
	Inner.Parent = Page

	-- vertical padding only; horizontal padding is done with plain offsets below
	local PagePad = Instance.new("UIPadding")
	PagePad.PaddingTop = UDim.new(0, 12)
	PagePad.PaddingBottom = UDim.new(0, 12)
	PagePad.Parent = Inner

	-- split: left / right columns. 12px left margin, 14px right margin (room for the scrollbar)
	local Split = Instance.new("Frame")
	Split.Name = "Split"
	Split.Position = UDim2.new(0, 12, 0, 0)
	Split.Size = UDim2.new(1, -26, 0, 0)
	Split.AutomaticSize = Enum.AutomaticSize.Y
	Split.BackgroundTransparency = 1
	Split.BorderSizePixel = 0
	Split.Parent = Inner

	local SplitLayout = Instance.new("UIListLayout")
	SplitLayout.FillDirection = Enum.FillDirection.Horizontal
	SplitLayout.Padding = UDim.new(0, 8)
	SplitLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SplitLayout.Parent = Split

	local function column(order)
		local Col = Instance.new("Frame")
		Col.Name = order == 1 and "Left" or "Right"
		Col.Size = UDim2.new(0.5, -4, 0, 0)
		Col.AutomaticSize = Enum.AutomaticSize.Y
		Col.BackgroundTransparency = 1
		Col.BorderSizePixel = 0
		Col.LayoutOrder = order
		Col.Parent = Split
		local Layout = Instance.new("UIListLayout")
		Layout.Padding = UDim.new(0, 8)
		Layout.SortOrder = Enum.SortOrder.LayoutOrder
		Layout.Parent = Col
		return Col
	end

	local tab = setmetatable({
		Page = Page,
		Button = TabButton,
		Icon = Icon,
		Fallback = Fallback,
		Left = column(1),
		Right = column(2),
		_sectionCount = 0,
	}, Tab)

	table.insert(self.Tabs, tab)
	TabButton.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)

	if not self.ActiveTab then self:SelectTab(tab) end
	return tab
end

function Library:SelectTab(tab)
	if self.ActiveTab then
		self.ActiveTab.Page.Visible = false
		self.ActiveTab.Button.BackgroundColor3 = Theme.Card
		setTabIconColor(self.ActiveTab, Theme.IconOff)
	end
	tab.Page.Visible = true
	tab.Button.BackgroundColor3 = Theme.Accent
	setTabIconColor(tab, Theme.IconOn)
	self.ActiveTab = tab
end

--// ================= SECTION =================
function Tab:AddSection(name, side)
	local parent = (side == "right") and self.Right or self.Left
	self._sectionCount += 1

	local Holder = Instance.new("Frame")
	Holder.Name = "Section"
	Holder.Size = UDim2.new(1, 0, 0, 0)
	Holder.AutomaticSize = Enum.AutomaticSize.Y
	Holder.BackgroundColor3 = Theme.Card
	Holder.BorderSizePixel = 0
	Holder.LayoutOrder = self._sectionCount
	Holder.Parent = parent
	corner(Holder, 6)

	local Pad = Instance.new("UIPadding")
	Pad.PaddingTop = UDim.new(0, 8)
	Pad.PaddingBottom = UDim.new(0, 8)
	Pad.PaddingLeft = UDim.new(0, 8)
	Pad.PaddingRight = UDim.new(0, 8)
	Pad.Parent = Holder

	local Layout = Instance.new("UIListLayout")
	Layout.Padding = UDim.new(0, 6)
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Parent = Holder

	if name then
		local Title = Instance.new("TextLabel")
		Title.Name = "Title"
		Title.Size = UDim2.new(1, 0, 0, 16)
		Title.BackgroundTransparency = 1
		Title.BorderSizePixel = 0
		Title.Text = name
		Title.TextColor3 = Theme.SubText
		Title.Font = Enum.Font.GothamBold
		Title.TextSize = 13
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.TextTruncate = Enum.TextTruncate.AtEnd
		Title.LayoutOrder = 0
		Title.Parent = Holder
	end

	return setmetatable({ Holder = Holder, _count = 0 }, Section)
end

function Section:AddButton(config)
	config = config or {}
	self._count += 1

	local Btn = Instance.new("TextButton")
	Btn.Name = "Button"
	Btn.Size = UDim2.new(1, 0, 0, 32)
	Btn.BackgroundColor3 = Theme.Element
	Btn.BorderSizePixel = 0
	Btn.Text = config.Name or "Button"
	Btn.TextColor3 = Theme.Text
	Btn.Font = Enum.Font.Gotham
	Btn.TextSize = 14
	Btn.TextTruncate = Enum.TextTruncate.AtEnd -- long names no longer spill out of the button
	Btn.AutoButtonColor = true
	Btn.LayoutOrder = self._count
	Btn.Parent = self.Holder
	corner(Btn, 6)

	local BtnPad = Instance.new("UIPadding")
	BtnPad.PaddingLeft = UDim.new(0, 8)
	BtnPad.PaddingRight = UDim.new(0, 8)
	BtnPad.Parent = Btn

	Btn.MouseButton1Click:Connect(function()
		if config.Callback then config.Callback() end
	end)

	return Btn
end

return Library
