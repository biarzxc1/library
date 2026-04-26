-- KingRua UI Library - White/Light Gradient Theme
-- Changes: Green → White/Light gradient, Logo toggle button preserved

local Library = {}
local UIS         = game:GetService("UserInputService")
local TweenSvc    = game:GetService("TweenService")
local RunSvc      = game:GetService("RunService")

-- ── Helpers ────────────────────────────────────────────────────────────────

local function GetVP()
	return workspace.CurrentCamera.ViewportSize
end

local function IsMobile()
	return UIS.TouchEnabled
end

-- ── Core Library Methods ────────────────────────────────────────────────────

function Library:TweenInstance(Inst, Time, Prop, Val)
	local t = TweenSvc:Create(Inst, TweenInfo.new(Time, Enum.EasingStyle.Quad), { [Prop] = Val })
	t:Play()
	return t
end

function Library:UpdateContent(Content, Title, Object)
	if Content.Text ~= "" then
		Title.Position  = UDim2.new(0, 10, 0, 7)
		Title.Size      = UDim2.new(1, -60, 0, 16)
		local MaxY = math.max(Content.TextBounds.Y + 15, 45)
		Object.Size = UDim2.new(1, 0, 0, MaxY)
	end
end

function Library:UpdateScrolling(Scroll, List)
	List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Scroll.CanvasSize = UDim2.new(0, 0, 0, List.AbsoluteContentSize.Y + 15)
	end)
end

function Library:MakeConfig(Default, Given)
	for k, v in next, Default do
		if Given[k] == nil then
			Given[k] = v
		end
	end
	return Given
end

-- ── Draggable (mobile-safe) ─────────────────────────────────────────────────

function Library:MakeDraggable(Handle, Object)
	local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

	local function UpdatePos(input)
		local delta = input.Position - dragStart
		local pos   = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
		local vp   = GetVP()
		local absS = Object.AbsoluteSize
		local ox   = math.clamp(pos.X.Offset, -(Object.AbsolutePosition.X), vp.X - absS.X - Object.AbsolutePosition.X + pos.X.Offset)
		TweenSvc:Create(Object, TweenInfo.new(0.13), {
			Position = UDim2.new(pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset)
		}):Play()
	end

	Handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging  = true
			dragStart = input.Position
			startPos  = Object.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	Handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			UpdatePos(input)
		end
	end)
end

-- ── New Window ──────────────────────────────────────────────────────────────

