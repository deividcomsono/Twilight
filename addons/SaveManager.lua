--original: https://github.com/mstudio45/LinoriaLib/blob/main/addons/SaveManager.lua
local HttpService = game:GetService("HttpService")

local SaveManager = {
	Folder = "TwilightLibSettings",
	Ignore = {},
	Library = nil,
}

SaveManager.Parser = {
	Toggle = {
		Save = function(Flag, Table)
			return { Type = "Toggle", Flag = Flag, Value = Table.Value }
		end,
		Load = function(Flag, Data)
			local Table = SaveManager.Library.Flags[Flag]
			if Table then
				Table:SetValue(Data.Value)
			end
		end,
	},
	Slider = {
		Save = function(Flag, Table)
			return { Type = "Slider", Flag = Flag, Value = tostring(Table.Value) }
		end,
		Load = function(Flag, Data)
			local Table = SaveManager.Library.Flags[Flag]
			if Table then
				Table:SetValue(tonumber(Data.Value))
			end
		end,
	},
	Input = {
		Save = function(Flag, Table)
			return { Type = "Input", Flag = Flag, Value = Table.Value }
		end,
		Load = function(Flag, Data)
			local Table = SaveManager.Library.Flags[Flag]
			if Table then
				Table:SetValue(Data.Value)
			end
		end,
	},
	Dropdown = {
		Save = function(Flag, Table)
			return { Type = "Dropdown", Flag = Flag, Value = Table.Value, Multi = Table.Multi }
		end,
		Load = function(Flag, Data)
			local Table = SaveManager.Library.Flags[Flag]
			if Table then
				Table:SetValue(Data.Value)
			end
		end,
	},
	Keypicker = {
		Save = function(Flag, Table)
			return { Type = "Keypicker", Flag = Flag, Keybind = tostring(Table.Keybind), Mode = Table.Mode }
		end,
		Load = function(Flag, Data)
			local Table = SaveManager.Library.Flags[Flag]
			if Table then
				Table:SetKeybind(SaveManager:StringToEnum(Data.Keybind))
				Table:SetMode(Data.Mode)
			end
		end,
	},
	Colorpicker = {
		Save = function(Flag, Table)
			return { Type = "Colorpicker", Flag = Flag, Value = Table.Value:ToHex() }
		end,
		Load = function(Flag, Data)
			local Table = SaveManager.Library.Flags[Flag]
			if Table then
				Table:SetValue(Color3.fromHex(Data.Value))
			end
		end,
	},
}

function SaveManager:StringToEnum(EnumString: string)
	if not EnumString then
		return
	end
	local Split = EnumString:split(".")
	table.remove(Split, 1)

	local Result = Enum
	for _, v in pairs(Split) do
		Result = Result[v]
	end
	return Result
end

function SaveManager:SetLibrary(library)
	self.Library = library
end

--// Folders \\--
function SaveManager:BuildFolderTree()
	local paths = {
		self.Folder,
		self.Folder .. "/themes",
		self.Folder .. "/settings",
	}

	for i = 1, #paths do
		local str = paths[i]
		if not isfolder(str) then
			makefolder(str)
		end
	end
end

function SaveManager:SetFolder(folder)
	self.Folder = folder
	self:BuildFolderTree()
end

--// Save, Load, Delete, Refresh, Ignore \\--
function SaveManager:Save(name)
	if not name or name:gsub(" ", "") == "" then
		return self.Library:Notify({
			Title = "Save Manager",
			Content = "Invalid file name for config (empty)",
			Duration = 3,
		})
	end

	local file = self.Folder .. "/settings/" .. name .. ".json"

	local data = {
		objects = {},
	}

	for flag, option in pairs(self.Library.Flags) do
		if not self.Parser[option.Type] then
			continue
		end
		if self.Ignore[flag] then
			continue
		end

		table.insert(data.objects, self.Parser[option.Type].Save(flag, option))
	end

	local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
	if not success then
		return false, "failed to encode data"
	end

	writefile(file, encoded)
	return true
end

function SaveManager:Load(name)
	if not name or name:gsub(" ", "") == "" then
		return self.Library:Notify({
			Title = "Save Manager",
			Content = "Invalid file name for config (empty)",
			Duration = 3,
		})
	end

	local file = self.Folder .. "/settings/" .. name .. ".json"
	if not isfile(file) then
		return false, "invalid file"
	end

	local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(file))
	if not success then
		return false, "decode error"
	end

	for _, option in next, decoded.objects do
		if self.Parser[option.Type] then
			task.spawn(function()
				self.Parser[option.Type].Load(option.Flag, option)
			end)
		end
	end

	return true
end

function SaveManager:Delete(name)
	if not name then
		return false, "no config file is selected"
	end

	local file = self.Folder .. "/settings/" .. name .. ".json"
	if not isfile(file) then
		return false, "invalid file"
	end

	local success = pcall(delfile, file)
	if not success then
		return false, "delete file error"
	end

	return true
end

function SaveManager:RefreshConfigList()
	local list = listfiles(self.Folder .. "/settings")

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

--// Auto Load: Save, Load, Delete \\--
function SaveManager:SaveAutoloadConfig(name)
	local file = self.Folder .. "/settings/autoload.txt"

	local success = pcall(writefile, file, name)
	if not success then
		return false, "write file error"
	end

	return true
end

function SaveManager:LoadAutoloadConfig()
	if isfile(self.Folder .. "/settings/autoload.txt") then
		local successRead, file = pcall(readfile, self.Folder .. "/settings/autoload.txt")
		if not successRead then
			self.Library:Notify({
				Title = "Save Manager",
				Content = "Failed to read autoload config, read file error",
				Duration = 3,
			})
			return
		end

		local success, err = self:Load(file)
		if not success then
			self.Library:Notify({
				Title = "Save Manager",
				Content = "Failed to load autoload config, " .. err,
				Duration = 3,
			})
			return
		end

		self.Library:Notify({
			Title = "Save Manager",
			Content = string.format("Auto loaded config %q", file),
			Duration = 3,
		})
	end
