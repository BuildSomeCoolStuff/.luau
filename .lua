local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local Players           = game:GetService("Players")
local TextService       = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer

--============================================================
-- THEME
--============================================================
local DEFAULT_THEME = {
	-- surfaces: dark plum / charcoal
	Background   = Color3.fromRGB(24, 15, 22),   -- #180F16  window
	Panel        = Color3.fromRGB(33, 23, 32),   -- #211720  title bar, sidebar, popups
	Element      = Color3.fromRGB(43, 29, 40),   -- #2B1D28  component rows
	ElementHi    = Color3.fromRGB(58, 41, 55),   -- inputs, tracks, pills
	ElementHover = Color3.fromRGB(51, 35, 48),   -- row hover
	-- text
	Text         = Color3.fromRGB(245, 238, 247), -- #F5EEF7
	SubText      = Color3.fromRGB(169, 154, 169), -- #A99AA9
	-- borders (always drawn at low opacity)
	Stroke       = Color3.fromRGB(96, 70, 112),
	-- accent gradient (toggle fill, slider fill, window border, markers)
	GradientA    = Color3.fromRGB(113, 56, 245),  -- #7138F5
	GradientB    = Color3.fromRGB(52, 34, 184),   -- #3422B8
	-- status
	Success      = Color3.fromRGB(80, 185, 138),  -- #50B98A
	Warning      = Color3.fromRGB(232, 180, 93),  -- #E8B45D
	Error        = Color3.fromRGB(229, 106, 120), -- #E56A78
	-- metrics
	Radius       = 8,    -- rows, buttons, sections
	RadiusSmall  = 6,    -- inputs, pills, small buttons
	WindowRadius = 12,
	RowHeight    = 38,
	Gap          = 8,    -- spacing between components
	Padding      = 12,   -- page padding
	TitleBarHeight = 44,
	-- typography
	Font         = Enum.Font.Gotham,
	FontSemibold = Enum.Font.GothamSemibold,
	FontBold     = Enum.Font.GothamBold,
	-- quick colours offered by the colour picker
	ColorPresets = {
		Color3.fromRGB(113, 56, 245), Color3.fromRGB(59, 130, 246),
		Color3.fromRGB(56, 189, 248), Color3.fromRGB(80, 185, 138),
		Color3.fromRGB(232, 180, 93), Color3.fromRGB(229, 106, 120),
		Color3.fromRGB(236, 110, 210), Color3.fromRGB(245, 238, 247),
	},
}

-- Presets only list what differs from DEFAULT_THEME.
local ThemePresets = {
	Plum = {},
	Midnight = {
		Background   = Color3.fromRGB(11, 14, 24),
		Panel        = Color3.fromRGB(17, 21, 34),
		Element      = Color3.fromRGB(24, 29, 47),
		ElementHi    = Color3.fromRGB(37, 43, 67),
		ElementHover = Color3.fromRGB(31, 37, 59),
		Text         = Color3.fromRGB(236, 240, 250),
		SubText      = Color3.fromRGB(142, 152, 180),
		Stroke       = Color3.fromRGB(70, 84, 130),
		GradientA    = Color3.fromRGB(88, 130, 255),
		GradientB    = Color3.fromRGB(110, 60, 235),
	},
	Graphite = {
		Background   = Color3.fromRGB(17, 17, 20),
		Panel        = Color3.fromRGB(24, 24, 28),
		Element      = Color3.fromRGB(33, 33, 39),
		ElementHi    = Color3.fromRGB(46, 46, 54),
		ElementHover = Color3.fromRGB(40, 40, 47),
		Text         = Color3.fromRGB(238, 238, 242),
		SubText      = Color3.fromRGB(150, 150, 160),
		Stroke       = Color3.fromRGB(84, 84, 98),
		GradientA    = Color3.fromRGB(124, 92, 255),
		GradientB    = Color3.fromRGB(56, 189, 248),
	},
}

-- The live theme table. Components read it when they are created, so changes
-- apply to anything built afterwards (set the theme before creating a window).
local Theme = {}
for k, v in pairs(DEFAULT_THEME) do
	Theme[k] = v
end

local ThemeAliases = { Accent = "GradientA", AccentB = "GradientB" }

-- Derives a matching darker/bluer second accent when only one is supplied.
local function deriveSecondary(color)
	local h, s, v = color:ToHSV()
	return Color3.fromHSV((h - 0.06) % 1, math.min(s + 0.1, 1), v * 0.7)
end

-- string -> reset to that preset; table -> merge tokens over the current theme.
local function applyTheme(spec)
	if type(spec) == "string" then
		local preset = ThemePresets[spec]
		if not preset then
			return false
		end
		for k in pairs(Theme) do
			Theme[k] = nil
		end
		for k, v in pairs(DEFAULT_THEME) do
			Theme[k] = v
		end
		for k, v in pairs(preset) do
			Theme[k] = v
		end
		return true
	elseif type(spec) == "table" then
		for k, v in pairs(spec) do
			Theme[ThemeAliases[k] or k] = v
		end
		if (spec.Accent or spec.GradientA) and not (spec.AccentB or spec.GradientB) then
			Theme.GradientB = deriveSecondary(Theme.GradientA)
		end
		return true
	end
	return false
end

-- Animation settings (per CreateWindow call).
local Anim = { Enabled = true, Speed = 1 }

--============================================================
-- HELPERS
--============================================================
-- Glass ("Transparent") mode. Set per CreateWindow call; elements built
-- afterwards read it, so it applies to everything created for that window.
local Glass = false
-- tr(x): the transparency to use for a surface in glass mode, 0 (opaque) otherwise.
local function tr(x)
	return Glass and x or 0
end

local function new(class, props, children)
	local inst = Instance.new(class)
	if inst:IsA("GuiObject") then
		-- Roblox defaults every Frame/Button/Label to a 1px border. Left on,
		-- this is exactly what shows up as a stray line along frame edges
		-- (e.g. between the tab sidebar and the page content). Kill it here
		-- once so nothing has to remember to do it per-element.
		inst.BorderSizePixel = 0
	end
	for k, v in pairs(props or {}) do
		inst[k] = v
	end
	for _, child in ipairs(children or {}) do
		child.Parent = inst
	end
	return inst
end

local function corner(parent, radius)
	return new("UICorner", { CornerRadius = UDim.new(0, radius or Theme.Radius), Parent = parent })
end

local function stroke(parent, color, thickness, transparency)
	return new("UIStroke", {
		Color = color or Theme.Stroke,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		Parent = parent,
	})
end

-- Subtle themed hairline border (always low opacity).
local function border(parent, transparency)
	return stroke(parent, Theme.Stroke, 1, transparency or 0.55)
end

-- Standard surface for a component row: rounded corners + hairline border.
-- Returns the stroke so components can react to hover/focus.
local function rowStyle(obj, radius)
	corner(obj, radius or Theme.Radius)
	return border(obj, 0.6)
end

local function gradient(parent, colorA, colorB, rotation)
	return new("UIGradient", {
		Color = ColorSequence.new(colorA or Theme.GradientA, colorB or Theme.GradientB),
		Rotation = rotation or 45,
		Parent = parent,
	})
end

-- Drop shadow. Uses the engine's UIShadow when it exists; otherwise falls
-- back to a soft 9-slice shadow image placed behind the object and kept in
-- sync with it (position, size, visibility). Fallback image asset:
-- rbxassetid://6014261993.
local function shadow(obj, opts)
	opts = opts or {}
	local blur = opts.Blur or 20
	local yOff = opts.OffsetY or 6
	local transparency = opts.Transparency or 0.55

	local ok = pcall(function()
		local sh = Instance.new("UIShadow")
		sh.BlurRadius = UDim.new(0, blur)
		sh.Color = Color3.fromRGB(0, 0, 0)
		sh.Offset = UDim2.fromOffset(0, yOff)
		sh.Transparency = transparency
		sh.Parent = obj
	end)
	if ok then
		return
	end

	local pad = blur + 4
	local img = Instance.new("ImageLabel")
	img.Name = "Shadow"
	img.BackgroundTransparency = 1
	img.BorderSizePixel = 0
	img.Image = "rbxassetid://6014261993"
	img.ImageColor3 = Color3.fromRGB(0, 0, 0)
	img.ImageTransparency = math.clamp(transparency + 0.1, 0, 1)
	img.ScaleType = Enum.ScaleType.Slice
	img.SliceCenter = Rect.new(49, 49, 450, 450)
	img.AnchorPoint = Vector2.new(0.5, 0.5)
	img.ZIndex = obj.ZIndex - 1
	img.Parent = obj.Parent

	local function sync()
		local abs = obj.AbsoluteSize
		local pos, anchor = obj.Position, obj.AnchorPoint
		img.Size = UDim2.fromOffset(abs.X + pad * 2, abs.Y + pad * 2)
		img.Position = UDim2.new(
			pos.X.Scale, pos.X.Offset + (0.5 - anchor.X) * abs.X,
			pos.Y.Scale, pos.Y.Offset + (0.5 - anchor.Y) * abs.Y + yOff
		)
		img.Visible = obj.Visible
	end
	sync()
	obj:GetPropertyChangedSignal("AbsoluteSize"):Connect(sync)
	obj:GetPropertyChangedSignal("Position"):Connect(sync)
	obj:GetPropertyChangedSignal("Visible"):Connect(sync)
	obj.Destroying:Connect(function()
		img:Destroy()
	end)
end

local function tween(obj, props, time, style, dir)
	local duration = Anim.Enabled and (time or 0.22) / math.max(Anim.Speed, 0.05) or 0
	local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
	local tw = TweenService:Create(obj, info, props)
	tw:Play()
	return tw
end

-- Subtle hover highlight for element rows (colour eases in/out).
local function addHover(obj, base, hi)
	base = base or Theme.Element
	hi = hi or Theme.ElementHover or Theme.ElementHi
	obj.MouseEnter:Connect(function()
		tween(obj, { BackgroundColor3 = hi }, 0.15)
	end)
	obj.MouseLeave:Connect(function()
		tween(obj, { BackgroundColor3 = base }, 0.2)
	end)
end

-- Drag `target` by `handle`. The global input listener is registered in
-- `conns` (when given) so it can be disconnected when the window is destroyed.
-- Returns a state table: state.moved is true if the last press travelled
-- far enough to count as a drag (used to ignore the click that follows it).
local function makeDraggable(handle, target, conns, onState)
	local dragging, dragStart, startPos, dragInput
	local state = { moved = false }

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			state.moved = false
			dragStart = input.Position
			startPos = target.Position
			if onState then
				onState(true)
			end
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					if onState then
						onState(false)
					end
				end
			end)
		end
	end)

	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	local conn = UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			if delta.Magnitude > 4 then
				state.moved = true
			end
			target.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
	if conns then
		table.insert(conns, conn)
	end
	return state
end

