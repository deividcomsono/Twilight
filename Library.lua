local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")

local Library = {
	LocalPlayer = Players.LocalPlayer,
	IsMobile = UserInputService.TouchEnabled,

	ScreenGui = nil,
	ToggleKeybind = Enum.KeyCode.RightControl,
	Opened = true,
	Unloaded = false,

	Flags = {},
	Labels = {},
	Buttons = {},
	Toggles = {},
	Options = {},

	Connections = {},
	UnloadCallbacks = {},

	Font = Font.fromEnum(Enum.Font.Code),
	Theme = {
		TitleBarColor = Color3.fromRGB(10, 10, 10),
		TabBarColor = Color3.fromRGB(10, 10, 10),
		ContainerColor = Color3.fromRGB(15, 15, 15),
		SectionColor = Color3.fromRGB(20, 20, 20),
		ButtonColor = Color3.fromRGB(25, 25, 25),
		BorderColor = Color3.fromRGB(45, 45, 45),
		FillColor = Color3.fromRGB(90, 90, 90),
		FillBorderColor = Color3.fromRGB(60, 60, 60),
		FontColor = Color3.new(1, 1, 1),
	} :: Themes,
	ThemeInstances = {},
}

local Templates = {
	--// UI \\-
	Frame = {
		BorderSizePixel = 0,
	},
	ImageLabel = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	},
	ImageButton = {
		AutoButtonColor = false,
		BorderSizePixel = 0,
	},
	ScrollingFrame = {
		BorderSizePixel = 0,
	},
	TextLabel = {
		BorderSizePixel = 0,
		RichText = true,
		TextColor3 = "FontColor",
	},
	TextButton = {
		AutoButtonColor = false,
		BorderSizePixel = 0,
		RichText = true,
		TextColor3 = "FontColor",
	},
	TextBox = {
		BorderSizePixel = 0,
		RichText = true,
		TextColor3 = "FontColor",
	},
	UIListLayout = {
		SortOrder = Enum.SortOrder.LayoutOrder,
	},
	UIStroke = {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	},

	--// Library \\--
	Notification = {
		Title = "Title",
		Content = "Content",
		Duration = 5,
	},
	Window = {
		Title = "Template",
		TopTabBar = false,
		OutlineThickness = 2,
		Width = 700,
		Height = 700,
		Font = Enum.Font.Code,
		FontSize = 16,
		SectionFontSize = 18,
		MaxDialogButtonsPerLine = 4,
		MaxDropdownItems = 8,
		Theme = Library.Theme,
		TweenTime = 0.1,
		ToggleKeybind = Enum.KeyCode.RightControl,
	},
	Dialog = {
		Title = "Title",
		Content = "Content",
		Buttons = {
			{
				Title = "Close",
			},
		},
	},
	Label = {
		Alignment = Enum.TextXAlignment.Left,
	},
	Toggle = {
		Value = false,
	},
	Slider = {
		Suffix = "",
		Min = 0,
		Max = 100,
		Increment = 1,
		Value = 50,
	},
	Input = {
		ClearOnFocus = false,
		Placeholder = "Placeholder",
		Value = "",
	},
	Dropdown = {
		Multi = false,
		AllowNull = true,
		SpecialType = "",
	},
	Keypicker = {
		Mode = "Toggle",
	},
	Colorpicker = {
		Value = Color3.new(1, 1, 1),
	},
}

export type Themes = {
	TitleBarColor: Color3,
	TabBarColor: Color3,
	ContainerColor: Color3,
	SectionColor: Color3,
	ButtonColor: Color3,
	BorderColor: Color3,
	FillColor: Color3,
	FillBorderColor: Color3,
	FontColor: Color3,
}

export type NotificationInfo = {
	Title: string,
	Content: string,
	Duration: number | Instance?,
}

export type WindowInfo = {
	Title: string,
	TopTabBar: boolean,
	OutlineThickness: number,
	Width: number,
	Height: number,
	Font: Font,
	FontSize: number,
	SectionFontSize: number,
	MaxDialogButtonsPerLine: number,
	MaxDropdownItems: number,
	Theme: Themes,
	TweenTime: number,
	ToggleKeybind: Enum.KeyCode,
}

export type DialogInfo = {
	Title: string,
	Content: string,
	Buttons: { [any]: any },
}

export type TabTable = {
	CreateSection: (SectionName: string) -> SectionTable,

	Hover: (Hovering: boolean) -> (),
	Show: () -> (),
	Hide: () -> (),
	Set: () -> (),
}

export type SectionTable = {
	CreateDivider: (Offset: number) -> DividerTable,
	CreateLabel: (LabelInfo: LabelInfo) -> LabelTable,
	CreateButton: (ButtonInfo: ButtonInfo) -> ButtonTable,
	CreateToggle: (ToggleInfo: ToggleInfo) -> ToggleTable,
	CreateSlider: (SliderInfo: SliderInfo) -> SliderTable,
	CreateInput: (InputInfo: InputInfo) -> InputTable,
	CreateDropdown: (DropdownInfo: DropdownInfo) -> DropdownTable,
	CreateKeypicker: (KeypickerInfo: KeypickerInfo) -> KeypickerTable,
	CreateColorpicker: (ColorpickerInfo: ColorpickerInfo) -> ColorpickerTable,

	Show: () -> (),
	Hide: () -> (),
	Toggle: () -> (),
}

export type DividerTable = {
	SetOffset: (NewOffset: number) -> (),

	Offset: number,
}

export type LabelInfo = {
	Text: string,
	Alignment: Enum.TextXAlignment?,
}

export type LabelTable = {
	SetText: (NewText: string) -> (),
	SetAlignment: (NewAlignment: Enum.TextXAlignment) -> (),

	Text: string,
	Alignment: Enum.TextXAlignment,

	Type: "Label",
}

export type ButtonInfo = {
	Title: string,
	Description: string?,
	Callback: () -> (),
}

export type ButtonTable = {
	SetTitle: (NewTitle: string) -> (),
	SetDescription: (NewDescription: string) -> (),
	SetCallback: (NewCallback: () -> ()) -> (),

	Title: string,
	Description: string?,
	Callback: () -> (),

	Type: "Button",
}

export type ToggleInfo = {
	Title: string,
	Description: string?,
	Value: boolean?,
	Callback: (Value: boolean) -> (),
	KeypickerInfo: KeypickerInfo?,
	SkipInitialCallback: boolean?,
}

export type ToggleTable = {
	CreateSlider: (SliderInfo: ToggleSliderInfo) -> ToggleSliderTable,
	CreateKeypicker: (KeypickerInfo: ToggleKeypickerInfo) -> ToggleKeypickerTable,

	SetTitle: (NewTitle: string) -> (),
	SetDescription: (NewDescription: string) -> (),
	SetValue: (NewValue: boolean, IgnoreCallback: boolean?) -> (),
	SetCallback: (NewCallback: (Value: boolean) -> ()) -> (),
	OnChanged: (Callback: (Value: boolean) -> ()) -> (),

	Title: string,
	Description: string?,
	Value: boolean,
	Callback: (Value: boolean) -> (),
	Changed: (Value: boolean) -> (),

	Slider: ToggleSliderTable?,
	Keypicker: ToggleKeypickerTable?,
	Type: "Toggle",
}

export type SliderInfo = {
	Title: string,
	Description: string?,
	Suffix: string?,
	Min: number,
	Max: number,
	Increment: number,
	Value: number,
	Callback: (Value: number) -> (),
	SkipInitialCallback: boolean?,
}

export type SliderTable = {
	SetTitle: (NewTitle: string) -> (),
	SetDescription: (NewDescription: string) -> (),
	SetMin: (NewMin: number) -> (),
	SetMax: (NewMax: number) -> (),
	SetIncrement: (NewIncrement: number) -> (),
	SetValue: (NewValue: number, IgnoreCallback: boolean?) -> (),
	SetCallback: (NewCallback: (Value: number) -> ()) -> (),
	OnChanged: (Callback: (Value: number) -> ()) -> (),

	Title: string,
	Description: string?,
	Suffix: string,
	Min: number,
	Max: number,
	Increment: number,
	Value: number,
	Callback: (Value: number) -> (),
	Changed: (Value: number) -> (),

	Type: "Slider",
}

export type ToggleSliderInfo = {
	Suffix: string?,
	Min: number,
	Max: number,
	Increment: number,
	Value: number,
	Callback: (Value: number) -> (),
	SkipInitialCallback: boolean?,
}

export type ToggleSliderTable = {
	SetMin: (NewMin: number) -> (),
	SetMax: (NewMax: number) -> (),
	SetIncrement: (NewIncrement: number) -> (),
	SetValue: (NewValue: number, IgnoreCallback: boolean?) -> (),
	SetCallback: (NewCallback: (Value: number) -> ()) -> (),
	OnChanged: (Callback: (Value: number) -> ()) -> (),

	Suffix: string,
	Min: number,
	Max: number,
	Increment: number,
	Value: number,
	Callback: (Value: number) -> (),
	Changed: (Value: number) -> (),

	SliderValue: TextLabel,
	Type: "Slider",
}

export type InputInfo = {
	Title: string,
	Description: string?,
	ClearOnFocus: boolean?,
	Placeholder: string,
	Value: string?,
	Callback: (Value: string) -> (),
	SkipInitialCallback: boolean?,
}

export type InputTable = {
	SetTitle: (NewTitle: string) -> (),
	SetDescription: (NewDescription: string) -> (),
	SetClearOnFocus: (NewClearOnFocus: boolean) -> (),
	SetPlaceholder: (NewPlaceholder: string) -> (),
	SetValue: (NewValue: string, IgnoreCallback: boolean?) -> (),
	SetCallback: (NewCallback: (Value: string) -> ()) -> (),
	OnChanged: (Callback: (Value: string) -> ()) -> (),

	Title: string,
	Description: string?,
	ClearOnFocus: boolean?,
	Placeholder: string,
	Value: string,
	Callback: (Value: string) -> (),
	Changed: (Value: string) -> (),

	Type: "Input",
}

export type DropdownInfo = {
	Title: string,
	Description: string?,
	Value: string | { [any]: string },
	Values: { [any]: any },
	Multi: boolean?,
	AllowNull: boolean?,
	SpecialType: string?,
	Callback: (Value: string) -> (),
	SkipInitialCallback: boolean?,
}

export type DropdownTable = {
	SetTitle: (NewTitle: string) -> (),
	SetDescription: (NewDescription: string) -> (),
	SetValue: (NewValue: string | { [any]: string }, IgnoreCallback: boolean?) -> (),
	SetValues: (NewValue: { [any]: any }) -> (),
	SetCallback: (NewCallback: (Value: string | { [any]: any }) -> ()) -> (),
	OnChanged: (Callback: (Value: string | { [any]: any }) -> ()) -> (),

	GetActiveValues: () -> number,

	Title: string,
	Description: string?,
	Value: string,
	Values: { [any]: any },
	Multi: boolean,
	AllowNull: boolean,
	SpecialType: string,
	Callback: (Value: string | { [any]: string }) -> (),
	Changed: (Value: string | { [any]: string }) -> (),

	Type: "Dropdown",
}

export type KeypickerInfo = {
	Title: string,
	Description: string?,
	Keybind: Enum.KeyCode | Enum.UserInputType?,
	Mode: "Hold" | "Toggle" | "Always"?,
	Callback: (Value: boolean) -> (),
}

export type KeypickerTable = {
	SetTitle: (NewTitle: string) -> (),
	SetDescription: (NewDescription: string) -> (),
	SetKeybind: (NewKeybind: Enum.KeyCode | Enum.UserInputState | nil, Picking: boolean?) -> (),
	SetMode: (NewMode: string) -> (),
	SetState: (NewState: boolean) -> (),
	SetCallback: (NewCallback: (Value: boolean) -> ()) -> (),
	OnChanged: (Callback: (Value: boolean) -> ()) -> (),

	Title: string,
	Description: string?,
	Keybind: Enum.KeyCode | Enum.UserInputType?,
	Mode: "Hold" | "Toggle" | "Always",
	State: boolean,
	Callback: (Value: boolean) -> (),
	Changed: (Value: boolean) -> (),

	Type: "Keypicker",
}

export type ToggleKeypickerInfo = {
	Keybind: Enum.KeyCode | Enum.UserInputType?,
	Mode: "Hold" | "Toggle" | "Always"?,
	SyncToggleState: boolean?,
	Callback: (Value: boolean) -> (),
}

export type ToggleKeypickerTable = {
	SetKeybind: (NewKeybind: Enum.KeyCode | Enum.UserInputState | nil, Picking: boolean?) -> (),
	SetState: (NewState: boolean) -> (),
	SetMode: (NewMode: string) -> (),
	SetCallback: (NewCallback: (Value: boolean) -> ()) -> (),
	OnChanged: (Callback: (Value: boolean) -> ()) -> (),

	Keybind: Enum.KeyCode | Enum.UserInputType?,
	Mode: "Hold" | "Toggle" | "Always"?,
	SyncToggleState: boolean?,
	State: boolean,
	Callback: (Value: boolean) -> (),
	Changed: (Value: boolean) -> (),

	Type: "Keypicker",
}

export type ColorpickerInfo = {
	Title: string,
	Description: string?,
	Value: Color3,
	Callback: (Value: Color3) -> (),
	SkipInitialCallback: boolean?,
}

