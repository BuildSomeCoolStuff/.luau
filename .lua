local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

--============================================================
-- THEME
--============================================================
local Theme = {
	Background = Color3.fromRGB(18, 18, 22),
	Panel      = Color3.fromRGB(26, 26, 32),
	Element    = Color3.fromRGB(34, 34, 41),
	ElementHi  = Color3.fromRGB(42, 42, 50),
	Text       = Color3.fromRGB(235, 235, 240),
	SubText    = Color3.fromRGB(140, 140, 152),
	Stroke     = Color3.fromRGB(46, 46, 54),
	GradientA  = Color3.fromRGB(124, 92, 255),
	GradientB  = Color3.fromRGB(56, 189, 248),
}

--============================================================
-- HELPERS
--============================================================
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
	return new("UICorner", { CornerRadius = UDim.new(0, radius or 8), Parent = parent })
end

local function stroke(parent, color, thickness, transparency)
	return new("UIStroke", {
		Color = color or Theme.Stroke,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		Parent = parent,
	})
end

local function gradient(parent, colorA, colorB, rotation)
	return new("UIGradient", {
		Color = ColorSequence.new(colorA or Theme.GradientA, colorB or Theme.GradientB),
		Rotation = rotation or 45,
		Parent = parent,
	})
end

local function tween(obj, props, time, style, dir)
	local info = TweenInfo.new(time or 0.22, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
	local tw = TweenService:Create(obj, info, props)
	tw:Play()
	return tw
end

-- Subtle hover highlight for element rows (colour eases in/out).
local HOVER_COLOR = Color3.fromRGB(39, 39, 47)
local function addHover(obj, base, hi)
	base = base or Theme.Element
	hi = hi or HOVER_COLOR
	obj.MouseEnter:Connect(function()
		tween(obj, { BackgroundColor3 = hi }, 0.15)
	end)
	obj.MouseLeave:Connect(function()
		tween(obj, { BackgroundColor3 = base }, 0.2)
	end)
end

local function makeDraggable(handle, target)
	local dragging, dragStart, startPos, dragInput

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = target.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
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

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			target.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
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
			Font = Enum.Font.GothamBold,
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
local function buildElementFactory(parent, popupLayer)
	local factory = {}

	----------------------------------------------------------------
	-- LABEL / SECTION
	----------------------------------------------------------------
	-- Renders a titled, bordered group box and returns a nested element
	-- factory scoped to its interior, so you can do:
	--   local section = Tab:CreateLabel("Preferences")
	--   section:CreateButton("Click me", function() ... end)
	function factory:CreateLabel(text)
		-- No background fill. The border and padding only appear once
		-- something is added inside; an empty section is just its text.
		local section = new("Frame", {
			Parent = parent,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
		})
		corner(section, 8)
		local sectionStroke = stroke(section, Theme.Stroke, 1)
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
			Size = UDim2.new(1, 0, 0, 16),
			Font = Enum.Font.GothamSemibold,
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		-- content lives in its own auto-sizing frame so the section's
		-- own height (title + content + padding) tracks whatever gets
		-- added inside it
		local content = new("Frame", {
			Parent = section,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
		})
		new("UIListLayout", {
			Parent = content,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
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

		return buildElementFactory(content, popupLayer)
	end

	----------------------------------------------------------------
	function factory:CreateButton(text, callback)
		local btn = new("TextButton", {
			Parent = parent,
			Size = UDim2.new(1, 0, 0, 38),
			BackgroundColor3 = Theme.Element,
			AutoButtonColor = false,
			Font = Enum.Font.Gotham,
			Text = "",
		})
		corner(btn, 8)
		new("TextLabel", {
			Parent = btn,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0, 0),
			Size = UDim2.new(1, -24, 1, 0),
			Font = Enum.Font.Gotham,
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		addHover(btn)
		local pressScale = new("UIScale", { Parent = btn, Scale = 1 })
		btn.MouseButton1Down:Connect(function()
			tween(pressScale, { Scale = 0.97 }, 0.08)
		end)
		local function release()
			tween(pressScale, { Scale = 1 }, 0.25, Enum.EasingStyle.Back)
		end
		btn.MouseButton1Up:Connect(release)
		btn.MouseLeave:Connect(release)

		btn.MouseButton1Click:Connect(function()
			pcall(callback)
		end)
		return btn
	end

	----------------------------------------------------------------
	function factory:CreateToggle(text, default, callback)
		local state = default or false

		local holder = new("Frame", {
			Parent = parent,
			Size = UDim2.new(1, 0, 0, 38),
			BackgroundColor3 = Theme.Element,
		})
		corner(holder, 8)
		addHover(holder)

		new("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0, 0),
			Size = UDim2.new(1, -70, 1, 0),
			Font = Enum.Font.Gotham,
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local switch = new("TextButton", {
			Parent = holder,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			Size = UDim2.new(0, 40, 0, 20),
			BackgroundColor3 = Theme.ElementHi,
			AutoButtonColor = false,
			Text = "",
		})
		corner(switch, 10)

		-- gradient fill layer, crossfaded in when ON
		local fill = new("Frame", {
			Parent = switch,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Theme.GradientA,
			BackgroundTransparency = 1,
		})
		corner(fill, 10)
		gradient(fill, Theme.GradientA, Theme.GradientB, 0)

		local knob = new("Frame", {
			Parent = switch,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 2, 0.5, 0),
			Size = UDim2.new(0, 16, 0, 16),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		})
		corner(knob, 8)

		local function render(instant)
			local knobPos = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
			local fillTransparency = state and 0 or 1
			if instant then
				knob.Position = knobPos
				fill.BackgroundTransparency = fillTransparency
			else
				tween(knob, { Position = knobPos }, 0.2)
				tween(fill, { BackgroundTransparency = fillTransparency }, 0.2)
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
				state = v
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
		local value = math.clamp(default or min, min, max)

		local holder = new("Frame", {
			Parent = parent,
			Size = UDim2.new(1, 0, 0, 46),
			BackgroundColor3 = Theme.Element,
		})
		corner(holder, 8)
		addHover(holder)

		new("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0, 6),
			Size = UDim2.new(1, -70, 0, 16),
			Font = Enum.Font.Gotham,
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local valueLabel = new("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -12, 0, 6),
			Size = UDim2.new(0, 50, 0, 16),
			Font = Enum.Font.GothamSemibold,
			Text = tostring(value),
			TextColor3 = Theme.SubText,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Right,
		})

		local track = new("Frame", {
			Parent = holder,
			Position = UDim2.new(0, 12, 0, 28),
			Size = UDim2.new(1, -24, 0, 6),
			BackgroundColor3 = Theme.ElementHi,
		})
		corner(track, 3)

		local fill = new("Frame", {
			Parent = track,
			Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
			BackgroundColor3 = Theme.GradientA,
		})
		corner(fill, 3)
		gradient(fill, Theme.GradientA, Theme.GradientB, 0)

		local dragging = false

		local function setFromX(x)
			local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			value = math.floor(min + (max - min) * rel + 0.5)
			valueLabel.Text = tostring(value)
			tween(fill, { Size = UDim2.new(rel, 0, 1, 0) }, 0.08)
			pcall(callback, value)
		end

		track.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				setFromX(input.Position.X)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch) then
				setFromX(input.Position.X)
			end
		end)

		return {
			Set = function(_, v)
				value = math.clamp(v, min, max)
				local rel = (value - min) / (max - min)
				valueLabel.Text = tostring(value)
				tween(fill, { Size = UDim2.new(rel, 0, 1, 0) }, 0.15)
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
			Size = UDim2.new(1, 0, 0, 38),
			BackgroundColor3 = Theme.Element,
		})
		corner(holder, 8)
		addHover(holder)

		new("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0, 0),
			Size = UDim2.new(0.4, 0, 1, 0),
			Font = Enum.Font.Gotham,
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
		corner(pill, 6)
		stroke(pill, Theme.Stroke, 1)

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
			Font = Enum.Font.Gotham,
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
			BackgroundColor3 = Theme.Element,
			Visible = false,
			ZIndex = 50,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Theme.GradientA,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
		})
		corner(list, 8)
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
			layoutList()
			-- grow from zero height to the laid-out size
			local target = list.Size
			list.Size = UDim2.new(target.X.Scale, target.X.Offset, 0, 0)
			list.Visible = true
			tween(list, { Size = target }, 0.2, Enum.EasingStyle.Quart)
		end

		-- selected option glows white (bold + accent bar), others are dim
		local function paintOption(entry, instant)
			local on = isSelected(entry.value)
			local color = on and WHITE or Theme.SubText
			local font = on and Enum.Font.GothamBold or Enum.Font.Gotham
			entry.label.Font = font
			entry.bar.Visible = on
			if instant then
				entry.label.TextColor3 = color
			else
				tween(entry.label, { TextColor3 = color }, 0.15)
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
			corner(optBtn, 6)

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
				Font = Enum.Font.Gotham,
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
				tween(optBtn, { BackgroundTransparency = 0.85 }, 0.1)
			end)
			optBtn.MouseLeave:Connect(function()
				tween(optBtn, { BackgroundTransparency = 1 }, 0.1)
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

		-- close when clicking outside both the pill and the popup
		UserInputService.InputBegan:Connect(function(input)
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
	function factory:CreateTextbox(text, placeholder, callback)
		local holder = new("Frame", {
			Parent = parent,
			Size = UDim2.new(1, 0, 0, 38),
			BackgroundColor3 = Theme.Element,
		})
		corner(holder, 8)
		addHover(holder)

		new("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0, 0),
			Size = UDim2.new(0.45, 0, 1, 0),
			Font = Enum.Font.Gotham,
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local box = new("TextBox", {
			Parent = holder,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			Size = UDim2.new(0.45, 0, 0, 24),
			BackgroundColor3 = Theme.ElementHi,
			ClearTextOnFocus = false,
			PlaceholderText = placeholder or "",
			Font = Enum.Font.Gotham,
			Text = "",
			TextColor3 = Theme.Text,
			TextSize = 12,
		})
		corner(box, 6)
		new("UIPadding", { Parent = box, PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })

		box.FocusLost:Connect(function(enterPressed)
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
		local key = defaultKey or Enum.KeyCode.Unknown
		local binding = false

		local holder = new("Frame", {
			Parent = parent,
			Size = UDim2.new(1, 0, 0, 38),
			BackgroundColor3 = Theme.Element,
		})
		corner(holder, 8)
		addHover(holder)

		new("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0, 0),
			Size = UDim2.new(1, -110, 1, 0),
			Font = Enum.Font.Gotham,
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local keyBtn = new("TextButton", {
			Parent = holder,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			Size = UDim2.new(0, 90, 0, 24),
			BackgroundColor3 = Theme.ElementHi,
			AutoButtonColor = false,
			Font = Enum.Font.Gotham,
			Text = key.Name,
			TextColor3 = Theme.SubText,
			TextSize = 12,
		})
		corner(keyBtn, 6)

		keyBtn.MouseButton1Click:Connect(function()
			if binding then return end
			binding = true
			keyBtn.Text = "..."
		end)

		UserInputService.InputBegan:Connect(function(input, processed)
			if binding then
				if input.UserInputType == Enum.UserInputType.Keyboard then
					key = input.KeyCode
					keyBtn.Text = key.Name
					binding = false
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
				keyBtn.Text = k.Name
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
	local title       = config.Title or "Menu"
	local size        = config.Size or UDim2.new(0, 520, 0, 340)
	local toggleKey   = config.ToggleKey or Enum.KeyCode.RightControl
	local toggleImage = config.ToggleImage or ""

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

	local Main = new("Frame", {
		Name = "Main",
		Parent = screenGui,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Theme.Background,
		ClipsDescendants = true,
	})
	corner(Main, 12)
	local mainStroke = stroke(Main, Theme.Stroke, 1)
	local mainGradient = gradient(mainStroke, Theme.GradientA, Theme.GradientB, 45)

	tween(Main, { Size = size }, 0.5)

	local TopBar = new("Frame", {
		Name = "TopBar",
		Parent = Main,
		BackgroundColor3 = Theme.Panel,
		Size = UDim2.new(1, 0, 0, 40),
	})
	corner(TopBar, 12)
	-- square off the bottom of the topbar so it reads as a flat header strip
	new("Frame", {
		Parent = TopBar,
		BackgroundColor3 = Theme.Panel,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, -12),
		Size = UDim2.new(1, 0, 0, 12),
	})

	local accentBar = new("Frame", {
		Parent = TopBar,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 14, 0.5, 0),
		Size = UDim2.new(0, 4, 0, 16),
		BackgroundColor3 = Theme.GradientA,
	})
	corner(accentBar, 2)
	gradient(accentBar, Theme.GradientA, Theme.GradientB, 90)

	new("TextLabel", {
		Parent = TopBar,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 28, 0, 0),
		Size = UDim2.new(1, -60, 1, 0),
		Font = Enum.Font.GothamSemibold,
		Text = title,
		TextColor3 = Theme.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local closeBtn = new("TextButton", {
		Parent = TopBar,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.new(0, 22, 0, 22),
		BackgroundColor3 = Theme.Element,
		AutoButtonColor = false,
		Text = "",
	})
	corner(closeBtn, 6)
	setIcon(closeBtn, ChromeIcons.Close, "x", 12, Theme.SubText)

	local minimizeBtn = new("TextButton", {
		Parent = TopBar,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -42, 0.5, 0),
		Size = UDim2.new(0, 22, 0, 22),
		BackgroundColor3 = Theme.Element,
		AutoButtonColor = false,
		Text = "",
	})
	corner(minimizeBtn, 6)
	setIcon(minimizeBtn, ChromeIcons.Minimize, "-", 12, Theme.SubText)

	makeDraggable(TopBar, Main)

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
	})
	corner(indicator, 10)
	local indicatorStroke = stroke(indicator, Theme.Stroke, 1)
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
			Font = Enum.Font.GothamBold,
			Text = "=",
			TextColor3 = Theme.Text,
			TextSize = 18,
		})
	end

	makeDraggable(indicator, indicator)

	local indicatorScale = new("UIScale", { Parent = indicator, Scale = 1 })

	local function setMinimized(state)
		minimized = state
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
		setMinimized(false)
	end)

	-- slow ambient rotation on the border gradient, purely cosmetic
	task.spawn(function()
		local rot = 45
		while Main.Parent do
			rot = (rot + 0.15) % 360
			mainGradient.Rotation = rot
			RunService.Heartbeat:Wait()
		end
	end)

	local TabBar = new("Frame", {
		Name = "TabBar",
		Parent = Main,
		Position = UDim2.new(0, 0, 0, 40),
		Size = UDim2.new(0, sidebarWidth(), 1, -40),
		BackgroundColor3 = Theme.Panel,
	})
	-- Main's UICorner only masks Main's own background -- it doesn't clip
	-- children, so TabBar's square corners were poking through Main's
	-- rounded bottom-left corner. Round TabBar itself to match, then
	-- square the other three corners back off since they're just interior
	-- seams (against the topbar above, and the page area to the right),
	-- not real edges of the window.
	corner(TabBar, 12)
	new("Frame", { -- squares off the top-left/top-right (seam against TopBar)
		Parent = TabBar,
		BackgroundColor3 = Theme.Panel,
		Size = UDim2.new(1, 0, 0, 12),
	})
	new("Frame", { -- squares off the bottom-right (seam against PagesHolder)
		Parent = TabBar,
		BackgroundColor3 = Theme.Panel,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, 0, 1, 0),
		Size = UDim2.new(0, 12, 0, 12),
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
		Position = UDim2.new(0, sidebarWidth(), 0, 40),
		Size = UDim2.new(1, -sidebarWidth(), 1, -40),
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
	UserInputService.InputBegan:Connect(function(input, processed)
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
		local DANGER = Color3.fromRGB(232, 92, 92)
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
		corner(overlay, 12)
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
			Active = true, -- swallow clicks so the backdrop doesn't see them
		})
		corner(card, 14)
		stroke(card, Theme.Stroke, 1)
		local cardScale = new("UIScale", { Parent = card, Scale = 0.9 })

		-- soft drop shadow where the engine supports UIShadow; skipped otherwise
		pcall(function()
			local shadow = Instance.new("UIShadow")
			shadow.BlurRadius = UDim.new(0, 18)
			shadow.Color = Color3.fromRGB(0, 0, 0)
			shadow.Offset = UDim2.fromOffset(0, 6)
			shadow.Transparency = 0.55
			shadow.Parent = card
		end)

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
			Font = Enum.Font.GothamBold,
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
				Font = Enum.Font.Gotham,
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
				or (kind == "danger") and Color3.fromRGB(240, 112, 112)
				or Theme.GradientA
			local b = new("TextButton", {
				Parent = row,
				LayoutOrder = order,
				Size = UDim2.new(0.5, -4, 1, 0), -- two equal halves around the 8px gap
				BackgroundColor3 = base,
				AutoButtonColor = false,
				Font = Enum.Font.GothamSemibold,
				Text = label,
				TextColor3 = (kind == "cancel") and Theme.SubText or Color3.fromRGB(255, 255, 255),
				TextSize = 13,
			})
			corner(b, 8)
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
			escConn = UserInputService.InputBegan:Connect(function(input)
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
		corner(overlay, 12)

		local card = new("Frame", {
			Parent = overlay,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = popupSize,
			BackgroundColor3 = Theme.Panel,
			Active = true, -- swallow clicks so they don't hit the dim backdrop
			ZIndex = 1,
		})
		corner(card, 10)
		local cardStroke = stroke(card, Theme.Stroke, 1)
		gradient(cardStroke, Theme.GradientA, Theme.GradientB, 45)
		local cardScale = new("UIScale", { Parent = card, Scale = 0.9 })

		new("TextLabel", {
			Parent = card,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 16, 0, 0),
			Size = UDim2.new(1, -56, 0, 40),
			Font = Enum.Font.GothamSemibold,
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

		local api = buildElementFactory(content, layer)

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
		tween(TabBar, { Size = UDim2.new(0, width, 1, -40) }, 0.2)
		tween(pagesHolder, {
			Position = UDim2.new(0, width, 0, 40),
			Size = UDim2.new(1, -width, 1, -40),
		}, 0.2)
		for _, t in pairs(Window._tabs) do
			applyTabLayout(t.icon, t.label, sidebarCompacted)
		end
	end

	----------------------------------------------------------------
	-- NOTIFY
	----------------------------------------------------------------
	local notifyHolder
	function Window:Notify(notifTitle, text, duration)
		duration = duration or 4

		-- one shared bottom-right stack so several notifications don't overlap
		if not notifyHolder or not notifyHolder.Parent then
			notifyHolder = new("Frame", {
				Name = "Notifications",
				Parent = screenGui,
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, -20, 1, -20),
				Size = UDim2.new(0, 260, 1, -40),
				BackgroundTransparency = 1,
			})
			new("UIListLayout", {
				Parent = notifyHolder,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDim.new(0, 8),
			})
		end

		local wrapper = new("Frame", {
			Parent = notifyHolder,
			Size = UDim2.new(1, 0, 0, 64),
			BackgroundTransparency = 1,
		})

		local holder = new("Frame", {
			Parent = wrapper,
			Position = UDim2.new(0, 290, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Theme.Panel,
		})
		corner(holder, 10)
		local nStroke = stroke(holder, Theme.Stroke, 1)
		gradient(nStroke, Theme.GradientA, Theme.GradientB, 45)

		new("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 14, 0, 8),
			Size = UDim2.new(1, -28, 0, 18),
			Font = Enum.Font.GothamSemibold,
			Text = notifTitle,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		new("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 14, 0, 28),
			Size = UDim2.new(1, -28, 0, 28),
			Font = Enum.Font.Gotham,
			Text = text,
			TextColor3 = Theme.SubText,
			TextSize = 12,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
		})

		-- countdown bar along the bottom edge
		local bar = new("Frame", {
			Parent = holder,
			Position = UDim2.new(0, 10, 1, -5),
			Size = UDim2.new(1, -20, 0, 2),
			BackgroundColor3 = Theme.GradientA,
		})
		corner(bar, 1)
		gradient(bar, Theme.GradientA, Theme.GradientB, 0)

		tween(holder, { Position = UDim2.new(0, 0, 0, 0) }, 0.4, Enum.EasingStyle.Back)
		tween(bar, { Size = UDim2.new(0, 0, 0, 2) }, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

		task.delay(duration, function()
			local out = tween(holder, { Position = UDim2.new(0, 290, 0, 0) }, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
			out.Completed:Wait()
			local collapse = tween(wrapper, { Size = UDim2.new(1, 0, 0, 0) }, 0.15)
			collapse.Completed:Wait()
			wrapper:Destroy()
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
			Size = UDim2.new(1, 0, 0, 32),
			BackgroundColor3 = Theme.Element,
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "",
		})
		corner(tabButton, 6)

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
			Font = Enum.Font.Gotham,
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
			CanvasSize = UDim2.new(0, 0, 0, 0),
			Visible = false,
		})
		new("UIPadding", {
			Parent = page,
			PaddingTop = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12),
		})
		local layout = new("UIListLayout", {
			Parent = page,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 24)
		end)

		local function selectTab()
			for _, t in pairs(Window._tabs) do
				t.page.Visible = false
				tween(t.button, { BackgroundTransparency = 1 }, 0.15)
				tween(t.label, { TextColor3 = Theme.SubText }, 0.15)
				if t.icon then
					tween(t.icon, { ImageColor3 = Theme.SubText }, 0.15)
				end
			end
			page.Position = UDim2.new(0, 0, 0, 12)
			page.Visible = true
			tween(page, { Position = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quart)
			tween(tabButton, { BackgroundTransparency = 0 }, 0.15)
			tween(tabLabel, { TextColor3 = Theme.Text }, 0.15)
			if tabIcon then
				tween(tabIcon, { ImageColor3 = Theme.Text }, 0.15)
			end
		end

		tabButton.MouseButton1Click:Connect(selectTab)

		table.insert(Window._tabs, { button = tabButton, page = page, label = tabLabel, icon = tabIcon })
		if not Window._firstTab then
			Window._firstTab = true
			selectTab()
		end

		local Tab = buildElementFactory(page, popupLayer)
		return Tab
	end

	return Window
end

return Library
