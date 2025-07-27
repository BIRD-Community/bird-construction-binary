local brickColorData = {}

brickColorData.length = 2

function brickColorData.serialize(value: BrickColor)
	local buff = buffer.create(brickColorData.length)
	buffer.writeu16(buff, 0, value.Number)
	return buff
end

function brickColorData.deserialize(buff: buffer)
	local number = buffer.readu16(buff, 0)
	return BrickColor.new(number)
end

function brickColorData.initDictionary()
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

return brickColorData
