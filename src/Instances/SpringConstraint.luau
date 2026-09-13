local module = {}

module.values = {
	["Name"] = {
		valueType = "string",
		defaultValue = "RopeConstraint",
		serializer = require("../Types/string"),
	},
	["Attachment0"] = {
		valueType = "Reference",
		defaultValue = nil,
		serializer = nil,
	},
	["Attachment1"] = {
		valueType = "Reference",
		defaultValue = nil,
		serializer = nil,
	},
	["Visible"] = {
		valueType = "boolean",
		defaultValue = false,
		serializer = require("../Types/boolean"),
	},
	["FreeLength"] = {
		valueType = "numberf32",
		defaultValue = 1,
		serializer = require("../Types/numberf32"),
	},
	["Thickness"] = {
		valueType = "numberf32",
		defaultValue = 0.1,
		serializer = require("../Types/numberf32"),
	},
	["Radius"] = {
		valueType = "numberf32",
		defaultValue = 0.4,
		serializer = require("../Types/numberf32"),
	},
	["Damping"] = {
		valueType = "numberf32",
		defaultValue = 0,
		serializer = require("../Types/numberf32"),
	},
	["Stiffness"] = {
		valueType = "numberf32",
		defaultValue = 0,
		serializer = require("../Types/numberf32"),
	},
	["Coils"] = {
		valueType = "numberf32",
		defaultValue = 0.4,
		serializer = require("../Types/numberf32"),
	},
	["Color"] = {
		valueType = "BrickColor",
		defaultValue = BrickColor.new("Earth orange"),
		serializer = require("../Types/BrickColor"),
	},
}


return module
