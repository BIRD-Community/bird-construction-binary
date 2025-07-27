local materialData = {}

materialData.length = 2

function materialData.serialize(value: Enum.Material)
	local buff = buffer.create(materialData.length)
	buffer.writeu16(buff, 0, value.Value)
	return buff
end

function materialData.deserialize(buff: buffer)
	local number = buffer.readu16(buff, 0)
	return Enum.Material:FromValue(number)
end

function materialData.initDictionary()
	return {}
end

return materialData