--============================================================
-- ICONS (https://github.com/Footagesus/Icons)
--============================================================
-- loadstring/game:HttpGetAsync only exist inside an executor environment,
-- not in a plain Studio LocalScript, so this is wrapped in pcall -- if it's
-- unavailable, icons are silently skipped instead of erroring the library.
local IconsV2
do
	local ok, result = pcall(function()
		return loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()
	end)
	if ok then
		IconsV2 = result
	end
end

-- Accepts a lucide name ("house"), an sf-symbols name ("sfsymbols:HouseFill"),
-- or an already-resolved rbxassetid:// / rbxasset:// string.
local function resolveIcon(icon)
	if not icon or icon == "" then
		return nil
	end
	if type(icon) == "string" and icon:match("^rbxasset") then
		return icon
	end
	if IconsV2 then
		local ok, image = pcall(IconsV2.GetIcon, icon)
		if ok and image and image ~= "" then
			return image
		end
	end
	return nil
end

-- Icons the library's own chrome uses (close/minimize buttons, dropdown
-- chevrons). Resolved once at load time rather than per-instance.
local ChromeIcons = {
	Close        = resolveIcon("x"),
	Minimize     = resolveIcon("minus"),
	ChevronRight = resolveIcon("chevron-right"),
	ChevronDown  = resolveIcon("chevron-down"),
}

-- Renders `image` (a resolved icon string) inside `container` as a centered
-- ImageLabel, or falls back to a plain text glyph if the icon pack didn't
-- load. Replaces whatever icon/glyph was there before, so it doubles as an
-- "update" call for things like the dropdown chevron swapping state.
local function setIcon(container, image, fallbackText, size, color)
	for _, child in ipairs(container:GetChildren()) do
		if child:IsA("ImageLabel") or child:IsA("TextLabel") then
			child:Destroy()
		end
	end
	if image then
		new("ImageLabel", {
			Parent = container,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, size, 0, size),
			Image = image,
			ImageColor3 = color,
		})
	else
		new("TextLabel", {
			Parent = container,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Font = Theme.FontBold,
			Text = fallbackText,
			TextColor3 = color,
			TextSize = size,
		})
	end
end