end

function SaveManager:DeleteAutoLoadConfig()
	local file = self.Folder .. "/settings/autoload.txt"

	local success = pcall(delfile, file)
	if not success then
		return false, "delete file error"
	end

	return true
end

function SaveManager:SetIgnoreIndexes(list)
	for _, key in pairs(list) do
		self.Ignore[key] = true
	end
end

function SaveManager:IgnoreThemeSettings()
	self:SetIgnoreIndexes({
		"TitleBarColor",
		"TabBarColor",
		"ContainerColor",
		"SectionColor",
		"ButtonColor",
		"BorderColor",
		"FillColor",
		"FillBorderColor",
		"FontColor", -- themes
		"ThemeManager_ThemeList",
		"ThemeManager_CustomThemeName",
		"ThemeManager_CustomThemeList", -- themes
	})
end

--// GUI \\--
function SaveManager:CreateSaveManager(Section)
	Section:CreateInput("SaveManager_ConfigName", {
		Title = "Config Name",
	})
	Section:CreateDropdown("SaveManager_ConfigList", {
		Title = "Config List",
		Values = self:RefreshConfigList(),
	})

	Section:CreateDivider()

	Section:CreateButton("SaveManager_CreateConfig", {
		Title = "Create Config",
		Callback = function()
			local name = self.Library.Flags.SaveManager_ConfigName.Value

			local success, err = self:Save(name)
			if not success then
				self.Library:Notify({
					Title = "Save Manager",
					Content = "Failed to save config, " .. err,
				})
				return
			end

			self.Library:Notify({
				Title = "Save Manager",
				Content = string.format("Created config %q", name),
				Duration = 3,
			})
			self.Library.Flags.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
			self.Library.Flags.SaveManager_ConfigList:SetValue(nil)
		end,
	})
	Section:CreateButton("SaveManager_LoadConfig", {
		Title = "Load Config",
		Callback = function()
			local name = self.Library.Flags.SaveManager_ConfigList.Value

			local success, err = self:Load(name)
			if not success then
				self.Library:Notify({
					Title = "Save Manager",
					Content = "Failed to load config, " .. err,
				})
				return
			end

			self.Library:Notify({
				Title = "Save Manager",
				Content = string.format("Loaded config %q", name),
				Duration = 3,
			})
		end,
	})
	Section:CreateButton("SaveManager_OverwriteConfig", {
		Title = "Overwrite Config",
		Callback = function()
			local name = self.Library.Flags.SaveManager_ConfigList.Value

			local success, err = self:Save(name)
			if not success then
				self.Library:Notify({
					Title = "Save Manager",
					Content = "Failed to overwrite config, " .. err,
				})
				return
			end

			self.Library:Notify({
				Title = "Save Manager",
				Content = string.format("Overwrote config %q", name),
				Duration = 3,
			})
		end,
	})
	Section:CreateButton("SaveManager_DeleteConfig", {
		Title = "Delete Config",
		Callback = function()
			local name = self.Library.Flags.SaveManager_ConfigList.Value

			local success, err = self:Delete(name)
			if not success then
				self.Library:Notify({
					Title = "Save Manager",
					Content = "Failed to delete config, " .. err,
				})
				return
			end

			self.Library:Notify({
				Title = "Save Manager",
				Content = string.format("Deleted config %q", name),
				Duration = 3,
			})
			self.Library.Flags.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
			self.Library.Flags.SaveManager_ConfigList:SetValue(nil)
		end,
	})
	Section:CreateButton("SaveManager_RefreshConfig", {
		Title = "Refresh List",
		Callback = function()
			self.Library.Flags.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
			self.Library.Flags.SaveManager_ConfigList:SetValue(nil)
		end,
	})

	Section:CreateDivider()

	local AutoloadLabel = Section:CreateLabel("AutoloadLabel", {
		Text = "Current autoload config: none",
	})
	Section:CreateButton("SaveManager_AutoloadConfig", {
		Title = "Set as autoload",
		Callback = function()
			local name = self.Library.Flags.SaveManager_ConfigList.Value

			local success, err = self:SaveAutoloadConfig(name)
			if not success then
				self.Library:Notify({
					Title = "Save Manager",
					Content = "Failed to set autoload config, " .. err,
				})
				return
			end

			AutoloadLabel:SetText("Current autoload config: " .. name)
			self.Library:Notify({
				Title = "Save Manager",
				Content = string.format("Set %q to auto load", name),
				Duration = 3,
			})
		end,
	})
	Section:CreateButton("SaveManager_ResetAutoloadConfig", {
		Title = "Reset autoload",
		Callback = function()
			local success, err = self:DeleteAutoLoadConfig()
			if not success then
				self.Library:Notify({
					Title = "Save Manager",
					Content = "Failed to reset autoload config, " .. err,
				})
				return
			end

			AutoloadLabel:SetText("Current autoload config: none")
			self.Library:Notify({
				Title = "Save Manager",
				Content = "Set autoload to none",
				Duration = 3,
			})
		end,
	})

	SaveManager:SetIgnoreIndexes({ "SaveManager_ConfigName", "SaveManager_ConfigList" })
end

function SaveManager:ApplyToTab(Tab)
	assert(self.Library, "Must set SaveManager.Library first!")
	local Section = Tab:CreateSection("Save Manager")
	self:CreateSaveManager(Section)
end

SaveManager:BuildFolderTree()
return SaveManager
