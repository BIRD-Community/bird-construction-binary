local numberData = {}

numberData.length = 4

function numberData.serialize(value: number)
	local buff = buffer.create(numberData.length)
	buffer.writef32(buff, 0, value)
	return buff
end

function numberData.deserialize(buff: buffer)
	return buffer.readf32(buff, 0)
end

function numberData.initDictionary()
	local dictionary = {}
	dictionary[1] = 0
	dictionary[2] = 1
	dictionary[3] = -1
	-- fill rest of 255 entries
	for i = 4, 255 do
		dictionary[i] = i - 2
	end
	return dictionary
end

numberData.name = script.Name

return numberData
