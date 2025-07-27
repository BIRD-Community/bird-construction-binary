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
		valueType = "number",
		defaultValue = 5,
		serializer = require("../Types/number"),
	},
	["Restitution"] = {
		valueType = "number",
		defaultValue = 0,
		serializer = require("../Types/number"),
	},
	["Thickness"] = {
		valueType = "number",
		defaultValue = 0.1,
		serializer = require("../Types/number"),
	},
	["Color"] = {
		valueType = "BrickColor",
		defaultValue = BrickColor.new("Earth orange"),
		serializer = require("../Types/BrickColor"),
	},
}


return module
