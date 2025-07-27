local color3Data = {}

color3Data.length = 3 * 4

function color3Data.serialize(value: Color3)
	local buff = buffer.create(color3Data.length)
	buffer.writef32(buff, 0, value.R)
	buffer.writef32(buff, 4, value.G)
	buffer.writef32(buff, 8, value.B)
	return buff
end

function color3Data.deserialize(buff: buffer)
	local r = buffer.readf32(buff, 0)
	local g = buffer.readf32(buff, 4)
	local b = buffer.readf32(buff, 8)
	return Color3.new(r, g, b)
end

function color3Data.initDictionary()
	local dictionary = {}
	for i = 1, 255 do
		dictionary[i] = Color3.fromRGB(i, i, i)
	end
	return dictionary
end

return color3Data
