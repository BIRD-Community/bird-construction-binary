local partTypeData = {}

partTypeData.length = 2

function partTypeData.serialize(value: Enum.PartType)
	local buff = buffer.create(partTypeData.length)
	buffer.writeu16(buff, 0, value.Value)
	return buff
end

function partTypeData.deserialize(buff: buffer)
	local number = buffer.readu16(buff, 0)
	return Enum.PartType:FromValue(number)
end

function partTypeData.initDictionary()
	return {}
end

return partTypeData