export type ColorpickerTable = {
	SetTitle: (NewTitle: string) -> (),
	SetDescription: (NewDescription: string) -> (),
	SetValue: (NewValue: Color3, IgnoreCallback: boolean?) -> (),
	SetCallback: (NewCallback: (Value: Color3) -> ()) -> (),
	OnChanged: (Callback: (Value: Color3) -> ()) -> (),

	Title: string,
	Description: string?,
	Value: Color3,
	Callback: (Value: Color3) -> (),
	Changed: (Value: Color3) -> (),

	Hue: number,
	Sat: number,
	Vib: number,

	Type: "Colorpicker",
}

--// Functions \\--
local function IsHoverInput(Input: InputObject)
	return (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
		and Input.UserInputState == Enum.UserInputState.Change
end
local function IsClickInput(Input: InputObject)
	return (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch)
		and Input.UserInputState == Enum.UserInputState.Begin
end
local function Round(Number, Factor)
	local Result = math.floor(Number / Factor + (math.sign(Number) * 0.5)) * Factor
	if Result < 0 then
		Result = Result + Factor
	end
	return Result
end

local function GetTableSize(Table: { [any]: any })
	local Size = 0

	for _, _ in pairs(Table) do
		Size += 1
	end

	return Size
end

local function FillInstance(Table: { [string]: any }, Instance: GuiObject)
	--[[
		Example:
		TextColor3 = "FontColor"
		k = "TextColor3" = Property
		v = "FontColor" = Theme
	]]
	for k, v in pairs(Table) do
		if Library.Theme[v] then
			Instance[k] = Library.Theme[v]
			Library:AddThemeTag(v, Instance, k)
			continue
		end
		Instance[k] = v
	end
end

local function New(ClassName: string, Properties: { [string]: any }): any
	local Instance = Instance.new(ClassName)

	FillInstance(Templates[ClassName] or {}, Instance)
	FillInstance(Properties, Instance)

	return Instance
end

local function Validate(Table: { [string]: any }, Template: { [string]: any }): { [string]: any }
	if typeof(Table) ~= "table" then
		return Template
	end

	for k, v in pairs(Template) do
		if typeof(v) == "table" then
			Table[k] = Validate(Table[k], v)
		elseif Table[k] == nil then
			Table[k] = v
		end
	end

	return Table
end

local FetchIcons, Icons = pcall(function()
	return loadstring(
		game:HttpGet("https://github.com/latte-soft/lucide-roblox/releases/latest/download/lucide-roblox.luau")
	)()
end)
local function GetIcon(IconName: string)
	if not FetchIcons then
		return
	end
	local Success, Icon = pcall(Icons.GetAsset, IconName, 48)
	if not Success then
		return
	end
	return Icon
end

local function ParentUI(UI: Instance)
	if not pcall(function()
		UI.Parent = gethui and gethui() or CoreGui
	end) then
		UI.Parent = Library.LocalPlayer:WaitForChild("PlayerGui")
	end
end

--// Main Instances \\-
local ScreenGui = New("ScreenGui", {
	Name = "Twilight",
	ResetOnSpawn = false,
})
ParentUI(ScreenGui)
Library.ScreenGui = ScreenGui

local MainFrame = New("Frame", {
	BackgroundTransparency = 1,
	Name = "Main",
	Position = UDim2.fromOffset(0, 0),
	Size = UDim2.fromOffset(0, 0),
	Parent = ScreenGui,
})

local NotificationsFrame = New("Frame", {
	AnchorPoint = Vector2.new(1, 0.5),
	BackgroundTransparency = 1,
	Name = "Notifications",
	Position = UDim2.new(1, -8, 0.5, 0),
	Size = UDim2.new(0, 300, 1, -16),
	ZIndex = 2,
	Parent = ScreenGui,
})

New("UIListLayout", {
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	Padding = UDim.new(0, 8),
	VerticalAlignment = Enum.VerticalAlignment.Bottom,
	Parent = NotificationsFrame,
})

local ButtonIcon = GetIcon("chevron-right")
local OpenIcon = GetIcon("chevron-down")

--// Lib Functions \\--
function Library:AddThemeTag(ThemeTag: string, Instance: GuiObject, Property: string)
	if not Library.ThemeInstances[ThemeTag] then
		Library.ThemeInstances[ThemeTag] = {}
	end

	Library.ThemeInstances[ThemeTag][Instance] = Property
end

function Library:ChangeTheme(ThemeTag: string, NewColor: Color3)
	Library.Theme[ThemeTag] = NewColor

	for Instance, Property in pairs(Library.ThemeInstances[ThemeTag] or {}) do
		Instance[Property] = NewColor
	end
end

function Library:GetDarkerColor(Color: Color3): Color3
	local H, S, V = Color:ToHSV()
	return Color3.fromHSV(H, S, V / 2)
end

function Library:GetTextBounds(Text: string, Font: Font, Size: number, Width: number?): (number, number)
	local Params = Instance.new("GetTextBoundsParams")
	Params.Text = Text
	Params.Font = Font
	Params.Size = Size
	Params.Width = Width or workspace.CurrentCamera.ViewportSize.X * 0.9

	local Bounds = TextService:GetTextBoundsAsync(Params)
	return Bounds.X, Bounds.Y
end

function Library:MouseIsOverFrame(Frame: GuiObject, Mouse: Vector2): boolean
	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
	return Mouse.X >= AbsPos.X
		and Mouse.X <= AbsPos.X + AbsSize.X
		and Mouse.Y >= AbsPos.Y
		and Mouse.Y <= AbsPos.Y + AbsSize.Y
end

function Library:SafeCallback(Func: (...any) -> ...any, ...: any)
	if not (Func and typeof(Func) == "function") then
		return
	end

	local Success, Response = pcall(Func, ...)
	if not Success then
		task.spawn(error, debug.traceback(Response))
		Library:Notify({
			Title = "Callback Error",
			Content = Response,
			Duration = 7,
		})
		return
	end

	return Response
end

function Library:MakeDraggable(UI: GuiObject, DragFrame: GuiObject, IgnoreOpened: boolean?)
	local StartPos
	local FramePos
	local Dragging = false
	local Changed
	DragFrame.InputBegan:Connect(function(Input: InputObject)
		if not IsClickInput(Input) then
			return
		end

		StartPos = Input.Position
		FramePos = UI.Position
		Dragging = true

		Changed = Input.Changed:Connect(function()
			if Input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			Dragging = false
			if Changed and Changed.Connected then
				Changed:Disconnect()
				Changed = nil
			end
		end)
	end)
	Library:Connect(UserInputService.InputChanged:Connect(function(Input: InputObject)
		if not IgnoreOpened and not Library.Opened or Library.Unloaded then
			Dragging = false
			if Changed and Changed.Connected then
				Changed:Disconnect()
				Changed = nil
			end

			return
		end

		if Dragging and IsHoverInput(Input) then
			local Delta = Input.Position - StartPos
			UI.Position =
				UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
		end
	end))
end

function Library:Notify(NotificationInfo: NotificationInfo)
	NotificationInfo = Validate(NotificationInfo, Templates.Notification)

	local Notification = New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = "ButtonColor",
		ClipsDescendants = true,
		Size = UDim2.fromScale(0, 0),
		Parent = NotificationsFrame,
	})

	New("UIListLayout", {
		Padding = UDim.new(0, 4),
		Parent = Notification,
	})

	New("UIPadding", {
		PaddingBottom = UDim.new(0, 6),
		PaddingLeft = UDim.new(0, 6),
		PaddingRight = UDim.new(0, 6),
		PaddingTop = UDim.new(0, 6),
		Parent = Notification,
	})

	New("UIStroke", {
		Color = "BorderColor",
		Parent = Notification,
	})

	local TitleX, TitleY = Library:GetTextBounds(NotificationInfo.Title, Library.Font, 18, 288)
	New("TextLabel", {
		BackgroundTransparency = 1,
		FontFace = Library.Font,
		Size = UDim2.fromOffset(TitleX, TitleY),
		Text = NotificationInfo.Title,
		TextSize = 18,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Notification,
	})

	local ContentX, ContentY = Library:GetTextBounds(NotificationInfo.Content, Library.Font, 16, 288)
	New("TextLabel", {
		BackgroundTransparency = 1,
		FontFace = Library.Font,
		Size = UDim2.fromOffset(ContentX, ContentY),
		Text = NotificationInfo.Content,
		TextSize = 16,
		TextTransparency = 0.5,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Notification,
	})

	pcall(Notification.TweenSize, Notification, UDim2.fromScale(1, 0), "InOut", "Linear", "0.25", true)
	task.spawn(function()
		if typeof(NotificationInfo.Duration) == "Instance" then
			NotificationInfo.Duration.Destroying:Wait()
		else
			task.wait(NotificationInfo.Duration)
		end

		task.wait(0.25)
		pcall(Notification.TweenSize, Notification, UDim2.fromScale(0, 0), "InOut", "Linear", "0.25", true)
		task.wait(0.25)
		Notification:Destroy()
	end)
end

