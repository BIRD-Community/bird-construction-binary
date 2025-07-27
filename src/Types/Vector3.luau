local vector3Data = {}

vector3Data.length = 3 * 4

function vector3Data.serialize(value: Vector3)
	local buff = buffer.create(vector3Data.length)
	buffer.writef32(buff, 0, value.X)
	buffer.writef32(buff, 4, value.Y)
	buffer.writef32(buff, 8, value.Z)
	return buff
end

function vector3Data.deserialize(buff: buffer)
	local x = buffer.readf32(buff, 0)
	local y = buffer.readf32(buff, 4)
	local z = buffer.readf32(buff, 8)
	return Vector3.new(x, y, z)
end

function vector3Data.initDictionary()
	local dictionary = {}
	dictionary[1] = Vector3.new(1, 0, 0)
	dictionary[2] = Vector3.new(0, 1, 0)
	dictionary[3] = Vector3.new(0, 0, 1)
	dictionary[4] = Vector3.new(1, 1, 1)
	-- fill in rest of 255 entries
	for i = 5, 255 do
		dictionary[i] = Vector3.new(i - 4, i -4 , i - 4)
	end
	return dictionary
end

return vector3Data
