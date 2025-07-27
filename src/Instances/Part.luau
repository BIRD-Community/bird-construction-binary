local module = {}

module.values = {
	["Name"] = {
		valueType = "string",
		defaultValue = "Part",
		serializer = require("../Types/string"),
	},
	["CFrame"] = {
		valueType = "CFrame",
		defaultValue = CFrame.new(),
		serializer = require("../Types/CFrame"),
	},
	["Size"] = {
		valueType = "Vector3",
		defaultValue = Vector3.new(4,1.2,2),
		serializer = require("../Types/Vector3"),
	},
	["Color"] = {
		valueType = "Color3",
		defaultValue = Color3.fromRGB(163,162,165),
		serializer = require("../Types/Color3"),
	},
	["Transparency"] = {
		valueType = "number",
		defaultValue = 0,
		serializer = require("../Types/number"),
	},
	["Material"] = {
		valueType = "Material",
		defaultValue = Enum.Material.Plastic,
		serializer = require("../Types/Material"),
	},
	["Shape"] = {
		valueType = "PartType",
		defaultValue = Enum.PartType.Block,
		serializer = require("../Types/PartType"),
	}
}

return module
