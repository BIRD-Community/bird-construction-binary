local booleanData = {}

booleanData.length = 1

function booleanData.serialize(value: boolean)
	local buff = buffer.create(booleanData.length)
	buffer.writeu8(buff, 0, value and 1 or 0)
	return buff
end

function booleanData.deserialize(buff: buffer)
	return buffer.readu8(buff, 0) == 1
end

function booleanData.initDictionary()
	local dictionary = {}
	dictionary[1] = true
	dictionary[2] = false
	return dictionary
end

booleanData.name = script.Name

return booleanData
