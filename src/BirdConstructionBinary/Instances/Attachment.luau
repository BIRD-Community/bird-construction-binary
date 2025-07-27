local module = {}

module.values = {
	["Name"] = {
		valueType = "string",
		defaultValue = "RopeConstraint",
		serializer = require(script.Parent.Parent.Types.string),
	},
	["Parent"] = {
		valueType = "Reference",
		defaultValue = nil,
		serializer = nil,
	},
	["CFrame"] = {
		valueType = "CFrame",
		defaultValue = CFrame.new(),
		serializer = require(script.Parent.Parent.Types.CFrame),
	},
}

return module
