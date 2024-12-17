--original: https://github.com/mstudio45/LinoriaLib/blob/main/addons/ThemeManager.lua
local HttpService = game:GetService("HttpService")

local ThemeManager = {
	Folder = "TwilightLibSettings",
	Library = nil,
	BuiltInThemes = {
		Default = {
			1,
			HttpService:JSONDecode(
				'{"FillColor":"5a5a5a","SectionColor":"141414","FontColor":"ffffff","TitleBarColor":"0a0a0a","ButtonColor":"191919","FillBorderColor":"3c3c3c","BorderColor":"2d2d2d","TabBarColor":"0a0a0a","ContainerColor":"0f0f0f"}'
			),
		},
		Deivid = {
			2,
			HttpService:JSONDecode(
				'{"FillColor":"303035","SectionColor":"18181d","FontColor":"ffffff","TitleBarColor":"141419","ButtonColor":"1c1c21","FillBorderColor":"343439","BorderColor":"202025","TabBarColor":"141419","ContainerColor":"141419"}'
			),	
		},
	},
}

function ThemeManager:SetLibrary(library)
	self.Library = library
end

--// Folders \\--
function ThemeManager:GetPaths()
	local paths = {}

	local parts = self.Folder:split("/")
	for idx = 1, #parts do
		paths[#paths + 1] = table.concat(parts, "/", 1, idx)
	end

	paths[#paths + 1] = self.Folder .. "/themes"

	return paths
end

function ThemeManager:BuildFolderTree()
	local paths = self:GetPaths()

	for i = 1, #paths do
		local str = paths[i]
		if isfolder(str) then
			continue
		end
		makefolder(str)
	end
end

function ThemeManager:SetFolder(folder)
	self.Folder = folder
	self:BuildFolderTree()
end

--// Get, Load, Save, Delete, Refresh \\--
function ThemeManager:GetCustomTheme(file)
	local path = self.Folder .. "/themes/" .. file .. ".json"
	if not isfile(path) then
		return nil
	end

	local data = readfile(path)
	local success, decoded = pcall(HttpService.JSONDecode, HttpService, data)

	if not success then
		return nil
	end

	return decoded
end

function ThemeManager:ApplyTheme(theme)
	local customThemeData = self:GetCustomTheme(theme)
	local data = customThemeData or self.BuiltInThemes[theme]

	if not data then
		return
	end

	if self.Library.Flags.ThemeManager_ThemeList.Value ~= theme then
		self.Library.Flags.ThemeManager_ThemeList:SetValue(nil, true)
	end

	local scheme = data[2]
	for idx, col in pairs(customThemeData or scheme) do
		self.Library[idx] = Color3.fromHex(col)

		if self.Library.Flags[idx] then
			self.Library.Flags[idx]:SetValue(Color3.fromHex(col))
		end
	end
end

function ThemeManager:LoadDefault()
	local theme = "Default"
	local content = isfile(self.Folder .. "/themes/default.txt") and readfile(self.Folder .. "/themes/default.txt")

	local isDefault = true
	if content then
		if self.BuiltInThemes[content] then
			theme = content
		elseif self:GetCustomTheme(content) then
			theme = content
			isDefault = false
		end
	elseif self.BuiltInThemes[self.DefaultTheme] then
		theme = self.DefaultTheme
	end

	if isDefault then
		self.Library.Flags.ThemeManager_ThemeList:SetValue(theme)
	else
		self:ApplyTheme(theme)
	end
end

function ThemeManager:SaveDefault(theme)
	writefile(self.Folder .. "/themes/default.txt", theme)
end

function ThemeManager:SaveCustomTheme(file)
	if not file or file:gsub(" ", "") == "" then
		return self.Library:Notify({
			Title = "Theme Manager",
			Content = "Invalid file name for theme (empty)",
			Duration = 3,
		})
	end

	local theme = {}
	local fields = {
		"TitleBarColor",
		"TabBarColor",
		"ContainerColor",
		"SectionColor",
		"ButtonColor",
		"BorderColor",
		"FillColor",
		"FillBorderColor",
		"FontColor",
	}

	for _, field in pairs(fields) do
		theme[field] = self.Library.Flags[field].Value:ToHex()
	end

	writefile(self.Folder .. "/themes/" .. file .. ".json", HttpService:JSONEncode(theme))
end

function ThemeManager:Delete(name)
	if not name then
		return false, "no theme file is selected"
	end

	local file = self.Folder .. "/themes/" .. name .. ".json"
	if not isfile(file) then
		return false, "invalid file"
	end

	local success = pcall(delfile, file)
	if not success then
		return false, "delete file error"
	end

	return true
end

function ThemeManager:ReloadCustomThemes()
	local list = listfiles(self.Folder .. "/themes")

	local out = {}
	for i = 1, #list do
		local file = list[i]
		if file:sub(-5) == ".json" then
			-- i hate this but it has to be done ...

			local pos = file:find(".json", 1, true)
			local start = pos

			local char = file:sub(pos, pos)
			while char ~= "/" and char ~= "\\" and char ~= "" do
				pos = pos - 1
				char = file:sub(pos, pos)
			end

			if char == "/" or char == "\\" then
				table.insert(out, file:sub(pos + 1, start - 1))
			end
		end
	end

	return out
end

--// GUI \\--
function ThemeManager:CreateThemeManager(Section)
	Section:CreateColorpicker("TitleBarColor", {
		Title = "Title Bar",
		Value = self.Library.Theme.TitleBarColor,
		Callback = function(Value)
			self.Library:ChangeTheme("TitleBarColor", Value)
		end,
	})
	Section:CreateColorpicker("TabBarColor", {
		Title = "Tab Bar Color",
		Value = self.Library.Theme.TabBarColor,
		Callback = function(Value)
			self.Library:ChangeTheme("TabBarColor", Value)
		end,
	})
	Section:CreateColorpicker("ContainerColor", {
		Title = "Container Color",
		Value = self.Library.Theme.ContainerColor,
		Callback = function(Value)
			self.Library:ChangeTheme("ContainerColor", Value)
		end,
	})
	Section:CreateColorpicker("SectionColor", {
		Title = "Section Color",
		Value = self.Library.Theme.SectionColor,
		Callback = function(Value)
			self.Library:ChangeTheme("SectionColor", Value)
		end,
	})
	Section:CreateColorpicker("ButtonColor", {
		Title = "Button Color",
		Value = self.Library.Theme.ButtonColor,
		Callback = function(Value)
			self.Library:ChangeTheme("ButtonColor", Value)
		end,
	})
	Section:CreateColorpicker("BorderColor", {
		Title = "Border Color",
		Value = self.Library.Theme.BorderColor,
		Callback = function(Value)
			self.Library:ChangeTheme("BorderColor", Value)
		end,
	})
	Section:CreateColorpicker("FillColor", {
		Title = "Fill Color",
		Value = self.Library.Theme.FillColor,
		Callback = function(Value)
			self.Library:ChangeTheme("FillColor", Value)
		end,
	})
	Section:CreateColorpicker("FillBorderColor", {
		Title = "Fill Border Color",
		Value = self.Library.Theme.FillBorderColor,
		Callback = function(Value)
			self.Library:ChangeTheme("FillBorderColor", Value)
		end,
	})
	Section:CreateColorpicker("FontColor", {
		Title = "Font Color",
		Value = self.Library.Theme.FontColor,
		Callback = function(Value)
			self.Library:ChangeTheme("FontColor", Value)
		end,
	})

	-- Save --
	local ThemesArray = {}
	for Name, _ in pairs(self.BuiltInThemes) do
		table.insert(ThemesArray, Name)
	end

	table.sort(ThemesArray, function(a, b)
		return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1]
	end)

	Section:CreateDivider()

	Section:CreateDropdown("ThemeManager_ThemeList", {
		Title = "Theme List",
		Values = ThemesArray,
		Callback = function(Value)
			self:ApplyTheme(Value)
		end,
	})
	Section:CreateButton("ThemeManager_ThemeDefault", {
		Title = "Set as default",
		Callback = function()
			local name = self.Library.Flags.ThemeManager_ThemeList.Value
			if not (name and name ~= "") then
				return
			end

			self:SaveDefault(name)
			self.Library:Notify({
				Title = "Theme Manager",
				Content = string.format("Set default theme to %q", name),
				Duration = 3,
			})
		end,
	})

	Section:CreateDivider()

	Section:CreateInput("ThemeManager_CustomThemeName", {
		Title = "Custom Theme Name",
	})
	Section:CreateButton("ThemeManager_CreateTheme", {
		Title = "Create Theme",
		Callback = function()
			self:SaveCustomTheme(self.Library.Flags.ThemeManager_CustomThemeName.Value)

			self.Library.Flags.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
			self.Library.Flags.ThemeManager_CustomThemeList:SetValue(nil)
		end,
	})

	Section:CreateDivider()

	Section:CreateDropdown("ThemeManager_CustomThemeList", {
		Title = "Custom Themes List",
		Values = self:ReloadCustomThemes(),
	})
	Section:CreateButton("ThemeManager_CustomThemeLoad", {
		Title = "Load Theme",
		Callback = function()
			local name = self.Library.Flags.ThemeManager_CustomThemeList.Value

			self:ApplyTheme(name)
			self.Library:Notify({
				Title = "Theme Manager",
				Content = string.format("Loaded theme %q", name),
				Duration = 3,
			})
		end,
	})
	Section:CreateButton("ThemeManager_CustomThemeOverwrite", {
		Title = "Overwrite Theme",
		Callback = function()
			local name = self.Library.Flags.ThemeManager_CustomThemeList.Value

			self:SaveCustomTheme(name)
			self.Library:Notify({
				Title = "Theme Manager",
				Content = string.format("Overwrote theme %q", name),
				Duration = 3,
			})
		end,
	})
	Section:CreateButton("ThemeManager_CustomThemeDelete", {
		Title = "Delete Theme",
		Callback = function()
			local name = self.Library.Flags.ThemeManager_CustomThemeList.Value

			local success, err = self:Delete(name)
			if not success then
				self.Library:Notify({
					Title = "Theme Manager",
					Content = "Failed to delete theme, " .. err,
				})
				return
			end

			self.Library:Notify({
				Title = "Theme Manager",
				Content = string.format("Deleted theme %q", name),
				Duration = 3,
			})
			self.Library.Flags.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
			self.Library.Flags.ThemeManager_CustomThemeList:SetValue(nil)
		end,
	})
	Section:CreateButton("ThemeManager_CustomThemeRefresh", {
		Title = "Refresh List",
		Callback = function()
			self.Library.Flags.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
			self.Library.Flags.ThemeManager_CustomThemeList:SetValue(nil)
		end,
	})
	Section:CreateButton("ThemeManager_CustomThemeDefault", {
		Title = "Set as default",
		Callback = function()
			local name = self.Library.Flags.ThemeManager_CustomThemeList.Value
			if not (name and name ~= "") then
				return
			end

			self:SaveDefault(name)
			self.Library:Notify({
				Title = "Theme Manager",
				Content = string.format("Set default theme to %q", name),
				Duration = 3,
			})
		end,
	})
	Section:CreateButton("ThemeManager_CustomThemeResetDefault", {
		Title = "Reset default",
		Callback = function()
			local success = pcall(delfile, self.Folder .. "/themes/default.txt")
			if not success then
				self.Library:Notify({
					Title = "Theme Manager",
					Content = "Failed to reset default: delete file error",
					Duration = 3,
				})
				return
			end

			self.Library:Notify({
				Title = "Theme Manager",
				Content = "Set default theme to nothing",
				Duration = 3,
			})
		end,
	})

	self:LoadDefault()
end

function ThemeManager:ApplyToTab(Tab)
	assert(self.Library, "Must set ThemeManager.Library first!")
	local Section = Tab:CreateSection("Theme Manager")
	self:CreateThemeManager(Section)
end

ThemeManager:BuildFolderTree()
return ThemeManager