function Library:NewWindow(ConfigWindow)
	ConfigWindow = self:MakeConfig({
		Title       = "King Rua Hub",
		Description = "By _ng.shinichi",
	}, ConfigWindow or {})

	local VP        = GetVP()
	local mobile    = IsMobile()
	local WW        = math.min(555, VP.X - (mobile and 6 or 20))
	local WH        = math.min(350, VP.Y - (mobile and 60 or 80))
	local TabW      = mobile and 110 or 144
	local ShadowPad = 47

	-- ── ScreenGui ──────────────────────────────────────────────────────────
	local KingRuaUI  = Instance.new("ScreenGui")
	KingRuaUI.Name             = "KingRuaUI_Premium"
	KingRuaUI.Parent           = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	KingRuaUI.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
	KingRuaUI.ResetOnSpawn     = false
	KingRuaUI.DisplayOrder     = 10

	-- ── Drop shadow holder ─────────────────────────────────────────────────
	local DSHolder = Instance.new("Frame")
	DSHolder.Name                 = "DropShadowHolder"
	DSHolder.Parent               = KingRuaUI
	DSHolder.AnchorPoint          = Vector2.new(0.5, 0.5)
	DSHolder.BackgroundTransparency = 1
	DSHolder.BorderSizePixel      = 0
	DSHolder.Position             = UDim2.new(0.5, 0, 0.5, 0)
	DSHolder.Size                 = UDim2.new(0, WW, 0, WH)
	DSHolder.ZIndex               = 0

	local DS = Instance.new("ImageLabel")
	DS.Name                  = "DropShadow"
	DS.Parent                = DSHolder
	DS.AnchorPoint           = Vector2.new(0.5, 0.5)
	DS.BackgroundTransparency = 1
	DS.BorderSizePixel       = 0
	DS.Position              = UDim2.new(0.5, 0, 0.5, 0)
	DS.Size                  = UDim2.new(1, ShadowPad, 1, ShadowPad)
	DS.ZIndex                = 0
	DS.Image                 = "rbxassetid://6015897843"
	DS.ImageColor3           = Color3.fromRGB(0, 0, 0)
	DS.ImageTransparency     = 0.5
	DS.ScaleType             = Enum.ScaleType.Slice
	DS.SliceCenter           = Rect.new(49, 49, 450, 450)

	-- ── Main frame ─────────────────────────────────────────────────────────
	local Main = Instance.new("Frame")
	Main.Name                  = "Main"
	Main.Parent                = DSHolder
	Main.AnchorPoint           = Vector2.new(0.5, 0.5)
	Main.BackgroundColor3      = Color3.fromRGB(9, 9, 9)
	Main.BackgroundTransparency = 0.07
	Main.BorderSizePixel       = 0
	Main.Position              = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size                  = UDim2.new(0, WW, 0, WH)
	Instance.new("UICorner").Parent = Main

	-- ── White/light gradient stroke (replaces green) ───────────────────────
	local MainStroke = Instance.new("UIStroke")
	MainStroke.Color        = Color3.fromRGB(180, 180, 180)   -- light gray instead of green
	MainStroke.Transparency = 0.7
	MainStroke.Parent       = Main

	-- ── Top bar ───────────────────────────────────────────────────────────
	local Top = Instance.new("Frame")
	Top.Name                  = "Top"
	Top.Parent                = Main
	Top.BackgroundTransparency = 1
	Top.BorderSizePixel       = 0
	Top.Size                  = UDim2.new(1, 0, 0, 50)

	-- White gradient line under top bar
	local TopLine = Instance.new("Frame")
	TopLine.Name              = "Line"
	TopLine.Parent            = Top
	TopLine.BackgroundColor3  = Color3.fromRGB(255, 255, 255)  -- white
	TopLine.BackgroundTransparency = 0.6
	TopLine.BorderSizePixel   = 0
	TopLine.Position          = UDim2.new(0, 0, 1, -1)
	TopLine.Size              = UDim2.new(1, 0, 0, 1)

	-- Logo
	local LogoHub = Instance.new("ImageLabel")
	LogoHub.Name                  = "LogoHub"
	LogoHub.Parent                = Top
	LogoHub.BackgroundTransparency = 1
	LogoHub.BorderSizePixel       = 0
	LogoHub.Position              = UDim2.new(0, 10, 0, 5)
	LogoHub.Size                  = UDim2.new(0, 40, 0, 35)
	LogoHub.Image                 = "rbxassetid://124762714875426"

	-- Title
	local NameHub = Instance.new("TextLabel")
	NameHub.Name                  = "NameHub"
	NameHub.Parent                = Top
	NameHub.BackgroundTransparency = 1
	NameHub.BorderSizePixel       = 0
	NameHub.Position              = UDim2.new(0, 60, 0, 10)
	NameHub.Size                  = UDim2.new(1, -160, 0, 20)
	NameHub.Font                  = Enum.Font.GothamBold
	NameHub.Text                  = ConfigWindow.Title
	NameHub.TextColor3            = Color3.fromRGB(255, 255, 255)
	NameHub.TextSize              = 14
	NameHub.TextXAlignment        = Enum.TextXAlignment.Left

	local Desc = Instance.new("TextLabel")
	Desc.Name                  = "Desc"
	Desc.Parent                = Top
	Desc.BackgroundTransparency = 1
	Desc.BorderSizePixel       = 0
	Desc.Position              = UDim2.new(0, 60, 0, 27)
	Desc.Size                  = UDim2.new(1, -160, 1, -30)
	Desc.Font                  = Enum.Font.GothamBold
	Desc.Text                  = ConfigWindow.Description
	Desc.TextColor3            = Color3.fromRGB(100, 100, 100)
	Desc.TextSize              = 12
	Desc.TextXAlignment        = Enum.TextXAlignment.Left
	Desc.TextYAlignment        = Enum.TextYAlignment.Top

	-- ── Window control buttons ─────────────────────────────────────────────
	local BtnFrame = Instance.new("Frame")
	BtnFrame.Parent                = Top
	BtnFrame.BackgroundTransparency = 1
	BtnFrame.BorderSizePixel       = 0
	BtnFrame.Position              = UDim2.new(1, -110, 0, 0)
	BtnFrame.Size                  = UDim2.new(0, 110, 1, 0)

	local BtnList = Instance.new("UIListLayout")
	BtnList.Parent        = BtnFrame
	BtnList.FillDirection = Enum.FillDirection.Horizontal
	BtnList.SortOrder     = Enum.SortOrder.LayoutOrder
	BtnList.Padding       = UDim.new(0, 6)

	local BtnPad = Instance.new("UIPadding")
	BtnPad.Parent     = BtnFrame
	BtnPad.PaddingTop = UDim.new(0, 10)

	local function MakeIconBtn(parent, iconId, rectOff, rectSz, iconSz, order)
		local btn = Instance.new("TextButton")
		btn.Active                = true
		btn.AnchorPoint          = Vector2.new(0, 0.5)
		btn.BackgroundTransparency = 1
		btn.BorderSizePixel      = 0
		btn.Selectable           = true
		btn.Size                 = UDim2.new(0, 30, 0, 30)
		btn.Text                 = ""
		btn.LayoutOrder          = order
		btn.Parent               = parent

		local ico = Instance.new("ImageLabel")
		ico.AnchorPoint          = Vector2.new(0.5, 0.5)
		ico.BackgroundTransparency = 1
		ico.BorderSizePixel      = 0
		ico.Position             = UDim2.new(0.5, 0, 0.5, 0)
		ico.Size                 = UDim2.new(0, iconSz, 0, iconSz)
		ico.Image                = iconId
		if rectOff then ico.ImageRectOffset = rectOff end
		if rectSz  then ico.ImageRectSize   = rectSz  end
		ico.Parent               = btn
		return btn
	end

	local Minimize = MakeIconBtn(BtnFrame,
		"rbxassetid://136452605242985", Vector2.new(288, 672), Vector2.new(96, 96), 20, 1)
	local Large = MakeIconBtn(BtnFrame,
		"rbxassetid://136452605242985", Vector2.new(580, 194), Vector2.new(96, 96), 18, 2)
	local Close = MakeIconBtn(BtnFrame,
		"rbxassetid://105957381820378", Vector2.new(480, 0),   Vector2.new(96, 96), 20, 3)

	-- ── DropdownZone ───────────────────────────────────────────────────────
	local DropdownZone = Instance.new("Frame")
	DropdownZone.Name                  = "DropdownZone"
	DropdownZone.Parent                = Main
	DropdownZone.BackgroundColor3      = Color3.fromRGB(0, 0, 0)
	DropdownZone.BackgroundTransparency = 1
	DropdownZone.BorderSizePixel       = 0
	DropdownZone.Size                  = UDim2.new(1, 0, 1, 0)
	DropdownZone.Visible               = false
	DropdownZone.Active                = false
	DropdownZone.ZIndex                = 5

	-- ── Close confirm dialog ───────────────────────────────────────────────
	Close.Activated:Connect(function()
		DropdownZone.Visible = true
		local Dialog = Instance.new("Frame")
		Dialog.BackgroundColor3  = Color3.fromRGB(19, 19, 19)
		Dialog.AnchorPoint       = Vector2.new(0.5, 0.5)
		Dialog.Size              = UDim2.new(0, math.min(400, WW - 20), 0, 150)
		Dialog.Position          = UDim2.new(0.5, 0, 0.5, 0)
		Dialog.BorderSizePixel   = 0
		Dialog.ZIndex            = 6
		Dialog.Parent            = DropdownZone

		local dStroke = Instance.new("UIStroke", Dialog)
		dStroke.Transparency = 0.5
		dStroke.Color        = Color3.fromRGB(101, 101, 101)

		local dCorner = Instance.new("UICorner", Dialog)
		dCorner.CornerRadius = UDim.new(0, 5)

		local dLabel = Instance.new("TextLabel", Dialog)
		dLabel.BackgroundTransparency = 1
		dLabel.BorderSizePixel        = 0
		dLabel.TextSize               = 20
		dLabel.FontFace               = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold)
		dLabel.TextColor3             = Color3.fromRGB(255, 255, 255)
		dLabel.Size                   = UDim2.new(1, 0, 0, 50)
		dLabel.Text                   = "Are you sure?"
		dLabel.ZIndex                 = 7

		local function MakeDialogBtn(txt, ap, pos)
			local b = Instance.new("TextButton", Dialog)
			b.BackgroundColor3  = Color3.fromRGB(5, 5, 5)
			b.BorderSizePixel   = 0
			b.TextSize          = 22
			b.TextColor3        = Color3.fromRGB(255, 255, 255)
			b.FontFace          = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold)
			b.AnchorPoint       = ap
			b.Size              = UDim2.new(0, 140, 0, 48)
			b.Position          = pos
			b.Text              = txt
			b.ZIndex            = 7
			b.Active            = true
			b.Selectable        = true
			Instance.new("UICorner", b)
			local s = Instance.new("UIStroke", b)
			s.ApplyStrokeMode   = Enum.ApplyStrokeMode.Border
			s.Color             = Color3.fromRGB(39, 39, 39)
			return b
		end

		local BtnYes = MakeDialogBtn("Yes",
			Vector2.new(0, 1), UDim2.new(0, 30, 1, -20))
		local BtnNo  = MakeDialogBtn("No",
			Vector2.new(1, 1), UDim2.new(1, -30, 1, -20))

		BtnYes.Activated:Connect(function()
			KingRuaUI:Destroy()
		end)
		BtnNo.Activated:Connect(function()
			Dialog:Destroy()
			DropdownZone.Visible = false
		end)
	end)

	-- ── Tab frame (left sidebar) ───────────────────────────────────────────
	local TabFrame = Instance.new("Frame")
	TabFrame.Name                  = "TabFrame"
	TabFrame.Parent                = Main
	TabFrame.BackgroundTransparency = 1
	TabFrame.BorderSizePixel       = 0
	TabFrame.Position              = UDim2.new(0, 0, 0, 50)
	TabFrame.Size                  = UDim2.new(0, TabW, 1, -50)

	-- White gradient line separating sidebar from content
	local TabLine = Instance.new("Frame")
	TabLine.Name              = "Line"
	TabLine.Parent            = TabFrame
	TabLine.BackgroundColor3  = Color3.fromRGB(255, 255, 255)  -- white
	TabLine.BackgroundTransparency = 0.7
	TabLine.BorderSizePixel   = 0
	TabLine.Position          = UDim2.new(1, -1, 0, 0)
	TabLine.Size              = UDim2.new(0, 1, 1, 0)

	-- Search
	local SearchFrame = Instance.new("Frame")
	SearchFrame.Name                  = "SearchFrame"
	SearchFrame.Parent                = TabFrame
	SearchFrame.BackgroundColor3      = Color3.fromRGB(255, 255, 255)
	SearchFrame.BackgroundTransparency = 0.95
	SearchFrame.BorderSizePixel       = 0
	SearchFrame.Position              = UDim2.new(0, 7, 0, 10)
	SearchFrame.Size                  = UDim2.new(1, -14, 0, 30)

	local SFCorner = Instance.new("UICorner", SearchFrame)
	SFCorner.CornerRadius = UDim.new(0, 3)

	local SearchIcon = Instance.new("ImageLabel")
	SearchIcon.Name                  = "IconSearch"
	SearchIcon.Parent                = SearchFrame
	SearchIcon.AnchorPoint           = Vector2.new(0, 0.5)
	SearchIcon.BackgroundTransparency = 1
	SearchIcon.BorderSizePixel       = 0
	SearchIcon.Position              = UDim2.new(0, 8, 0.5, 0)
	SearchIcon.Size                  = UDim2.new(0, 14, 0, 14)
	SearchIcon.Image                 = "rbxassetid://71309835376233"

	local SearchBox = Instance.new("TextBox")
	SearchBox.Name                  = "SearchBox"
	SearchBox.Parent                = SearchFrame
	SearchBox.BackgroundTransparency = 1
	SearchBox.BorderSizePixel       = 0
	SearchBox.ClipsDescendants      = true
	SearchBox.Position              = UDim2.new(0, 30, 0, 0)
	SearchBox.Size                  = UDim2.new(1, -32, 1, 0)
	SearchBox.Font                  = Enum.Font.GothamBold
	SearchBox.PlaceholderText       = "Search..."
	SearchBox.Text                  = ""
	SearchBox.TextColor3            = Color3.fromRGB(255, 255, 255)
	SearchBox.TextSize              = 12
	SearchBox.TextXAlignment        = Enum.TextXAlignment.Left

	-- Scrolling tab list
	local ScrollingTab = Instance.new("ScrollingFrame")
	ScrollingTab.Name                  = "ScrollingTab"
	ScrollingTab.Parent                = TabFrame
	ScrollingTab.BackgroundTransparency = 1
	ScrollingTab.BorderSizePixel       = 0
	ScrollingTab.Position              = UDim2.new(0, 0, 0, 48)
	ScrollingTab.Selectable            = false
	ScrollingTab.Size                  = UDim2.new(1, 0, 1, -48)
	ScrollingTab.ScrollBarThickness    = 0

	local TabPad = Instance.new("UIPadding", ScrollingTab)
	TabPad.PaddingBottom = UDim.new(0, 3)
	TabPad.PaddingLeft   = UDim.new(0, 7)
	TabPad.PaddingRight  = UDim.new(0, 7)
	TabPad.PaddingTop    = UDim.new(0, 3)

	local TabList = Instance.new("UIListLayout", ScrollingTab)
	TabList.SortOrder = Enum.SortOrder.LayoutOrder
	self:UpdateScrolling(ScrollingTab, TabList)

	-- ── Layout / content area ──────────────────────────────────────────────
	local LayoutFrame = Instance.new("Frame")
	LayoutFrame.Name                  = "LayoutFrame"
	LayoutFrame.Parent                = Main
	LayoutFrame.BackgroundTransparency = 1
	LayoutFrame.BorderSizePixel       = 0
	LayoutFrame.Position              = UDim2.new(0, TabW, 0, 50)
	LayoutFrame.Size                  = UDim2.new(1, -TabW, 1, -50)
	LayoutFrame.ClipsDescendants      = true

	local LayoutName = Instance.new("Frame")
	LayoutName.Name                  = "LayoutName"
	LayoutName.Parent                = LayoutFrame
	LayoutName.BackgroundTransparency = 1
	LayoutName.BorderSizePixel       = 0
	LayoutName.Size                  = UDim2.new(1, 0, 0, 40)

	local TabNameLabel = Instance.new("TextLabel")
	TabNameLabel.Parent                = LayoutName
	TabNameLabel.BackgroundTransparency = 1
	TabNameLabel.BorderSizePixel       = 0
	TabNameLabel.Position              = UDim2.new(0, 10, 0, 0)
	TabNameLabel.Size                  = UDim2.new(1, -10, 1, 0)
	TabNameLabel.Font                  = Enum.Font.GothamBold
	TabNameLabel.Text                  = ""
	TabNameLabel.TextColor3            = Color3.fromRGB(255, 255, 255)
	TabNameLabel.TextSize              = 13
	TabNameLabel.TextXAlignment        = Enum.TextXAlignment.Left

	local RealLayout = Instance.new("Frame")
	RealLayout.Name                  = "RealLayout"
	RealLayout.Parent                = LayoutFrame
	RealLayout.BackgroundTransparency = 1
	RealLayout.BorderSizePixel       = 0
	RealLayout.Position              = UDim2.new(0, 0, 0, 40)
	RealLayout.Size                  = UDim2.new(1, 0, 1, -40)

	local LayoutList = Instance.new("Folder")
	LayoutList.Name   = "Layout List"
	LayoutList.Parent = RealLayout

	local PageLayout = Instance.new("UIPageLayout", LayoutList)
	PageLayout.SortOrder    = Enum.SortOrder.LayoutOrder
	PageLayout.EasingStyle  = Enum.EasingStyle.Quad
	PageLayout.TweenTime    = 0.3

	-- ── Draggable ─────────────────────────────────────────────────────────
	self:MakeDraggable(Top, DSHolder)

	-- ── Logo toggle button (click to show/hide UI) ─────────────────────────
	local LogoGui = Instance.new("ScreenGui")
	LogoGui.Name           = "KingRuaLogoGui"
	LogoGui.Parent         = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	LogoGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	LogoGui.ResetOnSpawn   = false
	LogoGui.DisplayOrder   = 11

	local LogoBtn = Instance.new("ImageButton")
	LogoBtn.Name                  = "LogoButton"
	LogoBtn.Parent                = LogoGui
	LogoBtn.BorderSizePixel       = 0
	LogoBtn.BackgroundColor3      = Color3.fromRGB(20, 20, 20)  -- dark bg for logo
	LogoBtn.Image                 = "rbxassetid://124762714875426"
	LogoBtn.Size                  = UDim2.new(0, 50, 0, 50)
	LogoBtn.Position              = UDim2.new(1, -65, 0.45, 0)  -- right side, vertically centered
	LogoBtn.Active                = true
	LogoBtn.Selectable            = true
	LogoBtn.ZIndex                = 10

	local LBCorner = Instance.new("UICorner", LogoBtn)
	LBCorner.CornerRadius = UDim.new(1, 0)

	-- White/light stroke on logo button (replaces green)
	local LBStroke = Instance.new("UIStroke", LogoBtn)
	LBStroke.Thickness = 2
	LBStroke.Color     = Color3.fromRGB(200, 200, 200)   -- light white/gray

	self:MakeDraggable(LogoBtn, LogoBtn)

	-- ── Toggle UI on/off by clicking the logo ─────────────────────────────
	LogoBtn.Activated:Connect(function()
		KingRuaUI.Enabled = not KingRuaUI.Enabled
		-- Subtle feedback: pulse stroke color
		Library:TweenInstance(LBStroke, 0.15, "Thickness", 3)
		task.delay(0.15, function()
			Library:TweenInstance(LBStroke, 0.15, "Thickness", 2)
		end)
	end)

	Minimize.Activated:Connect(function()
		KingRuaUI.Enabled = false
	end)

	-- ── Tab builder ────────────────────────────────────────────────────────
	local AllLayouts = 0
	local Tab = {}

	function Tab:T(tabName)
		local TabRow = Instance.new("Frame")
		TabRow.Name              = "TabRow"
		TabRow.Parent            = ScrollingTab
		TabRow.BackgroundTransparency = 1
		TabRow.BorderSizePixel   = 0
		TabRow.Size              = UDim2.new(1, 0, 0, 28)

		-- White indicator bar (replaces green)
		local Indicator = Instance.new("Frame")
		Indicator.Name            = "Choose"
		Indicator.Parent          = TabRow
		Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)   -- white
		Indicator.BorderSizePixel = 0
		Indicator.Position        = UDim2.new(0, 0, 0, 6)
		Indicator.Size            = UDim2.new(0, 4, 0, 16)
		Indicator.Visible         = false
		Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

		local NameLbl = Instance.new("TextLabel")
		NameLbl.Name                  = "NameTab"
		NameLbl.Parent                = TabRow
		NameLbl.BackgroundTransparency = 1
		NameLbl.BorderSizePixel       = 0
		NameLbl.Position              = UDim2.new(0, 12, 0, 0)
		NameLbl.Size                  = UDim2.new(1, -12, 1, 0)
		NameLbl.Font                  = Enum.Font.GothamBold
		NameLbl.Text                  = tabName
		NameLbl.TextColor3            = Color3.fromRGB(255, 255, 255)
		NameLbl.TextSize              = 12
		NameLbl.TextTransparency      = 0.3
		NameLbl.TextXAlignment        = Enum.TextXAlignment.Left

		local ClickBtn = Instance.new("TextButton")
		ClickBtn.Name                  = "Click_Tab"
		ClickBtn.Parent                = TabRow
		ClickBtn.BackgroundTransparency = 1
		ClickBtn.BorderSizePixel       = 0
		ClickBtn.Size                  = UDim2.new(1, 0, 1, 0)
		ClickBtn.Text                  = ""
		ClickBtn.Active                = true
		ClickBtn.Selectable            = true
		ClickBtn.ZIndex                = 3

		local Layout = Instance.new("ScrollingFrame")
		Layout.Name                  = "Layout"
		Layout.Parent                = LayoutList
		Layout.BackgroundTransparency = 1
		Layout.BorderSizePixel       = 0
		Layout.Selectable            = false
		Layout.Size                  = UDim2.new(1, 0, 1, 0)
		Layout.CanvasSize            = UDim2.new(0, 0, 1, 0)
		Layout.ScrollBarThickness    = 0
		Layout.LayoutOrder           = AllLayouts
		Layout.ScrollingEnabled      = true
		Layout.Active                = true

		local LPad = Instance.new("UIPadding", Layout)
		LPad.PaddingBottom = UDim.new(0, 7)
		LPad.PaddingLeft   = UDim.new(0, 10)
		LPad.PaddingRight  = UDim.new(0, 7)

		local LList = Instance.new("UIListLayout", Layout)
		LList.SortOrder = Enum.SortOrder.LayoutOrder
		LList.Padding   = UDim.new(0, 10)
		Library:UpdateScrolling(Layout, LList)

		if AllLayouts == 0 then
			NameLbl.TextTransparency = 0
			Indicator.Visible        = true
			PageLayout:JumpToIndex(0)
			TabNameLabel.Text        = tabName
		end

		ClickBtn.Activated:Connect(function()
			TabNameLabel.Text = tabName
			for _, v in next, ScrollingTab:GetChildren() do
				if v:IsA("Frame") then
					Library:TweenInstance(v:FindFirstChild("NameTab"), 0.3, "TextTransparency", 0.3)
					local ch = v:FindFirstChild("Choose")
					if ch then ch.Visible = false end
				end
			end
			Library:TweenInstance(NameLbl, 0.2, "TextTransparency", 0)
			PageLayout:JumpToIndex(Layout.LayoutOrder)
			Indicator.Visible = true
		end)

		AllLayouts = AllLayouts + 1

		-- ── Section builder ──────────────────────────────────────────────
		local TabFunc = {}

		function TabFunc:AddSection(SectionName)
			local Section = Instance.new("Frame")
			Section.Name                  = "Section"
			Section.Parent                = Layout
			Section.BackgroundColor3      = Color3.fromRGB(255, 255, 255)
			Section.BackgroundTransparency = 0.98
			Section.BorderSizePixel       = 0
			Section.Size                  = UDim2.new(1, 0, 0, 55)

			local SCorner = Instance.new("UICorner", Section)
			SCorner.CornerRadius = UDim.new(0, 4)

			local SStroke = Instance.new("UIStroke", Section)
			SStroke.Color        = Color3.fromRGB(100, 100, 100)
			SStroke.Thickness    = 2
			SStroke.Transparency = 0.92

			local NameSec = Instance.new("Frame")
			NameSec.Name                  = "NameSection"
			NameSec.Parent                = Section
			NameSec.BackgroundTransparency = 1
			NameSec.BorderSizePixel       = 0
			NameSec.Size                  = UDim2.new(1, 0, 0, 30)

			local SecTitle = Instance.new("TextLabel")
			SecTitle.Name                  = "Title"
			SecTitle.Parent                = NameSec
			SecTitle.BackgroundTransparency = 1
			SecTitle.BorderSizePixel       = 0
			SecTitle.Size                  = UDim2.new(1, 0, 1, 0)
			SecTitle.Font                  = Enum.Font.GothamBold
			SecTitle.Text                  = SectionName
			SecTitle.TextColor3            = Color3.fromRGB(255, 255, 255)
			SecTitle.TextSize              = 14

			local SecLine = Instance.new("Frame")
			SecLine.Name              = "Line"
			SecLine.Parent            = NameSec
			SecLine.BackgroundColor3  = Color3.fromRGB(255, 255, 255)
			SecLine.BorderSizePixel   = 0
			SecLine.Position          = UDim2.new(0, 0, 1, -2)
			SecLine.Size              = UDim2.new(1, 0, 0, 2)

			-- White light gradient on section divider line (replaces green)
			local SecGrad = Instance.new("UIGradient")
			SecGrad.Color = ColorSequence.new {
				ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 24, 25)),
				ColorSequenceKeypoint.new(0.52, Color3.fromRGB(255, 255, 255)),   -- white center
				ColorSequenceKeypoint.new(1.00, Color3.fromRGB(24, 24, 25)),
			}
			SecGrad.Transparency = NumberSequence.new {
				NumberSequenceKeypoint.new(0.00, 0.53),
				NumberSequenceKeypoint.new(0.51, 0.00),
				NumberSequenceKeypoint.new(1.00, 0.51),
			}
			SecGrad.Parent = SecLine

			local SecList = Instance.new("Frame")
			SecList.Name                  = "SectionList"
			SecList.Parent                = Section
			SecList.BackgroundTransparency = 1
			SecList.BorderSizePixel       = 0
			SecList.Position              = UDim2.new(0, 0, 0, 35)
			SecList.Size                  = UDim2.new(1, 0, 1, -35)

			local SPad = Instance.new("UIPadding", SecList)
			SPad.PaddingBottom = UDim.new(0, 7)
			SPad.PaddingLeft   = UDim.new(0, 7)
			SPad.PaddingRight  = UDim.new(0, 7)
			SPad.PaddingTop    = UDim.new(0, 7)

			local SLList = Instance.new("UIListLayout", SecList)
			SLList.SortOrder = Enum.SortOrder.LayoutOrder
			SLList.Padding   = UDim.new(0, 6)

			SLList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Section.Size = UDim2.new(1, 0, 0, SLList.AbsoluteContentSize.Y + 55)
			end)

			-- ── Element builders ────────────────────────────────────────

			local SectionFunc = {}

			-- ── Toggle ────────────────────────────────────────────────
			function SectionFunc:AddToggle(cfg)
				cfg = Library:MakeConfig({
					Title       = "Toggle",
					Description = "",
					Default     = false,
					Callback    = function() end,
				}, cfg or {})

				local Row = Instance.new("Frame")
				Row.Name                  = "Toggle"
				Row.Parent                = SecList
				Row.BackgroundColor3      = Color3.fromRGB(255, 255, 255)
				Row.BackgroundTransparency = 0.95
				Row.BorderSizePixel       = 0
				Row.Size                  = UDim2.new(1, 0, 0, 35)
				Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 3)

				local TTitle = Instance.new("TextLabel")
				TTitle.Name                  = "Title"
				TTitle.Parent                = Row
				TTitle.BackgroundTransparency = 1
				TTitle.BorderSizePixel       = 0
				TTitle.Position              = UDim2.new(0, 10, 0, 0)
				TTitle.Size                  = UDim2.new(1, -60, 1, 0)
				TTitle.Font                  = Enum.Font.GothamBold
				TTitle.Text                  = cfg.Title
				TTitle.TextColor3            = Color3.fromRGB(255, 255, 255)
				TTitle.TextSize              = 13
				TTitle.TextXAlignment        = Enum.TextXAlignment.Left

				local Track = Instance.new("Frame")
				Track.Name              = "ToggleCheck"
				Track.Parent            = Row
				Track.AnchorPoint       = Vector2.new(0, 0.5)
				Track.BackgroundColor3  = Color3.fromRGB(60, 60, 60)
				Track.BorderSizePixel   = 0
				Track.Position          = UDim2.new(1, -50, 0.5, 0)
				Track.Size              = UDim2.new(0, 40, 0, 22)
				Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

				local Thumb = Instance.new("Frame")
				Thumb.Name              = "Check"
				Thumb.Parent            = Track
				Thumb.AnchorPoint       = Vector2.new(0, 0.5)
				Thumb.BackgroundColor3  = Color3.fromRGB(200, 200, 200)
				Thumb.BorderSizePixel   = 0
				Thumb.Position          = UDim2.new(0, 3, 0.5, 0)
				Thumb.Size              = UDim2.new(0, 16, 0, 16)
				Instance.new("UICorner", Thumb).CornerRadius = UDim.new(1, 0)

				local TClick = Instance.new("TextButton")
				TClick.Name                  = "Toggle_Click"
				TClick.Parent                = Row
				TClick.BackgroundTransparency = 1
				TClick.BorderSizePixel       = 0
				TClick.Size                  = UDim2.new(1, 0, 1, 0)
				TClick.Text                  = ""
				TClick.Active                = true
				TClick.Selectable            = true
				TClick.ZIndex                = 3

				local Content = Instance.new("TextLabel")
				Content.Name                  = "Content"
				Content.Parent                = Row
				Content.BackgroundTransparency = 1
				Content.BorderSizePixel       = 0
				Content.Position              = UDim2.new(0, 10, 0, 22)
				Content.Size                  = UDim2.new(1, -60, 1, 0)
				Content.Font                  = Enum.Font.GothamBold
				Content.Text                  = cfg.Description
				Content.TextColor3            = Color3.fromRGB(100, 100, 100)
				Content.TextSize              = 12
				Content.TextXAlignment        = Enum.TextXAlignment.Left
				Content.TextYAlignment        = Enum.TextYAlignment.Top
				Library:UpdateContent(Content, TTitle, Row)

				local TogFunc = { Value = cfg.Default }
				function TogFunc:Set(bool)
					self.Value = bool
					if bool then
						-- White/light when ON (replaces green)
						Library:TweenInstance(Track, 0.3, "BackgroundColor3", Color3.fromRGB(180, 180, 180))
						Library:TweenInstance(Thumb, 0.3, "Position", UDim2.new(0, 22, 0.5, 0))
						Library:TweenInstance(Thumb, 0.3, "BackgroundColor3", Color3.fromRGB(255, 255, 255))
					else
						Library:TweenInstance(Track, 0.3, "BackgroundColor3", Color3.fromRGB(60, 60, 60))
						Library:TweenInstance(Thumb, 0.3, "BackgroundColor3", Color3.fromRGB(200, 200, 200))
						Library:TweenInstance(Thumb, 0.3, "Position", UDim2.new(0, 3, 0.5, 0))
					end
					cfg.Callback(bool)
				end
				TogFunc:Set(TogFunc.Value)

				TClick.Activated:Connect(function()
					TogFunc:Set(not TogFunc.Value)
				end)
				return TogFunc
			end

			-- ── Button ────────────────────────────────────────────────
			function SectionFunc:AddButton(cfg)
				cfg = Library:MakeConfig({
					Title       = "Button",
					Description = "",
					Callback    = function() end,
				}, cfg or {})

				local Row = Instance.new("Frame")
				Row.Name                  = "Button"
				Row.Parent                = SecList
				Row.BackgroundColor3      = Color3.fromRGB(255, 255, 255)
				Row.BackgroundTransparency = 0.95
				Row.BorderSizePixel       = 0
				Row.Size                  = UDim2.new(1, 0, 0, 35)
				Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 3)

				local BTitle = Instance.new("TextLabel")
				BTitle.Name                  = "Title"
				BTitle.Parent                = Row
				BTitle.BackgroundTransparency = 1
				BTitle.BorderSizePixel       = 0
				BTitle.Position              = UDim2.new(0, 10, 0, 0)
				BTitle.Size                  = UDim2.new(1, -60, 1, 0)
				BTitle.Font                  = Enum.Font.GothamBold
				BTitle.Text                  = cfg.Title
				BTitle.TextColor3            = Color3.fromRGB(255, 255, 255)
				BTitle.TextSize              = 13
				BTitle.TextXAlignment        = Enum.TextXAlignment.Left

				local BClick = Instance.new("TextButton")
				BClick.Name                  = "Button_Click"
				BClick.Parent                = Row
				BClick.BackgroundTransparency = 1
				BClick.BorderSizePixel       = 0
				BClick.Size                  = UDim2.new(1, 0, 1, 0)
				BClick.Text                  = ""
				BClick.Active                = true
				BClick.Selectable            = true
				BClick.ZIndex                = 3

				local BContent = Instance.new("TextLabel")
				BContent.Name                  = "Content"
				BContent.Parent                = Row
				BContent.BackgroundTransparency = 1
				BContent.BorderSizePixel       = 0
				BContent.Position              = UDim2.new(0, 10, 0, 22)
				BContent.Size                  = UDim2.new(1, -60, 1, 0)
				BContent.Font                  = Enum.Font.GothamBold
				BContent.Text                  = cfg.Description
				BContent.TextColor3            = Color3.fromRGB(100, 100, 100)
				BContent.TextSize              = 12
				BContent.TextXAlignment        = Enum.TextXAlignment.Left
				BContent.TextYAlignment        = Enum.TextYAlignment.Top

				local BIcon = Instance.new("ImageLabel")
				BIcon.Parent                = Row
				BIcon.AnchorPoint           = Vector2.new(0, 0.5)
				BIcon.BackgroundTransparency = 1
				BIcon.BorderSizePixel       = 0
				BIcon.Position              = UDim2.new(1, -35, 0.5, 0)
				BIcon.Size                  = UDim2.new(0, 22, 0, 22)
				BIcon.Image                 = "rbxassetid://85905776508942"

				Library:UpdateContent(BContent, BTitle, Row)

				BClick.Activated:Connect(function()
					Row.BackgroundTransparency = 0.97
					cfg.Callback()
					Library:TweenInstance(Row, 0.2, "BackgroundTransparency", 0.95)
				end)
			end

			-- ── Slider ────────────────────────────────────────────────
			function SectionFunc:AddSlider(cfg)
				cfg = Library:MakeConfig({
					Title       = "Slider",
					Description = "",
					Max         = 100,
					Min         = 1,
					Increment   = 1,
					Default     = 1,
					Callback    = function() end,
				}, cfg or {})

				local Row = Instance.new("Frame")
				Row.Name                  = "Slider"
				Row.Parent                = SecList
				Row.BackgroundColor3      = Color3.fromRGB(255, 255, 255)
				Row.BackgroundTransparency = 0.95
				Row.BorderSizePixel       = 0
				Row.Size                  = UDim2.new(1, 0, 0, 35)
				Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 3)

				local STitle = Instance.new("TextLabel")
				STitle.Name                  = "Title"
				STitle.Parent                = Row
				STitle.BackgroundTransparency = 1
				STitle.BorderSizePixel       = 0
				STitle.Position              = UDim2.new(0, 10, 0, 0)
				STitle.Size                  = UDim2.new(1, -60, 1, 0)
				STitle.Font                  = Enum.Font.GothamBold
				STitle.Text                  = cfg.Title
				STitle.TextColor3            = Color3.fromRGB(255, 255, 255)
				STitle.TextSize              = 13
				STitle.TextXAlignment        = Enum.TextXAlignment.Left

				local SContent = Instance.new("TextLabel")
				SContent.Name                  = "Content"
				SContent.Parent                = Row
				SContent.BackgroundTransparency = 1
				SContent.BorderSizePixel       = 0
				SContent.Position              = UDim2.new(0, 10, 0, 22)
				SContent.Size                  = UDim2.new(1, -160, 1, 0)
				SContent.Font                  = Enum.Font.GothamBold
				SContent.Text                  = cfg.Description
				SContent.TextColor3            = Color3.fromRGB(100, 100, 100)
				SContent.TextSize              = 12
				SContent.TextXAlignment        = Enum.TextXAlignment.Left
				SContent.TextYAlignment        = Enum.TextYAlignment.Top
				Library:UpdateContent(SContent, STitle, Row)

				local Track = Instance.new("Frame")
				Track.Name              = "SliderFrame"
				Track.Parent            = Row
				Track.AnchorPoint       = Vector2.new(0, 0.5)
				Track.BackgroundColor3  = Color3.fromRGB(40, 40, 40)
				Track.BorderSizePixel   = 0
				Track.Position          = UDim2.new(1, -140, 0.5, 0)
				Track.Size              = UDim2.new(0, 130, 0, 10)
				Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

				-- White fill for slider (replaces green)
				local Fill = Instance.new("Frame")
				Fill.Name              = "SliderDraggable"
				Fill.Parent            = Track
				Fill.BackgroundColor3  = Color3.fromRGB(255, 255, 255)   -- white
				Fill.BorderSizePixel   = 0
				Fill.Size              = UDim2.new(0, 20, 1, 0)
				Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

				local Knob = Instance.new("Frame")
				Knob.Name              = "Circle"
				Knob.Parent            = Fill
				Knob.AnchorPoint       = Vector2.new(0, 0.5)
				Knob.BackgroundColor3  = Color3.fromRGB(220, 220, 220)
				Knob.BorderSizePixel   = 0
				Knob.Position          = UDim2.new(1, -6, 0.5, 0)
				Knob.Size              = UDim2.new(0, 14, 0, 14)
				Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

				-- Value box: dark bg with white text (replaces green bg)
				local ValBox = Instance.new("TextBox")
				ValBox.Name                  = "SliderValue"
				ValBox.Parent                = Row
				ValBox.AnchorPoint           = Vector2.new(0, 0.5)
				ValBox.BackgroundColor3      = Color3.fromRGB(35, 35, 35)   -- dark instead of green
				ValBox.BorderSizePixel       = 0
				ValBox.Position              = UDim2.new(1, -185, 0.5, 0)
				ValBox.Size                  = UDim2.new(0, 35, 0, 22)
				ValBox.Font                  = Enum.Font.GothamBold
				ValBox.PlaceholderText       = "..."
				ValBox.Text                  = ""
				ValBox.TextColor3            = Color3.fromRGB(255, 255, 255)
				ValBox.TextSize              = 11
				Instance.new("UICorner", ValBox).CornerRadius = UDim.new(0, 2)

				local HitArea = Instance.new("TextButton")
				HitArea.Name                  = "SliderHit"
				HitArea.Parent                = Track
				HitArea.BackgroundTransparency = 1
				HitArea.BorderSizePixel       = 0
				HitArea.Position              = UDim2.new(0, 0, 0.5, -15)
				HitArea.Size                  = UDim2.new(1, 0, 0, 30)
				HitArea.Text                  = ""
				HitArea.Active                = true
				HitArea.Selectable            = true
				HitArea.ZIndex                = 4

				local function Round(n, f)
					local r = math.floor(n / f + math.sign(n) * 0.5) * f
					if r < 0 then r = r + f end
					return r
				end

				local SliderFunc = { Value = cfg.Default }
				local dragging   = false

				function SliderFunc:Set(v)
					v = math.clamp(Round(v, cfg.Increment), cfg.Min, cfg.Max)
					self.Value = v
					ValBox.Text = tostring(v)
					TweenSvc:Create(Fill, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.fromScale((v - cfg.Min) / (cfg.Max - cfg.Min), 1)
					}):Play()
				end

				local function CalcFromInput(inputPos)
					local scale = math.clamp(
						(inputPos.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
					SliderFunc:Set(cfg.Min + (cfg.Max - cfg.Min) * scale)
				end

				HitArea.InputBegan:Connect(function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1
						or inp.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						CalcFromInput(inp.Position)
					end
				end)
				HitArea.InputEnded:Connect(function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1
						or inp.UserInputType == Enum.UserInputType.Touch then
						dragging = false
						cfg.Callback(SliderFunc.Value)
					end
				end)
				UIS.InputChanged:Connect(function(inp)
					if dragging and (
						inp.UserInputType == Enum.UserInputType.MouseMovement
						or inp.UserInputType == Enum.UserInputType.Touch
					) then
						CalcFromInput(inp.Position)
					end
				end)
				UIS.InputEnded:Connect(function(inp)
					if inp.UserInputType == Enum.UserInputType.Touch and dragging then
						dragging = false
						cfg.Callback(SliderFunc.Value)
					end
				end)

				Track.InputBegan:Connect(function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1
						or inp.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						CalcFromInput(inp.Position)
					end
				end)
				Track.InputEnded:Connect(function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1
						or inp.UserInputType == Enum.UserInputType.Touch then
						dragging = false
						cfg.Callback(SliderFunc.Value)
					end
				end)

				ValBox:GetPropertyChangedSignal("Text"):Connect(function()
					local clean = ValBox.Text:gsub("[^%d]", "")
					if clean ~= "" then
						local n = math.min(tonumber(clean), cfg.Max)
						if tostring(n) ~= ValBox.Text then ValBox.Text = tostring(n) end
					end
				end)
				ValBox.FocusLost:Connect(function()
					SliderFunc:Set(tonumber(ValBox.Text) or 0)
					cfg.Callback(SliderFunc.Value)
				end)

				SliderFunc:Set(cfg.Default)
				return SliderFunc
			end

			-- ── Dropdown ──────────────────────────────────────────────
			function SectionFunc:AddDropdown(cfg)
				cfg = Library:MakeConfig({
					Title       = "Dropdown",
					Description = "",
					Values      = {},
					Default     = "",
					Multi       = false,
					Callback    = function() end,
				}, cfg or {})

				local Row = Instance.new("Frame")
				Row.Name                  = "Dropdown"
				Row.Parent                = SecList
				Row.BackgroundColor3      = Color3.fromRGB(255, 255, 255)
				Row.BackgroundTransparency = 0.95
				Row.BorderSizePixel       = 0
				Row.Size                  = UDim2.new(1, 0, 0, 35)
				Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 3)

				local DTitle = Instance.new("TextLabel")
				DTitle.Name                  = "Title"
				DTitle.Parent                = Row
				DTitle.BackgroundTransparency = 1
				DTitle.BorderSizePixel       = 0
				DTitle.Position              = UDim2.new(0, 10, 0, 0)
				DTitle.Size                  = UDim2.new(1, -100, 1, 0)
				DTitle.Font                  = Enum.Font.GothamBold
				DTitle.Text                  = cfg.Title
				DTitle.TextColor3            = Color3.fromRGB(255, 255, 255)
				DTitle.TextSize              = 13
				DTitle.TextXAlignment        = Enum.TextXAlignment.Left

				local DContent = Instance.new("TextLabel")
				DContent.Name                  = "Content"
				DContent.Parent                = Row
				DContent.BackgroundTransparency = 1
				DContent.BorderSizePixel       = 0
				DContent.Position              = UDim2.new(0, 10, 0, 22)
				DContent.Size                  = UDim2.new(1, -100, 1, 0)
				DContent.Font                  = Enum.Font.GothamBold
				DContent.Text                  = cfg.Description
				DContent.TextColor3            = Color3.fromRGB(100, 100, 100)
				DContent.TextSize              = 12
				DContent.TextXAlignment        = Enum.TextXAlignment.Left
				DContent.TextYAlignment        = Enum.TextYAlignment.Top

				local Selects = Instance.new("Frame")
				Selects.Name              = "Selects"
				Selects.Parent            = Row
				Selects.AnchorPoint       = Vector2.new(0, 0.5)
				Selects.BackgroundColor3  = Color3.fromRGB(30, 30, 30)
				Selects.BorderSizePixel   = 0
				Selects.Position          = UDim2.new(1, -90, 0.5, 0)
				Selects.Size              = UDim2.new(0, 80, 0, 25)
				Instance.new("UICorner", Selects).CornerRadius = UDim.new(0, 5)

				local SelectText = Instance.new("TextLabel")
				SelectText.Name                  = "SelectText"
				SelectText.Parent                = Selects
				SelectText.BackgroundTransparency = 1
				SelectText.BorderSizePixel       = 0
				SelectText.Position              = UDim2.new(0, 4, 0, 0)
				SelectText.Size                  = UDim2.new(1, -22, 1, 0)
				SelectText.Font                  = Enum.Font.GothamBold
				SelectText.Text                  = ""
				SelectText.TextColor3            = Color3.fromRGB(255, 255, 255)
				SelectText.TextScaled            = true
				SelectText.TextWrapped           = true
				Instance.new("UITextSizeConstraint", SelectText).MaxTextSize = 12

				local DropArrow = Instance.new("ImageLabel")
				DropArrow.Parent                = Selects
				DropArrow.AnchorPoint           = Vector2.new(0, 0.5)
				DropArrow.BackgroundTransparency = 1
				DropArrow.BorderSizePixel       = 0
				DropArrow.Position              = UDim2.new(1, -18, 0.5, 0)
				DropArrow.Size                  = UDim2.new(0, 13, 0, 13)
				DropArrow.Image                 = "rbxassetid://80845745785361"

				local OpenBtn = Instance.new("TextButton")
				OpenBtn.Name                  = "Drop_Click"
				OpenBtn.Parent                = Selects
				OpenBtn.BackgroundTransparency = 1
				OpenBtn.BorderSizePixel       = 0
				OpenBtn.Size                  = UDim2.new(1, 0, 1, 0)
				OpenBtn.Text                  = ""
				OpenBtn.Active                = true
				OpenBtn.Selectable            = true
				OpenBtn.ZIndex                = 4

				Library:UpdateContent(DContent, DTitle, Row)

				-- ── Dropdown popup ───────────────────────────────────
				local DList = Instance.new("Frame")
				DList.Name                  = "DropdownList"
				DList.Parent                = DropdownZone
				DList.AnchorPoint           = Vector2.new(0.5, 0.5)
				DList.BackgroundColor3      = Color3.fromRGB(18, 18, 18)
				DList.BorderSizePixel       = 0
				DList.Position              = UDim2.new(0.5, 0, 0.5, 0)
				DList.Size                  = UDim2.new(0, math.min(400, WW - 20), 0, math.min(250, WH - 30))
				DList.Visible               = false
				DList.ZIndex                = 6
				Instance.new("UICorner", DList).CornerRadius = UDim.new(0, 5)
				local DLStroke = Instance.new("UIStroke", DList)
				DLStroke.Color        = Color3.fromRGB(100, 100, 100)
				DLStroke.Transparency = 0.5

				local Topbar = Instance.new("Frame")
				Topbar.Parent                = DList
				Topbar.BackgroundTransparency = 1
				Topbar.BorderSizePixel       = 0
				Topbar.Size                  = UDim2.new(1, 0, 0, 50)
				Topbar.ZIndex                = 7

				local DPopTitle = Instance.new("TextLabel")
				DPopTitle.Parent                = Topbar
				DPopTitle.BackgroundTransparency = 1
				DPopTitle.BorderSizePixel       = 0
				DPopTitle.Position              = UDim2.new(0, 12, 0, 0)
				DPopTitle.Size                  = UDim2.new(1, -180, 1, -5)
				DPopTitle.Font                  = Enum.Font.GothamBold
				DPopTitle.Text                  = cfg.Title
				DPopTitle.TextColor3            = Color3.fromRGB(255, 255, 255)
				DPopTitle.TextSize              = 13
				DPopTitle.TextWrapped           = true
				DPopTitle.TextXAlignment        = Enum.TextXAlignment.Left
				DPopTitle.ZIndex                = 7

				local SearchF2 = Instance.new("Frame")
				SearchF2.Parent              = Topbar
				SearchF2.BackgroundColor3    = Color3.fromRGB(15, 15, 15)
				SearchF2.BorderSizePixel     = 0
				SearchF2.Position            = UDim2.new(1, -148, 0, 8)
				SearchF2.Size               = UDim2.new(0, 98, 0, 30)
				SearchF2.ZIndex              = 7
				Instance.new("UICorner", SearchF2).CornerRadius = UDim.new(0, 5)
				local SF2Stroke = Instance.new("UIStroke", SearchF2)
				SF2Stroke.Color        = Color3.fromRGB(100, 100, 100)
				SF2Stroke.Transparency = 0.74

				local SF2Icon = Instance.new("ImageLabel")
				SF2Icon.AnchorPoint          = Vector2.new(0, 0.5)
				SF2Icon.BackgroundTransparency = 1
				SF2Icon.BorderSizePixel      = 0
				SF2Icon.Parent               = SearchF2
				SF2Icon.Position             = UDim2.new(0, 8, 0.5, 0)
				SF2Icon.Size                 = UDim2.new(0, 13, 0, 13)
				SF2Icon.Image                = "rbxassetid://71309835376233"
				SF2Icon.ZIndex               = 8

				local SF2Box = Instance.new("TextBox")
				SF2Box.Parent                = SearchF2
				SF2Box.BackgroundTransparency = 1
				SF2Box.BorderSizePixel       = 0
				SF2Box.Position              = UDim2.new(0, 28, 0, 0)
				SF2Box.Size                  = UDim2.new(1, -30, 1, 0)
				SF2Box.Font                  = Enum.Font.GothamBold
				SF2Box.PlaceholderText       = "Search..."
				SF2Box.Text                  = ""
				SF2Box.TextColor3            = Color3.fromRGB(255, 255, 255)
				SF2Box.TextSize              = 11
				SF2Box.TextXAlignment        = Enum.TextXAlignment.Left
				SF2Box.ZIndex                = 8

				local CloseBtn2 = Instance.new("TextButton")
				CloseBtn2.Parent                = Topbar
				CloseBtn2.BackgroundTransparency = 1
				CloseBtn2.BorderSizePixel       = 0
				CloseBtn2.Position              = UDim2.new(1, -40, 0, 8)
				CloseBtn2.Size                  = UDim2.new(0, 34, 0, 34)
				CloseBtn2.Text                  = ""
				CloseBtn2.Active                = true
				CloseBtn2.Selectable            = true
				CloseBtn2.ZIndex                = 8

				local CloseIco2 = Instance.new("ImageLabel", CloseBtn2)
				CloseIco2.AnchorPoint          = Vector2.new(0.5, 0.5)
				CloseIco2.BackgroundTransparency = 1
				CloseIco2.BorderSizePixel      = 0
				CloseIco2.Position             = UDim2.new(0.5, 0, 0.5, 0)
				CloseIco2.Size                 = UDim2.new(0, 18, 0, 18)
				CloseIco2.Image                = "rbxassetid://105957381820378"
				CloseIco2.ImageRectOffset      = Vector2.new(480, 0)
				CloseIco2.ImageRectSize        = Vector2.new(96, 96)
				CloseIco2.ZIndex               = 9

				local RealList = Instance.new("ScrollingFrame")
				RealList.Name                  = "Real_List"
				RealList.Parent                = DList
				RealList.BackgroundColor3      = Color3.fromRGB(12, 12, 12)
				RealList.BorderSizePixel       = 0
				RealList.Position              = UDim2.new(0, 8, 0, 52)
				RealList.Selectable            = false
				RealList.ScrollBarThickness    = 2
				RealList.Size                  = UDim2.new(1, -16, 1, -62)
				RealList.ZIndex                = 7
				RealList.ScrollingEnabled      = true
				RealList.Active                = true
				Instance.new("UICorner", RealList).CornerRadius = UDim.new(0, 5)

				local RLList = Instance.new("UIListLayout", RealList)
				RLList.SortOrder = Enum.SortOrder.LayoutOrder
				RLList.Padding   = UDim.new(0, 4)
				Library:UpdateScrolling(RealList, RLList)

				local RLPad = Instance.new("UIPadding", RealList)
				RLPad.PaddingBottom = UDim.new(0, 6)
				RLPad.PaddingLeft   = UDim.new(0, 6)
				RLPad.PaddingRight  = UDim.new(0, 6)
				RLPad.PaddingTop    = UDim.new(0, 6)

				OpenBtn.Activated:Connect(function()
					DropdownZone.Visible = true
					DList.Visible        = true
					Library:TweenInstance(DropdownZone, 0.2, "BackgroundTransparency", 0.3)
				end)
				CloseBtn2.Activated:Connect(function()
					DList.Visible = false
					Library:TweenInstance(DropdownZone, 0.2, "BackgroundTransparency", 1)
					task.wait(0.25)
					DropdownZone.Visible = false
				end)

				SF2Box:GetPropertyChangedSignal("Text"):Connect(function()
					local q = SF2Box.Text:lower()
					for _, v in next, RealList:GetChildren() do
						if v:IsA("Frame") then
							local t = v:FindFirstChild("Title")
							v.Visible = (q == "" or (t and t.Text:lower():find(q, 1, true)))
						end
					end
				end)

				local DropFunc = { Value = typeof(cfg.Default) == "table" and cfg.Default or (cfg.Default ~= "" and {cfg.Default} or {}) }

				function DropFunc:Set(newVal)
					if newVal then self.Value = newVal end
					for _, v in next, RealList:GetChildren() do
						if v:IsA("Frame") then
							local t = v:FindFirstChild("Title")
							if t and table.find(self.Value, t.Text) then
								Library:TweenInstance(v, 0.2, "BackgroundTransparency", 0)
								Library:TweenInstance(t, 0.2, "TextTransparency", 0)
							else
								Library:TweenInstance(v, 0.2, "BackgroundTransparency", 0.98)
								Library:TweenInstance(t, 0.2, "TextTransparency", 0.5)
							end
						end
					end
					local joined = table.concat(self.Value, ", ")
					SelectText.Text = joined
					cfg.Callback(cfg.Multi and self.Value or (self.Value[1] or ""))
				end

				function DropFunc:Add(val)
					local Opt = Instance.new("Frame")
					Opt.Name                  = "Option"
					Opt.Parent                = RealList
					Opt.BackgroundColor3      = Color3.fromRGB(255, 255, 255)
					Opt.BackgroundTransparency = 0.98
					Opt.BorderSizePixel       = 0
					Opt.Size                  = UDim2.new(1, 0, 0, 34)
					Opt.ZIndex                = 8
					Instance.new("UICorner", Opt).CornerRadius = UDim.new(0, 4)

					-- White light gradient for dropdown options (replaces green)
					local OptGrad = Instance.new("UIGradient")
					OptGrad.Color = ColorSequence.new {
						ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)),
						ColorSequenceKeypoint.new(0.51, Color3.fromRGB(200, 200, 200)),  -- light gray/white
						ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)),
					}
					OptGrad.Transparency = NumberSequence.new {
						NumberSequenceKeypoint.new(0.00, 0.5),
						NumberSequenceKeypoint.new(0.50, 0.49),
						NumberSequenceKeypoint.new(1.00, 0.44),
					}
					OptGrad.Parent = Opt

					local OptTitle = Instance.new("TextLabel")
					OptTitle.Name                  = "Title"
					OptTitle.Parent                = Opt
					OptTitle.BackgroundTransparency = 1
					OptTitle.BorderSizePixel       = 0
					OptTitle.Size                  = UDim2.new(1, -10, 1, 0)
					OptTitle.Position              = UDim2.new(0, 6, 0, 0)
					OptTitle.Font                  = Enum.Font.GothamBold
					OptTitle.Text                  = val
					OptTitle.TextColor3            = Color3.fromRGB(255, 255, 255)
					OptTitle.TextSize              = 12
					OptTitle.TextTransparency      = 0.5
					OptTitle.TextXAlignment        = Enum.TextXAlignment.Left
					OptTitle.ZIndex                = 9

					local OptBtn = Instance.new("TextButton")
					OptBtn.Parent                = Opt
					OptBtn.BackgroundTransparency = 1
					OptBtn.BorderSizePixel       = 0
					OptBtn.Size                  = UDim2.new(1, 0, 1, 0)
					OptBtn.Text                  = ""
					OptBtn.Active                = true
					OptBtn.Selectable            = true
					OptBtn.ZIndex                = 10

					OptBtn.Activated:Connect(function()
						if cfg.Multi then
							local idx = table.find(DropFunc.Value, OptTitle.Text)
							if idx then
								table.remove(DropFunc.Value, idx)
							else
								table.insert(DropFunc.Value, OptTitle.Text)
							end
							DropFunc:Set(DropFunc.Value)
						else
							DropFunc.Value = { OptTitle.Text }
							DropFunc:Set(DropFunc.Value)
						end
					end)
				end

				function DropFunc:Clear()
					for _, v in next, RealList:GetChildren() do
						if v:IsA("Frame") then v:Destroy() end
					end
				end

				function DropFunc:Refresh(list)
					self:Clear()
					for _, v in next, list do self:Add(v) end
				end

				DropFunc:Refresh(cfg.Values)
				DropFunc:Set(DropFunc.Value)
				return DropFunc
			end

			-- ── Input (TextBox) ───────────────────────────────────────
			function SectionFunc:AddInput(cfg)
				cfg = Library:MakeConfig({
					Title       = "Textbox",
					Description = "",
					PlaceHolder = "",
					Default     = "",
					Callback    = function() end,
				}, cfg or {})

				local Row = Instance.new("Frame")
				Row.Name                  = "Input"
				Row.Parent                = SecList
				Row.BackgroundColor3      = Color3.fromRGB(255, 255, 255)
				Row.BackgroundTransparency = 0.95
				Row.BorderSizePixel       = 0
				Row.Size                  = UDim2.new(1, 0, 0, 35)
				Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 3)

				local ITitle = Instance.new("TextLabel")
				ITitle.Name                  = "Title"
				ITitle.Parent                = Row
				ITitle.BackgroundTransparency = 1
				ITitle.BorderSizePixel       = 0
				ITitle.Position              = UDim2.new(0, 10, 0, 0)
				ITitle.Size                  = UDim2.new(1, -60, 1, 0)
				ITitle.Font                  = Enum.Font.GothamBold
				ITitle.Text                  = cfg.Title
				ITitle.TextColor3            = Color3.fromRGB(255, 255, 255)
				ITitle.TextSize              = 13
				ITitle.TextXAlignment        = Enum.TextXAlignment.Left

				local IContent = Instance.new("TextLabel")
				IContent.Name                  = "Content"
				IContent.Parent                = Row
				IContent.BackgroundTransparency = 1
				IContent.BorderSizePixel       = 0
				IContent.Position              = UDim2.new(0, 10, 0, 22)
				IContent.Size                  = UDim2.new(1, -160, 1, 0)
				IContent.Font                  = Enum.Font.GothamBold
				IContent.Text                  = cfg.Description
				IContent.TextColor3            = Color3.fromRGB(100, 100, 100)
				IContent.TextSize              = 12
				IContent.TextXAlignment        = Enum.TextXAlignment.Left
				IContent.TextYAlignment        = Enum.TextYAlignment.Top
				Library:UpdateContent(IContent, ITitle, Row)

				local TBFrame = Instance.new("Frame")
				TBFrame.Name              = "TextboxFrame"
				TBFrame.Parent            = Row
				TBFrame.AnchorPoint       = Vector2.new(0, 0.5)
				TBFrame.BackgroundColor3  = Color3.fromRGB(25, 25, 25)
				TBFrame.BorderSizePixel   = 0
				TBFrame.Position          = UDim2.new(1, -140, 0.5, 0)
				TBFrame.Size              = UDim2.new(0, 130, 0, 28)
				Instance.new("UICorner", TBFrame).CornerRadius = UDim.new(0, 3)

				local WriteIcon = Instance.new("ImageLabel")
				WriteIcon.AnchorPoint          = Vector2.new(0, 0.5)
				WriteIcon.BackgroundTransparency = 1
				WriteIcon.BorderSizePixel      = 0
				WriteIcon.Parent               = TBFrame
				WriteIcon.Position             = UDim2.new(0, 8, 0.5, 0)
				WriteIcon.Size                 = UDim2.new(0, 13, 0, 13)
				WriteIcon.Image                = "rbxassetid://126409600467363"

				local RTB = Instance.new("TextBox")
				RTB.Name                  = "RealTextBox"
				RTB.Parent                = TBFrame
				RTB.BackgroundTransparency = 1
				RTB.BorderSizePixel       = 0
				RTB.Position              = UDim2.new(0, 28, 0, 0)
				RTB.Size                  = UDim2.new(1, -30, 1, 0)
				RTB.Font                  = Enum.Font.GothamBold
				RTB.PlaceholderText       = cfg.PlaceHolder
				RTB.Text                  = cfg.Default
				RTB.TextColor3            = Color3.fromRGB(255, 255, 255)
				RTB.TextSize              = 12
				RTB.TextXAlignment        = Enum.TextXAlignment.Left

				RTB.FocusLost:Connect(function()
					cfg.Callback(RTB.Text)
				end)
				cfg.Callback(RTB.Text)
			end

			-- ── Separator ─────────────────────────────────────────────
			function SectionFunc:AddSeperator(text)
				local Sep = Instance.new("Frame")
				Sep.Name                  = "Seperator"
				Sep.Parent                = SecList
				Sep.BackgroundTransparency = 1
				Sep.BorderSizePixel       = 0
				Sep.Size                  = UDim2.new(1, 0, 0, 20)

				local SepLbl = Instance.new("TextLabel")
				SepLbl.Parent                = Sep
				SepLbl.BackgroundTransparency = 1
				SepLbl.BorderSizePixel       = 0
				SepLbl.Position              = UDim2.new(0, 10, 0, 0)
				SepLbl.Size                  = UDim2.new(1, -10, 1, 0)
				SepLbl.Font                  = Enum.Font.GothamBold
				SepLbl.Text                  = text or ""
				SepLbl.TextColor3            = Color3.fromRGB(255, 255, 255)
				SepLbl.TextSize              = 13
				SepLbl.TextXAlignment        = Enum.TextXAlignment.Left
			end

			-- ── Paragraph ─────────────────────────────────────────────
			function SectionFunc:AddParagraph(cfg)
				cfg = Library:MakeConfig({
					Title   = "Paragraph",
					Content = "",
				}, cfg or {})

				local Para = Instance.new("Frame")
				Para.Name                  = "Paragraph"
				Para.Parent                = SecList
				Para.BackgroundColor3      = Color3.fromRGB(255, 255, 255)
				Para.BackgroundTransparency = 0.95
				Para.BorderSizePixel       = 0
				Para.Size                  = UDim2.new(1, 0, 0, 45)
				Instance.new("UICorner", Para).CornerRadius = UDim.new(0, 3)

				local PTitle = Instance.new("TextLabel")
				PTitle.Name                  = "Title"
				PTitle.Parent                = Para
				PTitle.BackgroundTransparency = 1
				PTitle.BorderSizePixel       = 0
				PTitle.Position              = UDim2.new(0, 10, 0, 7)
				PTitle.Size                  = UDim2.new(1, -60, 0, 16)
				PTitle.Font                  = Enum.Font.GothamBold
				PTitle.Text                  = cfg.Title
				PTitle.TextColor3            = Color3.fromRGB(255, 255, 255)
				PTitle.TextSize              = 13
				PTitle.TextXAlignment        = Enum.TextXAlignment.Left

				local PContent = Instance.new("TextLabel")
				PContent.Name                  = "Content"
				PContent.Parent                = Para
				PContent.BackgroundTransparency = 1
				PContent.BorderSizePixel       = 0
				PContent.Position              = UDim2.new(0, 10, 0, 22)
				PContent.Size                  = UDim2.new(1, -10, 1, 0)
				PContent.Font                  = Enum.Font.GothamBold
				PContent.Text                  = cfg.Content
				PContent.TextColor3            = Color3.fromRGB(100, 100, 100)
				PContent.TextSize              = 12
				PContent.TextXAlignment        = Enum.TextXAlignment.Left
				PContent.TextYAlignment        = Enum.TextYAlignment.Top
				Library:UpdateContent(PContent, PTitle, Para)

				local ParaFunc = {}
				function ParaFunc:SetTitle(t) PTitle.Text = t end
				function ParaFunc:SetDesc(t)
					PContent.Text = t
					Library:UpdateContent(PContent, PTitle, Para)
				end
				return ParaFunc
			end

			return SectionFunc
		end

		return TabFunc
	end

	return Tab
end

return Library