--============================================================
-- LIBRARY
--============================================================
--============================================================
-- ELEMENT FACTORY
--============================================================
-- Builds the Button/Toggle/Slider/Dropdown/Textbox/Keybind/Label
-- creators for a given container. Used both for a tab's own page and,
-- recursively, for the bordered "section" that CreateLabel returns --
-- so section:CreateButton(...) etc. work exactly like Tab:CreateButton(...).
local function buildElementFactory(parent, popupLayer, conns)
	local factory = {}
	conns = conns or {}

	-- global (UserInputService) listeners are tracked so Window:Destroy can
	-- disconnect them; signals on our own instances die with the instance.
	local function bind(signal, fn)
		local c = signal:Connect(fn)
		table.insert(conns, c)
		return c
	end

	----------------------------------------------------------------
	-- LABEL / SECTION
	----------------------------------------------------------------
	-- Renders a titled, bordered group box and returns a nested element
	-- factory scoped to its interior, so you can do:
	--   local section = Tab:CreateLabel("Preferences")
	--   section:CreateButton("Click me", function() ... end)
	function factory:CreateLabel(text, description)
		-- No background fill. The border and padding only appear once
		-- something is added inside; an empty section is just its text.
		local section = new("Frame", {
			Parent = parent,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
		})
		corner(section, Theme.Radius)
		local sectionStroke = stroke(section, Theme.Stroke, 1, 0.6)
		sectionStroke.Enabled = false

		local sectionLayout = new("UIListLayout", {
			Parent = section,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 0),
		})
		local sectionPadding = new("UIPadding", {
			Parent = section,
			PaddingTop = UDim.new(0, 0),
			PaddingBottom = UDim.new(0, 0),
			PaddingLeft = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 0),
		})

		new("TextLabel", {
			Parent = section,
			LayoutOrder = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 18),
			Font = Theme.FontSemibold,
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		-- optional second line under the heading
		if description and description ~= "" then
			new("TextLabel", {
				Parent = section,
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Font = Theme.Font,
				Text = description,
				TextColor3 = Theme.SubText,
				TextSize = 12,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
			})
		end

		-- content lives in its own auto-sizing frame so the section's
		-- own height (title + content + padding) tracks whatever gets
		-- added inside it
		local content = new("Frame", {
			Parent = section,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
		})
		new("UIListLayout", {
			Parent = content,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, Theme.Gap),
		})

		-- switch between "just text" (empty) and "bordered box" (has elements)
		local function refreshSection()
			local hasElements = false
			for _, child in ipairs(content:GetChildren()) do
				if child:IsA("GuiObject") then
					hasElements = true
					break
				end
			end
			sectionStroke.Enabled = hasElements
			sectionLayout.Padding = UDim.new(0, hasElements and 8 or 0)
			local pad = UDim.new(0, hasElements and 10 or 0)
			sectionPadding.PaddingTop = pad
			sectionPadding.PaddingBottom = pad
			sectionPadding.PaddingLeft = pad
			sectionPadding.PaddingRight = pad
		end
		content.ChildAdded:Connect(refreshSection)
		content.ChildRemoved:Connect(refreshSection)
		refreshSection()

		return buildElementFactory(content, popupLayer, conns)
	end

	----------------------------------------------------------------
	function factory:CreateButton(text, callback)
		callback = callback or function() end
		local btn = new("TextButton", {
			Parent = parent,
			BackgroundTransparency = tr(0.55),
			Size = UDim2.new(1, 0, 0, Theme.RowHeight),
			BackgroundColor3 = Theme.Element,
			AutoButtonColor = false,
			Font = Theme.Font,
			Text = "",
		})
		local btnStroke = rowStyle(btn)
		new("TextLabel", {
			Parent = btn,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0, 0),
			Size = UDim2.new(1, -44, 1, 0),
			Font = Theme.Font,
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		-- lucide chevron-right on the right edge; nudges right and brightens on hover
		local chevron = new("Frame", {
			Parent = btn,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			Size = UDim2.new(0, 16, 0, 16),
			BackgroundTransparency = 1,
		})
		setIcon(chevron, ChromeIcons.ChevronRight, ">", 14, Theme.SubText)
		local function chevronObj()
			return chevron:FindFirstChildWhichIsA("ImageLabel") or chevron:FindFirstChildWhichIsA("TextLabel")
		end
		local function chevronColor(color)
			local o = chevronObj()
			if o then
				tween(o, o:IsA("ImageLabel") and { ImageColor3 = color } or { TextColor3 = color }, 0.15)
			end
		end
		btn.MouseEnter:Connect(function()
			tween(chevron, { Position = UDim2.new(1, -8, 0.5, 0) }, 0.2, Enum.EasingStyle.Quart)
			chevronColor(Theme.Text)
		end)
		btn.MouseLeave:Connect(function()
			tween(chevron, { Position = UDim2.new(1, -12, 0.5, 0) }, 0.2, Enum.EasingStyle.Quart)
			chevronColor(Theme.SubText)
		end)

		addHover(btn)
		-- hover: border picks up the accent. pressed: darker surface + slight shrink.
		btn.MouseEnter:Connect(function()
			tween(btnStroke, { Color = Theme.GradientA, Transparency = 0.25 }, 0.15)
		end)
		btn.MouseLeave:Connect(function()
			tween(btnStroke, { Color = Theme.Stroke, Transparency = 0.6 }, 0.2)
		end)
		local pressScale = new("UIScale", { Parent = btn, Scale = 1 })
		btn.MouseButton1Down:Connect(function()
			tween(pressScale, { Scale = 0.97 }, 0.08)
			tween(btn, { BackgroundColor3 = Theme.ElementHi }, 0.06)
		end)
		local function release(restoreBg)
			tween(pressScale, { Scale = 1 }, 0.25, Enum.EasingStyle.Back)
			if restoreBg then
				tween(btn, { BackgroundColor3 = Theme.ElementHover or Theme.Element }, 0.12)
			end
		end
		btn.MouseButton1Up:Connect(function()
			release(true)
		end)
		btn.MouseLeave:Connect(function()
			release(false)
		end)

		btn.MouseButton1Click:Connect(function()
			pcall(callback)
		end)
		return btn
	end

	----------------------------------------------------------------
	function factory:CreateToggle(text, default, callback)
		callback = callback or function() end
		local state = default or false

		local holder = new("Frame", {
			Parent = parent,
			BackgroundTransparency = tr(0.55),
			Size = UDim2.new(1, 0, 0, Theme.RowHeight),
			BackgroundColor3 = Theme.Element,
		})
		rowStyle(holder)
		addHover(holder)

		new("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0, 0),
			Size = UDim2.new(1, -70, 1, 0),
			Font = Theme.Font,
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local KNOB, PAD = 16, 3
		local switch = new("TextButton", {
			Parent = holder,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			Size = UDim2.new(0, 40, 0, 22),
			BackgroundColor3 = Theme.ElementHi,
			AutoButtonColor = false,
			Text = "",
		})
		corner(switch, 100)
		local switchStroke = border(switch, 0.5)

		-- gradient fill layer, crossfaded in when ON
		local fill = new("Frame", {
			Parent = switch,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Theme.GradientA,
			BackgroundTransparency = 1,
		})
		corner(fill, 100)
		gradient(fill, Theme.GradientA, Theme.GradientB, 0)

		local knob = new("Frame", {
			Parent = switch,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, PAD, 0.5, 0),
			Size = UDim2.new(0, KNOB, 0, KNOB),
			BackgroundColor3 = Theme.SubText,
		})
		corner(knob, 100)

		local function render(instant)
			local goal = {
				Position = state and UDim2.new(1, -(KNOB + PAD), 0.5, 0) or UDim2.new(0, PAD, 0.5, 0),
				BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Theme.SubText,
			}
			local fillTransparency = state and 0 or 1
			local strokeTransparency = state and 1 or 0.5
			if instant then
				knob.Position = goal.Position
				knob.BackgroundColor3 = goal.BackgroundColor3
				fill.BackgroundTransparency = fillTransparency
				switchStroke.Transparency = strokeTransparency
			else
				tween(knob, goal, 0.2)
				tween(fill, { BackgroundTransparency = fillTransparency }, 0.2)
				tween(switchStroke, { Transparency = strokeTransparency }, 0.2)
			end
		end
		render(true)

		switch.MouseButton1Click:Connect(function()
			state = not state
			render(false)
			pcall(callback, state)
		end)

		return {
			Set = function(_, v)
				state = v and true or false
				render(false)
				pcall(callback, state)
			end,
			Get = function()
				return state
			end,
		}
	end

	----------------------------------------------------------------
	function factory:CreateSlider(text, min, max, default, callback)
		min, max = min or 0, max or 100
		callback = callback or function() end
		local range = max - min
		local value = math.clamp(default or min, min, max)

		local function relOf(v)
			if range == 0 then
				return 0
			end
			return math.clamp((v - min) / range, 0, 1)
		end

		local holder = new("Frame", {
			Parent = parent,
			BackgroundTransparency = tr(0.55),
			Size = UDim2.new(1, 0, 0, Theme.RowHeight + 8),
			BackgroundColor3 = Theme.Element,
		})
		rowStyle(holder)
		addHover(holder)

		new("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0, 7),
			Size = UDim2.new(1, -70, 0, 16),
			Font = Theme.Font,
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local valueLabel = new("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -12, 0, 7),
			Size = UDim2.new(0, 50, 0, 16),
			Font = Theme.FontSemibold,
			Text = tostring(value),
			TextColor3 = Theme.SubText,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Right,
		})

		local track = new("Frame", {
			Parent = holder,
			Position = UDim2.new(0, 12, 0, 30),
			Size = UDim2.new(1, -24, 0, 6),
			BackgroundColor3 = Theme.ElementHi,
		})
		corner(track, 100)

		local fill = new("Frame", {
			Parent = track,
			Size = UDim2.new(relOf(value), 0, 1, 0),
			BackgroundColor3 = Theme.GradientA,
		})
		corner(fill, 100)
		gradient(fill, Theme.GradientA, Theme.GradientB, 0)

		-- thumb rides the end of the fill
		local thumb = new("Frame", {
			Parent = track,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(relOf(value), 0, 0.5, 0),
			Size = UDim2.new(0, 14, 0, 14),
			BackgroundColor3 = Theme.Text,
			ZIndex = 2,
		})
		corner(thumb, 100)
		stroke(thumb, Theme.GradientA, 2)
		local thumbScale = new("UIScale", { Parent = thumb, Scale = 1 })

		-- generous, invisible hit area (the 6px track alone is hard to hit on touch)
		local hit = new("Frame", {
			Parent = holder,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, 22),
			Size = UDim2.new(1, 0, 1, -22),
		})

		-- single place that keeps label, fill, thumb and value in sync
		local function applyValue(v, animate)
			value = v
			valueLabel.Text = tostring(value)
			local rel = relOf(value)
			if animate then
				tween(fill, { Size = UDim2.new(rel, 0, 1, 0) }, 0.08)
				tween(thumb, { Position = UDim2.new(rel, 0, 0.5, 0) }, 0.08)
			else
				fill.Size = UDim2.new(rel, 0, 1, 0)
				thumb.Position = UDim2.new(rel, 0, 0.5, 0)
			end
		end

		local dragging = false

		local function setDragVisual(on)
			tween(thumbScale, { Scale = on and 1.2 or 1 }, 0.12)
			tween(valueLabel, { TextColor3 = on and Theme.Text or Theme.SubText }, 0.12)
		end

		local function setFromX(x, force)
			local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
			local newValue = math.floor(min + range * rel + 0.5)
			if newValue == value and not force then
				return -- nothing changed; skip redundant tweens/callbacks while dragging
			end
			applyValue(newValue, true)
			pcall(callback, value)
		end

		hit.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				setDragVisual(true)
				setFromX(input.Position.X, true)
			end
		end)
		bind(UserInputService.InputEnded, function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch) then
				dragging = false
				setDragVisual(false)
			end
		end)
		bind(UserInputService.InputChanged, function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch) then
				setFromX(input.Position.X)
			end
		end)

		return {
			Set = function(_, v)
				applyValue(math.clamp(v, min, max), true)
				pcall(callback, value)
			end,
			Get = function()
				return value
			end,
		}
	end

	----------------------------------------------------------------
	function factory:CreateDropdown(text, options, default, callback, multi)
		options = options or {}
		callback = callback or function() end
		local MAX_VISIBLE = 6
		local ROW_H = 30
		local WHITE = Color3.fromRGB(255, 255, 255)
		local open = false
		local optionButtons = {}

		-- selection state: single mode keeps one value, multi keeps a set
		local selected = nil
		local selectedSet = {}
		if multi then
			if type(default) == "table" then
				for _, v in ipairs(default) do
					selectedSet[v] = true
				end
			end
		else
			selected = default
			if selected == nil then
				selected = options[1]
			end
		end

		local function isSelected(opt)
			if multi then
				return selectedSet[opt] == true
			end
			return opt == selected
		end

		-- ordered array of the current multi selection (follows option order)
		local function multiList()
			local out = {}
			for _, opt in ipairs(options) do
				if selectedSet[opt] then
					table.insert(out, opt)
				end
			end
			return out
		end

		local function displayText()
			if multi then
				local list = multiList()
				if #list == 0 then
					return "None"
				end
				local names = {}
				for _, v in ipairs(list) do
					table.insert(names, tostring(v))
				end
				return table.concat(names, ", ")
			end
			return selected ~= nil and tostring(selected) or ""
		end

		local holder = new("Frame", {
			Parent = parent,
			BackgroundTransparency = tr(0.55),
			Size = UDim2.new(1, 0, 0, Theme.RowHeight),
			BackgroundColor3 = Theme.Element,
		})
		rowStyle(holder)
		addHover(holder)

		new("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0, 0),
			Size = UDim2.new(0.4, 0, 1, 0),
			Font = Theme.Font,
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		-- pill-style selector box (value + chevron in their own rounded rect)
		local pill = new("TextButton", {
			Parent = holder,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			Size = UDim2.new(0.45, -6, 0, 26),
			BackgroundColor3 = Theme.ElementHi,
			AutoButtonColor = false,
			Text = "",
		})
		corner(pill, Theme.RadiusSmall)
		local pillStroke = border(pill, 0.3)

		local arrow = new("Frame", {
			Parent = pill,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -8, 0.5, 0),
			Size = UDim2.new(0, 14, 0, 14),
			BackgroundTransparency = 1,
		})
		setIcon(arrow, ChromeIcons.ChevronRight, ">", 12, Theme.SubText)

		local selectedLabel = new("TextLabel", {
			Parent = pill,
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(1, -28, 1, 0),
			BackgroundTransparency = 1,
			Font = Theme.Font,
			Text = displayText(),
			TextColor3 = Theme.Text,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
		})

		-- Scrollable popup on the shared popup layer. A ScrollingFrame (not a
		-- plain Frame) so long lists can be scrolled with the wheel / touch.
		local list = new("ScrollingFrame", {
			Parent = popupLayer,
			BackgroundColor3 = Theme.Panel,
			BackgroundTransparency = tr(0.12),
			Visible = false,
			ZIndex = 50,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Theme.GradientA,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
		})
		corner(list, Theme.Radius)
		shadow(list, { Blur = 14, OffsetY = 4 })
		local listStroke = stroke(list, Theme.Stroke, 1)
		gradient(listStroke, Theme.GradientA, Theme.GradientB, 45)
		new("UIListLayout", {
			Parent = list,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 2),
		})
		new("UIPadding", {
			Parent = list,
			PaddingTop = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 4),
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 6),
		})

		-- sizes/positions the popup under the pill; flips above it when
		-- there isn't enough room below inside the window
		local function layoutList()
			local layerPos = popupLayer.AbsolutePosition
			local layerSize = popupLayer.AbsoluteSize
			local pillPos = pill.AbsolutePosition - layerPos
			local pillH = pill.AbsoluteSize.Y

			local wanted = math.min(#options, MAX_VISIBLE) * (ROW_H + 2) + 8
			local below = layerSize.Y - (pillPos.Y + pillH) - 12
			local above = pillPos.Y - 12
			local height, y
			if wanted <= below or below >= above then
				height = math.max(math.min(wanted, below), 40)
				y = pillPos.Y + pillH + 4
			else
				height = math.max(math.min(wanted, above), 40)
				y = pillPos.Y - height - 4
			end

			list.Position = UDim2.new(0, pillPos.X, 0, y)
			list.Size = UDim2.new(0, pill.AbsoluteSize.X, 0, height)
		end

		local function closeList()
			open = false
			setIcon(arrow, ChromeIcons.ChevronRight, ">", 12, Theme.SubText)
			tween(pillStroke, { Color = Theme.Stroke, Transparency = 0.3 }, 0.15)
			local t = tween(list, { Size = UDim2.new(0, list.Size.X.Offset, 0, 0) }, 0.15)
			t.Completed:Once(function()
				if not open then
					list.Visible = false
				end
			end)
		end

		local function openList()
			open = true
			setIcon(arrow, ChromeIcons.ChevronDown, "v", 12, Theme.SubText)
			tween(pillStroke, { Color = Theme.GradientA, Transparency = 0 }, 0.15)
			layoutList()
			-- grow from zero height to the laid-out size
			local target = list.Size
			list.Size = UDim2.new(target.X.Scale, target.X.Offset, 0, 0)
			list.Visible = true
			tween(list, { Size = target }, 0.2, Enum.EasingStyle.Quart)
		end

		-- selected option: bright semibold text, accent bar and a soft accent
		-- wash; the rest are dim
		local function paintOption(entry, instant)
			local on = isSelected(entry.value)
			local color = on and Theme.Text or Theme.SubText
			entry.label.Font = on and Theme.FontSemibold or Theme.Font
			entry.bar.Visible = on
			entry.rest = on and 0.82 or 1
			entry.button.BackgroundColor3 = on and Theme.GradientA or Theme.ElementHi
			if instant then
				entry.label.TextColor3 = color
				entry.button.BackgroundTransparency = entry.rest
			else
				tween(entry.label, { TextColor3 = color }, 0.15)
				tween(entry.button, { BackgroundTransparency = entry.rest }, 0.15)
			end
		end

		local function paintAll(instant)
			for _, entry in ipairs(optionButtons) do
				paintOption(entry, instant)
			end
			selectedLabel.Text = displayText()
		end

		local function fire()
			if multi then
				pcall(callback, multiList())
			else
				pcall(callback, selected)
			end
		end

		local function addOption(opt)
			local optBtn = new("TextButton", {
				Parent = list,
				Size = UDim2.new(1, 0, 0, ROW_H),
				BackgroundColor3 = Theme.ElementHi,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Text = "",
				ZIndex = 51,
			})
			corner(optBtn, Theme.RadiusSmall)

			local bar = new("Frame", {
				Parent = optBtn,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 3, 0.5, 0),
				Size = UDim2.new(0, 3, 0, 14),
				BackgroundColor3 = WHITE,
				Visible = false,
				ZIndex = 52,
			})
			corner(bar, 2)
			gradient(bar, Theme.GradientA, Theme.GradientB, 90)

			local optLabel = new("TextLabel", {
				Parent = optBtn,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 14, 0, 0),
				Size = UDim2.new(1, -22, 1, 0),
				Font = Theme.Font,
				Text = tostring(opt),
				TextColor3 = Theme.SubText,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = 52,
			})

			local entry = { button = optBtn, label = optLabel, bar = bar, value = opt }
			table.insert(optionButtons, entry)
			paintOption(entry, true)

			optBtn.MouseEnter:Connect(function()
				tween(optBtn, { BackgroundTransparency = entry.rest < 1 and 0.7 or 0.5 }, 0.1)
			end)
			optBtn.MouseLeave:Connect(function()
				tween(optBtn, { BackgroundTransparency = entry.rest }, 0.1)
			end)
			optBtn.MouseButton1Click:Connect(function()
				if multi then
					-- toggle and keep the list open so more can be picked
					selectedSet[opt] = (not selectedSet[opt]) or nil
					paintAll(false)
					fire()
				else
					selected = opt
					paintAll(false)
					fire()
					closeList()
				end
			end)
		end

		for _, opt in ipairs(options) do
			addOption(opt)
		end
		paintAll(true)

		pill.MouseButton1Click:Connect(function()
			if open then
				closeList()
			else
				openList()
			end
		end)

		holder:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
			if open then
				closeList()
			end
		end)

		-- close when clicking outside both the pill and the popup
		bind(UserInputService.InputBegan, function(input)
			if not open then
				return
			end
			if input.UserInputType ~= Enum.UserInputType.MouseButton1
				and input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end
			local pos = input.Position
			local function within(frame)
				local topLeft = frame.AbsolutePosition
				local size = frame.AbsoluteSize
				return pos.X >= topLeft.X and pos.X <= topLeft.X + size.X
					and pos.Y >= topLeft.Y and pos.Y <= topLeft.Y + size.Y
			end
			if not within(pill) and not within(list) then
				closeList()
			end
		end)

		local dropdown = {}

		-- single: Set("Bob")   multi: Set({"Alice", "Bob"})
		function dropdown:Set(v)
			if multi then
				selectedSet = {}
				if type(v) == "table" then
					for _, item in ipairs(v) do
						selectedSet[item] = true
					end
				end
			else
				selected = v
			end
			paintAll(false)
			fire()
		end

		-- single: the value   multi: array of selected values
		function dropdown:Get()
			if multi then
				return multiList()
			end
			return selected
		end

		-- Rebuilds the option list in place. Keeps selections that still
		-- exist; single mode falls back to the first option otherwise.
		function dropdown:Refresh(newOptions)
			options = newOptions or {}

			for _, entry in ipairs(optionButtons) do
				entry.button:Destroy()
			end
			optionButtons = {}

			if multi then
				local valid = {}
				for _, opt in ipairs(options) do
					if selectedSet[opt] then
						valid[opt] = true
					end
				end
				selectedSet = valid
			else
				local stillValid = false
				for _, opt in ipairs(options) do
					if opt == selected then
						stillValid = true
						break
					end
				end
				if not stillValid then
					selected = options[1]
				end
			end

			for _, opt in ipairs(options) do
				addOption(opt)
			end
			paintAll(true)

			if open then
				layoutList()
			end
		end

		return dropdown
	end

	----------------------------------------------------------------
	-- PARAGRAPH
	----------------------------------------------------------------
	-- Info card with an optional title and wrapped body text.
	--   local p = section:CreateParagraph("About", "Long text that wraps...")
	--   p:Set("New title", "New text")  /  p:SetTitle(...)  /  p:SetText(...)
	-- A single argument is treated as body text only.
	function factory:CreateParagraph(title, text)
		if text == nil then
			title, text = nil, title
		end

		local holder = new("Frame", {
			Parent = parent,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Theme.Element,
			BackgroundTransparency = tr(0.55),
		})
		rowStyle(holder)
		new("UIListLayout", {
			Parent = holder,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4),
		})
		new("UIPadding", {
			Parent = holder,
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
		})

		local titleLabel = new("TextLabel", {
			Parent = holder,
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Font = Theme.FontSemibold,
			Text = title or "",
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Visible = title ~= nil and title ~= "",
		})
		local bodyLabel = new("TextLabel", {
			Parent = holder,
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Font = Theme.Font,
			Text = text or "",
			TextColor3 = Theme.SubText,
			TextSize = 12,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
		})

		local paragraph = {}
		function paragraph:SetTitle(t)
			titleLabel.Text = t or ""
			titleLabel.Visible = t ~= nil and t ~= ""
		end
		function paragraph:SetText(t)
			bodyLabel.Text = t or ""
		end
		function paragraph:Set(t, body)
			paragraph:SetTitle(t)
			paragraph:SetText(body)
		end
		return paragraph
	end

	----------------------------------------------------------------
	-- COLOR PICKER
	----------------------------------------------------------------
	-- Row with a colour swatch; clicking it opens a floating picker with a
	-- saturation/value square, a hue bar and a hex box.
	--   local cp = section:CreateColorPicker("Accent", Color3.fromRGB(124, 92, 255), function(color) end)
	--   cp:Set(Color3.new(1, 0, 0))  /  cp:Get()
	function factory:CreateColorPicker(text, default, callback)
		callback = callback or function() end
		local color = default or Color3.fromRGB(255, 255, 255)
		local h, s, v = color:ToHSV()
		local open = false
		local dragMode -- nil | "sv" | "hue"
		local PW, PH = 208, 224

		local holder = new("Frame", {
			Parent = parent,
			Size = UDim2.new(1, 0, 0, Theme.RowHeight),
			BackgroundColor3 = Theme.Element,
			BackgroundTransparency = tr(0.55),
		})
		rowStyle(holder)
		addHover(holder)

		new("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0, 0),
			Size = UDim2.new(1, -150, 1, 0),
			Font = Theme.Font,
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local swatch = new("TextButton", {
			Parent = holder,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			Size = UDim2.new(0, 44, 0, 22),
			BackgroundColor3 = color,
			AutoButtonColor = false,
			Text = "",
		})
		corner(swatch, Theme.RadiusSmall)
		stroke(swatch, Theme.Text, 1, 0.8)

		-- current value, shown next to the swatch
		local hexLabel = new("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -64, 0.5, 0),
			Size = UDim2.new(0, 70, 0, 16),
			Font = Theme.Font,
			Text = "",
			TextColor3 = Theme.SubText,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Right,
		})

		-- floating picker panel
		local panel = new("Frame", {
			Parent = popupLayer,
			Size = UDim2.new(0, PW, 0, PH),
			BackgroundColor3 = Theme.Panel,
			BackgroundTransparency = tr(0.12),
			Visible = false,
			Active = true, -- clicks on the panel shouldn't fall through
			ZIndex = 50,
		})
		corner(panel, Theme.Radius + 2)
		border(panel, 0.2)
		shadow(panel, { Blur = 18, OffsetY = 5 })
		local panelScale = new("UIScale", { Parent = panel, Scale = 1 })

		-- saturation (x) / value (y) square
		local sv = new("Frame", {
			Parent = panel,
			Position = UDim2.new(0, 12, 0, 12),
			Size = UDim2.new(0, PW - 24, 0, 110),
			BackgroundColor3 = Color3.fromHSV(h, 1, 1),
			ClipsDescendants = true,
			ZIndex = 51,
		})
		corner(sv, 6)
		local white = new("Frame", {
			Parent = sv,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			ZIndex = 52,
		})
		new("UIGradient", {
			Parent = white,
			Rotation = 0,
			Transparency = NumberSequence.new(0, 1), -- opaque white at left -> clear at right
		})
		local black = new("Frame", {
			Parent = sv,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			ZIndex = 53,
		})
		new("UIGradient", {
			Parent = black,
			Rotation = 90,
			Transparency = NumberSequence.new(1, 0), -- clear at top -> opaque black at bottom
		})
		local svCursor = new("Frame", {
			Parent = sv,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 12, 0, 12),
			BackgroundTransparency = 1,
			ZIndex = 55,
		})
		corner(svCursor, 6)
		stroke(svCursor, Color3.fromRGB(255, 255, 255), 2)
		local svHit = new("TextButton", {
			Parent = sv,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 56,
		})

		-- hue bar
		local hue = new("Frame", {
			Parent = panel,
			Position = UDim2.new(0, 12, 0, 130),
			Size = UDim2.new(0, PW - 24, 0, 12),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			ZIndex = 51,
		})
		corner(hue, 6)
		new("UIGradient", {
			Parent = hue,
			Rotation = 0,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
				ColorSequenceKeypoint.new(1 / 6, Color3.fromHSV(1 / 6, 1, 1)),
				ColorSequenceKeypoint.new(2 / 6, Color3.fromHSV(2 / 6, 1, 1)),
				ColorSequenceKeypoint.new(3 / 6, Color3.fromHSV(3 / 6, 1, 1)),
				ColorSequenceKeypoint.new(4 / 6, Color3.fromHSV(4 / 6, 1, 1)),
				ColorSequenceKeypoint.new(5 / 6, Color3.fromHSV(5 / 6, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.fromHSV(0, 1, 1)),
			}),
		})
		local hueCursor = new("Frame", {
			Parent = hue,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 6, 1, 6),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			ZIndex = 53,
		})
		corner(hueCursor, 3)
		stroke(hueCursor, Color3.fromRGB(0, 0, 0), 1, 0.5)
		local hueHit = new("TextButton", {
			Parent = hue,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 54,
		})

		-- hex input
		local hexBox = new("TextBox", {
			Parent = panel,
			Position = UDim2.new(0, 12, 0, 154),
			Size = UDim2.new(0, PW - 24, 0, 28),
			BackgroundColor3 = Theme.ElementHi,
			ClearTextOnFocus = false,
			Font = Theme.Font,
			Text = "",
			PlaceholderText = "#RRGGBB",
			TextColor3 = Theme.Text,
			TextSize = 12,
			ZIndex = 51,
		})
		corner(hexBox, Theme.RadiusSmall)
		local hexStroke = border(hexBox, 0.4)
		hexBox.Focused:Connect(function()
			tween(hexStroke, { Color = Theme.GradientA, Transparency = 0 }, 0.15)
		end)
		hexBox.FocusLost:Connect(function()
			tween(hexStroke, { Color = Theme.Stroke, Transparency = 0.4 }, 0.15)
		end)

		local function toHex(c)
			return string.format("#%02X%02X%02X",
				math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
		end

		local function refresh(fire)
			color = Color3.fromHSV(h, s, v)
			swatch.BackgroundColor3 = color
			sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
			svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
			hueCursor.Position = UDim2.new(h, 0, 0.5, 0)
			hexBox.Text = toHex(color)
			hexLabel.Text = toHex(color)
			if fire then
				pcall(callback, color)
			end
		end
		refresh(false)

		-- preset swatches (Theme.ColorPresets, up to 8)
		do
			local presets = Theme.ColorPresets or {}
			local n = math.min(#presets, 8)
			for i = 1, n do
				local preset = presets[i]
				local chip = new("TextButton", {
					Parent = panel,
					Position = UDim2.new(0, 12 + math.floor((i - 1) * (PW - 24 - 18) / math.max(n - 1, 1)), 0, 192),
					Size = UDim2.new(0, 18, 0, 18),
					BackgroundColor3 = preset,
					AutoButtonColor = false,
					Text = "",
					ZIndex = 51,
				})
				corner(chip, 100)
				stroke(chip, Theme.Text, 1, 0.75)
				chip.MouseButton1Click:Connect(function()
					h, s, v = preset:ToHSV()
					refresh(true)
				end)
			end
		end

		local function applyDrag(pos)
			if dragMode == "sv" then
				s = math.clamp((pos.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
				v = 1 - math.clamp((pos.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
			elseif dragMode == "hue" then
				h = math.clamp((pos.X - hue.AbsolutePosition.X) / hue.AbsoluteSize.X, 0, 1)
			else
				return
			end
			refresh(true)
		end

		local function isPointer(input)
			return input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
		end

		svHit.InputBegan:Connect(function(input)
			if isPointer(input) then
				dragMode = "sv"
				applyDrag(input.Position)
			end
		end)
		hueHit.InputBegan:Connect(function(input)
			if isPointer(input) then
				dragMode = "hue"
				applyDrag(input.Position)
			end
		end)
		bind(UserInputService.InputChanged, function(input)
			if dragMode and (input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch) then
				applyDrag(input.Position)
			end
		end)
		bind(UserInputService.InputEnded, function(input)
			if isPointer(input) then
				dragMode = nil
			end
		end)

		hexBox.FocusLost:Connect(function()
			local hex = hexBox.Text:gsub("#", "")
			if #hex == 3 then
				hex = hex:gsub(".", "%0%0") -- "f80" -> "ff8800"
			end
			if hex:match("^%x%x%x%x%x%x$") then
				local r = tonumber(hex:sub(1, 2), 16)
				local g = tonumber(hex:sub(3, 4), 16)
				local b = tonumber(hex:sub(5, 6), 16)
				h, s, v = Color3.fromRGB(r, g, b):ToHSV()
				refresh(true)
			else
				hexBox.Text = toHex(color) -- invalid input: put the real value back
			end
		end)

		-- right-aligned under the swatch; flips above it if there's no room
		local function layoutPanel()
			local layerPos = popupLayer.AbsolutePosition
			local layerSize = popupLayer.AbsoluteSize
			local sp = swatch.AbsolutePosition - layerPos
			local sh = swatch.AbsoluteSize.Y
			local x = math.clamp(sp.X + swatch.AbsoluteSize.X - PW, 8, math.max(8, layerSize.X - PW - 8))
			local y = sp.Y + sh + 4
			if y + PH > layerSize.Y - 8 then
				y = math.max(8, sp.Y - PH - 4)
			end
			panel.Position = UDim2.fromOffset(x, y)
		end

		local function closePanel()
			open = false
			dragMode = nil
			local t = tween(panelScale, { Scale = 0.92 }, 0.12)
			t.Completed:Once(function()
				if not open then
					panel.Visible = false
				end
			end)
		end

		local function openPanel()
			open = true
			layoutPanel()
			panelScale.Scale = 0.92
			panel.Visible = true
			tween(panelScale, { Scale = 1 }, 0.25, Enum.EasingStyle.Back)
		end

		swatch.MouseButton1Click:Connect(function()
			if open then
				closePanel()
			else
				openPanel()
			end
		end)

		-- close when clicking outside, or when the page scrolls the row away
		bind(UserInputService.InputBegan, function(input)
			if not open or not isPointer(input) then
				return
			end
			local pos = input.Position
			local function within(frame)
				local tl, sz = frame.AbsolutePosition, frame.AbsoluteSize
				return pos.X >= tl.X and pos.X <= tl.X + sz.X and pos.Y >= tl.Y and pos.Y <= tl.Y + sz.Y
			end
			if not within(swatch) and not within(panel) then
				closePanel()
			end
		end)
		holder:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
			if open then
				closePanel()
			end
		end)

		local picker = {}
		function picker:Set(c)
			h, s, v = c:ToHSV()
			refresh(true)
		end
		function picker:Get()
			return color
		end
		return picker
	end

	----------------------------------------------------------------
	function factory:CreateTextbox(text, placeholder, callback)
		callback = callback or function() end
		local holder = new("Frame", {
			Parent = parent,
			BackgroundTransparency = tr(0.55),
			Size = UDim2.new(1, 0, 0, Theme.RowHeight),
			BackgroundColor3 = Theme.Element,
		})
		rowStyle(holder)
		addHover(holder)

		new("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0, 0),
			Size = UDim2.new(0.45, 0, 1, 0),
			Font = Theme.Font,
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local box = new("TextBox", {
			Parent = holder,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			Size = UDim2.new(0.45, 0, 0, 26),
			BackgroundColor3 = Theme.ElementHi,
			ClearTextOnFocus = false,
			ClipsDescendants = true,
			PlaceholderText = placeholder or "",
			PlaceholderColor3 = Theme.SubText,
			Font = Theme.Font,
			Text = "",
			TextColor3 = Theme.Text,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		corner(box, Theme.RadiusSmall)
		local boxStroke = border(box, 0.4)
		new("UIPadding", { Parent = box, PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })

		-- focus: border picks up the accent and the field sinks into the row
		box.Focused:Connect(function()
			tween(boxStroke, { Color = Theme.GradientA, Transparency = 0 }, 0.15)
			tween(box, { BackgroundColor3 = Theme.Background }, 0.15)
		end)
		box.FocusLost:Connect(function(enterPressed)
			tween(boxStroke, { Color = Theme.Stroke, Transparency = 0.4 }, 0.15)
			tween(box, { BackgroundColor3 = Theme.ElementHi }, 0.15)
			if enterPressed and #box.Text > 0 then
				pcall(callback, box.Text)
			end
		end)

		return {
			Set = function(_, v)
				box.Text = v
			end,
			Get = function()
				return box.Text
			end,
		}
	end

	----------------------------------------------------------------
	function factory:CreateKeybind(text, defaultKey, callback)
		callback = callback or function() end
		local key = defaultKey or Enum.KeyCode.Unknown
		local binding = false

		local holder = new("Frame", {
			Parent = parent,
			BackgroundTransparency = tr(0.55),
			Size = UDim2.new(1, 0, 0, Theme.RowHeight),
			BackgroundColor3 = Theme.Element,
		})
		rowStyle(holder)
		addHover(holder)

		new("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0, 0),
			Size = UDim2.new(1, -120, 1, 0),
			Font = Theme.Font,
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local function keyName(k)
			return (k == Enum.KeyCode.Unknown) and "None" or k.Name
		end

		local keyBtn = new("TextButton", {
			Parent = holder,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			Size = UDim2.new(0, 96, 0, 26),
			BackgroundColor3 = Theme.ElementHi,
			AutoButtonColor = false,
			Font = Theme.FontSemibold,
			Text = keyName(key),
			TextColor3 = Theme.SubText,
			TextSize = 12,
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		corner(keyBtn, Theme.RadiusSmall)
		local keyStroke = border(keyBtn, 0.4)

		-- idle: key name in dim text. rebinding: accent border + prompt.
		local function paint()
			if binding then
				keyBtn.Text = "Press a key..."
				tween(keyBtn, { TextColor3 = Theme.Text }, 0.12)
				tween(keyStroke, { Color = Theme.GradientA, Transparency = 0 }, 0.12)
			else
				keyBtn.Text = keyName(key)
				tween(keyBtn, { TextColor3 = Theme.SubText }, 0.12)
				tween(keyStroke, { Color = Theme.Stroke, Transparency = 0.4 }, 0.12)
			end
		end

		keyBtn.MouseButton1Click:Connect(function()
			if binding then return end
			binding = true
			paint()
		end)

		bind(UserInputService.InputBegan, function(input, processed)
			if binding then
				if input.UserInputType == Enum.UserInputType.Keyboard then
					-- Escape cancels and keeps the previous binding
					if input.KeyCode ~= Enum.KeyCode.Escape then
						key = input.KeyCode
					end
					binding = false
					paint()
				end
			elseif not processed
				and key ~= Enum.KeyCode.Unknown
				and input.UserInputType == Enum.UserInputType.Keyboard
				and input.KeyCode == key then
				pcall(callback)
			end
		end)

		return {
			Set = function(_, k)
				key = k
				paint()
			end,
			Get = function()
				return key
			end,
		}
	end

	return factory
end

local Library = {}

function Library:CreateWindow(config)
	config = config or {}

	-- optional theming / behaviour (all opt-in; defaults are the Plum theme)
	if config.Theme ~= nil then
		applyTheme(config.Theme)
	end
	if config.Accent then
		Theme.GradientA = config.Accent
		Theme.GradientB = config.AccentB or deriveSecondary(config.Accent)
	elseif config.AccentB then
		Theme.GradientB = config.AccentB
	end
	if config.Radius then
		Theme.Radius = config.Radius
		Theme.RadiusSmall = math.max(2, config.Radius - 2)
	end
	if config.Spacing then
		Theme.Gap = config.Spacing
	end
	Anim.Enabled = config.Animations ~= false
	Anim.Speed = config.AnimationSpeed or 1

	local WR = Theme.WindowRadius
	local TOP_H = Theme.TitleBarHeight

	-- every global (UserInputService) listener is tracked here so that
	-- Window:Destroy can disconnect them all
	local conns = {}
	local function bindWin(signal, fn)
		local c = signal:Connect(fn)
		table.insert(conns, c)
		return c
	end
	local borderTween
	local title       = config.Title or "Menu"
	local size        = config.Size or UDim2.new(0, 520, 0, 340)
	local toggleKey   = config.ToggleKey or Enum.KeyCode.RightControl
	local toggleImage = config.ToggleImage or ""

	-- Transparent = true -> fake frosted / liquid-glass look: translucent
	-- surfaces, a diagonal sheen, a bright rim and a top specular line.
	-- (Roblox UI can't blur what's behind it, so this is layered
	-- translucency, not a real blur.)
	Glass = config.Transparent == true

	-- icon-only sidebar: tabs show just their icon (falling back to a
	-- centered label if a tab has no icon), and the sidebar itself
	-- narrows to match. Can also be changed later via Window:SetSidebarCompacted.
	local sidebarCompacted = config.SidebarCompacted and true or false
	local EXPANDED_SIDEBAR_WIDTH = 130
	local COMPACT_SIDEBAR_WIDTH  = 50
	local function sidebarWidth()
		return sidebarCompacted and COMPACT_SIDEBAR_WIDTH or EXPANDED_SIDEBAR_WIDTH
	end

	local screenGui = new("ScreenGui", {
		Name = "MinimalUI",
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false,
		Parent = LocalPlayer:WaitForChild("PlayerGui"),
	})

	local destroyed = false
	local function cleanup()
		if destroyed then
			return
		end
		destroyed = true
		for _, c in ipairs(conns) do
			pcall(function()
				c:Disconnect()
			end)
		end
		table.clear(conns)
		if borderTween then
			borderTween:Cancel()
		end
	end
	screenGui.Destroying:Connect(cleanup)

	-- responsive: never open larger than the screen, and fall back to the
	-- icon-only sidebar on narrow windows unless the caller chose explicitly
	local viewport = screenGui.AbsoluteSize
	if viewport.X > 0 and viewport.Y > 0 then
		local w, h = size.X, size.Y
		if w.Scale == 0 and w.Offset > viewport.X - 24 then
			w = UDim.new(0, math.max(280, viewport.X - 24))
		end
		if h.Scale == 0 and h.Offset > viewport.Y - 24 then
			h = UDim.new(0, math.max(200, viewport.Y - 24))
		end
		size = UDim2.new(w.Scale, w.Offset, h.Scale, h.Offset)
		if config.SidebarCompacted == nil and w.Scale == 0 and w.Offset < 420 then
			sidebarCompacted = true
		end
	end

	local Main = new("Frame", {
		Name = "Main",
		Parent = screenGui,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Theme.Background,
		BackgroundTransparency = tr(0.3),
		ClipsDescendants = true,
	})
	corner(Main, WR)
	shadow(Main, { Blur = 28, OffsetY = 8, Transparency = 0.5 })
	local mainStroke = stroke(Main, Theme.Stroke, 1, 0.35)
	local mainGradient = gradient(mainStroke, Theme.GradientA, Theme.GradientB, 45)

	-- soft vertical depth on the window surface (colour only, no extra instances)
	new("UIGradient", {
		Parent = Main,
		Rotation = 90,
		Color = ColorSequence.new(
			Theme.Background:Lerp(Color3.new(1, 1, 1), 0.035),
			Theme.Background:Lerp(Color3.new(0, 0, 0), 0.2)
		),
	})

	local sideDivider
	if Glass then
		-- bright glass rim instead of the accent border
		mainStroke.Thickness = 1.5
		mainStroke.Transparency = 0.35
		mainGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Theme.GradientA:Lerp(Color3.new(1, 1, 1), 0.4))

		-- diagonal sheen across the whole pane (created first so it sits behind content)
		local sheen = new("Frame", {
			Name = "Sheen",
			Parent = Main,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		})
		corner(sheen, WR)
		new("UIGradient", {
			Parent = sheen,
			Rotation = 45,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.84),
				NumberSequenceKeypoint.new(0.35, 0.96),
				NumberSequenceKeypoint.new(0.7, 0.975),
				NumberSequenceKeypoint.new(1, 0.9),
			}),
		})

		-- specular highlight along the top edge
		local spec = new("Frame", {
			Name = "Specular",
			Parent = Main,
			Position = UDim2.new(0, 14, 0, 1),
			Size = UDim2.new(1, -28, 0, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		})
		new("UIGradient", {
			Parent = spec,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.5, 0.45),
				NumberSequenceKeypoint.new(1, 1),
			}),
		})

	end

	-- hairline dividers on the header and sidebar seams (both modes)
	local dividerColor = Glass and Color3.fromRGB(255, 255, 255) or Theme.Stroke
	local dividerAlpha = Glass and 0.9 or 0.5
	new("Frame", {
		Name = "HeaderDivider",
		Parent = Main,
		Position = UDim2.new(0, 0, 0, TOP_H),
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = dividerColor,
		BackgroundTransparency = dividerAlpha,
		ZIndex = 2,
	})
	sideDivider = new("Frame", {
		Name = "SidebarDivider",
		Parent = Main,
		Position = UDim2.new(0, sidebarWidth(), 0, TOP_H + 1),
		Size = UDim2.new(0, 1, 1, -(TOP_H + 1)),
		BackgroundColor3 = dividerColor,
		BackgroundTransparency = dividerAlpha,
		ZIndex = 2,
	})

	tween(Main, { Size = size }, 0.5)

	local TopBar = new("Frame", {
		Name = "TopBar",
		Parent = Main,
		BackgroundColor3 = Theme.Panel,
		BackgroundTransparency = Glass and 1 or 0,
		Size = UDim2.new(1, 0, 0, TOP_H),
	})
	corner(TopBar, WR)
	-- square off the bottom of the topbar so it reads as a flat header strip
	new("Frame", {
		Parent = TopBar,
		BackgroundColor3 = Theme.Panel,
		BackgroundTransparency = Glass and 1 or 0,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, -WR),
		Size = UDim2.new(1, 0, 0, WR),
	})

	local accentBar = new("Frame", {
		Parent = TopBar,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 14, 0.5, 0),
		Size = UDim2.new(0, 4, 0, 18),
		BackgroundColor3 = Theme.GradientA,
	})
	corner(accentBar, 100)
	gradient(accentBar, Theme.GradientA, Theme.GradientB, 90)

	new("TextLabel", {
		Parent = TopBar,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 28, 0, 0),
		Size = UDim2.new(1, -96, 1, 0),
		Font = Theme.FontSemibold,
		Text = title,
		TextColor3 = Theme.Text,
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})

	-- title bar buttons: tinted tile that lights up on hover
	local function chromeButton(xOffset, icon, fallback, hoverBg, hoverFg)
		local b = new("TextButton", {
			Parent = TopBar,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, xOffset, 0.5, 0),
			Size = UDim2.new(0, 24, 0, 24),
			BackgroundColor3 = Theme.Element,
			AutoButtonColor = false,
			Text = "",
		})
		corner(b, Theme.RadiusSmall)
		setIcon(b, icon, fallback, 13, Theme.SubText)
		local function paint(bg, fg)
			tween(b, { BackgroundColor3 = bg }, 0.15)
			local o = b:FindFirstChildWhichIsA("ImageLabel") or b:FindFirstChildWhichIsA("TextLabel")
			if o then
				tween(o, o:IsA("ImageLabel") and { ImageColor3 = fg } or { TextColor3 = fg }, 0.15)
			end
		end
		b.MouseEnter:Connect(function()
			paint(hoverBg, hoverFg)
		end)
		b.MouseLeave:Connect(function()
			paint(Theme.Element, Theme.SubText)
		end)
		return b
	end

	local closeBtn = chromeButton(-14, ChromeIcons.Close, "x", Theme.Error, Color3.fromRGB(255, 255, 255))
	local minimizeBtn = chromeButton(-44, ChromeIcons.Minimize, "-", Theme.ElementHi, Theme.Text)

	makeDraggable(TopBar, Main, conns, function(active)
		-- border brightens while the window is being dragged
		tween(mainStroke, { Transparency = active and 0.05 or 0.35 }, 0.15)
	end)

	----------------------------------------------------------------
	-- MINIMIZE
	----------------------------------------------------------------
	-- Floating pill shown in place of the window while minimized.
	-- Corner radius is kept small on purpose so it reads as a
	-- rounded button rather than a circle.
	local minimized = false

	local indicator = new("TextButton", {
		Name = "MinimizedIndicator",
		Parent = screenGui,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 16),
		Size = UDim2.new(0, 44, 0, 44),
		BackgroundColor3 = Theme.Panel,
		AutoButtonColor = false,
		Text = "",
		Visible = false,
		BackgroundTransparency = tr(0.2),
	})
	corner(indicator, 10)
	shadow(indicator, { Blur = 14, OffsetY = 4 })
	local indicatorStroke = stroke(indicator, Theme.Stroke, 1, 0.35)
	gradient(indicatorStroke, Theme.GradientA, Theme.GradientB, 45)

	if toggleImage ~= "" then
		new("ImageLabel", {
			Parent = indicator,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 22, 0, 22),
			Image = toggleImage,
			ImageColor3 = Theme.Text,
		})
	else
		new("TextLabel", {
			Parent = indicator,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Font = Theme.FontBold,
			Text = "=",
			TextColor3 = Theme.Text,
			TextSize = 18,
		})
	end

	local indicatorDrag = makeDraggable(indicator, indicator, conns)

	local indicatorScale = new("UIScale", { Parent = indicator, Scale = 1 })

	local function setMinimized(state)
		minimized = state
		if borderTween then
			if minimized then
				borderTween:Pause()
			else
				borderTween:Play()
			end
		end
		if minimized then
			indicatorScale.Scale = 0
			indicator.Visible = true
			tween(indicatorScale, { Scale = 1 }, 0.35, Enum.EasingStyle.Back)
			local closeTween = tween(Main, { Size = UDim2.new(0, 0, 0, 0) }, 0.3)
			closeTween.Completed:Once(function()
				if minimized then
					Main.Visible = false
				end
			end)
		else
			Main.Visible = true
			indicator.Visible = false
			tween(Main, { Size = size }, 0.35)
		end
	end

	minimizeBtn.MouseButton1Click:Connect(function()
		setMinimized(true)
	end)

	indicator.MouseButton1Click:Connect(function()
		if indicatorDrag.moved then
			return -- this click ended a drag, not a tap
		end
		setMinimized(false)
	end)

	-- Optional ambient border rotation (config.AnimatedBorder = true). It is a
	-- single engine-side looping tween -- no per-frame Lua -- and it pauses
	-- while minimized. Off by default.
	if config.AnimatedBorder and Anim.Enabled then
		mainGradient.Rotation = 45
		borderTween = TweenService:Create(
			mainGradient,
			TweenInfo.new(24, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1),
			{ Rotation = 405 }
		)
		borderTween:Play()
	end

	local TabBar = new("Frame", {
		Name = "TabBar",
		Parent = Main,
		Position = UDim2.new(0, 0, 0, TOP_H),
		Size = UDim2.new(0, sidebarWidth(), 1, -TOP_H),
		BackgroundColor3 = Theme.Panel,
		BackgroundTransparency = Glass and 1 or 0,
	})
	-- Main's UICorner only masks Main's own background -- it doesn't clip
	-- children, so TabBar's square corners were poking through Main's
	-- rounded bottom-left corner. Round TabBar itself to match, then
	-- square the other three corners back off since they're just interior
	-- seams (against the topbar above, and the page area to the right),
	-- not real edges of the window.
	corner(TabBar, WR)
	new("Frame", { -- squares off the top-left/top-right (seam against TopBar)
		Parent = TabBar,
		BackgroundColor3 = Theme.Panel,
		BackgroundTransparency = Glass and 1 or 0,
		Size = UDim2.new(1, 0, 0, WR),
	})
	new("Frame", { -- squares off the bottom-right (seam against PagesHolder)
		Parent = TabBar,
		BackgroundColor3 = Theme.Panel,
		BackgroundTransparency = Glass and 1 or 0,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, 0, 1, 0),
		Size = UDim2.new(0, WR, 0, WR),
	})

	-- tab buttons live in their own layout container so the corner
	-- patches above aren't swept into the UIListLayout ordering
	local TabList = new("Frame", {
		Name = "TabList",
		Parent = TabBar,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
	})
	new("UIListLayout", {
		Parent = TabList,
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	new("UIPadding", {
		Parent = TabList,
		PaddingTop = UDim.new(0, 10),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
	})

	local pagesHolder = new("Frame", {
		Name = "PagesHolder",
		Parent = Main,
		Position = UDim2.new(0, sidebarWidth(), 0, TOP_H),
		Size = UDim2.new(1, -sidebarWidth(), 1, -TOP_H),
		BackgroundTransparency = 1,
	})

	-- Floating layer for popups (currently: dropdown option lists). It's a
	-- later sibling of TabBar/PagesHolder so it draws on top of them, and
	-- being outside the scrolling page means a popup near the bottom of a
	-- long page isn't clipped by the page's own scroll viewport.
	local popupLayer = new("Frame", {
		Name = "PopupLayer",
		Parent = Main,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
	})

	-- show / hide the whole window on the toggle key
	local visible = true
	bindWin(UserInputService.InputBegan, function(input, processed)
		if processed then return end
		if input.KeyCode == toggleKey then
			visible = not visible
			if visible then
				screenGui.Enabled = true
				tween(Main, { Size = size }, 0.4)
			else
				local closeTween = tween(Main, { Size = UDim2.new(0, 0, 0, 0) }, 0.4)
				closeTween.Completed:Once(function()
					screenGui.Enabled = false
				end)
			end
		end
	end)

	local Window = {
		_tabs = {},
		_firstTab = false,
	}

	----------------------------------------------------------------
	-- DIALOG
	----------------------------------------------------------------
	-- Modal confirm box, based on the exported "Leave the match?" design:
	-- left-aligned title + body, a hairline divider, and two equal-width
	-- buttons (grey cancel, red/gradient confirm).
	--
	-- Positional:
	--   Window:Dialog("Reset?", "This can't be undone.", "Reset", function() ... end)
	-- Or a config table:
	--   Window:Dialog({
	--       Title = "Leave the match?", Text = "Your progress will not be saved.",
	--       ConfirmText = "Leave", CancelText = "Cancel",
	--       Danger = true,              -- red confirm button
	--       Dismissable = true,         -- backdrop click / Esc cancels (default true)
	--       OnConfirm = function() end, OnCancel = function() end,
	--   })
	-- Dialogs queue: opening one while another is showing waits its turn.
	local activeDialog
	local dialogQueue = {}

	local function showDialog(cfg)
		local DANGER = Theme.Error
		local closed = false
		local escConn

		local overlay = new("TextButton", {
			Name = "Dialog",
			Parent = Main,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "",
			ZIndex = 100,
		})
		corner(overlay, WR)
		activeDialog = overlay

		-- never wider than the window, so it can't spill off small windows
		local width = math.min(320, math.max(220, Main.AbsoluteSize.X - 40))
		local card = new("Frame", {
			Parent = overlay,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, width, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Theme.Panel,
			BackgroundTransparency = tr(0.15),
			Active = true, -- swallow clicks so the backdrop doesn't see them
		})
		corner(card, 14)
		border(card, 0.25)
		local cardScale = new("UIScale", { Parent = card, Scale = 0.9 })

		shadow(card, { Blur = 24, OffsetY = 6 })

		new("UIListLayout", {
			Parent = card,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 10),
		})
		new("UIPadding", {
			Parent = card,
			PaddingTop = UDim.new(0, 18),
			PaddingBottom = UDim.new(0, 16),
			PaddingLeft = UDim.new(0, 18),
			PaddingRight = UDim.new(0, 18),
		})

		new("TextLabel", {
			Parent = card,
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Font = Theme.FontBold,
			Text = cfg.Title,
			TextColor3 = Theme.Text,
			TextSize = 16,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
		})

		if cfg.Text and cfg.Text ~= "" then
			new("TextLabel", {
				Parent = card,
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y, -- grows with wrapped text, never clips
				Font = Theme.Font,
				Text = cfg.Text,
				TextColor3 = Theme.SubText,
				TextSize = 13,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
			})
		end

		new("Frame", { -- 1px divider
			Parent = card,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = Theme.Stroke,
			BackgroundTransparency = 0.5,
		})

		local row = new("Frame", {
			Parent = card,
			LayoutOrder = 4,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 34),
		})
		new("UIListLayout", {
			Parent = row,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
		})

		local function makeButton(label, order, kind)
			local base = (kind == "cancel") and Theme.Element
				or (kind == "danger") and DANGER
				or Theme.GradientA
			local hover = (kind == "cancel") and Theme.ElementHi
				or (kind == "danger") and Theme.Error:Lerp(Color3.new(1, 1, 1), 0.12)
				or Theme.GradientA
			local b = new("TextButton", {
				Parent = row,
				LayoutOrder = order,
				Size = UDim2.new(0.5, -4, 1, 0), -- two equal halves around the 8px gap
				BackgroundColor3 = base,
				AutoButtonColor = false,
				Font = Theme.FontSemibold,
				Text = label,
				TextColor3 = (kind == "cancel") and Theme.SubText or Color3.fromRGB(255, 255, 255),
				TextSize = 13,
			})
			corner(b, Theme.Radius)
			if kind == "confirm" then
				gradient(b, Theme.GradientA, Theme.GradientB, 0)
			end
			local press = new("UIScale", { Parent = b, Scale = 1 })
			b.MouseEnter:Connect(function()
				tween(b, { BackgroundColor3 = hover }, 0.12)
				if kind == "cancel" then
					tween(b, { TextColor3 = Theme.Text }, 0.12)
				end
			end)
			b.MouseLeave:Connect(function()
				tween(b, { BackgroundColor3 = base }, 0.15)
				if kind == "cancel" then
					tween(b, { TextColor3 = Theme.SubText }, 0.15)
				end
				tween(press, { Scale = 1 }, 0.15)
			end)
			b.MouseButton1Down:Connect(function()
				tween(press, { Scale = 0.96 }, 0.08)
			end)
			b.MouseButton1Up:Connect(function()
				tween(press, { Scale = 1 }, 0.2, Enum.EasingStyle.Back)
			end)
			return b
		end

		local cancelBtn = makeButton(cfg.CancelText or "Cancel", 1, "cancel")
		local confirmBtn = makeButton(cfg.ConfirmText or "OK", 2, cfg.Danger and "danger" or "confirm")

		local function dismiss(callback)
			if closed then
				return -- guards against double-clicks firing the callback twice
			end
			closed = true
			if escConn then
				escConn:Disconnect()
			end
			tween(overlay, { BackgroundTransparency = 1 }, 0.15)
			tween(cardScale, { Scale = 0.92 }, 0.15)
			task.delay(0.16, function()
				overlay:Destroy()
				if activeDialog == overlay then
					activeDialog = nil
				end
				if callback then
					pcall(callback)
				end
				local nextCfg = table.remove(dialogQueue, 1)
				if nextCfg then
					showDialog(nextCfg)
				end
			end)
		end

		cancelBtn.MouseButton1Click:Connect(function()
			dismiss(cfg.OnCancel)
		end)
		confirmBtn.MouseButton1Click:Connect(function()
			dismiss(cfg.OnConfirm)
		end)

		if cfg.Dismissable ~= false then
			overlay.MouseButton1Click:Connect(function()
				dismiss(cfg.OnCancel)
			end)
			escConn = bindWin(UserInputService.InputBegan, function(input)
				if input.KeyCode == Enum.KeyCode.Escape then
					dismiss(cfg.OnCancel)
				end
			end)
		end

		tween(overlay, { BackgroundTransparency = 0.45 }, 0.2)
		tween(cardScale, { Scale = 1 }, 0.3, Enum.EasingStyle.Back)
	end

	function Window:Dialog(dialogTitle, text, confirmText, onConfirm, cancelText)
		local cfg
		if type(dialogTitle) == "table" then
			cfg = dialogTitle
		else
			cfg = {
				Title = dialogTitle,
				Text = text,
				ConfirmText = confirmText,
				CancelText = cancelText,
				OnConfirm = onConfirm,
			}
		end
		cfg.Title = cfg.Title or "Confirm"

		if activeDialog then
			table.insert(dialogQueue, cfg)
		else
			showDialog(cfg)
		end
	end

	----------------------------------------------------------------
	-- POPUP (modal panel that holds elements)
	----------------------------------------------------------------
	-- Returns an element factory, so everything works like on a tab:
	--   local popup = Window:CreatePopup({ Title = "Settings", Size = UDim2.new(0, 300, 0, 260) })
	--   popup:CreateToggle("Enabled", false, function(v) end)
	--   popup:CreateDropdown(...)
	--   popup:Open()  /  popup:Close()  /  popup:Toggle()  /  popup:Destroy()
	function Window:CreatePopup(config)
		if type(config) == "string" then
			config = { Title = config }
		end
		config = config or {}
		local popupTitle = config.Title or "Popup"
		local popupSize = config.Size or UDim2.new(0, 300, 0, 260)
		local isOpen = false

		local overlay = new("TextButton", {
			Name = "Popup",
			Parent = Main,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "",
			Visible = false,
			ZIndex = 90,
		})
		corner(overlay, WR)

		local card = new("Frame", {
			Parent = overlay,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = popupSize,
			BackgroundColor3 = Theme.Panel,
			BackgroundTransparency = tr(0.15),
			Active = true, -- swallow clicks so they don't hit the dim backdrop
			ZIndex = 1,
		})
		corner(card, 10)
		shadow(card, { Blur = 24, OffsetY = 6 })
		local cardStroke = stroke(card, Theme.Stroke, 1)
		gradient(cardStroke, Theme.GradientA, Theme.GradientB, 45)
		local cardScale = new("UIScale", { Parent = card, Scale = 0.9 })

		new("TextLabel", {
			Parent = card,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 16, 0, 0),
			Size = UDim2.new(1, -56, 0, 40),
			Font = Theme.FontSemibold,
			Text = popupTitle,
			TextColor3 = Theme.Text,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local popupClose = new("TextButton", {
			Parent = card,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -10, 0, 9),
			Size = UDim2.new(0, 22, 0, 22),
			BackgroundColor3 = Theme.Element,
			AutoButtonColor = false,
			Text = "",
		})
		corner(popupClose, 6)
		setIcon(popupClose, ChromeIcons.Close, "x", 12, Theme.SubText)
		addHover(popupClose)

		local content = new("ScrollingFrame", {
			Parent = card,
			Position = UDim2.new(0, 0, 0, 40),
			Size = UDim2.new(1, 0, 1, -40),
			BackgroundTransparency = 1,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Theme.GradientA,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
		})
		new("UIListLayout", {
			Parent = content,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
		})
		new("UIPadding", {
			Parent = content,
			PaddingTop = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
		})

		-- transparent layer above the card so dropdown lists can float over it
		local layer = new("Frame", {
			Parent = overlay,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ZIndex = 2,
		})

		local api = buildElementFactory(content, layer, conns)

		function api:Open()
			if isOpen then return end
			isOpen = true
			overlay.Visible = true
			cardScale.Scale = 0.9
			tween(overlay, { BackgroundTransparency = 0.45 }, 0.2)
			tween(cardScale, { Scale = 1 }, 0.3, Enum.EasingStyle.Back)
		end

		function api:Close()
			if not isOpen then return end
			isOpen = false
			tween(overlay, { BackgroundTransparency = 1 }, 0.15)
			local t = tween(cardScale, { Scale = 0.9 }, 0.15)
			t.Completed:Once(function()
				if not isOpen then
					overlay.Visible = false
				end
			end)
		end

		function api:Toggle()
			if isOpen then
				api:Close()
			else
				api:Open()
			end
		end

		function api:Destroy()
			overlay:Destroy()
		end

		popupClose.MouseButton1Click:Connect(function()
			api:Close()
		end)
		overlay.MouseButton1Click:Connect(function()
			api:Close()
		end)

		return api
	end

	-- Removes the window completely (after the close animation).
	function Window:Destroy()
		cleanup() -- drop every global input listener straight away
		local closeTween = tween(Main, { Size = UDim2.new(0, 0, 0, 0) }, 0.35)
		closeTween.Completed:Once(function()
			screenGui:Destroy()
		end)
	end

	closeBtn.MouseButton1Click:Connect(function()
		Window:Dialog({
			Title = "Close window?",
			Text = "This removes the menu completely. You'll need to run the script again to bring it back.",
			ConfirmText = "Close",
			CancelText = "Cancel",
			Danger = true,
			OnConfirm = function()
				Window:Destroy()
			end,
		})
	end)

	----------------------------------------------------------------
	-- MINIMIZE (programmatic)
	----------------------------------------------------------------
	function Window:Minimize(state)
		if state == nil then
			state = not minimized
		end
		setMinimized(state)
	end

	----------------------------------------------------------------
	-- SIDEBAR (compact / icon-only mode)
	----------------------------------------------------------------
	-- Repositions a single tab's icon/label for the current sidebar mode.
	-- Icon present + compact -> icon only, centered. No icon -> label stays,
	-- centered in compact mode since there's nothing else to show.
	local function applyTabLayout(icon, label, compact)
		if icon then
			icon.AnchorPoint = compact and Vector2.new(0.5, 0.5) or Vector2.new(0, 0.5)
			icon.Position = compact and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0, 10, 0.5, 0)
		end
		if label then
			if compact and icon then
				label.Visible = false
			else
				label.Visible = true
				if compact and not icon then
					label.Position = UDim2.new(0, 4, 0, 0)
					label.Size = UDim2.new(1, -8, 1, 0)
					label.TextXAlignment = Enum.TextXAlignment.Center
				else
					local offset = icon and 34 or 12
					label.Position = UDim2.new(0, offset, 0, 0)
					label.Size = UDim2.new(1, -offset - 8, 1, 0)
					label.TextXAlignment = Enum.TextXAlignment.Left
				end
			end
		end
	end

	function Window:SetSidebarCompacted(state)
		sidebarCompacted = state and true or false
		local width = sidebarWidth()
		tween(TabBar, { Size = UDim2.new(0, width, 1, -TOP_H) }, 0.2)
		if sideDivider then
			tween(sideDivider, { Position = UDim2.new(0, width, 0, TOP_H + 1) }, 0.2)
		end
		tween(pagesHolder, {
			Position = UDim2.new(0, width, 0, TOP_H),
			Size = UDim2.new(1, -width, 1, -TOP_H),
		}, 0.2)
		for _, t in pairs(Window._tabs) do
			applyTabLayout(t.icon, t.label, sidebarCompacted)
		end
	end

	----------------------------------------------------------------
	-- NOTIFY
	----------------------------------------------------------------
	local notifyHolder
	local NOTIFY_W = 260
	function Window:Notify(notifTitle, text, duration, kind)
		duration = duration or 4
		text = text or ""

		-- optional 4th argument tints the marker: "success" | "warning" | "error"
		local kindColor
		if kind == "success" then
			kindColor = Theme.Success
		elseif kind == "warning" then
			kindColor = Theme.Warning
		elseif kind == "error" or kind == "danger" then
			kindColor = Theme.Error
		end

		-- one shared bottom-right stack so several notifications don't overlap
		if not notifyHolder or not notifyHolder.Parent then
			notifyHolder = new("Frame", {
				Name = "Notifications",
				Parent = screenGui,
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, -20, 1, -20),
				Size = UDim2.new(0, NOTIFY_W, 1, -40),
				BackgroundTransparency = 1,
			})
			new("UIListLayout", {
				Parent = notifyHolder,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDim.new(0, 8),
			})
		end

		-- size the card to its wrapped text so long messages never clip
		local bodyH = 0
		if text ~= "" then
			local ok, bounds = pcall(function()
				return TextService:GetTextSize(text, 12, Theme.Font, Vector2.new(NOTIFY_W - 38, 1000))
			end)
			bodyH = ok and bounds.Y or 28
		end
		local height = 10 + 18 + (bodyH > 0 and (bodyH + 4) or 0) + 16

		local wrapper = new("Frame", {
			Parent = notifyHolder,
			Size = UDim2.new(1, 0, 0, height),
			BackgroundTransparency = 1,
		})

		local holder = new("Frame", {
			Parent = wrapper,
			Position = UDim2.new(0, NOTIFY_W + 30, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Theme.Panel,
			BackgroundTransparency = tr(0.15),
		})
		corner(holder, Theme.Radius + 2)
		shadow(holder, { Blur = 16, OffsetY = 4 })
		local nStroke = stroke(holder, Theme.Stroke, 1, 0.35)
		gradient(nStroke, Theme.GradientA, Theme.GradientB, 45)

		-- left marker: accent gradient, or a status colour when `kind` is given
		local marker = new("Frame", {
			Parent = holder,
			Position = UDim2.new(0, 10, 0, 10),
			Size = UDim2.new(0, 3, 1, -26),
			BackgroundColor3 = kindColor or Theme.GradientA,
		})
		corner(marker, 100)
		if not kindColor then
			gradient(marker, Theme.GradientA, Theme.GradientB, 90)
		end

		new("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 24, 0, 10),
			Size = UDim2.new(1, -38, 0, 18),
			Font = Theme.FontSemibold,
			Text = notifTitle,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
		})

		if bodyH > 0 then
			new("TextLabel", {
				Parent = holder,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 24, 0, 32),
				Size = UDim2.new(1, -38, 0, bodyH),
				Font = Theme.Font,
				Text = text,
				TextColor3 = Theme.SubText,
				TextSize = 12,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
			})
		end

		-- countdown bar along the bottom edge
		local bar = new("Frame", {
			Parent = holder,
			Position = UDim2.new(0, 10, 1, -6),
			Size = UDim2.new(1, -20, 0, 2),
			BackgroundColor3 = kindColor or Theme.GradientA,
		})
		corner(bar, 1)
		if not kindColor then
			gradient(bar, Theme.GradientA, Theme.GradientB, 0)
		end

		tween(holder, { Position = UDim2.new(0, 0, 0, 0) }, 0.4, Enum.EasingStyle.Back)
		tween(bar, { Size = UDim2.new(0, 0, 0, 2) }, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

		task.delay(duration, function()
			if not wrapper.Parent then
				return -- window was destroyed meanwhile
			end
			local out = tween(holder, { Position = UDim2.new(0, NOTIFY_W + 30, 0, 0) }, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
			out.Completed:Once(function()
				if not wrapper.Parent then
					return
				end
				local collapse = tween(wrapper, { Size = UDim2.new(1, 0, 0, 0) }, 0.15)
				collapse.Completed:Once(function()
					wrapper:Destroy()
				end)
			end)
		end)
	end

	----------------------------------------------------------------
	-- TAB
	----------------------------------------------------------------
	function Window:CreateTab(name, icon)
		local iconImage = resolveIcon(icon)
		local iconSize = 16

		local tabButton = new("TextButton", {
			Parent = TabList,
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Theme.Element,
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "",
		})
		corner(tabButton, Theme.Radius)

		-- active-tab marker: accent gradient bar on the left edge
		local activeBar = new("Frame", {
			Parent = tabButton,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 2, 0.5, 0),
			Size = UDim2.new(0, 3, 0, 16),
			BackgroundColor3 = Theme.GradientA,
			BackgroundTransparency = 1,
		})
		corner(activeBar, 100)
		gradient(activeBar, Theme.GradientA, Theme.GradientB, 90)

		local tabIcon
		if iconImage then
			tabIcon = new("ImageLabel", {
				Parent = tabButton,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, iconSize, 0, iconSize),
				Image = iconImage,
				ImageColor3 = Theme.SubText,
			})
		end

		local tabLabel = new("TextLabel", {
			Parent = tabButton,
			BackgroundTransparency = 1,
			Font = Theme.Font,
			Text = name,
			TextColor3 = Theme.SubText,
			TextSize = 13,
			TextTruncate = Enum.TextTruncate.AtEnd,
		})

		-- lays out icon/label for whichever sidebar mode the window is
		-- currently in (compact = icon only, expanded = icon + label)
		applyTabLayout(tabIcon, tabLabel, sidebarCompacted)

		local page = new("ScrollingFrame", {
			Parent = pagesHolder,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Theme.GradientA,
			ScrollBarImageTransparency = 0.25,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			Visible = false,
		})
		new("UIPadding", {
			Parent = page,
			PaddingTop = UDim.new(0, Theme.Padding),
			PaddingLeft = UDim.new(0, Theme.Padding),
			PaddingRight = UDim.new(0, Theme.Padding),
			PaddingBottom = UDim.new(0, Theme.Padding),
		})
		local layout = new("UIListLayout", {
			Parent = page,
			Padding = UDim.new(0, Theme.Gap),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 24)
		end)

		-- three visual states: idle, hover, active
		local active, hovering = false, false
		local hoverFg = Theme.Text:Lerp(Theme.SubText, 0.35)
		local function paint()
			local bg, fg
			if active then
				bg, fg = tr(0.55), Theme.Text
			elseif hovering then
				bg, fg = 0.8, hoverFg
			else
				bg, fg = 1, Theme.SubText
			end
			tween(tabButton, { BackgroundTransparency = bg }, 0.15)
			tween(tabLabel, { TextColor3 = fg }, 0.15)
			if tabIcon then
				tween(tabIcon, { ImageColor3 = fg }, 0.15)
			end
			tween(activeBar, { BackgroundTransparency = active and 0 or 1 }, 0.15)
		end

		local entry = { button = tabButton, page = page, label = tabLabel, icon = tabIcon }
		function entry.setActive(on)
			active = on
			paint()
		end

		local function selectTab()
			for _, t in pairs(Window._tabs) do
				if t ~= entry then
					t.page.Visible = false
					t.setActive(false)
				end
			end
			page.Position = UDim2.new(0, 0, 0, 12)
			page.Visible = true
			tween(page, { Position = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quart)
			entry.setActive(true)
		end

		tabButton.MouseButton1Click:Connect(selectTab)
		tabButton.MouseEnter:Connect(function()
			hovering = true
			if not active then
				paint()
			end
		end)
		tabButton.MouseLeave:Connect(function()
			hovering = false
			if not active then
				paint()
			end
		end)

		table.insert(Window._tabs, entry)
		if not Window._firstTab then
			Window._firstTab = true
			selectTab()
		end

		local Tab = buildElementFactory(page, popupLayer, conns)
		return Tab
	end

	return Window
end


-- Optional, additive helpers. Existing scripts never need to call these.
Library.Version = "2.0.0"
Library.Theme   = Theme         -- live token table (read, or tweak before creating a window)
Library.Themes  = ThemePresets  -- "Plum", "Midnight", "Graphite"

-- Library:SetTheme("Midnight")  or  Library:SetTheme({ Accent = Color3.fromRGB(...) })
-- Applies to windows/components created afterwards. Returns true on success.
function Library:SetTheme(spec)
    return applyTheme(spec)
end

-- Returns a copy of the current theme tokens.
function Library:GetTheme()
    local copy = {}
    for k, v in pairs(Theme) do
        copy[k] = v
    end
    return copy
end

return Library
