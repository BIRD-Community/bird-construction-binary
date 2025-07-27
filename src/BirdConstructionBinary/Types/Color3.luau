local module = {}

module.length = 3 * 4

function module.serialize(value: Color3)
	local buff = buffer.create(module.length)
	buffer.writef32(buff, 0, value.R)
	buffer.writef32(buff, 4, value.G)
	buffer.writef32(buff, 8, value.B)
	return buff
end

function module.deserialize(buff: buffer)
	local r = buffer.readf32(buff, 0)
	local g = buffer.readf32(buff, 4)
	local b = buffer.readf32(buff, 8)
	return Color3.new(r, g, b)
end

function module.initDictionary()
	local dictionary = {}
	for i = 1, 255 do
		dictionary[i] = Color3.fromRGB(i, i, i)
	end
	return dictionary
end

return module
