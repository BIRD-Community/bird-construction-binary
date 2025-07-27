local module = {}

module.length = 4

function module.serialize(value: number)
	local buff = buffer.create(module.length)
	buffer.writef32(buff, 0, value)
	return buff
end

function module.deserialize(buff: number)
	return buffer.readf32(buff, 0)
end

function module.initDictionary()
	local dictionary = {}
	dictionary[1] = 0
	dictionary[2] = 1
	dictionary[3] = -1
	-- fill rest of 255 entries
	for i = 4, 255 do
		dictionary[i] = i - 2
	end
	print(dictionary)
	return dictionary
end

return module
