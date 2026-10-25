local Library = {}
Library.__index = Library

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Theme = {
	Main = Color3.fromRGB(24, 24, 28),
	Sidebar = Color3.fromRGB(18, 18, 22),
	Card = Color3.fromRGB(30, 30, 35),
	Element = Color3.fromRGB(40, 40, 46),
	Off = Color3.fromRGB(65, 65, 74),
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

-- Loads the icon library (lucide by default). Returns nil if it can't be loaded.
local function loadIcons()
	local ok, res = pcall(function()
		return loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()
	end)
	if ok and res then return res end
	warn("[RobloxUI] failed to load icon library:", res)
	return nil
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
	self.Icons = config.Icons or loadIcons() -- icon provider with .GetIcon(name); auto-loaded if not passed
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
		_icons = self.Icons,
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

	return setmetatable({ Holder = Holder, _count = 0, _icons = self._icons }, Section)
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

function Section:AddToggle(config)
	config = config or {}
	self._count += 1
	local state = config.Default == true

	local Row = Instance.new("TextButton")
	Row.Name = "Toggle"
	Row.Size = UDim2.new(1, 0, 0, 32)
	Row.BackgroundColor3 = Theme.Element
	Row.BorderSizePixel = 0
	Row.Text = ""
	Row.AutoButtonColor = false
	Row.LayoutOrder = self._count
	Row.Parent = self.Holder
	corner(Row, 6)

	local Label = Instance.new("TextLabel")
	Label.Name = "Label"
	Label.Position = UDim2.new(0, 8, 0, 0)
	Label.Size = UDim2.new(1, -60, 1, 0)
	Label.BackgroundTransparency = 1
	Label.BorderSizePixel = 0
	Label.Text = config.Name or "Toggle"
	Label.TextColor3 = Theme.Text
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextTruncate = Enum.TextTruncate.AtEnd
	Label.Parent = Row

	local Track = Instance.new("Frame")
	Track.Name = "Track"
	Track.AnchorPoint = Vector2.new(1, 0.5)
	Track.Position = UDim2.new(1, -8, 0.5, 0)
	Track.Size = UDim2.new(0, 34, 0, 18)
	Track.BackgroundColor3 = Theme.Off
	Track.BorderSizePixel = 0
	Track.Parent = Row
	corner(Track, 9)

	local Knob = Instance.new("Frame")
	Knob.Name = "Knob"
	Knob.AnchorPoint = Vector2.new(0, 0.5)
	Knob.Position = UDim2.new(0, 2, 0.5, 0)
	Knob.Size = UDim2.new(0, 14, 0, 14)
	Knob.BackgroundColor3 = Theme.Text
	Knob.BorderSizePixel = 0
	Knob.Parent = Track
	corner(Knob, 7)

	local function render(animate)
		local info = TweenInfo.new(animate and 0.15 or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		TweenService:Create(Track, info, { BackgroundColor3 = state and Theme.Accent or Theme.Off }):Play()
		TweenService:Create(Knob, info, {
			Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		}):Play()
	end
	render(false)

	local toggle = { Instance = Row }

	function toggle:Set(value, silent)
		state = value and true or false
		render(true)
		if not silent and config.Callback then config.Callback(state) end
	end

	function toggle:Get()
		return state
	end

	Row.MouseButton1Click:Connect(function()
		toggle:Set(not state)
	end)

	return toggle
end

function Section:AddDropdown(config)
	config = config or {}
	self._count += 1

	local options = config.Options or {}
	local multi = config.Multi == true
	local MAX_LIST_HEIGHT = 130
	local OPTION_HEIGHT, OPTION_GAP = 26, 4

	local current = nil -- single mode
	local selected = {} -- multi mode: [value] = true
	local buttons = {} -- [value] = TextButton
	local open = false

	-- container grows downward when open, pushing the elements below it (nothing gets clipped)
	local Container = Instance.new("Frame")
	Container.Name = "Dropdown"
	Container.Size = UDim2.new(1, 0, 0, 32)
	Container.AutomaticSize = Enum.AutomaticSize.Y
	Container.BackgroundTransparency = 1
	Container.BorderSizePixel = 0
	Container.LayoutOrder = self._count
	Container.Parent = self.Holder

	local ContainerLayout = Instance.new("UIListLayout")
	ContainerLayout.Padding = UDim.new(0, 4)
	ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ContainerLayout.Parent = Container

	local Header = Instance.new("TextButton")
	Header.Name = "Header"
	Header.Size = UDim2.new(1, 0, 0, 32)
	Header.BackgroundColor3 = Theme.Element
	Header.BorderSizePixel = 0
	Header.Text = ""
	Header.AutoButtonColor = false
	Header.LayoutOrder = 1
	Header.Parent = Container
	corner(Header, 6)

	local NameLabel = Instance.new("TextLabel")
	NameLabel.Name = "Name"
	NameLabel.Position = UDim2.new(0, 8, 0, 0)
	NameLabel.Size = UDim2.new(0.5, -8, 1, 0)
	NameLabel.BackgroundTransparency = 1
	NameLabel.BorderSizePixel = 0
	NameLabel.Text = config.Name or "Dropdown"
	NameLabel.TextColor3 = Theme.Text
	NameLabel.Font = Enum.Font.Gotham
	NameLabel.TextSize = 14
	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	NameLabel.Parent = Header

	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Name = "Value"
	ValueLabel.Position = UDim2.new(0.5, 0, 0, 0)
	ValueLabel.Size = UDim2.new(0.5, -28, 1, 0)
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.BorderSizePixel = 0
	ValueLabel.Text = "None"
	ValueLabel.TextColor3 = Theme.SubText
	ValueLabel.Font = Enum.Font.Gotham
	ValueLabel.TextSize = 13
	ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
	ValueLabel.TextTruncate = Enum.TextTruncate.AtEnd
	ValueLabel.Parent = Header

	local Arrow = Instance.new("ImageLabel")
	Arrow.Name = "Arrow"
	Arrow.AnchorPoint = Vector2.new(1, 0.5)
	Arrow.Position = UDim2.new(1, -8, 0.5, 0)
	Arrow.Size = UDim2.new(0, 16, 0, 16)
	Arrow.BackgroundTransparency = 1
	Arrow.BorderSizePixel = 0
	Arrow.ImageColor3 = Theme.SubText
	Arrow.ScaleType = Enum.ScaleType.Fit
	Arrow.Parent = Header

	-- text fallback if the icon library isn't available
	local ArrowFallback = Instance.new("TextLabel")
	ArrowFallback.Name = "ArrowFallback"
	ArrowFallback.Size = UDim2.new(1, 0, 1, 0)
	ArrowFallback.BackgroundTransparency = 1
	ArrowFallback.Text = "▼"
	ArrowFallback.TextColor3 = Theme.SubText
	ArrowFallback.Font = Enum.Font.Gotham
	ArrowFallback.TextSize = 9
	ArrowFallback.Visible = false
	ArrowFallback.Parent = Arrow

	local function setArrow(isOpen)
		local ok = applyIcon(Arrow, isOpen and "chevron-up" or "chevron-down", self._icons)
		Arrow.Image = ok and Arrow.Image or ""
		ArrowFallback.Visible = not ok
		ArrowFallback.Text = isOpen and "▲" or "▼"
	end
	setArrow(false)

	local List = Instance.new("ScrollingFrame")
	List.Name = "List"
	List.Size = UDim2.new(1, 0, 0, 0)
	List.BackgroundColor3 = Theme.Sidebar
	List.BorderSizePixel = 0
	List.ScrollBarThickness = 3
	List.ScrollBarImageColor3 = Theme.IconOff
	List.ScrollingDirection = Enum.ScrollingDirection.Y
	List.AutomaticCanvasSize = Enum.AutomaticSize.Y
	List.CanvasSize = UDim2.new(0, 0, 0, 0)
	List.Visible = false
	List.LayoutOrder = 2
	List.Parent = Container
	corner(List, 6)

	-- vertical padding only (UIPadding on a ScrollingFrame doesn't affect scale widths)
	local ListPad = Instance.new("UIPadding")
	ListPad.PaddingTop = UDim.new(0, 4)
	ListPad.PaddingBottom = UDim.new(0, 4)
	ListPad.Parent = List

	local ListLayout = Instance.new("UIListLayout")
	ListLayout.Padding = UDim.new(0, OPTION_GAP)
	ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ListLayout.Parent = List

	local function isSelected(v)
		if multi then return selected[v] == true end
		return current == v
	end

	local function selectedList()
		local out = {}
		for _, o in ipairs(options) do
			if selected[o] then table.insert(out, o) end
		end
		return out
	end

	local function refreshVisuals()
		for v, b in pairs(buttons) do
			local on = isSelected(v)
			b.BackgroundColor3 = on and Theme.Accent or Theme.Element
			b.TextColor3 = on and Theme.IconOn or Theme.SubText
		end
		if multi then
			local names = {}
			for _, o in ipairs(selectedList()) do table.insert(names, tostring(o)) end
			ValueLabel.Text = #names > 0 and table.concat(names, ", ") or "None"
		else
			ValueLabel.Text = current ~= nil and tostring(current) or "None"
		end
	end

	local function setOpen(state)
		open = state
		List.Visible = state
		setArrow(state)
	end

	local dropdown = { Instance = Container }

	local function fire()
		if config.Callback then
			config.Callback(multi and selectedList() or current)
		end
	end

	local function buildOptions()
		for _, b in pairs(buttons) do b:Destroy() end
		buttons = {}

		for i, value in ipairs(options) do
			local Opt = Instance.new("TextButton")
			Opt.Name = "Option"
			Opt.Size = UDim2.new(1, -8, 0, OPTION_HEIGHT)
			Opt.BackgroundColor3 = Theme.Element
			Opt.BorderSizePixel = 0
			Opt.Text = tostring(value)
			Opt.TextColor3 = Theme.SubText
			Opt.Font = Enum.Font.Gotham
			Opt.TextSize = 13
			Opt.TextTruncate = Enum.TextTruncate.AtEnd
			Opt.AutoButtonColor = true
			Opt.LayoutOrder = i
			Opt.Parent = List
			corner(Opt, 5)

			Opt.MouseButton1Click:Connect(function()
				if multi then
					selected[value] = not selected[value] or nil
					refreshVisuals()
					fire()
				else
					current = value
					refreshVisuals()
					setOpen(false)
					fire()
				end
			end)

			buttons[value] = Opt
		end

		local n = #options
		local h = n > 0 and (n * OPTION_HEIGHT + (n - 1) * OPTION_GAP + 8) or 0
		List.Size = UDim2.new(1, 0, 0, math.min(h, MAX_LIST_HEIGHT))
		refreshVisuals()
	end

	-- Single mode: Set("Blue"). Multi mode: Set({"A", "B"}).
	function dropdown:Set(value, silent)
		if multi then
			selected = {}
			for _, v in ipairs(typeof(value) == "table" and value or { value }) do
				selected[v] = true
			end
		else
			current = value
		end
		refreshVisuals()
		if not silent then fire() end
	end

	function dropdown:Get()
		return multi and selectedList() or current
	end

	-- Replace the option list. Keeps selections that still exist when keepSelection is true.
	function dropdown:Refresh(newOptions, keepSelection)
		options = newOptions or {}
		if keepSelection then
			local stillThere = {}
			for _, o in ipairs(options) do stillThere[o] = true end
			if multi then
				for v in pairs(selected) do
					if not stillThere[v] then selected[v] = nil end
				end
			elseif not stillThere[current] then
				current = nil
			end
		else
			selected, current = {}, nil
		end
		buildOptions()
	end

	function dropdown:Open() setOpen(true) end
	function dropdown:Close() setOpen(false) end

	Header.MouseButton1Click:Connect(function()
		setOpen(not open)
	end)

	buildOptions()
	if config.Default ~= nil then
		dropdown:Set(config.Default, true)
	end

	return dropdown
end

return Library