function Library:CreateWindow(WindowInfo: WindowInfo)
	WindowInfo = Validate(WindowInfo, Templates.Window)
	local WindowTweenInfo = TweenInfo.new(WindowInfo.TweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local ViewportSize: Vector2 = workspace.CurrentCamera.ViewportSize

	WindowInfo.Width = math.clamp(WindowInfo.Width, 0, ViewportSize.X * 0.9)
	WindowInfo.Height = math.clamp(WindowInfo.Height, 0, ViewportSize.Y * 0.9)
	if typeof(WindowInfo.Font) == "EnumItem" then
		WindowInfo.Font = Font.fromEnum(WindowInfo.Font)
	end

	Library.Font = WindowInfo.Font
	Library.ToggleKeybind = WindowInfo.ToggleKeybind
	Library.Theme = WindowInfo.Theme

	local HueSequenceTable = {}
	for Hue = 0, 1, 0.1 do
		table.insert(HueSequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)))
	end

	local TitleBar
	local TabButtons
	local TabsContainer

	local DialogHolder
	local DialogFrame
	local DialogTitle: TextLabel
	local DialogContent: TextLabel
	local DialogButtons
	local DialogGrid: UIGridLayout

	do
		MainFrame.Position = UDim2.fromOffset(
			(ViewportSize.X - WindowInfo.Width) / 2,
			((ViewportSize.Y - WindowInfo.Height) / 2) - GuiService:GetGuiInset().Y
		)
		MainFrame.Size = UDim2.fromOffset(WindowInfo.Width, WindowInfo.Height)

		New("UIStroke", {
			Color = "BorderColor",
			Thickness = WindowInfo.OutlineThickness,
			Parent = MainFrame,
		})

		--// Title Bar \\--
		TitleBar = New("TextLabel", {
			BackgroundColor3 = "TitleBarColor",
			FontFace = WindowInfo.Font,
			Size = UDim2.new(1, 0, 0, 32),
			Text = WindowInfo.Title,
			TextSize = WindowInfo.FontSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = MainFrame,
		})

		New("UIPadding", {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
			Parent = TitleBar,
		})

		--// Tab Sections \\--
		TabButtons = New("ScrollingFrame", {
			AnchorPoint = Vector2.new(0, WindowInfo.TopTabBar and 0 or 1),
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			BackgroundColor3 = "TabBarColor",
			CanvasSize = UDim2.fromScale(0, 0),
			Position = UDim2.new(0, 0, WindowInfo.TopTabBar and 0 or 1, WindowInfo.TopTabBar and 32 or 0),
			ScrollBarThickness = 0,
			Size = UDim2.new(1, 0, 0, 42),
			Parent = MainFrame,
		})

		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 1),
			Parent = TabButtons,
		})

		New("UIPadding", {
			PaddingBottom = UDim.new(0, WindowInfo.TopTabBar and 1 or 0),
			PaddingTop = UDim.new(0, WindowInfo.TopTabBar and 0 or 1),
			Parent = TabButtons,
		})

		--// Tab Container \\--
		TabsContainer = New("Frame", {
			AnchorPoint = Vector2.new(0, WindowInfo.TopTabBar and 1 or 0),
			BackgroundColor3 = "ContainerColor",
			Position = UDim2.new(0, 0, WindowInfo.TopTabBar and 1 or 0, WindowInfo.TopTabBar and 0 or 32),
			Size = UDim2.new(1, 0, 1, -74),
			Parent = MainFrame,
		})

		--// Dialog \\--
		DialogHolder = New("TextButton", {
			BackgroundColor3 = Color3.new(),
			BackgroundTransparency = 0.6,
			Size = UDim2.fromScale(1, 1),
			Text = "",
			Visible = false,
			ZIndex = 2,
			Parent = MainFrame,
		})

		DialogFrame = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = "SectionColor",
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.75, 0.4),
			ZIndex = 2,
			Parent = DialogHolder,
		})

		New("UIPadding", {
			PaddingBottom = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 8),
			Parent = DialogFrame,
		})

		New("UIStroke", {
			Color = "BorderColor",
			Parent = DialogFrame,
		})

		DialogTitle = New("TextLabel", {
			BackgroundTransparency = 1,
			FontFace = WindowInfo.Font,
			Size = UDim2.fromScale(1, 0),
			Text = "",
			TextSize = 24,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 2,
			Parent = DialogFrame,
		})

		DialogContent = New("TextLabel", {
			BackgroundTransparency = 1,
			FontFace = WindowInfo.Font,
			Size = UDim2.fromScale(1, 0),
			Text = "",
			TextSize = 18,
			TextTransparency = 0.5,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 2,
			Parent = DialogFrame,
		})

		DialogButtons = New("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 32),
			ZIndex = 2,
			Parent = DialogFrame,
		})

		DialogGrid = New("UIGridLayout", {
			CellPadding = UDim2.fromOffset(9, 9),
			CellSize = UDim2.fromOffset(0, 32),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Parent = DialogButtons,
		})
	end

	--// Window Table \\--
	local Window = {}
	Window.ActiveTab = nil :: TabTable | nil

	function Window:CreateDialog(DialogInfo: DialogInfo)
		DialogInfo = Validate(DialogInfo, Templates.Dialog)

		local _, TitleY = Library:GetTextBounds(
			DialogInfo.Title,
			DialogTitle.FontFace,
			DialogTitle.TextSize,
			DialogFrame.AbsoluteSize.X - 16
		)
		DialogTitle.Size = UDim2.new(1, 0, 0, TitleY)
		DialogTitle.Text = DialogInfo.Title

		local _, ContentY = Library:GetTextBounds(
			DialogInfo.Content,
			DialogContent.FontFace,
			DialogContent.TextSize,
			DialogFrame.AbsoluteSize.X - 16
		)
		DialogContent.Position = UDim2.fromOffset(0, TitleY)
		DialogContent.Size = UDim2.new(1, 0, 0, ContentY)
		DialogContent.Text = DialogInfo.Content

		local Amount = GetTableSize(DialogInfo.Buttons)
		local ClampedAmount = math.clamp(Amount, 0, WindowInfo.MaxDialogButtonsPerLine)
		local Quantity = math.ceil(Amount / WindowInfo.MaxDialogButtonsPerLine)

		local ButtonsY = (32 * Quantity) + (9 * (Quantity - 1))
		DialogButtons.Size = UDim2.new(1, 0, 0, ButtonsY)
		DialogGrid.CellSize = UDim2.new(1 / ClampedAmount, -(3 + ClampedAmount), 0, 32)

		for _, ButtonInfo in pairs(DialogInfo.Buttons) do
			local Button = New("TextButton", {
				BackgroundColor3 = "ButtonColor",
				FontFace = WindowInfo.Font,
				Text = ButtonInfo.Title,
				TextSize = 18,
				TextTransparency = 0.5,
				ZIndex = 2,
				Parent = DialogButtons,
			})

			local Stroke = New("UIStroke", {
				Color = "BorderColor",
				Transparency = 0.5,
				Parent = Button,
			})

			Button.MouseEnter:Connect(function()
				TweenService:Create(Button, WindowTweenInfo, {
					TextTransparency = 0.25,
				}):Play()
				TweenService:Create(Stroke, WindowTweenInfo, {
					Transparency = 0,
				}):Play()
			end)
			Button.MouseLeave:Connect(function()
				TweenService:Create(Button, WindowTweenInfo, {
					TextTransparency = 0.5,
				}):Play()
				TweenService:Create(Stroke, WindowTweenInfo, {
					Transparency = 0.5,
				}):Play()
			end)
			Button.MouseButton1Click:Connect(function()
				DialogHolder.Visible = false
				for _, Button in pairs(DialogButtons:GetChildren()) do
					if Button.ClassName == "TextButton" then
						Button:Destroy()
					end
				end

				Library:SafeCallback(ButtonInfo.Callback)
			end)
		end

		DialogFrame.Size = UDim2.new(0.75, 0, 0, TitleY + ContentY + ButtonsY + 22)
		DialogHolder.Visible = true
	end

	function Window:CreateTab(TabName: string, IconName: string?)
		local TabButton
		local TabStroke
		local Icon
		local TabContainer
		do
			TabButton = New("TextButton", {
				BackgroundColor3 = "ButtonColor",
				BackgroundTransparency = 1,
				FontFace = WindowInfo.Font,
				Size = UDim2.fromScale(0, 1),
				Text = TabName,
				TextSize = WindowInfo.FontSize,
				TextTransparency = 0.5,
				Parent = TabButtons,
			})

			New("UIPadding", {
				PaddingLeft = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 16),
				Parent = TabButton,
			})

			TabStroke = New("UIStroke", {
				Color = "BorderColor",
				Transparency = 1,
				Parent = TabButton,
			})

			local IconAsset = IconName and GetIcon(IconName)
			if IconAsset then
				TabButton.TextXAlignment = Enum.TextXAlignment.Right

				Icon = New("ImageLabel", {
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					Image = IconAsset.Url,
					ImageRectSize = IconAsset.ImageRectSize,
					ImageRectOffset = IconAsset.ImageRectOffset,
					ImageTransparency = 0.5,
					Position = UDim2.fromScale(0, 0.5),
					Size = UDim2.fromOffset(18, 18),
					Parent = TabButton,
				})
			end

			TabContainer = New("ScrollingFrame", {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
				BackgroundTransparency = 1,
				CanvasSize = UDim2.fromScale(0, 0),
				ScrollBarImageColor3 = "FillColor",
				ScrollBarThickness = 4,
				Size = UDim2.fromScale(1, 1),
				TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
				Visible = false,
				Parent = TabsContainer,
			})

			New("UIListLayout", {
				Padding = UDim.new(0, 6),
				Parent = TabContainer,
			})

			New("UIPadding", {
				PaddingBottom = UDim.new(0, 6),
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6),
				PaddingTop = UDim.new(0, 6),
				Parent = TabContainer,
			})
		end

		--// Tab Table \\--
		local Tab = {} :: TabTable

		function Tab:CreateSection(SectionName: string, Opened: boolean?)
			local SectionButton
			local SectionArrow
			local Container
			do
				local SectionFrame = New("Frame", {
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = "SectionColor",
					Size = UDim2.new(1, 0, 0, 36),
					Parent = TabContainer,
				})

				New("UIPadding", {
					PaddingBottom = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					PaddingTop = UDim.new(0, 8),
					Parent = SectionFrame,
				})

				SectionButton = New("TextButton", {
					BackgroundTransparency = 1,
					FontFace = WindowInfo.Font,
					Size = UDim2.new(1, 0, 0, 20),
					Text = SectionName,
					TextSize = WindowInfo.SectionFontSize,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					Parent = SectionFrame,
				})

				SectionArrow = New("ImageLabel", {
					AnchorPoint = Vector2.new(1, 0),
					Image = OpenIcon and OpenIcon.Url or "rbxassetid://105228422307430",
					ImageRectSize = OpenIcon and OpenIcon.ImageRectSize or 0,
					ImageRectOffset = OpenIcon and OpenIcon.ImageRectOffset or 0,
					ImageColor3 = "FillColor",
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.fromOffset(WindowInfo.SectionFontSize + 2, WindowInfo.SectionFontSize + 2),
					Parent = SectionButton,
				})

				Container = New("Frame", {
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = "ButtonColor",
					Position = UDim2.fromOffset(0, WindowInfo.SectionFontSize + 11),
					Size = UDim2.fromScale(1, 0),
					Visible = false,
					Parent = SectionFrame,
				})

				New("UIListLayout", {
					Padding = UDim.new(0, 1),
					Parent = Container,
				})

				New("UIStroke", {
					Color = "BorderColor",
					Parent = Container,
				})
			end

			--// Section Table \\--
			local Section = {} :: SectionTable

			function Section:Show()
				Container.Visible = true
				SectionArrow.Rotation = 180
			end

			function Section:Hide()
				Container.Visible = false
				SectionArrow.Rotation = 0
			end

			function Section:Toggle()
				Container.Visible = not Container.Visible
				SectionArrow.Rotation = Container.Visible and 180 or 0
			end

			if Opened then
				Section:Show()
			end

			--// Elements \\--
			function Section:CreateDivider(Offset: number)
				Offset = Offset or 12

				local Frame = New("Frame", {
					BackgroundColor3 = "ButtonColor",
					Size = UDim2.new(1, 0, 0, Offset),
					Parent = Container,
				})

				New("UIStroke", {
					Color = "BorderColor",
					Transparency = 0.75,
					Parent = Frame,
				})

				--// Divider Table \\--
				local Divider = {
					Offset = Offset,
				} :: DividerTable

				function Divider:SetOffset(NewOffset: number)
					Divider.Offset = NewOffset
					Frame.Size = UDim2.new(1, 0, 0, NewOffset)
				end

				return Divider
			end

			function Section:CreateLabel(Flag: string, LabelInfo: LabelInfo)
				LabelInfo = Validate(LabelInfo, Templates.Label)

				local TextLabel: TextLabel = New("TextLabel", {
					BackgroundColor3 = "ButtonColor",
					FontFace = WindowInfo.Font,
					Size = UDim2.fromScale(1, 0),
					Text = "",
					TextSize = WindowInfo.FontSize,
					TextTransparency = 0.5,
					TextXAlignment = LabelInfo.Alignment,
					Parent = Container,
				})

				New("UIPadding", {
					PaddingBottom = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					PaddingTop = UDim.new(0, 8),
					Parent = TextLabel,
				})

				New("UIStroke", {
					Color = "BorderColor",
					Transparency = 0.75,
					Parent = TextLabel,
				})

				--// Label Table \\--
				local Label = {
					Text = LabelInfo.Text,
					Alignment = LabelInfo.Alignment,

					Type = "Label",
				} :: LabelTable

				function Label:SetText(NewText: string)
					Label.Text = NewText
					TextLabel.Text = NewText

					local _, Y =
						Library:GetTextBounds(NewText, WindowInfo.Font, WindowInfo.FontSize, Container.AbsoluteSize.X)
					TextLabel.Size = UDim2.new(1, 0, 0, Y + 16)
				end

				function Label:SetAlignment(NewAlignment: Enum.TextXAlignment)
					Label.Alignment = NewAlignment
					TextLabel.TextXAlignment = NewAlignment
				end

				Library.Flags[Flag] = Label
				Library.Labels[Flag] = Label
				Label:SetText(Label.Text)

				return Label
			end

			function Section:CreateButton(Flag: string, ButtonInfo: ButtonInfo)
				local ButtonFrame: TextButton = New("TextButton", {
					BackgroundColor3 = "ButtonColor",
					Size = UDim2.new(1, 0, 0, 36),
					Text = "",
					Parent = Container,
				})

				New("UIPadding", {
					PaddingBottom = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					PaddingTop = UDim.new(0, 8),
					Parent = ButtonFrame,
				})

				local Stroke = New("UIStroke", {
					Color = "BorderColor",
					Transparency = 0.75,
					Parent = ButtonFrame,
				})

				local ButtonLabel: TextButton = New("TextLabel", {
					BackgroundColor3 = "ButtonColor",
					FontFace = WindowInfo.Font,
					Size = UDim2.new(1, 0, 0, 20),
					Text = ButtonInfo.Title,
					TextSize = WindowInfo.FontSize,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = ButtonFrame,
				})

				local DescLabel = New("TextLabel", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = 1,
					FontFace = WindowInfo.Font,
					Position = UDim2.fromScale(0, 1),
					Size = UDim2.new(1, 0, 0, 14),
					Text = "",
					TextSize = 14,
					TextTransparency = 0.6,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = ButtonFrame,
				})

				if ButtonIcon then
					New("ImageLabel", {
						AnchorPoint = Vector2.new(1, 0),
						BackgroundTransparency = 1,
						Image = ButtonIcon.Url,
						ImageRectSize = ButtonIcon.ImageRectSize,
						ImageRectOffset = ButtonIcon.ImageRectOffset,
						ImageTransparency = 0.5,
						Position = UDim2.fromScale(1, 0),
						Size = UDim2.fromOffset(20, 20),
						Parent = ButtonFrame,
					})
				end

				--// Button Table \\--
				local Button = {
					Title = ButtonInfo.Title,
					Description = ButtonInfo.Description,
					Callback = ButtonInfo.Callback,

					Type = "Button",
				} :: ButtonTable

				function Button:SetTitle(NewTitle: string)
					Button.Title = NewTitle
					ButtonLabel.Text = NewTitle
				end

				function Button:SetDescription(NewDescription: string)
					Button.Description = NewDescription

					ButtonFrame.Size = UDim2.new(1, 0, 0, 54)
					DescLabel.Text = NewDescription
				end

				function Button:SetCallback(NewCallback: () -> ())
					Button.Callback = NewCallback
				end

				if Button.Description then
					ButtonFrame.Size = UDim2.new(1, 0, 0, 54)
					DescLabel.Text = Button.Description
				end
				Library.Flags[Flag] = Button
				Library.Buttons[Flag] = Button

				--// Execution \\--
				ButtonFrame.MouseEnter:Connect(function()
					TweenService:Create(ButtonLabel, WindowTweenInfo, {
						TextTransparency = 0.25,
					}):Play()
					TweenService:Create(Stroke, WindowTweenInfo, {
						Transparency = 0,
					}):Play()
				end)
				ButtonFrame.MouseLeave:Connect(function()
					TweenService:Create(ButtonLabel, WindowTweenInfo, {
						TextTransparency = 0.5,
					}):Play()
					TweenService:Create(Stroke, WindowTweenInfo, {
						Transparency = 0.75,
					}):Play()
				end)

				ButtonFrame.MouseButton1Click:Connect(function()
					Library:SafeCallback(Button.Callback)
				end)

				return Button
			end

			function Section:CreateToggle(Flag: string, ToggleInfo: ToggleInfo)
				ToggleInfo = Validate(ToggleInfo, Templates.Toggle)

				local ButtonFrame: TextButton = New("TextButton", {
					BackgroundColor3 = "ButtonColor",
					Size = UDim2.new(1, 0, 0, 36),
					Text = "",
					Parent = Container,
				})

				New("UIPadding", {
					PaddingBottom = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					PaddingTop = UDim.new(0, 8),
					Parent = ButtonFrame,
				})

				local Stroke = New("UIStroke", {
					Color = "BorderColor",
					Transparency = 0.75,
					Parent = ButtonFrame,
				})

				local ToggleLabel: TextButton = New("TextLabel", {
					BackgroundTransparency = 1,
					FontFace = WindowInfo.Font,
					Size = UDim2.new(1, 0, 0, 20),
					Text = ToggleInfo.Title,
					TextSize = WindowInfo.FontSize,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = ButtonFrame,
				})

				local DescLabel = New("TextLabel", {
					BackgroundTransparency = 1,
					FontFace = WindowInfo.Font,
					Position = UDim2.fromOffset(0, 24),
					Size = UDim2.new(1, 0, 0, 14),
					Text = "",
					TextSize = 14,
					TextTransparency = 0.6,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = ButtonFrame,
				})

				local Checkbox = New("Frame", {
					AnchorPoint = Vector2.new(1, 0),
					BackgroundColor3 = "FillColor",
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.fromOffset(20, 20),
					Parent = ButtonFrame,
				})

				New("UIStroke", {
					Color = "FillBorderColor",
					Thickness = 2,
					Transparency = 0,
					Parent = Checkbox,
				})

				--// Toggle Table \\--
				local Toggle = {
					Title = ToggleInfo.Title,
					Description = ToggleInfo.Description,
					Value = ToggleInfo.Value,
					Callback = ToggleInfo.Callback,

					Slider = nil,
					Keypicker = nil,
					Type = "Toggle",
				} :: ToggleTable

				function Toggle:CreateSlider(Flag: string, SliderInfo: ToggleSliderInfo)
					SliderInfo = Validate(SliderInfo, Templates.Slider)

					ButtonFrame.Size = UDim2.new(1, 0, 0, Toggle.Description and 86 or 66)

					local SliderValue = New("TextLabel", {
						BackgroundTransparency = 1,
						FontFace = WindowInfo.Font,
						Size = UDim2.new(1, Toggle.Keypicker and -52 or -30, 0, 20),
						Text = "Value",
						TextSize = WindowInfo.FontSize,
						TextTransparency = 0.5,
						TextXAlignment = Enum.TextXAlignment.Right,
						Parent = ButtonFrame,
					})

					local SliderBar: TextButton = New("TextButton", {
						AnchorPoint = Vector2.new(0, 1),
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 0, 1, -4),
						Size = UDim2.new(1, 0, 0, 20),
						Text = "",
						TextTransparency = 0.5,
						TextXAlignment = Enum.TextXAlignment.Right,
						Parent = ButtonFrame,
					})

					New("UIStroke", {
						Color = "FillBorderColor",
						Thickness = 2,
						Parent = SliderBar,
					})

					local PercentageBar = New("Frame", {
						BackgroundColor3 = "FillColor",
						Size = UDim2.fromScale(0.5, 1),
						Parent = SliderBar,
					})

					--// Slider Table \\--
					local Slider = {
						Suffix = SliderInfo.Suffix,
						Min = SliderInfo.Min,
						Max = SliderInfo.Max,
						Increment = SliderInfo.Increment,
						Value = SliderInfo.Value,
						Callback = SliderInfo.Callback,

						SliderValue = SliderValue,
						Type = "Slider",
					} :: ToggleSliderTable
					Toggle.Slider = Slider

					function Slider:SetMin(NewMin: number)
						if not (NewMin and NewMin < Slider.Max) then
							return
						end

						Slider.Min = NewMin
						Slider:SetValue(Slider.Value)
					end

					function Slider:SetMax(NewMax: number)
						if not (NewMax and NewMax > Slider.Min) then
							return
						end

						Slider.Max = NewMax
						Slider:SetValue(Slider.Value)
					end

					function Slider:SetIncrement(NewIncrement: number)
						if not NewIncrement then
							return
						end

						Slider.Increment = NewIncrement
						Slider:SetValue(Slider.Value)
					end

					function Slider:SetValue(NewValue: number, IgnoreCallback: boolean?)
						local OldValue = Slider.Value

						Slider.Value = math.clamp(Round(NewValue, Slider.Increment), Slider.Min, Slider.Max)
						Slider:Display()

						if Slider.Value ~= OldValue and not IgnoreCallback then
							Library:SafeCallback(Slider.Callback, Slider.Value)
							Library:SafeCallback(Slider.Changed, Slider.Value)
						end
					end

					function Slider:SetCallback(NewCallback: (Value: number) -> ())
						Slider.Callback = NewCallback
					end

					function Slider:OnChanged(Callback: (Value: number) -> ())
						Slider.Changed = Callback
					end

					function Slider:Display()
						SliderValue.Text = tostring(Slider.Value) .. Slider.Suffix
						TweenService
							:Create(PercentageBar, WindowTweenInfo, {
								Size = UDim2.fromScale((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 1),
							})
							:Play()
					end

					Library.Flags[Flag] = Slider
					Library.Options[Flag] = Slider
					Slider:SetValue(SliderInfo.Value, SliderInfo.SkipInitialCallback)

					--// Execution \\--
					local Dragging = false
					local Changed
					SliderBar.InputBegan:Connect(function(Input: InputObject)
						if not IsClickInput(Input) then
							return
						end

						Dragging = true

						local Percentage = math.clamp(
							(Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X,
							0,
							1
						)
						Slider:SetValue(Slider.Min + ((Slider.Max - Slider.Min) * Percentage))

						Changed = Input.Changed:Connect(function()
							if Input.UserInputState ~= Enum.UserInputState.End then
								return
							end

							Dragging = false
							if Changed and Changed.Connected then
								Changed:Disconnect()
								Changed = nil
							end
						end)
					end)
					Library:Connect(UserInputService.InputChanged:Connect(function(Input: InputObject)
						if not Library.Opened or Library.Unloaded then
							Dragging = false
							if Changed and Changed.Connected then
								Changed:Disconnect()
								Changed = nil
							end

							return
						end

						if Dragging and IsHoverInput(Input) then
							local Percentage = math.clamp(
								(Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X,
								0,
								1
							)
							Slider:SetValue(Slider.Min + ((Slider.Max - Slider.Min) * Percentage))
						end
					end))

					Slider.CreateKeypicker = function(...)
						Toggle:CreateKeypicker(...)
					end
					return Slider
				end

				function Toggle:CreateKeypicker(Flag: string, KeypickerInfo: ToggleKeypickerInfo)
					KeypickerInfo = Validate(KeypickerInfo, Templates.Keypicker)

					local KeybindButton: TextButton = New("TextButton", {
						AnchorPoint = Vector2.new(1, 0),
						BackgroundTransparency = 1,
						FontFace = WindowInfo.Font,
						Position = UDim2.new(1, -28, 0, 0),
						Size = UDim2.new(0, 0, 0, 20),
						Text = "",
						TextSize = WindowInfo.FontSize,
						TextTransparency = 0.5,
						Parent = ButtonFrame,
					})

					New("Frame", {
						BackgroundColor3 = "FillBorderColor",
						Position = UDim2.fromOffset(0, -2),
						Size = UDim2.new(1, 0, 0, 2),
						Parent = KeybindButton,
					})

					New("Frame", {
						AnchorPoint = Vector2.new(0, 1),
						BackgroundColor3 = "FillBorderColor",
						Position = UDim2.new(0, 0, 1, 2),
						Size = UDim2.new(1, 0, 0, 2),
						Parent = KeybindButton,
					})

					local KeypickerConfig = New("Frame", {
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = "ButtonColor",
						Size = UDim2.fromOffset(80, 0),
						Visible = false,
						Parent = ScreenGui,
					})

					New("UIListLayout", {
						Padding = UDim.new(0, 1),
						Parent = KeypickerConfig,
					})
					--// Keypicker Table \\--
					local Keypicker = {
						Keybind = KeypickerInfo.Keybind,
						Mode = KeypickerInfo.Mode,
						SyncToggleState = KeypickerInfo.SyncToggleState,
						State = (KeypickerInfo.Mode == "Always"),
						Callback = KeypickerInfo.Callback,

						Type = "Keypicker",
					} :: ToggleKeypickerTable
					Toggle.Keypicker = Keypicker

					function Keypicker:SetKeybind(
						NewKeybind: Enum.KeyCode | Enum.UserInputState | nil,
						Picking: boolean?
					)
						Keypicker.Keybind = NewKeybind
						Keypicker:Display(Picking)
					end

					function Keypicker:SetMode(NewMode: string)
						Keypicker.Mode = NewMode
						Keypicker:SetState(NewMode == "Always")
					end

					function Keypicker:SetState(NewState: boolean)
						local OldState = Keypicker.State
						Keypicker.State = NewState

						if Keypicker.State ~= OldState then
							Library:SafeCallback(Keypicker.Callback, Keypicker.State)
							Library:SafeCallback(Keypicker.Changed, Keypicker.State)
						end
					end

					function Keypicker:SetCallback(NewCallback: (Value: boolean) -> ())
						Keypicker.Callback = NewCallback
					end

					function Keypicker:OnChanged(Callback: (Value: boolean) -> ())
						Keypicker.Changed = Callback
					end

					function Keypicker:Display(Picking: boolean?)
						KeybindButton.Text = Picking and "..."
							or (Keypicker.Keybind and Keypicker.Keybind.Name or "---")

						local X, _ = Library:GetTextBounds(
							KeybindButton.Text,
							KeybindButton.FontFace,
							KeybindButton.TextSize,
							ButtonFrame.AbsoluteSize.X
						)
						KeybindButton.Size = UDim2.fromOffset(X + 8, 20)
						if Toggle.Slider then
							Toggle.Slider.SliderValue.Size = UDim2.new(1, -(X + 42), 0, 20)
						end
					end

					function Keypicker:ShowConfig()
						KeypickerConfig.Visible = true
					end

					function Keypicker:HideConfig()
						KeypickerConfig.Visible = false
					end

					function Keypicker:ToggleConfig()
						KeypickerConfig.Visible = not KeypickerConfig.Visible
					end

					local ScreenSize = ViewportSize
					function Keypicker:UpdatePosition()
						ScreenSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or ScreenSize

						local Position = KeybindButton.AbsolutePosition
						local ConfigSize = KeypickerConfig.AbsoluteSize
						local Inset = GuiService:GetGuiInset().Y

						KeypickerConfig.Position = UDim2.fromOffset(
							math.clamp(Position.X + KeybindButton.Size.X.Offset, 0, ScreenSize.X - ConfigSize.X),
							math.clamp(Position.Y, -Inset, ScreenSize.Y - ConfigSize.Y - Inset)
						)
					end

					do
						local Current = nil
						local function CreateButton(Mode: string)
							local Button = New("TextButton", {
								BackgroundTransparency = 1,
								FontFace = WindowInfo.Font,
								Size = UDim2.new(1, 0, 0, 20),
								Text = Mode,
								TextSize = WindowInfo.FontSize,
								TextTransparency = 0.5,
								Parent = KeypickerConfig,
							})

							Button.MouseEnter:Connect(function()
								if Button.TextTransparency == 0 then
									return
								end
								TweenService:Create(Button, WindowTweenInfo, {
									TextTransparency = 0.25,
								}):Play()
							end)
							Button.MouseLeave:Connect(function()
								if Button.TextTransparency == 0 then
									return
								end
								TweenService:Create(Button, WindowTweenInfo, {
									TextTransparency = 0.5,
								}):Play()
							end)
							Button.MouseButton1Click:Connect(function()
								Current.TextTransparency = 0.5
								Current = Button
								Button.TextTransparency = 0

								Keypicker:SetMode(Mode)
							end)

							if Keypicker.Mode == Mode then
								Current = Button
								Button.TextTransparency = 0
							end
							return Button
						end

						if Keypicker.SyncToggleState then
							Keypicker:SetMode("Toggle")
							Keypicker.State = Toggle.Value
							CreateButton("Toggle")
						else
							CreateButton("Hold")
							CreateButton("Toggle")
							CreateButton("Always")
						end
					end

					Library.Flags[Flag] = Keypicker
					Library.Options[Flag] = Keypicker
					Keypicker:SetKeybind(Keypicker.Keybind)
					Keypicker:UpdatePosition()

					--// Execution \\--
					KeybindButton:GetPropertyChangedSignal("AbsolutePosition"):Connect(Keypicker.UpdatePosition)
					KeybindButton.MouseButton2Click:Connect(Keypicker.ToggleConfig)

					local Picking = false
					local KeyPressed = nil
					KeybindButton.MouseButton1Click:Connect(function()
						if Picking then
							return
						end

						Picking = true
						Keypicker:SetKeybind(nil, true)

						local Input = UserInputService.InputBegan:Wait()
						local IsKeyCode = Input.KeyCode ~= Enum.KeyCode.Unknown

						if
							IsKeyCode and Input.KeyCode == Enum.KeyCode.Escape
							or Input.UserInputType == Enum.UserInputType.Touch
						then
							Keypicker:SetKeybind(nil)
							Picking = false
							return
						end

						KeyPressed = IsKeyCode and Input.KeyCode or Input.UserInputType
						Keypicker:SetKeybind(KeyPressed)
					end)

					Library:Connect(UserInputService.InputBegan:Connect(function(Input: InputObject)
						if IsClickInput(Input) then
							local Mouse = Input.Position

							if
								not (
									Library:MouseIsOverFrame(KeybindButton, Mouse)
									or Library:MouseIsOverFrame(KeypickerConfig, Mouse)
								)
							then
								Keypicker:HideConfig()
							end

							return
						end

						if Keypicker.Mode == "Always" then
							return
						end

						if
							(Input.KeyCode == Keypicker.Keybind or Input.UserInputType == Keypicker.Keybind)
							and not Picking
							and not UserInputService:GetFocusedTextBox()
						then
							if Keypicker.Mode == "Hold" then
								Keypicker:SetState(true)
							else
								Keypicker:SetState(not Keypicker.State)
								if Keypicker.SyncToggleState then
									Toggle:SetValue(Keypicker.State)
								end
							end
						end
					end))

					Library:Connect(UserInputService.InputEnded:Connect(function(Input: InputObject)
						if
							(Input.KeyCode == Keypicker.Keybind or Input.UserInputType == Keypicker.Keybind)
							and not Picking
						then
							if Keypicker.Mode == "Hold" then
								Keypicker:SetState(false)
							end
						elseif (Input.KeyCode == KeyPressed or Input.UserInputType == KeyPressed) and Picking then
							KeyPressed = nil
							Picking = false
						end
					end))

					Keypicker.CreateSlider = function(...)
						Toggle:CreateSlider(...)
					end
					return Keypicker
				end

				function Toggle:SetTitle(NewTitle: string)
					Toggle.Title = NewTitle
					ToggleLabel.Text = NewTitle
				end

				function Toggle:SetDescription(NewDescription: string)
					Toggle.Description = NewDescription

					ButtonFrame.Size = UDim2.new(1, 0, 0, Toggle.Slider and 86 or 54)
					DescLabel.Text = NewDescription
				end

				function Toggle:SetValue(NewValue: boolean, IgnoreCallback: boolean?)
					local OldValue = Toggle.Value

					Toggle.Value = NewValue
					Toggle:Display()

					if Toggle.Keypicker and Toggle.Keypicker.SyncToggleState then
						Toggle.Keypicker:SetState(Toggle.Value)
					end

					if Toggle.Value ~= OldValue and not IgnoreCallback then
						Library:SafeCallback(Toggle.Callback, Toggle.Value)
						Library:SafeCallback(Toggle.Changed, Toggle.Value)
					end
				end

				function Toggle:SetCallback(NewCallback: (Value: boolean) -> ())
					Toggle.Callback = NewCallback
				end

				function Toggle:OnChanged(Callback: (Value: boolean) -> ())
					Toggle.Changed = Callback
				end

				function Toggle:Display()
					TweenService:Create(ToggleLabel, WindowTweenInfo, {
						TextTransparency = Toggle.Value and 0 or 0.5,
					}):Play()
					TweenService:Create(Checkbox, WindowTweenInfo, {
						BackgroundTransparency = Toggle.Value and 0 or 1,
					}):Play()
				end

				if Toggle.Description then
					ButtonFrame.Size = UDim2.new(1, 0, 0, 54)
					DescLabel.Text = Toggle.Description
				end
				Library.Flags[Flag] = Toggle
				Library.Toggles[Flag] = Toggle
				Toggle:SetValue(Toggle.Value, ToggleInfo.SkipInitialCallback)

				--// Execution \\--
				ButtonFrame.MouseEnter:Connect(function()
					TweenService:Create(Stroke, WindowTweenInfo, {
						Transparency = 0,
					}):Play()
				end)
				ButtonFrame.MouseLeave:Connect(function()
					TweenService:Create(Stroke, WindowTweenInfo, {
						Transparency = 0.75,
					}):Play()
				end)

				ButtonFrame.MouseButton1Click:Connect(function()
					Toggle:SetValue(not Toggle.Value)
				end)

				return Toggle
			end

			function Section:CreateSlider(Flag: string, SliderInfo: SliderInfo)
				SliderInfo = Validate(SliderInfo, Templates.Slider)

				local SliderFrame: Frame = New("Frame", {
					BackgroundColor3 = "ButtonColor",
					Size = UDim2.new(1, 0, 0, 66),
					Parent = Container,
				})

				New("UIPadding", {
					PaddingBottom = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					PaddingTop = UDim.new(0, 8),
					Parent = SliderFrame,
				})

				local Stroke = New("UIStroke", {
					Color = "BorderColor",
					Transparency = 0.75,
					Parent = SliderFrame,
				})

				local SliderLabel = New("TextLabel", {
					BackgroundTransparency = 1,
					FontFace = WindowInfo.Font,
					Size = UDim2.new(1, 0, 0, 20),
					Text = SliderInfo.Title,
					TextSize = WindowInfo.FontSize,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = SliderFrame,
				})

				local SliderValue = New("TextLabel", {
					BackgroundTransparency = 1,
					FontFace = WindowInfo.Font,
					Size = UDim2.new(1, 0, 0, 20),
					Text = "Value",
					TextSize = WindowInfo.FontSize,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Right,
					Parent = SliderFrame,
				})

				local DescLabel = New("TextLabel", {
					BackgroundTransparency = 1,
					FontFace = WindowInfo.Font,
					Position = UDim2.fromOffset(0, 24),
					Size = UDim2.new(1, 0, 0, 14),
					Text = "",
					TextSize = 14,
					TextTransparency = 0.6,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = SliderFrame,
				})

				local SliderBar: TextButton = New("TextButton", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 1, -4),
					Size = UDim2.new(1, 0, 0, 20),
					Text = "",
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Right,
					Parent = SliderFrame,
				})

				New("UIStroke", {
					Color = "FillBorderColor",
					Thickness = 2,
					Parent = SliderBar,
				})

				local PercentageBar = New("Frame", {
					BackgroundColor3 = "FillColor",
					Size = UDim2.fromScale(0.5, 1),
					Parent = SliderBar,
				})

				--// Slider Table \\--
				local Slider = {
					Title = SliderInfo.Title,
					Description = SliderInfo.Description,
					Suffix = SliderInfo.Suffix,
					Min = SliderInfo.Min,
					Max = SliderInfo.Max,
					Increment = SliderInfo.Increment,
					Value = SliderInfo.Value,
					Callback = SliderInfo.Callback,

					Type = "Slider",
				} :: SliderTable

				function Slider:SetTitle(NewTitle: string)
					Slider.Title = NewTitle
					SliderLabel.Text = NewTitle
				end

				function Slider:SetDescription(NewDescription: string)
					Slider.Description = NewDescription

					SliderFrame.Size = UDim2.new(1, 0, 0, 86)
					DescLabel.Text = NewDescription
				end

				function Slider:SetMin(NewMin: number)
					if not (NewMin and NewMin < Slider.Max) then
						return
					end

					Slider.Min = NewMin
					Slider:SetValue(Slider.Value)
				end

				function Slider:SetMax(NewMax: number)
					if not (NewMax and NewMax > Slider.Min) then
						return
					end

					Slider.Max = NewMax
					Slider:SetValue(Slider.Value)
				end

				function Slider:SetIncrement(NewIncrement: number)
					if not NewIncrement then
						return
					end

					Slider.Increment = NewIncrement
					Slider:SetValue(Slider.Value)
				end

				function Slider:SetValue(NewValue: number, IgnoreCallback: boolean?)
					local OldValue = Slider.Value

					Slider.Value = math.clamp(Round(NewValue, Slider.Increment), Slider.Min, Slider.Max)
					Slider:Display()

					if Slider.Value ~= OldValue and not IgnoreCallback then
						Library:SafeCallback(Slider.Callback, Slider.Value)
						Library:SafeCallback(Slider.Changed, Slider.Value)
					end
				end

				function Slider:SetCallback(NewCallback: (Value: number) -> ())
					Slider.Callback = NewCallback
				end

				function Slider:OnChanged(Callback: (Value: number) -> ())
					Slider.Changed = Callback
				end

				function Slider:Display()
					SliderValue.Text = tostring(Slider.Value) .. Slider.Suffix
					TweenService:Create(PercentageBar, WindowTweenInfo, {
						Size = UDim2.fromScale((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 1),
					}):Play()
				end

				if Slider.Description then
					SliderFrame.Size = UDim2.new(1, 0, 0, 86)
					DescLabel.Text = Slider.Description
				end
				Library.Flags[Flag] = Slider
				Library.Options[Flag] = Slider
				Slider:SetValue(SliderInfo.Value, SliderInfo.SkipInitialCallback)

				--// Execution \\--
				SliderFrame.MouseEnter:Connect(function()
					TweenService:Create(Stroke, WindowTweenInfo, {
						Transparency = 0,
					}):Play()
				end)
				SliderFrame.MouseLeave:Connect(function()
					TweenService:Create(Stroke, WindowTweenInfo, {
						Transparency = 0.75,
					}):Play()
				end)

				local Dragging = false
				local Changed
				SliderBar.InputBegan:Connect(function(Input: InputObject)
					if not IsClickInput(Input) then
						return
					end

					Dragging = true

					local Percentage =
						math.clamp((Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
					Slider:SetValue(Slider.Min + ((Slider.Max - Slider.Min) * Percentage))

					Changed = Input.Changed:Connect(function()
						if Input.UserInputState ~= Enum.UserInputState.End then
							return
						end

						Dragging = false
						if Changed and Changed.Connected then
							Changed:Disconnect()
							Changed = nil
						end
					end)
				end)
				Library:Connect(UserInputService.InputChanged:Connect(function(Input: InputObject)
					if not Library.Opened or Library.Unloaded then
						Dragging = false
						if Changed and Changed.Connected then
							Changed:Disconnect()
							Changed = nil
						end

						return
					end

					if Dragging and IsHoverInput(Input) then
						local Percentage = math.clamp(
							(Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X,
							0,
							1
						)
						Slider:SetValue(Slider.Min + ((Slider.Max - Slider.Min) * Percentage))
					end
				end))

				return Slider
			end

			function Section:CreateInput(Flag: string, InputInfo: InputInfo)
				InputInfo = Validate(InputInfo, Templates.Input)

				local InputFrame: Frame = New("Frame", {
					BackgroundColor3 = "ButtonColor",
					Size = UDim2.new(1, 0, 0, 36),
					Parent = Container,
				})

				New("UIPadding", {
					PaddingBottom = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					PaddingTop = UDim.new(0, 8),
					Parent = InputFrame,
				})

				local Stroke = New("UIStroke", {
					Color = "BorderColor",
					Transparency = 0.75,
					Parent = InputFrame,
				})

				local InputLabel = New("TextLabel", {
					BackgroundTransparency = 1,
					FontFace = WindowInfo.Font,
					Size = UDim2.new(1, 0, 0, 20),
					Text = InputInfo.Title,
					TextSize = WindowInfo.FontSize,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = InputFrame,
				})

				local DescLabel = New("TextLabel", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = 1,
					FontFace = WindowInfo.Font,
					Position = UDim2.fromScale(0, 1),
					Size = UDim2.new(1, 0, 0, 14),
					Text = "",
					TextSize = 14,
					TextTransparency = 0.6,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = InputFrame,
				})

				local InputBox: TextBox = New("TextBox", {
					AnchorPoint = Vector2.new(1, 0),
					BackgroundTransparency = 1,
					ClearTextOnFocus = InputInfo.ClearOnFocus,
					FontFace = WindowInfo.Font,
					PlaceholderText = InputInfo.Placeholder,
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.new(0, 0, 0, 20),
					Text = InputInfo.Value,
					TextSize = WindowInfo.FontSize,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Right,
					Parent = InputFrame,
				})

				New("Frame", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundColor3 = "FillBorderColor",
					Position = UDim2.new(0, 0, 1, 2),
					Size = UDim2.new(1, 0, 0, 2),
					Parent = InputBox,
				})

				--// Input Table \\--
				local Input = {
					Title = InputInfo.Title,
					Description = InputInfo.Description,
					ClearOnFocus = InputInfo.ClearOnFocus,
					Placeholder = InputInfo.Placeholder,
					Value = InputInfo.Value,
					Callback = InputInfo.Callback,

					Type = "Input",
				} :: InputTable

				function Input:SetTitle(NewTitle: string)
					Input.Title = NewTitle
					InputLabel.Text = NewTitle
				end

				function Input:SetDescription(NewDescription: string)
					Input.Description = NewDescription

					InputFrame.Size = UDim2.new(1, 0, 0, 54)
					DescLabel.Text = NewDescription
				end

				function Input:SetClearOnFocus(NewClearOnFocus: boolean)
					Input.ClearOnFocus = NewClearOnFocus
					InputBox.ClearTextOnFocus = NewClearOnFocus
				end

				function Input:SetPlaceholder(NewPlaceholder: string)
					Input.Placeholder = NewPlaceholder
					InputBox.PlaceholderText = NewPlaceholder
				end

				function Input:SetValue(NewValue: string, IgnoreCallback: boolean?)
					local OldValue = Input.Value

					Input.Value = NewValue
					InputBox.Text = NewValue
					Input:Display()

					if Input.Value ~= OldValue and not IgnoreCallback then
						Library:SafeCallback(Input.Callback, Input.Value)
						Library:SafeCallback(Input.Changed, Input.Value)
					end
				end

				function Input:SetCallback(NewCallback: (Value: string) -> ())
					Input.Callback = NewCallback
				end

				function Input:OnChanged(Callback: (Value: boolean) -> ())
					Input.Changed = Callback
				end

				function Input:Display()
					local Text = InputBox.Text ~= "" and InputBox.Text or Input.Placeholder

					local X, _ =
						Library:GetTextBounds(Text, InputBox.FontFace, InputBox.TextSize, InputFrame.AbsoluteSize.X)
					InputBox.Size = UDim2.fromOffset(X, 20)
				end

				if Input.Description then
					InputFrame.Size = UDim2.new(1, 0, 0, 54)
					DescLabel.Text = Input.Description
				end
				Library.Flags[Flag] = Input
				Library.Options[Flag] = Input
				Input:SetValue(Input.Value, InputInfo.SkipInitialCallback)

				--// Execution \\--
				InputFrame.MouseEnter:Connect(function()
					TweenService:Create(Stroke, WindowTweenInfo, {
						Transparency = 0,
					}):Play()
				end)
				InputFrame.MouseLeave:Connect(function()
					TweenService:Create(Stroke, WindowTweenInfo, {
						Transparency = 0.75,
					}):Play()
				end)

				InputBox:GetPropertyChangedSignal("Text"):Connect(function()
					Input:SetValue(InputBox.Text)
				end)

				return Input
			end

			function Section:CreateDropdown(Flag: string, DropdownInfo: DropdownInfo)
				DropdownInfo = Validate(DropdownInfo, Templates.Dropdown)
				if DropdownInfo.SpecialType == "Player" then
					DropdownInfo.Values = Players:GetPlayers()
					DropdownInfo.AllowNull = true
				end

				local DropdownFrame: Frame = New("Frame", {
					BackgroundColor3 = "ButtonColor",
					Size = UDim2.new(1, 0, 0, 40),
					Parent = Container,
				})

				New("UIPadding", {
					PaddingBottom = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					PaddingTop = UDim.new(0, 8),
					Parent = DropdownFrame,
				})

				local Stroke = New("UIStroke", {
					Color = "BorderColor",
					Transparency = 0.75,
					Parent = DropdownFrame,
				})

				local DropdownLabel = New("TextLabel", {
					BackgroundTransparency = 1,
					FontFace = WindowInfo.Font,
					Size = UDim2.fromScale(1, 1),
					Text = DropdownInfo.Title,
					TextSize = WindowInfo.FontSize,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = DropdownFrame,
				})

				local DescLabel = New("TextLabel", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = 1,
					FontFace = WindowInfo.Font,
					Position = UDim2.fromScale(0, 1),
					Size = UDim2.new(1, 0, 0, 14),
					Text = "",
					TextSize = 14,
					TextTransparency = 0.6,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = DropdownFrame,
				})

				local DropdownButton = New("TextButton", {
					AnchorPoint = Vector2.new(1, 0),
					BackgroundTransparency = 1,
					FontFace = WindowInfo.Font,
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.new(0.4, 0, 0, 24),
					Text = "",
					TextSize = WindowInfo.FontSize,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = DropdownFrame,
				})

				New("UIPadding", {
					PaddingBottom = UDim.new(0, 4),
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					PaddingTop = UDim.new(0, 4),
					Parent = DropdownButton,
				})

				New("UIStroke", {
					Color = "FillBorderColor",
					Thickness = 2,
					Parent = DropdownButton,
				})

				local DropdownArrow = New("ImageLabel", {
					AnchorPoint = Vector2.new(1, 0),
					BackgroundTransparency = 1,
					Image = OpenIcon and OpenIcon.Url or "rbxassetid://105228422307430",
					ImageColor3 = "FillColor",
					ImageRectSize = OpenIcon and OpenIcon.ImageRectSize or 0,
					ImageRectOffset = OpenIcon and OpenIcon.ImageRectOffset or 0,
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.fromScale(1, 1),
					SizeConstraint = Enum.SizeConstraint.RelativeYY,
					Parent = DropdownButton,
				})

				local DropdownList = New("ScrollingFrame", {
					BackgroundColor3 = "ButtonColor",
					BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
					CanvasSize = UDim2.fromScale(0, 0),
					ScrollBarImageColor3 = "FillColor",
					ScrollBarThickness = 4,
					TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
					Visible = false,
					Parent = ScreenGui,
				})

				New("UIListLayout", {
					Padding = UDim.new(0, 2),
					Parent = DropdownList,
				})

				New("UIPadding", {
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					Parent = DropdownList,
				})

				--// Dropdown Table \\--
				local Dropdown = {
					Title = DropdownInfo.Title,
					Description = DropdownInfo.Description,
					Value = DropdownInfo.Value,
					Values = DropdownInfo.Values,
					Multi = DropdownInfo.Multi,
					AllowNull = DropdownInfo.AllowNull,
					SpecialType = DropdownInfo.SpecialType,
					Callback = DropdownInfo.Callback,

					Type = "Dropdown",
				} :: DropdownTable

				function Dropdown:SetTitle(NewTitle: string)
					Dropdown.Title = NewTitle
					DropdownLabel.Text = NewTitle
				end

				function Dropdown:SetDescription(NewDescription: string)
					Dropdown.Description = NewDescription

					DropdownFrame.Size = UDim2.new(1, 0, 0, 54)
					DropdownLabel.Size = UDim2.new(1, 0, 0, 20)
					DescLabel.Text = NewDescription
				end

				function Dropdown:SetValue(NewValue: string | { [any]: string }, IgnoreCallback: boolean?)
					if Dropdown.Multi then
						local Table = {}

						for Value1, Value2 in pairs(NewValue) do
							if table.find(Dropdown.Values, Value1) and Value2 then
								Table[Value1] = true
							elseif table.find(Dropdown.Values, Value2) then
								Table[Value2] = true
							end
						end

						Dropdown.Value = Table
					elseif table.find(Dropdown.Values, NewValue) then
						Dropdown.Value = NewValue
					else
						Dropdown.Value = nil
					end

					Dropdown:BuildDropdownList()

					if not IgnoreCallback then
						Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
						Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
					end
				end

				function Dropdown:SetValues(NewValues: { [any]: string })
					Dropdown.Values = NewValues

					Dropdown:BuildDropdownList()
				end

				function Dropdown:SetCallback(NewCallback: (Value: string | { [any]: any }) -> ())
					Dropdown.Callback = NewCallback
				end

				function Dropdown:OnChanged(Callback: (Value: string | { [any]: any }) -> ())
					Dropdown.Changed = Callback
				end

				function Dropdown:GetActiveValues()
					if Dropdown.Multi then
						return GetTableSize(Dropdown.Value)
					end

					return Dropdown.Value and 1 or 0
				end

				function Dropdown:Display()
					local String = ""

					if Dropdown.Multi then
						for _, Value in pairs(Dropdown.Values) do
							if not Dropdown.Value[Value] then
								continue
							end

							String = String .. tostring(Value) .. ", "
						end

						String = String:sub(1, #String - 2)
					else
						String = Dropdown.Value and tostring(Dropdown.Value) or ""
					end

					if #String >= 23 then
						String = String:sub(1, 19) .. "..."
					end
					DropdownButton.Text = (String == "" and "---" or String)
				end

				function Dropdown:Show()
					DropdownList.Visible = true
					DropdownArrow.Rotation = 180

					Dropdown:UpdateSize()
				end

				function Dropdown:Hide()
					DropdownList.Visible = false
					DropdownArrow.Rotation = 0
				end

				function Dropdown:Toggle()
					DropdownList.Visible = not DropdownList.Visible
					DropdownArrow.Rotation = DropdownList.Visible and 180 or 0
					if DropdownList.Visible then
						Dropdown:UpdateSize()
					end
				end

				local Updates = {}
				function Dropdown:BuildDropdownList()
					table.clear(Updates)

					for _, Button in pairs(DropdownList:GetChildren()) do
						if Button.ClassName == "TextButton" then
							Button:Destroy()
						end
					end

					if Dropdown.Multi then
						for Value, _ in pairs(Dropdown.Value) do
							if not table.find(Dropdown.Values, Value) then
								Dropdown.Value[Value] = nil
							end
						end
					else
						if not table.find(Dropdown.Values, Dropdown.Value) then
							Dropdown.Value = nil
						end
					end

					for _, Value in pairs(Dropdown.Values) do
						local Button: TextButton = New("TextButton", {
							BackgroundTransparency = 1,
							FontFace = WindowInfo.Font,
							Size = UDim2.new(1, 0, 0, 20),
							Text = tostring(Value),
							TextSize = WindowInfo.FontSize,
							TextTransparency = 0.5,
							TextXAlignment = Enum.TextXAlignment.Left,
							Parent = DropdownList,
						})

						local Selected

						local function Update()
							if Dropdown.Multi then
								Selected = Dropdown.Value[Value]
							else
								Selected = Dropdown.Value == Value
							end

							Button.TextTransparency = Selected and 0 or 0.5
						end

						do
							Update()

							Button.MouseEnter:Connect(function()
								if Selected then
									return
								end

								TweenService:Create(Button, WindowTweenInfo, {
									TextTransparency = 0.25,
								}):Play()
							end)

							Button.MouseLeave:Connect(function()
								if Selected then
									return
								end

								TweenService:Create(Button, WindowTweenInfo, {
									TextTransparency = 0.5,
								}):Play()
							end)

							Button.MouseButton1Click:Connect(function()
								if Selected and Dropdown.GetActiveValues() == 1 and not Dropdown.AllowNull then
									return
								end

								Selected = not Selected
								if Dropdown.Multi then
									Dropdown.Value[Value] = Selected and true or nil
								else
									Dropdown.Value = Selected and Value or nil

									for _, UpdateFunction in pairs(Updates) do
										UpdateFunction()
									end
								end

								Update()
								Dropdown:Display()

								Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
								Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
							end)
						end

						table.insert(Updates, Update)
					end

					Dropdown:Display()
					Dropdown:UpdateSize()
				end

				function Dropdown:UpdatePosition()
					local Position = DropdownButton.AbsolutePosition
					DropdownList.Position = UDim2.fromOffset(Position.X + 1, Position.Y + DropdownButton.Size.Y.Offset)
				end
				function Dropdown:UpdateSize()
					local Amount = GetTableSize(Dropdown.Values)
					local Size = DropdownButton.AbsoluteSize
					DropdownList.Size =
						UDim2.fromOffset(Size.X + 0.5, math.clamp(Amount * 22, 0, WindowInfo.MaxDropdownItems * 22) + 2)
					DropdownList.CanvasSize = UDim2.fromOffset(0, (Amount * 22) + 1)
				end

				if Dropdown.Description then
					DropdownFrame.Size = UDim2.new(1, 0, 0, 54)
					DropdownLabel.Size = UDim2.new(1, 0, 0, 20)
					DescLabel.Text = Dropdown.Description
				end
				Library.Flags[Flag] = Dropdown
				Library.Options[Flag] = Dropdown
				if typeof(Dropdown.Value) == "table" then
					local Table = {}

					for _, Value in pairs(Dropdown.Value) do
						Table[Value] = true
					end

					Dropdown.Value = Table
				elseif Dropdown.Multi then
					Dropdown.Value = {}
				end

				Dropdown:BuildDropdownList()
				Dropdown:UpdatePosition()

				--// Execution \\--
				DropdownFrame.MouseEnter:Connect(function()
					TweenService:Create(Stroke, WindowTweenInfo, {
						Transparency = 0,
					}):Play()
				end)
				DropdownFrame.MouseLeave:Connect(function()
					TweenService:Create(Stroke, WindowTweenInfo, {
						Transparency = 0.75,
					}):Play()
				end)
				DropdownFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(Dropdown.UpdatePosition)

				DropdownButton.MouseButton1Click:Connect(Dropdown.Toggle)

				Library:Connect(UserInputService.InputBegan:Connect(function(Input: InputObject)
					if IsClickInput(Input) then
						local Mouse = Input.Position

						if
							not (
								Library:MouseIsOverFrame(DropdownButton, Mouse)
								or Library:MouseIsOverFrame(DropdownList, Mouse)
							)
						then
							Dropdown:Hide()
						end
					end
				end))

				return Dropdown
			end

			function Section:CreateKeypicker(Flag: string, KeypickerInfo: KeypickerInfo)
				KeypickerInfo = Validate(KeypickerInfo, Templates.Keypicker)

				local KeypickerFrame: Frame = New("Frame", {
					BackgroundColor3 = "ButtonColor",
					Size = UDim2.new(1, 0, 0, 36),
					Parent = Container,
				})

				New("UIPadding", {
					PaddingBottom = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					PaddingTop = UDim.new(0, 8),
					Parent = KeypickerFrame,
				})

				local Stroke = New("UIStroke", {
					Color = "BorderColor",
					Transparency = 0.75,
					Parent = KeypickerFrame,
				})

				local KeypickerLabel = New("TextLabel", {
					BackgroundTransparency = 1,
					FontFace = WindowInfo.Font,
					Size = UDim2.new(1, 0, 0, 20),
					Text = KeypickerInfo.Title,
					TextSize = WindowInfo.FontSize,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = KeypickerFrame,
				})

				local DescLabel = New("TextLabel", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = 1,
					FontFace = WindowInfo.Font,
					Position = UDim2.fromScale(0, 1),
					Size = UDim2.new(1, 0, 0, 14),
					Text = "",
					TextSize = 14,
					TextTransparency = 0.6,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = KeypickerFrame,
				})

				local KeybindButton: TextButton = New("TextButton", {
					AnchorPoint = Vector2.new(1, 0),
					BackgroundTransparency = 1,
					FontFace = WindowInfo.Font,
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.new(0, 0, 0, 20),
					Text = "",
					TextSize = WindowInfo.FontSize,
					TextTransparency = 0.5,
					Parent = KeypickerFrame,
				})

				New("Frame", {
					BackgroundColor3 = "FillBorderColor",
					Position = UDim2.fromOffset(0, -2),
					Size = UDim2.new(1, 0, 0, 2),
					Parent = KeybindButton,
				})

				New("Frame", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundColor3 = "FillBorderColor",
					Position = UDim2.new(0, 0, 1, 2),
					Size = UDim2.new(1, 0, 0, 2),
					Parent = KeybindButton,
				})

				local KeypickerConfig = New("Frame", {
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = "ButtonColor",
					Size = UDim2.fromOffset(80, 0),
					Visible = false,
					Parent = ScreenGui,
				})

				New("UIListLayout", {
					Padding = UDim.new(0, 1),
					Parent = KeypickerConfig,
				})
				--// Keypicker Table \\--
				local Keypicker = {
					Title = KeypickerInfo.Title,
					Description = KeypickerInfo.Description,
					Keybind = KeypickerInfo.Keybind,
					Mode = KeypickerInfo.Mode,
					State = (KeypickerInfo.Mode == "Always"),
					Callback = KeypickerInfo.Callback,

					Type = "Keypicker",
				} :: KeypickerTable

				function Keypicker:SetTitle(NewTitle: string)
					Keypicker.Title = NewTitle
					KeypickerLabel.Text = NewTitle
				end

				function Keypicker:SetDescription(NewDescription: string)
					Keypicker.Description = NewDescription

					KeypickerFrame.Size = UDim2.new(1, 0, 0, 54)
					DescLabel.Text = NewDescription
				end

				function Keypicker:SetKeybind(NewKeybind: Enum.KeyCode | Enum.UserInputState | nil, Picking: boolean?)
					Keypicker.Keybind = NewKeybind
					Keypicker:Display(Picking)
				end

				function Keypicker:SetMode(NewMode: string)
					Keypicker.Mode = NewMode
					Keypicker:SetState(NewMode == "Always")
				end

				function Keypicker:SetState(NewState: boolean)
					local OldState = Keypicker.State
					Keypicker.State = NewState

					if Keypicker.State ~= OldState then
						Library:SafeCallback(Keypicker.Callback, Keypicker.State)
						Library:SafeCallback(Keypicker.Changed, Keypicker.Value)
					end
				end

				function Keypicker:SetCallback(NewCallback: (Value: boolean) -> ())
					Keypicker.Callback = NewCallback
				end

				function Keypicker:OnChanged(Callback: (Value: boolean) -> ())
					Keypicker.Changed = Callback
				end

				function Keypicker:Display(Picking: boolean?)
					KeybindButton.Text = Picking and "..." or (Keypicker.Keybind and Keypicker.Keybind.Name or "---")

					local X, _ = Library:GetTextBounds(
						KeybindButton.Text,
						KeybindButton.FontFace,
						KeybindButton.TextSize,
						KeypickerFrame.AbsoluteSize.X
					)
					KeybindButton.Size = UDim2.fromOffset(X + 8, 20)
				end

				function Keypicker:ShowConfig()
					KeypickerConfig.Visible = true
				end

				function Keypicker:HideConfig()
					KeypickerConfig.Visible = false
				end

				function Keypicker:ToggleConfig()
					KeypickerConfig.Visible = not KeypickerConfig.Visible
				end

				local ScreenSize = ViewportSize
				function Keypicker:UpdatePosition()
					ScreenSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or ScreenSize

					local Position = KeybindButton.AbsolutePosition
					local ConfigSize = KeypickerConfig.AbsoluteSize
					local Inset = GuiService:GetGuiInset().Y

					KeypickerConfig.Position = UDim2.fromOffset(
						math.clamp(Position.X + KeybindButton.Size.X.Offset, 0, ScreenSize.X - ConfigSize.X),
						math.clamp(Position.Y, -Inset, ScreenSize.Y - ConfigSize.Y - Inset)
					)
				end

				do
					local Current = nil
					local function CreateButton(Mode: string)
						local Button = New("TextButton", {
							BackgroundTransparency = 1,
							FontFace = WindowInfo.Font,
							Size = UDim2.new(1, 0, 0, 20),
							Text = Mode,
							TextSize = WindowInfo.FontSize,
							TextTransparency = 0.5,
							Parent = KeypickerConfig,
						})

						Button.MouseEnter:Connect(function()
							if Button.TextTransparency == 0 then
								return
							end
							TweenService:Create(Button, WindowTweenInfo, {
								TextTransparency = 0.25,
							}):Play()
						end)
						Button.MouseLeave:Connect(function()
							if Button.TextTransparency == 0 then
								return
							end
							TweenService:Create(Button, WindowTweenInfo, {
								TextTransparency = 0.5,
							}):Play()
						end)
						Button.MouseButton1Click:Connect(function()
							Current.TextTransparency = 0.5
							Current = Button
							Button.TextTransparency = 0

							Keypicker:SetMode(Mode)
						end)

						if Keypicker.Mode == Mode then
							Current = Button
							Button.TextTransparency = 0
						end
						return Button
					end
					CreateButton("Hold")
					CreateButton("Toggle")
					CreateButton("Always")
				end

				if Keypicker.Description then
					KeypickerFrame.Size = UDim2.new(1, 0, 0, 54)
					DescLabel.Text = Keypicker.Description
				end
				Library.Flags[Flag] = Keypicker
				Library.Options[Flag] = Keypicker
				Keypicker:SetKeybind(Keypicker.Keybind)
				Keypicker:UpdatePosition()

				--// Execution \\--
				KeypickerFrame.MouseEnter:Connect(function()
					TweenService:Create(Stroke, WindowTweenInfo, {
						Transparency = 0,
					}):Play()
				end)
				KeypickerFrame.MouseLeave:Connect(function()
					TweenService:Create(Stroke, WindowTweenInfo, {
						Transparency = 0.75,
					}):Play()
				end)

				KeybindButton:GetPropertyChangedSignal("AbsolutePosition"):Connect(Keypicker.UpdatePosition)
				KeybindButton.MouseButton2Click:Connect(Keypicker.ToggleConfig)

				local Picking = false
				local KeyPressed = nil
				KeybindButton.MouseButton1Click:Connect(function()
					if Picking then
						return
					end

					Picking = true
					Keypicker:SetKeybind(nil, true)

					local Input = UserInputService.InputBegan:Wait()
					local IsKeyCode = Input.KeyCode ~= Enum.KeyCode.Unknown

					if
						IsKeyCode and Input.KeyCode == Enum.KeyCode.Escape
						or Input.UserInputType == Enum.UserInputType.Touch
					then
						Keypicker:SetKeybind(nil)
						Picking = false
						return
					end

					KeyPressed = IsKeyCode and Input.KeyCode or Input.UserInputType
					Keypicker:SetKeybind(KeyPressed)
				end)

				Library:Connect(UserInputService.InputBegan:Connect(function(Input: InputObject)
					if IsClickInput(Input) then
						local Mouse = Input.Position

						if
							not (
								Library:MouseIsOverFrame(KeybindButton, Mouse)
								or Library:MouseIsOverFrame(KeypickerConfig, Mouse)
							)
						then
							Keypicker:HideConfig()
						end

						return
					end

					if Keypicker.Mode == "Always" then
						return
					end

					if
						(Input.KeyCode == Keypicker.Keybind or Input.UserInputType == Keypicker.Keybind)
						and not Picking
						and not UserInputService:GetFocusedTextBox()
					then
						if Keypicker.Mode == "Hold" then
							Keypicker:SetState(true)
						else
							Keypicker:SetState(not Keypicker.State)
						end
					end
				end))

				Library:Connect(UserInputService.InputEnded:Connect(function(Input: InputObject)
					if
						(Input.KeyCode == Keypicker.Keybind or Input.UserInputType == Keypicker.Keybind)
						and not Picking
					then
						if Keypicker.Mode == "Hold" then
							Keypicker:SetState(false)
						end
					elseif (Input.KeyCode == KeyPressed or Input.UserInputType == KeyPressed) and Picking then
						KeyPressed = nil
						Picking = false
					end
				end))

				return Keypicker
			end

			function Section:CreateColorpicker(Flag: string, ColorpickerInfo: ColorpickerInfo)
				ColorpickerInfo = Validate(ColorpickerInfo, Templates.Colorpicker)

				local ColorpickerFrame: Frame = New("Frame", {
					BackgroundColor3 = "ButtonColor",
					Size = UDim2.new(1, 0, 0, 36),
					Parent = Container,
				})

				New("UIPadding", {
					PaddingBottom = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					PaddingTop = UDim.new(0, 8),
					Parent = ColorpickerFrame,
				})

				local Stroke = New("UIStroke", {
					Color = "BorderColor",
					Transparency = 0.75,
					Parent = ColorpickerFrame,
				})

				local ColorpickerLabel = New("TextLabel", {
					BackgroundTransparency = 1,
					FontFace = WindowInfo.Font,
					Size = UDim2.new(1, 0, 0, 20),
					Text = ColorpickerInfo.Title,
					TextSize = WindowInfo.FontSize,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = ColorpickerFrame,
				})

				local DescLabel = New("TextLabel", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = 1,
					FontFace = WindowInfo.Font,
					Position = UDim2.fromScale(0, 1),
					Size = UDim2.new(1, 0, 0, 14),
					Text = "",
					TextSize = 14,
					TextTransparency = 0.6,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = ColorpickerFrame,
				})

				local ColorpickerButton = New("TextButton", {
					AnchorPoint = Vector2.new(1, 0),
					BackgroundColor3 = ColorpickerInfo.Value,
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.fromOffset(40, 20),
					Text = "",
					Parent = ColorpickerFrame,
				})

				local ButtonStroke = New("UIStroke", {
					Color = Library:GetDarkerColor(ColorpickerInfo.Value),
					Thickness = 2,
					Parent = ColorpickerButton,
				})

				local ColorpickerConfig = New("Frame", {
					BackgroundColor3 = "ButtonColor",
					Size = UDim2.fromOffset(222, 226),
					Visible = false,
					Parent = ScreenGui,
				})

				New("UIPadding", {
					PaddingBottom = UDim.new(0, 4),
					PaddingLeft = UDim.new(0, 4),
					PaddingRight = UDim.new(0, 4),
					PaddingTop = UDim.new(0, 4),
					Parent = ColorpickerConfig,
				})

				local ColorMap = New("ImageButton", {
					BackgroundColor3 = ColorpickerInfo.Value,
					Image = "rbxassetid://4155801252",
					Size = UDim2.fromOffset(192, 192),
					Parent = ColorpickerConfig,
				})

				local ColorMapIndicator = New("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.new(1, 1, 1),
					Size = UDim2.fromOffset(6, 6),
					Parent = ColorMap,
				})

				New("UICorner", {
					CornerRadius = UDim.new(0, 6),
					Parent = ColorMapIndicator,
				})

				New("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.new(0, 0, 0),
					Parent = ColorMapIndicator,
				})

				local ColorHue = New("TextButton", {
					AnchorPoint = Vector2.new(1, 0),
					BackgroundColor3 = Color3.new(1, 1, 1),
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.fromOffset(16, 192),
					Text = "",
					Parent = ColorpickerConfig,
				})

				New("UIGradient", {
					Color = ColorSequence.new(HueSequenceTable),
					Rotation = 90,
					Parent = ColorHue,
				})

				local ColorHueIndicator = New("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.new(1, 1, 1),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.new(1, 2, 0, 1),
					Parent = ColorHue,
				})

				New("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.new(0, 0, 0),
					Parent = ColorHueIndicator,
				})

				local ColorHexInput = New("TextBox", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = 1,
					ClearTextOnFocus = false,
					FontFace = WindowInfo.Font,
					Position = UDim2.new(0, 0, 1, -2),
					Size = UDim2.new(1, 0, 0, 20),
					Text = "000000",
					TextSize = WindowInfo.FontSize,
					TextTransparency = 0.5,
					Parent = ColorpickerConfig,
				})

				New("Frame", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundColor3 = "FillBorderColor",
					Position = UDim2.new(0, 0, 1, 2),
					Size = UDim2.new(1, 0, 0, 2),
					Parent = ColorHexInput,
				})

				--// Colorpicker Table \\--
				local Colorpicker = {
					Title = ColorpickerInfo.Title,
					Description = ColorpickerInfo.Description,
					Value = ColorpickerInfo.Value,
					Callback = ColorpickerInfo.Callback,

					Hue = 0,
					Sat = 0,
					Vib = 0,

					Type = "Colorpicker",
				} :: ColorpickerTable

				function Colorpicker:SetTitle(NewTitle: string)
					Colorpicker.Title = NewTitle
					ColorpickerLabel.Text = NewTitle
				end

				function Colorpicker:SetDescription(NewDescription: string)
					Colorpicker.Description = NewDescription

					ColorpickerFrame.Size = UDim2.new(1, 0, 0, 54)
					DescLabel.Text = NewDescription
				end

				function Colorpicker:SetValue(NewValue: Color3, IgnoreCallback: boolean?)
					local OldValue = Colorpicker.Value
					Colorpicker.Value = NewValue

					local H, S, V = NewValue:ToHSV()
					Colorpicker.Hue = H
					Colorpicker.Sat = S
					Colorpicker.Vib = V

					Colorpicker:Display()

					if Colorpicker.Value ~= OldValue and not IgnoreCallback then
						Library:SafeCallback(Colorpicker.Callback, Colorpicker.Value)
						Library:SafeCallback(Colorpicker.Changed, Colorpicker.Value)
					end
				end

				function Colorpicker:SetCallback(NewCallback: (Value: Color3) -> ())
					Colorpicker.Callback = NewCallback
				end

				function Colorpicker:OnChanged(Callback: (Value: Color3) -> ())
					Colorpicker.Changed = Callback
				end

				function Colorpicker:Update()
					local OldValue = Colorpicker.Value
					Colorpicker.Value = Color3.fromHSV(Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib)

					Colorpicker:Display()

					if Colorpicker.Value ~= OldValue then
						Library:SafeCallback(Colorpicker.Callback, Colorpicker.Value)
						Library:SafeCallback(Colorpicker.Changed, Colorpicker.Value)
					end
				end

				function Colorpicker:Display()
					ColorpickerButton.BackgroundColor3 = Colorpicker.Value
					ButtonStroke.Color = Library:GetDarkerColor(Colorpicker.Value)

					ColorMap.BackgroundColor3 = Color3.fromHSV(Colorpicker.Hue, 1, 1)

					ColorMapIndicator.Position = UDim2.fromScale(Colorpicker.Sat, 1 - Colorpicker.Vib)
					ColorHueIndicator.Position = UDim2.fromScale(0.5, Colorpicker.Hue)

					ColorHexInput.Text = Colorpicker.Value:ToHex()
				end

				function Colorpicker:Show()
					ColorpickerConfig.Visible = true
				end

				function Colorpicker:Hide()
					ColorpickerConfig.Visible = false
				end

				function Colorpicker:Toggle()
					ColorpickerConfig.Visible = not ColorpickerConfig.Visible
				end

				local ScreenSize = ViewportSize
				function Colorpicker:UpdatePosition()
					ScreenSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or ScreenSize

					local Position = ColorpickerButton.AbsolutePosition
					local ConfigSize = ColorpickerConfig.AbsoluteSize
					local Inset = GuiService:GetGuiInset().Y

					ColorpickerConfig.Position = UDim2.fromOffset(
						math.clamp(Position.X + ColorpickerButton.Size.X.Offset, 0, ScreenSize.X - ConfigSize.X),
						math.clamp(Position.Y, -Inset, ScreenSize.Y - ConfigSize.Y - Inset)
					)
				end

				if Colorpicker.Description then
					ColorpickerFrame.Size = UDim2.new(1, 0, 0, 54)
					DescLabel.Text = Colorpicker.Description
				end
				Library.Flags[Flag] = Colorpicker
				Library.Options[Flag] = Colorpicker

				Colorpicker:SetValue(Colorpicker.Value, ColorpickerInfo.SkipInitialCallback)
				Colorpicker:UpdatePosition()

				--// Execution \\--
				ColorpickerFrame.MouseEnter:Connect(function()
					TweenService:Create(Stroke, WindowTweenInfo, {
						Transparency = 0,
					}):Play()
				end)
				ColorpickerFrame.MouseLeave:Connect(function()
					TweenService:Create(Stroke, WindowTweenInfo, {
						Transparency = 0.75,
					}):Play()
				end)
				ColorpickerFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(Colorpicker.UpdatePosition)

				ColorpickerButton.MouseButton1Click:Connect(Colorpicker.Toggle)

				ColorHexInput.FocusLost:Connect(function()
					local Success, Color = pcall(Color3.fromHex, ColorHexInput.Text)
					if Success then
						Colorpicker:SetValue(Color)
					else
						ColorHexInput.Text = Colorpicker.Value:ToHex()
					end
				end)

				local DraggingColor = false
				local DraggingHue = false
				local Changed
				ColorMap.InputBegan:Connect(function(Input: InputObject)
					if not IsClickInput(Input) then
						return
					end

					DraggingColor = true

					local AbsPos, AbsSize = ColorMap.AbsolutePosition, ColorMap.AbsoluteSize

					local MaxX = AbsPos.X + AbsSize.X
					local MouseX = math.clamp(Input.Position.X, AbsPos.X, MaxX)

					local MaxY = AbsPos.Y + AbsSize.Y
					local MouseY = math.clamp(Input.Position.Y, AbsPos.Y, MaxY)

					Colorpicker.Sat = (MouseX - AbsPos.X) / (MaxX - AbsPos.X)
					Colorpicker.Vib = 1 - (MouseY - AbsPos.Y) / (MaxY - AbsPos.Y)
					Colorpicker:Update()

					Changed = Input.Changed:Connect(function()
						if Input.UserInputState ~= Enum.UserInputState.End then
							return
						end

						DraggingColor = false
						if Changed and Changed.Connected then
							Changed:Disconnect()
							Changed = nil
						end
					end)
				end)
				ColorHue.InputBegan:Connect(function(Input: InputObject)
					if not IsClickInput(Input) then
						return
					end

					DraggingHue = true

					local AbsPos, AbsSize = ColorHue.AbsolutePosition, ColorHue.AbsoluteSize

					local MaxY = AbsPos.Y + AbsSize.Y
					local MouseY = math.clamp(Input.Position.Y, AbsPos.Y, MaxY)

					Colorpicker.Hue = (MouseY - AbsPos.Y) / (MaxY - AbsPos.Y)
					Colorpicker:Update()

					Changed = Input.Changed:Connect(function()
						if Input.UserInputState ~= Enum.UserInputState.End then
							return
						end

						DraggingHue = false
						if Changed and Changed.Connected then
							Changed:Disconnect()
							Changed = nil
						end
					end)
				end)

				Library:Connect(UserInputService.InputChanged:Connect(function(Input: InputObject)
					if not Library.Opened or Library.Unloaded then
						DraggingColor = false
						DraggingHue = false
						if Changed and Changed.Connected then
							Changed:Disconnect()
							Changed = nil
						end

						return
					end

					if not IsHoverInput(Input) then
						return
					end

					if DraggingColor then
						local AbsPos, AbsSize = ColorMap.AbsolutePosition, ColorMap.AbsoluteSize

						local MaxX = AbsPos.X + AbsSize.X
						local MouseX = math.clamp(Input.Position.X, AbsPos.X, MaxX)

						local MaxY = AbsPos.Y + AbsSize.Y
						local MouseY = math.clamp(Input.Position.Y, AbsPos.Y, MaxY)

						Colorpicker.Sat = (MouseX - AbsPos.X) / (MaxX - AbsPos.X)
						Colorpicker.Vib = 1 - (MouseY - AbsPos.Y) / (MaxY - AbsPos.Y)
						Colorpicker:Update()
					elseif DraggingHue then
						local AbsPos, AbsSize = ColorHue.AbsolutePosition, ColorHue.AbsoluteSize

						local MaxY = AbsPos.Y + AbsSize.Y
						local MouseY = math.clamp(Input.Position.Y, AbsPos.Y, MaxY)

						Colorpicker.Hue = (MouseY - AbsPos.Y) / (MaxY - AbsPos.Y)
						Colorpicker:Update()
					end
				end))

				Library:Connect(UserInputService.InputBegan:Connect(function(Input: InputObject)
					if IsClickInput(Input) then
						local Mouse = Input.Position

						if
							not (
								Library:MouseIsOverFrame(ColorpickerButton, Mouse)
								or Library:MouseIsOverFrame(ColorpickerConfig, Mouse)
							)
						then
							Colorpicker:Hide()
						end
					end
				end))

				return Colorpicker
			end

			--// Execution \\--
			SectionButton.MouseButton1Click:Connect(Section.Toggle)

			return Section
		end

		function Tab:Hover(Hovering: boolean)
			if Window.ActiveTab == Tab then
				return
			end

			TweenService:Create(TabButton, WindowTweenInfo, {
				BackgroundTransparency = Hovering and 0.5 or 1,
				TextTransparency = Hovering and 0.25 or 0.5,
			}):Play()
			TweenService:Create(TabStroke, WindowTweenInfo, {
				Transparency = Hovering and 0.5 or 1,
			}):Play()
			if Icon then
				TweenService:Create(Icon, WindowTweenInfo, {
					ImageTransparency = Hovering and 0.25 or 0.5,
				}):Play()
			end
		end

		function Tab:Show()
			TabContainer.Visible = true

			TweenService:Create(TabButton, WindowTweenInfo, {
				BackgroundTransparency = 0,
				TextTransparency = 0,
			}):Play()
			TweenService:Create(TabStroke, WindowTweenInfo, {
				Transparency = 0,
			}):Play()
			if Icon then
				TweenService:Create(Icon, WindowTweenInfo, {
					ImageTransparency = 0,
				}):Play()
			end
		end

		function Tab:Hide()
			TabContainer.Visible = false

			TweenService:Create(TabButton, WindowTweenInfo, {
				BackgroundTransparency = 1,
				TextTransparency = 0.5,
			}):Play()
			TweenService:Create(TabStroke, WindowTweenInfo, {
				Transparency = 1,
			}):Play()
			if Icon then
				TweenService:Create(Icon, WindowTweenInfo, {
					ImageTransparency = 0.5,
				}):Play()
			end
		end

		function Tab:Set()
			if Window.ActiveTab == Tab then
				return
			end

			Window.ActiveTab.Hide()
			Window.ActiveTab = Tab
			Tab.Show()
		end

		--// Execution \\--
		local TextSizeX = Library:GetTextBounds(TabButton.Text, TabButton.FontFace, TabButton.TextSize)
		local IconOffset = Icon and 16 or 0
		TabButton.Size = UDim2.new(0, TextSizeX + IconOffset + 48, 1, 0)

		if not Window.ActiveTab then
			Window.ActiveTab = Tab
			Tab.Show()
		end

		TabButton.MouseEnter:Connect(function()
			Tab:Hover(true)
		end)
		TabButton.MouseLeave:Connect(function()
			Tab:Hover(false)
		end)

		TabButton.MouseButton1Click:Connect(Tab.Set)

		return Tab
	end

	function Library:Toggle(Value: boolean?)
		if typeof(Value) == "boolean" then
			Library.Opened = Value
		else
			Library.Opened = not Library.Opened
		end
		MainFrame.Visible = Library.Opened
	end

	--// Execution \\--
	Library:MakeDraggable(MainFrame, TitleBar)

	if Library.IsMobile then
		local ToggleButton = New("TextButton", {
			AnchorPoint = Vector2.new(0.5, 0.8),
			BackgroundColor3 = "ButtonColor",
			FontFace = WindowInfo.Font,
			Position = UDim2.fromScale(0.5, 0.8),
			Text = "Toggle",
			TextSize = WindowInfo.FontSize,
			ZIndex = 100,
			Parent = ScreenGui,
		})

		New("UIStroke", {
			Color = "BorderColor",
			Parent = ToggleButton,
		})

		ToggleButton.Size = UDim2.fromOffset(ToggleButton.TextBounds.X + 32, WindowInfo.FontSize + 16)

		ToggleButton.MouseButton1Click:Connect(Library.Toggle)
		Library:MakeDraggable(ToggleButton, ToggleButton, true)
	end
	Library:Connect(UserInputService.InputBegan:Connect(function(Input: InputObject)
		if UserInputService:GetFocusedTextBox() then
			return
		end

		if
			(
				typeof(Library.ToggleKeybind) == "table"
				and Library.ToggleKeybind.Type == "Keypicker"
				and Input.KeyCode == Library.ToggleKeybind.Keybind
			) or Input.KeyCode == Library.ToggleKeybind
		then
			Library.Toggle()
		end
	end))

	local function PlayerUpdate()
		local PlayersTable = Players:GetPlayers()

		for _, Flag: DropdownTable in pairs(Library.Flags) do
			if Flag.SpecialType and Flag.SpecialType == "Player" then
				Flag:SetValues(PlayersTable)
			end
		end
	end
	Library:Connect(Players.PlayerAdded:Connect(PlayerUpdate))
	Library:Connect(Players.PlayerRemoving:Connect(PlayerUpdate))

	return Window
end

function Library:Connect(Connection: RBXScriptConnection)
	table.insert(Library.Connections, Connection)
end

function Library:OnUnload(Callback)
	table.insert(Library.UnloadCallbacks, Callback)
end

function Library:Unload()
	for Index = #Library.Connections, 1, -1 do
		local Connection = table.remove(Library.Connections, Index)
		Connection:Disconnect()
	end

	for _, Callback in pairs(Library.UnloadCallbacks) do
		Library:SafeCallback(Callback)
	end

	Library.Unloaded = true
	ScreenGui:Destroy()
end

if getgenv then
	getgenv().Library = Library
end
return Library
