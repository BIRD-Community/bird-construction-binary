local module = {}

module.length = 2

function module.serialize(value: BrickColor)
	local buff = buffer.create(module.length)
	buffer.writeu16(buff, 0, value.Number)
	return buff
end

function module.deserialize(buff: buffer)
	local number = buffer.readu16(buff, 0)
	return BrickColor.new(number)
end

function module.initDictionary()
	local dictionary = {}
	for i = 1, 255 do
		local success, brickColor = pcall(function()
			return BrickColor.palette(i)
		end)
		if success then
			dictionary[i] = brickColor
		else
			break
		end
	end
	return dictionary
end

return module
