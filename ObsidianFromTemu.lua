local Library = {}
Library.__index = Library

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Theme = {
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

local SIDEBAR_WIDTH = 50
local CORNER_RADIUS = 8

--// ================= ANIMATION HELPERS =================
local function tween(obj, props, time, style, dir)
	local t = TweenService:Create(
		obj,
		TweenInfo.new(time or 0.15, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
		props
	)
	t:Play()
	return t
end

local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

-- Hover colour + press-scale feedback for a button.
-- `locked` (optional) returns true while the button manages its own colour (e.g. active tab).
local function addFeedback(btn, normal, hover, locked)
	local scale = Instance.new("UIScale")
	scale.Parent = btn

	btn.MouseEnter:Connect(function()
		if not (locked and locked()) then
			tween(btn, { BackgroundColor3 = hover }, 0.12)
		end
	end)
	btn.MouseLeave:Connect(function()
		tween(scale, { Scale = 1 }, 0.12)
		if not (locked and locked()) then
			tween(btn, { BackgroundColor3 = normal }, 0.15)
		end
	end)
	btn.InputBegan:Connect(function(input)
		if isPress(input) then tween(scale, { Scale = 0.96 }, 0.08) end
	end)
	btn.InputEnded:Connect(function(input)
		if isPress(input) then tween(scale, { Scale = 1 }, 0.18, Enum.EasingStyle.Back) end
	end)
end

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
local function applyIcon(imageObj, icon, provider, quiet)
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
		if not quiet then warn("[RobloxUI] icon not recognized:", typeof(icon), icon) end
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
	self._binds = {} -- every registered keybind (one shared input listener dispatches to them)
	self._cleanups = {} -- [component] = function, run on Library:Destroy (drag listeners etc.)
	self._listening = nil -- the keybind currently waiting for a key
	self._toggleKey = config.ToggleKey -- reserved: window show/hide key
	self._connections = {}

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "Interface"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	protectGui(ScreenGui)

	local desiredSize = config.Size or UDim2.new(0, 600, 0, 400)

	-- CanvasGroup lets the whole window fade in/out as one piece
	local Main = Instance.new("CanvasGroup")
	Main.Name = "Main"
	Main.Size = desiredSize
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.BackgroundColor3 = Theme.Main
	Main.BorderSizePixel = 0
	Main.ClipsDescendants = true
	Main.GroupTransparency = 1 -- starts hidden; Show() animates it in
	Main.Parent = ScreenGui
	corner(Main, CORNER_RADIUS)

	local MainScale = Instance.new("UIScale")
	MainScale.Scale = 0.9
	MainScale.Parent = Main

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

	-- resize grip: bottom-right corner, lucide "expand" icon
	if config.Resizable ~= false then
		local minSize = config.MinSize or Vector2.new(380, 260)
		local maxSize = config.MaxSize -- optional Vector2

		local Grip = Instance.new("TextButton")
		Grip.Name = "ResizeGrip"
		Grip.AnchorPoint = Vector2.new(1, 1)
		Grip.Position = UDim2.new(1, -6, 1, -6)
		Grip.Size = UDim2.new(0, 22, 0, 22)
		Grip.BackgroundColor3 = Theme.Main
		Grip.BackgroundTransparency = 0.25
		Grip.BorderSizePixel = 0
		Grip.Text = ""
		Grip.AutoButtonColor = false
		Grip.Parent = Main -- created after Content, so it draws above the pages
		corner(Grip, 6)

		local GripIcon = Instance.new("ImageLabel")
		GripIcon.Name = "Icon"
		GripIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		GripIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
		GripIcon.Size = UDim2.new(0, 14, 0, 14)
		GripIcon.BackgroundTransparency = 1
		GripIcon.BorderSizePixel = 0
		GripIcon.ImageColor3 = Theme.IconOff
		GripIcon.ScaleType = Enum.ScaleType.Fit
		GripIcon.Parent = Grip

		-- text fallback if the icon library isn't available
		local GripFallback = Instance.new("TextLabel")
		GripFallback.Name = "IconFallback"
		GripFallback.Size = UDim2.new(1, 0, 1, 0)
		GripFallback.BackgroundTransparency = 1
		GripFallback.Text = "⤢"
		GripFallback.TextColor3 = Theme.IconOff
		GripFallback.Font = Enum.Font.GothamBold
		GripFallback.TextSize = 14
		GripFallback.Parent = GripIcon
		GripFallback.Visible = not applyIcon(GripIcon, "expand", self.Icons)

		local GripScale = Instance.new("UIScale")
		GripScale.Parent = Grip

		local hovering, resizing, resizeConns = false, false, nil

		local function gripLook()
			local on = hovering or resizing
			local c = on and Theme.IconOn or Theme.IconOff
			tween(GripIcon, { ImageColor3 = c }, 0.15)
			tween(GripFallback, { TextColor3 = c }, 0.15)
			tween(Grip, { BackgroundColor3 = on and Theme.Hover or Theme.Main }, 0.15)
		end

		-- resize listeners only exist while a resize drag is active
		local function stopResize()
			if resizeConns then
				for _, c in ipairs(resizeConns) do c:Disconnect() end
				resizeConns = nil
			end
			if resizing then
				resizing = false
				gripLook()
				tween(GripScale, { Scale = hovering and 1.1 or 1 }, 0.18, Enum.EasingStyle.Back)
			end
		end

		local function startResize(input)
			stopResize()
			resizing = true
			gripLook()
			tween(GripScale, { Scale = 0.9 }, 0.08)

			local s = MainScale.Scale
			local startPos = input.Position
			local startSize = Main.AbsoluteSize / s
			local topLeft = Main.AbsolutePosition

			resizeConns = {
				UserInputService.InputChanged:Connect(function(i)
					if i.UserInputType ~= Enum.UserInputType.MouseMovement and i ~= input then return end
					local delta = i.Position - startPos
					local vp = ScreenGui.AbsoluteSize

					-- keep the window on screen and within Min/MaxSize
					local maxW = math.max(minSize.X, vp.X - topLeft.X - 4)
					local maxH = math.max(minSize.Y, vp.Y - topLeft.Y - 4)
					if maxSize then
						maxW = math.max(minSize.X, math.min(maxW, maxSize.X))
						maxH = math.max(minSize.Y, math.min(maxH, maxSize.Y))
					end
					local w = math.clamp(startSize.X + delta.X / s, minSize.X, maxW)
					local h = math.clamp(startSize.Y + delta.Y / s, minSize.Y, maxH)

					-- Main is centre-anchored; move the centre so the top-left corner stays put
					desiredSize = UDim2.fromOffset(w, h) -- also what fitToScreen() uses from now on
					Main.Size = desiredSize
					Main.Position = UDim2.fromOffset(topLeft.X + w * s / 2, topLeft.Y + h * s / 2)
				end),
				UserInputService.InputEnded:Connect(function(i)
					if i == input or i.UserInputType == Enum.UserInputType.MouseButton1 then
						stopResize()
					end
				end),
			}
		end

		Grip.InputBegan:Connect(function(input)
			if isPress(input) then startResize(input) end
		end)
		Grip.MouseEnter:Connect(function()
			hovering = true
			gripLook()
			if not resizing then tween(GripScale, { Scale = 1.1 }, 0.12) end
		end)
		Grip.MouseLeave:Connect(function()
			hovering = false
			gripLook()
			if not resizing then tween(GripScale, { Scale = 1 }, 0.12) end
		end)

		self._cleanups[Grip] = stopResize
	end

	self.ScreenGui, self.Main, self.Sidebar, self.Content = ScreenGui, Main, Sidebar, Content
	self._scale = MainScale
	self._visible = false

	-- floating watermark (lives in the ScreenGui, NOT inside Main, so it survives Hide())
	if config.Watermark ~= false then
		self:_buildWatermark(config.Title or "RobloxUI")
	end

	-- Single shared keyboard listener: rebinding capture, window ToggleKey and every keybind
	-- go through here, so one key press can never be handled twice or by two systems at once.
	table.insert(self._connections, UserInputService.InputBegan:Connect(function(input, processed)
		local listening = self._listening
		if listening then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				-- ignore typing while a textbox has focus
				if not UserInputService:GetFocusedTextBox() then
					listening:_capture(input.KeyCode)
				end
			elseif isPress(input) and not processed then
				listening:_stopListening() -- clicked outside the UI: cancel rebinding
			end
			return
		end

		if processed or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
		local code = input.KeyCode

		if self._toggleKey and code == self._toggleKey then
			self:Toggle()
			return
		end

		for _, kb in ipairs(table.clone(self._binds)) do
			if kb._key == code and not kb._destroyed then
				kb._onPress()
			end
		end
	end))

	if config.StartHidden then
		Main.Visible = false
		self:_updateWatermark()
	else
		self:Show()
	end

	return self
end

function Library:Destroy()
	for _, c in ipairs(self._connections) do
		c:Disconnect()
	end
	self._connections = {}
	self._destroyed = true
	for _, fn in pairs(self._cleanups) do pcall(fn) end -- drag listeners, keybinds
	self._cleanups = {}
	self._binds = {}
	self._listening = nil
	self.ScreenGui:Destroy()
end

--// ================= SHOW / HIDE =================
local SHOW_TIME, HIDE_TIME = 0.35, 0.2

function Library:_cancelAnim()
	if self._anim then
		for _, t in ipairs(self._anim) do t:Cancel() end
		self._anim = nil
	end
end

function Library:Show()
	if self._destroyed then return end
	self._visible = true
	self:_cancelAnim()
	self.Main.Visible = true
	self._anim = {
		tween(self.Main, { GroupTransparency = 0 }, SHOW_TIME, Enum.EasingStyle.Quint),
		tween(self._scale, { Scale = 1 }, SHOW_TIME, Enum.EasingStyle.Back),
	}
	self:_updateWatermark()
end

function Library:Hide()
	if self._destroyed or not self._visible then return end
	self._visible = false
	self:_cancelAnim()
	-- drop textbox focus so the keyboard isn't captured by a hidden window
	local focused = UserInputService:GetFocusedTextBox()
	if focused and focused:IsDescendantOf(self.Main) then focused:ReleaseFocus() end

	local fade = tween(self.Main, { GroupTransparency = 1 }, HIDE_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local shrink = tween(self._scale, { Scale = 0.92 }, HIDE_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	self._anim = { fade, shrink }
	fade.Completed:Connect(function(state)
		-- only fully hide once the fade finished and nobody re-opened the window meanwhile
		if state == Enum.PlaybackState.Completed and not self._visible and not self._destroyed then
			self.Main.Visible = false
		end
	end)
	self:_updateWatermark()
end

function Library:Toggle()
	if self._visible then self:Hide() else self:Show() end
end

function Library:IsVisible()
	return self._visible == true
end

-- True if `key` is already used by the window ToggleKey or by another keybind.
function Library:_keyTaken(key, except)
	if not key then return false end
	if key == self._toggleKey then return true end
	for _, kb in ipairs(self._binds) do
		if kb ~= except and kb._key == key then return true end
	end
	return false
end

--// ================= NOTIFICATIONS =================
-- Window:Notify({ Title = "Saved", Content = "Config loaded", Duration = 4 })
-- Duration = 0 keeps it until clicked.
-- Cards look like the watermark, slide down from the top, stack under it, and click to dismiss.
local NOTIFY_WIDTH, NOTIFY_MAX = 280, 5

function Library:_getNotifyContainer()
	if self._notifyContainer and self._notifyContainer.Parent then
		return self._notifyContainer
	end

	local vp = self.ScreenGui.AbsoluteSize
	local width = vp.X > 0 and math.min(NOTIFY_WIDTH, vp.X - 20) or NOTIFY_WIDTH

	local C = Instance.new("Frame")
	C.Name = "Notifications"
	C.AnchorPoint = Vector2.new(0.5, 0)
	C.Position = UDim2.new(0.5, 0, 0, self._wm and 48 or 10) -- right under the watermark
	C.Size = UDim2.new(0, width, 0, 0)
	C.AutomaticSize = Enum.AutomaticSize.Y
	C.BackgroundTransparency = 1
	C.BorderSizePixel = 0
	C.Parent = self.ScreenGui

	local Layout = Instance.new("UIListLayout")
	Layout.Padding = UDim.new(0, 6)
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	Layout.Parent = C

	self._notifyContainer = C
	return C
end

function Library:Notify(config)
	if self._destroyed then return end
	if type(config) == "string" then config = { Content = config } end
	config = config or {}

	local duration = tonumber(config.Duration) or 4
	local container = self:_getNotifyContainer()

	self._notifyCount = (self._notifyCount or 0) + 1
	self._notifs = self._notifs or {}
	local dismissed = false

	-- Wrapper reserves the layout space (its height is animated); Card is what slides.
	local Wrapper = Instance.new("Frame")
	Wrapper.Name = "Notification"
	Wrapper.Size = UDim2.new(1, 0, 0, 0)
	Wrapper.BackgroundTransparency = 1
	Wrapper.BorderSizePixel = 0
	Wrapper.LayoutOrder = self._notifyCount
	Wrapper.Parent = container

	local Card = Instance.new("CanvasGroup")
	Card.Name = "Card"
	Card.Size = UDim2.new(1, 0, 0, 0)
	Card.AutomaticSize = Enum.AutomaticSize.Y
	Card.BackgroundColor3 = Theme.Sidebar
	Card.BorderSizePixel = 0
	Card.GroupTransparency = 1 -- invisible until measured and positioned above the screen
	Card.Parent = Wrapper
	corner(Card, 8)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Theme.Element
	Stroke.Thickness = 1
	Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	Stroke.Parent = Card

	local Body = Instance.new("Frame")
	Body.Name = "Body"
	Body.Size = UDim2.new(1, 0, 0, 0)
	Body.AutomaticSize = Enum.AutomaticSize.Y
	Body.BackgroundTransparency = 1
	Body.BorderSizePixel = 0
	Body.Parent = Card

	local BodyPad = Instance.new("UIPadding")
	BodyPad.PaddingTop = UDim.new(0, 8)
	BodyPad.PaddingBottom = UDim.new(0, 8)
	BodyPad.PaddingLeft = UDim.new(0, 12)
	BodyPad.PaddingRight = UDim.new(0, 12)
	BodyPad.Parent = Body

	local BodyMin = Instance.new("UISizeConstraint")
	BodyMin.MinSize = Vector2.new(0, 30) -- same height as the watermark
	BodyMin.Parent = Body

	local Texts = Instance.new("Frame")
	Texts.Name = "Texts"
	Texts.Position = UDim2.new(0, 0, 0, 0)
	Texts.Size = UDim2.new(1, 0, 0, 0)
	Texts.AutomaticSize = Enum.AutomaticSize.Y
	Texts.BackgroundTransparency = 1
	Texts.BorderSizePixel = 0
	Texts.Parent = Body

	local TextsLayout = Instance.new("UIListLayout")
	TextsLayout.Padding = UDim.new(0, 2)
	TextsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TextsLayout.Parent = Texts

	local function textLabel(text, font, size, tint, order)
		local L = Instance.new("TextLabel")
		L.Size = UDim2.new(1, 0, 0, 0)
		L.AutomaticSize = Enum.AutomaticSize.Y
		L.BackgroundTransparency = 1
		L.BorderSizePixel = 0
		L.Text = text
		L.TextColor3 = tint
		L.Font = font
		L.TextSize = size
		L.TextWrapped = true
		L.TextXAlignment = Enum.TextXAlignment.Left
		L.TextYAlignment = Enum.TextYAlignment.Top
		L.LayoutOrder = order
		L.Parent = Texts
		return L
	end

	if config.Title and config.Title ~= "" then
		textLabel(tostring(config.Title), Enum.Font.GothamBold, 13, Theme.Text, 1).Name = "Title"
	end
	if config.Content and config.Content ~= "" then
		textLabel(tostring(config.Content), Enum.Font.Gotham, 12, Theme.SubText, 2).Name = "Content"
	end

	-- countdown bar along the bottom edge
	local Bar = Instance.new("Frame")
	Bar.Name = "Timer"
	Bar.AnchorPoint = Vector2.new(0, 1)
	Bar.Position = UDim2.new(0, 0, 1, 0)
	Bar.Size = UDim2.new(1, 0, 0, 2)
	Bar.BackgroundColor3 = Theme.Accent
	Bar.BorderSizePixel = 0
	Bar.Visible = duration > 0
	Bar.Parent = Card

	-- click anywhere on the card to dismiss
	local Click = Instance.new("TextButton")
	Click.Name = "Click"
	Click.Size = UDim2.new(1, 0, 1, 0)
	Click.BackgroundTransparency = 1
	Click.BorderSizePixel = 0
	Click.Text = ""
	Click.AutoButtonColor = false
	Click.Parent = Card

	local function dismiss()
		if dismissed then return end
		dismissed = true
		local i = table.find(self._notifs, dismiss)
		if i then table.remove(self._notifs, i) end
		if self._destroyed then return end

		local away = tween(Card, {
			Position = UDim2.new(0, 0, 0, -20),
			GroupTransparency = 1,
		}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		away.Completed:Connect(function()
			local collapse = tween(Wrapper, { Size = UDim2.new(1, 0, 0, 0) }, 0.2, Enum.EasingStyle.Quint)
			collapse.Completed:Connect(function()
				Wrapper:Destroy()
			end)
		end)
	end
	Click.MouseButton1Click:Connect(dismiss)

	table.insert(self._notifs, dismiss)
	while #self._notifs > NOTIFY_MAX do
		self._notifs[1]() -- drop the oldest (removes itself from the list)
	end

	-- measure once layout has settled, then slide in from above the screen
	task.spawn(function()
		RunService.Heartbeat:Wait()
		RunService.Heartbeat:Wait()
		local h = Card.AbsoluteSize.Y
		for _ = 1, 10 do
			if h > 0 then break end
			RunService.Heartbeat:Wait()
			h = Card.AbsoluteSize.Y
		end
		if h <= 0 then h = 50 end
		if dismissed or self._destroyed or not Wrapper.Parent then return end

		Card.Position = UDim2.new(0, 0, 0, -(Wrapper.AbsolutePosition.Y + h + 10))
		tween(Wrapper, { Size = UDim2.new(1, 0, 0, h) }, 0.3, Enum.EasingStyle.Quint)
		tween(Card, { Position = UDim2.new(0, 0, 0, 0) }, 0.45, Enum.EasingStyle.Back)
		tween(Card, { GroupTransparency = 0 }, 0.25)

		-- keep the reserved height right if the text reflows later
		Card:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			if not dismissed and Card.AbsoluteSize.Y > 0 then
				Wrapper.Size = UDim2.new(1, 0, 0, Card.AbsoluteSize.Y)
			end
		end)

		if duration > 0 then
			local countdown = tween(Bar, { Size = UDim2.new(0, 0, 0, 2) }, duration, Enum.EasingStyle.Linear)
			countdown.Completed:Connect(function(state)
				if state == Enum.PlaybackState.Completed then dismiss() end
			end)
		end
	end)

	return { Dismiss = dismiss }
end

--// ================= FLOATING WATERMARK =================
function Library:_buildWatermark(title)
	local WM = Instance.new("Frame")
	WM.Name = "Watermark"
	WM.AnchorPoint = Vector2.new(0.5, 0)
	WM.Position = UDim2.new(0.5, 0, 0, -40) -- starts above the screen, slides in below
	WM.Size = UDim2.new(0, 0, 0, 30)
	WM.AutomaticSize = Enum.AutomaticSize.X
	WM.BackgroundColor3 = Theme.Sidebar
	WM.BorderSizePixel = 0
	WM.Parent = self.ScreenGui
	corner(WM, 8)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Theme.Element
	Stroke.Thickness = 1
	Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	Stroke.Parent = WM

	local Pad = Instance.new("UIPadding")
	Pad.PaddingLeft = UDim.new(0, 10)
	Pad.PaddingRight = UDim.new(0, 4)
	Pad.Parent = WM

	local Layout = Instance.new("UIListLayout")
	Layout.FillDirection = Enum.FillDirection.Horizontal
	Layout.VerticalAlignment = Enum.VerticalAlignment.Center
	Layout.Padding = UDim.new(0, 8)
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Parent = WM

	local Label = Instance.new("TextLabel")
	Label.Name = "Title"
	Label.Size = UDim2.new(0, 0, 1, 0)
	Label.AutomaticSize = Enum.AutomaticSize.X
	Label.BackgroundTransparency = 1
	Label.BorderSizePixel = 0
	Label.Text = title
	Label.TextColor3 = Theme.SubText
	Label.Font = Enum.Font.GothamBold
	Label.TextSize = 13
	Label.LayoutOrder = 1
	Label.Parent = WM

	local Button = Instance.new("TextButton")
	Button.Name = "ToggleButton"
	Button.Size = UDim2.new(0, 22, 0, 22)
	Button.BackgroundColor3 = Theme.Element
	Button.BorderSizePixel = 0
	Button.Text = ""
	Button.AutoButtonColor = false
	Button.LayoutOrder = 2
	Button.Parent = WM
	corner(Button, 6)

	local Icon = Instance.new("ImageLabel")
	Icon.Name = "Icon"
	Icon.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
	Icon.Size = UDim2.new(0, 14, 0, 14)
	Icon.BackgroundTransparency = 1
	Icon.BorderSizePixel = 0
	Icon.ImageColor3 = Theme.IconOn
	Icon.ScaleType = Enum.ScaleType.Fit
	Icon.Parent = Button

	-- text fallback if the icon library isn't available
	local Fallback = Instance.new("TextLabel")
	Fallback.Name = "IconFallback"
	Fallback.Size = UDim2.new(1, 0, 1, 0)
	Fallback.BackgroundTransparency = 1
	Fallback.TextColor3 = Theme.IconOn
	Fallback.Font = Enum.Font.GothamBold
	Fallback.TextSize = 12
	Fallback.Visible = false
	Fallback.Parent = Icon

	-- button hover / press feedback
	local BtnScale = Instance.new("UIScale")
	BtnScale.Parent = Button
	Button.MouseEnter:Connect(function() tween(BtnScale, { Scale = 1.1 }, 0.12) end)
	Button.MouseLeave:Connect(function() tween(BtnScale, { Scale = 1 }, 0.12) end)
	Button.InputBegan:Connect(function(input)
		if isPress(input) then tween(BtnScale, { Scale = 0.9 }, 0.08) end
	end)
	Button.InputEnded:Connect(function(input)
		if isPress(input) then tween(BtnScale, { Scale = 1.1 }, 0.15, Enum.EasingStyle.Back) end
	end)
	Button.MouseButton1Click:Connect(function()
		self:Toggle()
	end)

	-- drag the watermark by its title, clamped to the screen
	local dragging, dragStart, startPos = false, nil, nil
	Label.InputBegan:Connect(function(input)
		if isPress(input) then
			dragging = true
			dragStart = input.Position
			startPos = WM.AbsolutePosition + Vector2.new(WM.AbsoluteSize.X / 2, 0)
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	table.insert(self._connections, UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local delta = input.Position - dragStart
		local vp = self.ScreenGui.AbsoluteSize
		local half = WM.AbsoluteSize.X / 2
		local cx = math.clamp(startPos.X + delta.X, half, math.max(vp.X - half, half))
		local cy = math.clamp(startPos.Y + delta.Y, 0, math.max(vp.Y - WM.AbsoluteSize.Y, 0))
		WM.Position = UDim2.fromOffset(cx, cy)
	end))

	self._wm = { Frame = WM, Button = Button, Icon = Icon, Fallback = Fallback }

	-- slide-in entrance
	tween(WM, { Position = UDim2.new(0.5, 0, 0, 10) }, 0.5, Enum.EasingStyle.Back)
end

-- Syncs the watermark button with the window state (accent + eye icon = visible, grey + eye-off = hidden)
function Library:_updateWatermark()
	local wm = self._wm
	if not wm then return end
	local on = self._visible == true

	tween(wm.Button, { BackgroundColor3 = on and Theme.Accent or Theme.Element }, 0.2)

	local ok = applyIcon(wm.Icon, on and "eye" or "eye-off", self.Icons)
	if not ok then wm.Icon.Image = "" end
	wm.Fallback.Visible = not ok
	wm.Fallback.Text = on and "●" or "○"

	-- small cross-fade on the icon swap
	wm.Icon.ImageTransparency = 1
	tween(wm.Icon, { ImageTransparency = 0 }, 0.2)
end

--// ================= TAB =================
local function setTabIconColor(tab, color)
	tween(tab.Icon, { ImageColor3 = color }, 0.2)
	if tab.Fallback then
		tween(tab.Fallback, { TextColor3 = color }, 0.2)
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
		Inner = Inner,
		_icons = self.Icons,
		_lib = self,
		Left = column(1),
		Right = column(2),
		_sectionCount = 0,
	}, Tab)

	table.insert(self.Tabs, tab)
	addFeedback(TabButton, Theme.Card, Theme.Element, function()
		return self.ActiveTab == tab
	end)
	TabButton.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)

	if not self.ActiveTab then self:SelectTab(tab) end
	return tab
end

function Library:SelectTab(tab)
	if self.ActiveTab == tab then return end

	local previous = self.ActiveTab
	self.ActiveTab = tab

	if previous then
		previous.Page.Visible = false
		tween(previous.Button, { BackgroundColor3 = Theme.Card }, 0.2)
		setTabIconColor(previous, Theme.IconOff)
	end

	-- new page slides up into place
	tab.Inner.Position = UDim2.new(0, 0, 0, 14)
	tab.Page.Visible = true
	tween(tab.Inner, { Position = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quint)

	tween(tab.Button, { BackgroundColor3 = Theme.Accent }, 0.2)
	setTabIconColor(tab, Theme.IconOn)
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

	return setmetatable({ Holder = Holder, _count = 0, _icons = self._icons, _lib = self._lib }, Section)
end

--// ================= KEYBIND (shared by Toggle:AddKeybind and Section:AddKeybind) =================
local function resolveKey(key)
	if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then return key end
	if type(key) == "string" then
		local ok, res = pcall(function() return Enum.KeyCode[key] end)
		if ok then return res end
	end
	return nil
end

-- Builds the small key "chip" button and registers it with the library's shared key listener.
--   config.Key          initial Enum.KeyCode (optional)
--   config.CanBeChanged false = fixed key, no rebinding UI (default true)
--   config.Callback     fired with the new Enum.KeyCode, or nil when the binding is cleared
--   onPress             called when the bound key is pressed
local function createKeybind(lib, parent, config, position, onPress)
	config = config or {}
	local canChange = config.CanBeChanged ~= false
	local conns = {}
	local kb = { _key = nil, _onPress = onPress, _isListening = false, _destroyed = false }

	local Chip = Instance.new("TextButton")
	Chip.Name = "Keybind"
	Chip.AnchorPoint = Vector2.new(1, 0.5)
	Chip.Position = position
	Chip.Size = UDim2.new(0, 0, 0, 20)
	Chip.AutomaticSize = Enum.AutomaticSize.X
	Chip.BackgroundColor3 = Theme.Card
	Chip.BorderSizePixel = 0
	Chip.Text = "None"
	Chip.TextColor3 = Theme.SubText
	Chip.Font = Enum.Font.Gotham
	Chip.TextSize = 12
	Chip.TextTruncate = Enum.TextTruncate.AtEnd
	Chip.AutoButtonColor = false
	Chip.Parent = parent
	corner(Chip, 5)
	kb.Instance = Chip

	local ChipPad = Instance.new("UIPadding")
	ChipPad.PaddingLeft = UDim.new(0, 7)
	ChipPad.PaddingRight = UDim.new(0, 7)
	ChipPad.Parent = Chip

	local ChipLimit = Instance.new("UISizeConstraint")
	ChipLimit.MinSize = Vector2.new(30, 20)
	ChipLimit.MaxSize = Vector2.new(96, 20)
	ChipLimit.Parent = Chip

	local function render()
		if kb._isListening then
			Chip.Text = "..."
		else
			Chip.Text = kb._key and kb._key.Name or "None"
		end
	end

	local function flashError()
		Chip.BackgroundColor3 = Theme.Danger
		tween(Chip, { BackgroundColor3 = Theme.Card }, 0.45)
	end

	-- Assign (or clear with nil) the key. Returns false if the key is already in use.
	function kb:Set(key, silent)
		key = resolveKey(key)
		if key and lib:_keyTaken(key, kb) then
			warn("[RobloxUI] key already in use:", key.Name)
			flashError()
			return false
		end
		kb._key = key
		render()
		if not silent and config.Callback then config.Callback(key) end
		return true
	end

	function kb:Get()
		return kb._key
	end

	function kb:_startListening()
		if lib._listening and lib._listening ~= kb then
			lib._listening:_stopListening()
		end
		lib._listening = kb
		kb._isListening = true
		tween(Chip, { BackgroundColor3 = Theme.Accent }, 0.15)
		render()
	end

	function kb:_stopListening()
		if lib._listening == kb then lib._listening = nil end
		kb._isListening = false
		tween(Chip, { BackgroundColor3 = Theme.Card }, 0.15)
		render()
	end

	-- Called by the shared listener while this keybind is waiting for a key.
	-- Escape cancels, Backspace/Delete clears, anything else is assigned.
	function kb:_capture(code)
		if code == Enum.KeyCode.Unknown then return end
		kb:_stopListening()
		if code == Enum.KeyCode.Escape then return end
		if code == Enum.KeyCode.Backspace or code == Enum.KeyCode.Delete then
			kb:Set(nil)
		else
			kb:Set(code)
		end
	end

	function kb:Destroy()
		if kb._destroyed then return end
		kb._destroyed = true
		if lib._listening == kb then lib._listening = nil end
		local i = table.find(lib._binds, kb)
		if i then table.remove(lib._binds, i) end
		lib._cleanups[kb] = nil
		for _, c in ipairs(conns) do c:Disconnect() end
		conns = {}
		Chip:Destroy()
	end

	if canChange then
		addFeedback(Chip, Theme.Card, Theme.Sidebar, function() return kb._isListening end)
		table.insert(conns, Chip.MouseButton1Click:Connect(function()
			if kb._isListening then kb:_stopListening() else kb:_startListening() end
		end))
		-- right-click clears the binding
		table.insert(conns, Chip.MouseButton2Click:Connect(function()
			if kb._isListening then kb:_stopListening() end
			kb:Set(nil)
		end))
	end

	if config.Key ~= nil then
		kb:Set(config.Key, true) -- initial key: no callback
	end
	table.insert(lib._binds, kb)
	lib._cleanups[kb] = function() kb:Destroy() end

	return kb
end

-- Keeps a row's label from running underneath the key chip.
local function fitLabelToKeybind(label, kb, reserve)
	local chip = kb.Instance
	local function fit()
		local w = math.clamp(chip.TextBounds.X + 14, 30, 96)
		label.Size = UDim2.new(1, -(reserve + w + 6), 1, 0)
	end
	fit()
	chip:GetPropertyChangedSignal("TextBounds"):Connect(fit)
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
	Btn.AutoButtonColor = false
	Btn.LayoutOrder = self._count
	Btn.Parent = self.Holder
	corner(Btn, 6)

	local BtnPad = Instance.new("UIPadding")
	BtnPad.PaddingLeft = UDim.new(0, 8)
	BtnPad.PaddingRight = UDim.new(0, 8)
	BtnPad.Parent = Btn

	addFeedback(Btn, Theme.Element, Theme.Hover)

	Btn.MouseButton1Click:Connect(function()
		-- quick accent flash that fades back to the hover colour
		Btn.BackgroundColor3 = Theme.Accent
		tween(Btn, { BackgroundColor3 = Theme.Hover }, 0.3)
		if config.Callback then config.Callback() end
	end)

	return Btn
end

function Section:AddToggle(config)
	config = config or {}
	self._count += 1
	local state = config.Default == true
	local section = self

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
	addFeedback(Row, Theme.Element, Theme.Hover)

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

	-- Chain onto the same toggle: AddToggle({...}):AddKeybind({...})
	-- Pressing the key flips THIS toggle and fires its normal Callback; rebinding only
	-- changes the key, so the toggle and its callback are never recreated or disconnected.
	function toggle:AddKeybind(kbConfig)
		if toggle.Keybind then
			warn("[RobloxUI] this toggle already has a keybind")
			return toggle.Keybind
		end

		local kb = createKeybind(section._lib, Row, kbConfig, UDim2.new(1, -48, 0.5, 0), function()
			toggle:Set(not state)
		end)
		fitLabelToKeybind(Label, kb, 60)

		local baseDestroy = kb.Destroy
		function kb:Destroy()
			baseDestroy(kb)
			toggle.Keybind = nil
			Label.Size = UDim2.new(1, -60, 1, 0)
		end

		toggle.Keybind = kb
		return kb
	end

	function toggle:Destroy()
		if toggle._destroyed then return end
		toggle._destroyed = true
		if toggle.Keybind then toggle.Keybind:Destroy() end
		Row:Destroy()
	end

	return toggle
end

-- Paragraph: static wrapped text block with an optional bold title. Grows to fit its text.
-- Options: Title, Content, RichText (default false)
function Section:AddParagraph(config)
	config = config or {}
	self._count += 1

	local title = config.Title and tostring(config.Title) or ""
	local content = config.Content and tostring(config.Content) or ""

	local Holder = Instance.new("Frame")
	Holder.Name = "Paragraph"
	Holder.Size = UDim2.new(1, 0, 0, 0)
	Holder.AutomaticSize = Enum.AutomaticSize.Y
	Holder.BackgroundColor3 = Theme.Element
	Holder.BorderSizePixel = 0
	Holder.LayoutOrder = self._count
	Holder.Parent = self.Holder
	corner(Holder, 6)

	local Pad = Instance.new("UIPadding")
	Pad.PaddingTop = UDim.new(0, 8)
	Pad.PaddingBottom = UDim.new(0, 8)
	Pad.PaddingLeft = UDim.new(0, 8)
	Pad.PaddingRight = UDim.new(0, 8)
	Pad.Parent = Holder

	local Layout = Instance.new("UIListLayout")
	Layout.Padding = UDim.new(0, 3)
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Parent = Holder

	local function makeLabel(name, font, size, tint, order)
		local L = Instance.new("TextLabel")
		L.Name = name
		L.Size = UDim2.new(1, 0, 0, 0)
		L.AutomaticSize = Enum.AutomaticSize.Y
		L.BackgroundTransparency = 1
		L.BorderSizePixel = 0
		L.TextColor3 = tint
		L.Font = font
		L.TextSize = size
		L.TextWrapped = true
		L.RichText = config.RichText == true
		L.TextXAlignment = Enum.TextXAlignment.Left
		L.TextYAlignment = Enum.TextYAlignment.Top
		L.LayoutOrder = order
		L.Parent = Holder
		return L
	end

	local TitleLabel = makeLabel("Title", Enum.Font.GothamBold, 14, Theme.Text, 1)
	local ContentLabel = makeLabel("Content", Enum.Font.Gotham, 13, Theme.SubText, 2)

	-- hidden labels are skipped by the layout, so an empty title/content leaves no gap
	local function refresh(animate)
		TitleLabel.Text = title
		TitleLabel.Visible = title ~= ""
		ContentLabel.Text = content
		ContentLabel.Visible = content ~= ""
		if animate then
			TitleLabel.TextTransparency = 1
			ContentLabel.TextTransparency = 1
			tween(TitleLabel, { TextTransparency = 0 }, 0.2)
			tween(ContentLabel, { TextTransparency = 0 }, 0.2)
		end
	end
	refresh(false)

	local paragraph = { Instance = Holder }

	function paragraph:SetTitle(text)
		title = text and tostring(text) or ""
		refresh(true)
	end

	function paragraph:SetContent(text)
		content = text and tostring(text) or ""
		refresh(true)
	end

	-- paragraph:Set({ Title = "...", Content = "..." }) updates both at once
	function paragraph:Set(data)
		data = data or {}
		if data.Title ~= nil then title = tostring(data.Title) end
		if data.Content ~= nil then content = tostring(data.Content) end
		refresh(true)
	end

	function paragraph:Get()
		return title, content
	end

	function paragraph:Destroy()
		Holder:Destroy()
	end

	return paragraph
end

-- Textbox. Callback fires when the box loses focus (Enter or click away):
--   Callback(text, enterPressed)            -- string
--   Callback(number, enterPressed)          -- when Numeric = true (invalid input reverts to the last value)
-- Options: Name, Default, Placeholder, ClearTextOnFocus, MaxLength, Numeric, Min, Max
function Section:AddTextbox(config)
	config = config or {}
	self._count += 1

	local numeric = config.Numeric == true
	local maxLength = tonumber(config.MaxLength)
	local hasName = config.Name ~= nil and config.Name ~= ""
	local focused, hovering, filtering = false, false, false

	local function clampNumber(n)
		if config.Min then n = math.max(n, config.Min) end
		if config.Max then n = math.min(n, config.Max) end
		return n
	end

	local value
	if numeric then
		value = tonumber(config.Default)
		if value then value = clampNumber(value) end
	else
		value = tostring(config.Default or "")
	end

	local function toText(v)
		return v == nil and "" or tostring(v)
	end

	-- keeps digits, a single dot and a leading minus
	local function filterNumeric(s)
		local neg = s:sub(1, 1) == "-"
		s = s:gsub("[^%d%.]", "")
		local first = s:find(".", 1, true)
		if first then
			local rest = s:sub(first + 1):gsub("%.", "")
			s = s:sub(1, first) .. rest
		end
		return (neg and "-" or "") .. s
	end

	local Row = Instance.new("Frame")
	Row.Name = "Textbox"
	Row.Size = UDim2.new(1, 0, 0, 32)
	Row.BackgroundColor3 = Theme.Element
	Row.BorderSizePixel = 0
	Row.LayoutOrder = self._count
	Row.Parent = self.Holder
	corner(Row, 6)

	if hasName then
		local Label = Instance.new("TextLabel")
		Label.Name = "Label"
		Label.Position = UDim2.new(0, 8, 0, 0)
		Label.Size = UDim2.new(0.4, -8, 1, 0)
		Label.BackgroundTransparency = 1
		Label.BorderSizePixel = 0
		Label.Text = config.Name
		Label.TextColor3 = Theme.Text
		Label.Font = Enum.Font.Gotham
		Label.TextSize = 14
		Label.TextXAlignment = Enum.TextXAlignment.Left
		Label.TextTruncate = Enum.TextTruncate.AtEnd
		Label.Parent = Row
	end

	local BoxHolder = Instance.new("Frame")
	BoxHolder.Name = "BoxHolder"
	BoxHolder.AnchorPoint = Vector2.new(1, 0.5)
	BoxHolder.Position = UDim2.new(1, -6, 0.5, 0)
	BoxHolder.Size = hasName and UDim2.new(0.6, -10, 0, 22) or UDim2.new(1, -12, 0, 22)
	BoxHolder.BackgroundColor3 = Theme.Card
	BoxHolder.BorderSizePixel = 0
	BoxHolder.Parent = Row
	corner(BoxHolder, 5)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Theme.Accent
	Stroke.Thickness = 1
	Stroke.Transparency = 1 -- fades in while focused
	Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	Stroke.Parent = BoxHolder

	local Box = Instance.new("TextBox")
	Box.Name = "Input"
	Box.Size = UDim2.new(1, 0, 1, 0)
	Box.BackgroundTransparency = 1
	Box.BorderSizePixel = 0
	Box.Text = toText(value)
	Box.PlaceholderText = config.Placeholder or ""
	Box.PlaceholderColor3 = Theme.IconOff
	Box.TextColor3 = Theme.Text
	Box.Font = Enum.Font.Gotham
	Box.TextSize = 13
	Box.TextXAlignment = Enum.TextXAlignment.Left
	Box.ClearTextOnFocus = config.ClearTextOnFocus == true
	Box.ClipsDescendants = true
	Box.Parent = BoxHolder

	local BoxPad = Instance.new("UIPadding")
	BoxPad.PaddingLeft = UDim.new(0, 6)
	BoxPad.PaddingRight = UDim.new(0, 6)
	BoxPad.Parent = Box

	local function look()
		tween(BoxHolder, { BackgroundColor3 = (hovering and not focused) and Theme.Sidebar or Theme.Card }, 0.12)
		tween(Stroke, { Transparency = focused and 0 or 1 }, 0.15)
	end

	-- live filtering (numeric characters / max length)
	Box:GetPropertyChangedSignal("Text"):Connect(function()
		if filtering then return end
		local t = Box.Text
		if numeric then t = filterNumeric(t) end
		if maxLength and #t > maxLength then t = t:sub(1, maxLength) end
		if t ~= Box.Text then
			filtering = true
			Box.Text = t
			filtering = false
		end
	end)

	Box.Focused:Connect(function()
		focused = true
		look()
	end)

	Box.FocusLost:Connect(function(enterPressed)
		focused = false
		look()

		if numeric then
			local n = tonumber(Box.Text)
			if n == nil then
				Box.Text = toText(value) -- invalid / empty: revert
				return
			end
			n = clampNumber(n)
			value = n
			Box.Text = toText(n)
		else
			value = Box.Text
		end
		if config.Callback then config.Callback(value, enterPressed) end
	end)

	BoxHolder.MouseEnter:Connect(function()
		hovering = true
		look()
	end)
	BoxHolder.MouseLeave:Connect(function()
		hovering = false
		look()
	end)

	local textbox = { Instance = Row }

	function textbox:Set(v, silent)
		if numeric then
			local n = tonumber(v)
			if n == nil then return end
			value = clampNumber(n)
		else
			value = tostring(v == nil and "" or v)
			if maxLength then value = value:sub(1, maxLength) end
		end
		Box.Text = toText(value)
		if not silent and config.Callback then config.Callback(value, false) end
	end

	function textbox:Get()
		return value
	end

	function textbox:Focus()
		Box:CaptureFocus()
	end

	function textbox:Destroy()
		if Box:IsFocused() then Box:ReleaseFocus() end
		Row:Destroy()
	end

	return textbox
end

-- Standalone keybind row. Callback(key) fires when the binding changes (key or nil);
-- OnPress() fires when the bound key is pressed.
function Section:AddKeybind(config)
	config = config or {}
	self._count += 1

	local Row = Instance.new("Frame")
	Row.Name = "KeybindRow"
	Row.Size = UDim2.new(1, 0, 0, 32)
	Row.BackgroundColor3 = Theme.Element
	Row.BorderSizePixel = 0
	Row.LayoutOrder = self._count
	Row.Parent = self.Holder
	corner(Row, 6)

	local Label = Instance.new("TextLabel")
	Label.Name = "Label"
	Label.Position = UDim2.new(0, 8, 0, 0)
	Label.Size = UDim2.new(1, -60, 1, 0)
	Label.BackgroundTransparency = 1
	Label.BorderSizePixel = 0
	Label.Text = config.Name or "Keybind"
	Label.TextColor3 = Theme.Text
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextTruncate = Enum.TextTruncate.AtEnd
	Label.Parent = Row

	local kb = createKeybind(self._lib, Row, config, UDim2.new(1, -8, 0.5, 0), function()
		if config.OnPress then config.OnPress() end
	end)
	fitLabelToKeybind(Label, kb, 16)

	kb.Row = Row
	local baseDestroy = kb.Destroy
	function kb:Destroy()
		baseDestroy(kb)
		Row:Destroy()
	end

	return kb
end

function Section:AddSlider(config)
	config = config or {}
	self._count += 1
	local lib = self._lib

	local function decimalsOf(n)
		return #(tostring(n):match("%.(%d+)") or "")
	end

	local min = tonumber(config.Min) or 0
	local max = tonumber(config.Max) or 100
	if max < min then min, max = max, min end
	local increment = tonumber(config.Increment) or 1
	if increment <= 0 then increment = 1 end
	local decimals = math.max(decimalsOf(increment), decimalsOf(min))
	local suffix = config.ValueName -- shown after the number, e.g. "16 Speed"

	-- clamp to [min, max], snap to Increment, strip float noise
	local function snap(v)
		v = math.clamp(v, min, max)
		v = min + math.floor((v - min) / increment + 0.5) * increment
		v = math.clamp(v, min, max)
		local p = 10 ^ decimals
		return math.floor(v * p + 0.5) / p
	end

	local function toAlpha(v)
		return max > min and (v - min) / (max - min) or 0
	end

	local function format(v)
		local s = decimals > 0 and string.format("%." .. decimals .. "f", v) or tostring(v)
		if suffix and suffix ~= "" then s = s .. " " .. tostring(suffix) end
		return s
	end

	local value = snap(tonumber(config.Default) or min)
	local hovering, dragging = false, false
	local dragConns = nil

	local Holder = Instance.new("Frame")
	Holder.Name = "Slider"
	Holder.Size = UDim2.new(1, 0, 0, 46)
	Holder.BackgroundColor3 = Theme.Element
	Holder.BorderSizePixel = 0
	Holder.LayoutOrder = self._count
	Holder.Parent = self.Holder
	corner(Holder, 6)

	local NameLabel = Instance.new("TextLabel")
	NameLabel.Name = "Name"
	NameLabel.Position = UDim2.new(0, 8, 0, 6)
	NameLabel.Size = UDim2.new(0.6, -8, 0, 16)
	NameLabel.BackgroundTransparency = 1
	NameLabel.BorderSizePixel = 0
	NameLabel.Text = config.Name or "Slider"
	NameLabel.TextColor3 = Theme.Text
	NameLabel.Font = Enum.Font.Gotham
	NameLabel.TextSize = 14
	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	NameLabel.Parent = Holder

	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Name = "Value"
	ValueLabel.Position = UDim2.new(0.6, 0, 0, 6)
	ValueLabel.Size = UDim2.new(0.4, -8, 0, 16)
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.BorderSizePixel = 0
	ValueLabel.Text = format(value)
	ValueLabel.TextColor3 = Theme.SubText
	ValueLabel.Font = Enum.Font.GothamBold
	ValueLabel.TextSize = 13
	ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
	ValueLabel.TextTruncate = Enum.TextTruncate.AtEnd
	ValueLabel.Parent = Holder

	-- inset so the knob stays inside the card even at both ends
	local Track = Instance.new("Frame")
	Track.Name = "Track"
	Track.Position = UDim2.new(0, 15, 0, 31)
	Track.Size = UDim2.new(1, -30, 0, 6)
	Track.BackgroundColor3 = Theme.Off
	Track.BorderSizePixel = 0
	Track.Parent = Holder
	corner(Track, 3)

	local Fill = Instance.new("Frame")
	Fill.Name = "Fill"
	Fill.Size = UDim2.new(toAlpha(value), 0, 1, 0)
	Fill.BackgroundColor3 = Theme.Accent
	Fill.BorderSizePixel = 0
	Fill.Parent = Track
	corner(Fill, 3)

	local Knob = Instance.new("Frame")
	Knob.Name = "Knob"
	Knob.AnchorPoint = Vector2.new(0.5, 0.5)
	Knob.Position = UDim2.new(toAlpha(value), 0, 0.5, 0)
	Knob.Size = UDim2.new(0, 14, 0, 14)
	Knob.BackgroundColor3 = Theme.Text
	Knob.BorderSizePixel = 0
	Knob.Parent = Track
	local KnobCorner = Instance.new("UICorner")
	KnobCorner.CornerRadius = UDim.new(1, 0)
	KnobCorner.Parent = Knob

	-- transparent hit area over the whole card (a TextButton, so it also blocks window dragging)
	local Hit = Instance.new("TextButton")
	Hit.Name = "Hit"
	Hit.Size = UDim2.new(1, 0, 1, 0)
	Hit.BackgroundTransparency = 1
	Hit.BorderSizePixel = 0
	Hit.Text = ""
	Hit.AutoButtonColor = false
	Hit.Parent = Holder

	local function look()
		local active = hovering or dragging
		tween(Holder, { BackgroundColor3 = active and Theme.Hover or Theme.Element }, 0.12)
		local size = dragging and 18 or (hovering and 16 or 14)
		tween(Knob, { Size = UDim2.new(0, size, 0, size) }, 0.12, Enum.EasingStyle.Back)
	end

	local function render(duration)
		local a = toAlpha(value)
		tween(Fill, { Size = UDim2.new(a, 0, 1, 0) }, duration)
		tween(Knob, { Position = UDim2.new(a, 0, 0.5, 0) }, duration)
		ValueLabel.Text = format(value)
	end

	local function apply(v, silent, duration)
		v = snap(v)
		local changed = v ~= value
		value = v
		render(duration)
		if changed then
			ValueLabel.TextColor3 = Theme.Text -- brief highlight on change
			tween(ValueLabel, { TextColor3 = Theme.SubText }, 0.3)
			if not silent and config.Callback then config.Callback(value) end
		end
	end

	local function updateFromX(x)
		local w = Track.AbsoluteSize.X
		if w <= 0 then return end
		apply(min + ((x - Track.AbsolutePosition.X) / w) * (max - min), false, 0.08)
	end

	-- drag listeners only exist while a drag is active
	local function stopDrag()
		if dragConns then
			for _, c in ipairs(dragConns) do c:Disconnect() end
			dragConns = nil
		end
		if dragging then
			dragging = false
			look()
		end
	end

	local function startDrag(input)
		stopDrag()
		dragging = true
		look()
		updateFromX(input.Position.X)
		dragConns = {
			UserInputService.InputChanged:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseMovement or i == input then
					updateFromX(i.Position.X)
				end
			end),
			UserInputService.InputEnded:Connect(function(i)
				if i == input or i.UserInputType == Enum.UserInputType.MouseButton1 then
					stopDrag()
				end
			end),
		}
	end

	Hit.InputBegan:Connect(function(input)
		if isPress(input) then startDrag(input) end
	end)
	Hit.MouseEnter:Connect(function()
		hovering = true
		look()
	end)
	Hit.MouseLeave:Connect(function()
		hovering = false
		look()
	end)

	local slider = { Instance = Holder }

	function slider:Set(v, silent)
		apply(tonumber(v) or value, silent, 0.2)
	end

	function slider:Get()
		return value
	end

	function slider:Destroy()
		stopDrag()
		lib._cleanups[slider] = nil
		Holder:Destroy()
	end

	lib._cleanups[slider] = stopDrag -- Library:Destroy() while mid-drag won't leak listeners

	return slider
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
	local listHeight = 0 -- full height of the option list when open
	local listTween = nil

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
	addFeedback(Header, Theme.Element, Theme.Hover)

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
		if not ok then Arrow.Image = "" end
		ArrowFallback.Visible = not ok
		ArrowFallback.Text = isOpen and "▲" or "▼"

		-- small cross-fade when the chevron swaps
		Arrow.ImageTransparency = 1
		ArrowFallback.TextTransparency = 1
		tween(Arrow, { ImageTransparency = 0 }, 0.18)
		tween(ArrowFallback, { TextTransparency = 0 }, 0.18)
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
		if open == state then return end
		open = state
		if listTween then listTween:Cancel() end
		setArrow(state)

		if state then
			-- grow downward
			List.Visible = true
			listTween = tween(List, { Size = UDim2.new(1, 0, 0, listHeight) }, 0.22, Enum.EasingStyle.Quint)
		else
			-- shrink, then hide once finished (unless it was re-opened meanwhile)
			local t = tween(List, { Size = UDim2.new(1, 0, 0, 0) }, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			listTween = t
			t.Completed:Connect(function(playbackState)
				if playbackState == Enum.PlaybackState.Completed and not open then
					List.Visible = false
				end
			end)
		end
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
		listHeight = math.min(h, MAX_LIST_HEIGHT)
		List.Size = UDim2.new(1, 0, 0, open and listHeight or 0)
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
