local numberf64Data = {}

numberf64Data.length = 8

function numberf64Data.serialize(value: number)
	local buff = buffer.create(numberf64Data.length)
	buffer.writef64(buff, 0, value)
	return buff
end

function numberf64Data.deserialize(buff: buffer)
	return buffer.readf64(buff, 0)
end

function numberf64Data.initDictionary()
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

numberf64Data.name = script.Name

return numberf64Data
