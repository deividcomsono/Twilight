local repo = "https://raw.githubusercontent.com/deividcomsono/Twilight/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
	Title = [[deivid ui <font transparency="0.5">| deivid has ballers</font>]],
	TopTabBar = true,

	--[[Default:
        Title = "Template",
        TopTabBar = false,
        OutlineThickness = 2,
        Width = 700,
        Height = 700,
        Font = Font.fromEnum(Enum.Font.Code),
        FontSize = 16,
        SectionFontSize = 18,
        SectionTitleTransparency = 0.5,
        ElementTitleTransparency = 0.5,
        MaxDialogButtonsPerLine = 4,
        MaxDropdownItems = 8,
        Theme = nil,
        TweenTime = 0.1,
        ToggleKeybind = Enum.KeyCode.RightControl,
    ]]
})

-- Twilight uses Lucide Icons v0.363.0 by https://github.com/latte-soft/lucide-roblox
local Main = Window:CreateTab("Main", "home") --home: Lucide Icon for Tab (optional)
local Settings = Window:CreateTab("Settings")

local ShowcaseSec = Main:CreateSection("Showcase", true) --true: Section Opened for default

ShowcaseSec:CreateLabel("Label", {
	Text = "This is a Label\n<font transparency='0'>It has Rich Text Enabled</font>\n<font size='14'>Tiny Size!</font>",
})

ShowcaseSec:CreateDivider()

local Button = ShowcaseSec:CreateButton("Button", {
	Title = "Test Notification",
	Description = "Cool Description",
	Callback = function()
		Library:Notify({
			Title = "Cool Title",
			Content = "Cool Content with <b>Cool Rich Text!</b>",
			Duration = 6,
		})

		Window:CreateDialog({
			Title = "Cool Title",
			Content = "Cool Content!!!",
			Buttons = {
				{
					Title = "Confirm",
					Callback = function()
						print("Confirmed")
					end,
				},
				{
					Title = "Cancel",
					Callback = function()
						print("Cancelled")
					end,
				},
				{
					Title = "...",
					Callback = function()
						print("...")
					end,
				},
			},
		})
	end,
})

ShowcaseSec:CreateDivider(16) -- 16: Offset Size, Default is 12

local Toggle = ShowcaseSec:CreateToggle("Toggle", {
	Title = "Toggle",
	Description = "skibid rizz ohio town",
	Callback = function(Value: boolean)
		print("Toggle:", Value)
	end,
})

local Slider = ShowcaseSec:CreateSlider("Slider", {
	Title = "Slider",
	Suffix = " suffix",
	Min = -10,
	Max = 10,
	Value = 0,
	Increment = 0.5,
})

Slider:OnChanged(function(Value: number)
	print("Slider:", Value)
end)

local Input = ShowcaseSec:CreateInput("Input", {
	Title = "Cool Input",
	ClearOnFocus = false,
	Value = "Input",
	Callback = function(Value: number)
		print("Cool Input:", Value)
	end,
})

local Dropdown = ShowcaseSec:CreateDropdown("Dropdown", {
	Title = "Dropdown",
	Value = "real",
	Values = { "real", "fake", "deivid" },
	Callback = function(Value: string)
		print("Dropdown:", Value)
	end,
})

local TestValues = {}
for i = 1, 500 do
	table.insert(TestValues, tostring(i))
end
local MultiDropdown = ShowcaseSec:CreateDropdown("MultiDropdown", {
	Title = "Multi Dropdown",
	Value = { "1", "2", "3", "4", "5" },
	Values = TestValues,
	Multi = true,
	Callback = function(Values: { [any]: string })
		local Table = {}
		for Value, _ in pairs(Values) do
			table.insert(Table, Value)
		end
		print("Multi Dropdown:", unpack(Table))
	end,
})

local PlayerDropdown = ShowcaseSec:CreateDropdown("PlayerDropdown", {
	Title = "Player Dropdown",
	SpecialType = "Player",
	Callback = function(Player: Player)
		print("Player Dropdown:", Player)
	end,
})

local MultiPlayerDropdown = ShowcaseSec:CreateDropdown("MultiPlayerDropdown", {
	Title = "Multi Player Dropdown",
	Multi = true,
	SpecialType = "Player",
	Callback = function(Players: { [any]: Player })
		local Table = {}
		for Player, _ in pairs(Players) do
			table.insert(Table, Player)
		end
		print("Multi Player Dropdown:", unpack(Table))
	end,
})

local Keypicker = ShowcaseSec:CreateKeypicker("Keypicker", {
	Title = "Keypicker",
	Keybind = Enum.KeyCode.E,
	Mode = "Hold", -- Modes: Always, Toggle, Hold | Default is Toggle
	Callback = function(Value: boolean)
		print("Keypicker:", Value)
	end,
})

local Toggle_Slider = ShowcaseSec:CreateToggle("ToggleSlider", {
	Title = "Toggle + Slider + Keypicker",
	Callback = function(Value: boolean)
		print("Toggle with Slider and Keypicker:", Value)
	end,
})
	:CreateSlider("SliderToggle", {
		Min = 0,
		Max = 20,
		Value = 0,
		Callback = function(Value: number)
			print("Slider from Toggle + Keypicker:", Value)
		end,
	})
	:CreateKeypicker({
		Keybind = Enum.KeyCode.B,
		Callback = function(Value: boolean)
			print("Keypicker from Toggle + Slider:", Value)
		end,
	})

--[[
    Toggle_Slider:CreateSlider("SliderToggle", {
        Min = 0,
        Max = 20,
        Value = 0,
        Callback = function(Value: number)
            print("Slider from Toggle:", Value)
        end,
    })

    Toggle_Slider:CreateKeypicker({
        Keybind = Enum.KeyCode.Q,
        Callback = function(Value: boolean)
            print("Keypicker from Toggle + Slider:", Value)
        end,
    })]]

ShowcaseSec:CreateToggle("Toggle1", {
	Title = "Toggle + Keypicker",
	Callback = function(Value: boolean)
		print("Toggle with Keybind:", Value)
	end,
}):CreateKeypicker("Keypicker1", {
	Keybind = Enum.KeyCode.F,
	Callback = function(Value: boolean)
		print("Keypicker from Toggle:", Value)
	end,
})

ShowcaseSec:CreateToggle("ToggleSync", {
	Title = "Toggle + Keypicker with Sync State",
	Value = true,
	Callback = function(Value: boolean)
		print("Toggle with Sync State:", Value)
	end,
}):CreateKeypicker("KeypickerSync", {
	Keybind = Enum.KeyCode.G,
	SyncToggleState = true,
	Callback = function(Value: boolean)
		print("Keypicker With Sync State:", Value)
	end,
})

ShowcaseSec:CreateColorpicker("Colorpicker1", {
	Title = "Colorpicker",
	Value = Color3.new(1, 0, 0),
	Callback = function(Value: Color3)
		print("Colorpicker:", Value)
	end,
})

local MenuSec = Settings:CreateSection("Menu")

local ToggleKeypicker = MenuSec:CreateKeypicker("ToggleKeybind", {
	Title = "Toggle Keybind",
	Keybind = Library.ToggleKeybind,
})

MenuSec:CreateButton("UnloadButton", {
	Title = "Unload",
	Callback = function()
		Library:Unload()
	end,
})

Library.ToggleKeybind = ToggleKeypicker

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:ApplyToTab(Settings)
SaveManager:ApplyToTab(Settings)

Library:OnUnload(function()
	print("Unloading UI Library")
end)
