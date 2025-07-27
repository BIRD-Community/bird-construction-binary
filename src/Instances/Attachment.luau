local module = {}

module.values = {
	["Name"] = {
		valueType = "string",
		defaultValue = "RopeConstraint",
		serializer = require("../Types/string"),
	},
	["Parent"] = {
		valueType = "Reference",
		defaultValue = nil,
		serializer = nil,
	},
	["CFrame"] = {
		valueType = "CFrame",
		defaultValue = CFrame.new(),
		serializer = require("../Types/CFrame"),
	},
}

return module
