local module = {}

module.length = 2

function module.serialize(value: Enum.PartType)
	local buff = buffer.create(module.length)
	buffer.writeu16(buff, 0, value.Value)
	return buff
end

function module.deserialize(buff: buffer)
	local number = buffer.readu16(buff, 0)
	return Enum.PartType:FromValue(number)
end

function module.initDictionary()
	return {}
end

return module
