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
	["Length"] = {
		valueType = "numberf32",
		defaultValue = 5,
		serializer = require("../Types/numberf32"),
	},
	["Restitution"] = {
		valueType = "numberf32",
		defaultValue = 0,
		serializer = require("../Types/numberf32"),
	},
	["Thickness"] = {
		valueType = "numberf32",
		defaultValue = 0.1,
		serializer = require("../Types/numberf32"),
	},
	["Color"] = {
		valueType = "BrickColor",
		defaultValue = BrickColor.new("Earth orange"),
		serializer = require("../Types/BrickColor"),
	},
}


return module
