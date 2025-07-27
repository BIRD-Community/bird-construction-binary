local stringData = {}

stringData.length = "variable"

function stringData.serialize(value: string)
	local length = #value
	local buff = buffer.create(length + 2)
	buffer.writeu16(buff, 0, length)
	buffer.writestring(buff, 2, value)
	return buff
end

function stringData.deserialize(buff: buffer)
	local length = buffer.readu16(buff, 0)
	return buffer.readstring(buff, 2, length)
end

function stringData.initDictionary()
	local dictionary = {}
	dictionary[1] = "Brick"
	dictionary[2] = "WedgePart"
	dictionary[3] = "CornerWedgePart"
	dictionary[4] = "UnionOperation"
	dictionary[5] = "MeshPart"
	dictionary[6] = "TrussPart"
	dictionary[7] = "VehicleSeat"
	dictionary[8] = "Instance"
	dictionary[9] = "Model"
	dictionary[10] = "Folder"
	dictionary[11] = "Size"
	dictionary[12] = "WeldBall"
	dictionary[13] = "WeldConstraint"
	dictionary[14] = "CylindricalConstraint"
	dictionary[15] = "SpringConstraint"
	dictionary[16] = "NoCollisionConstraint"
	dictionary[17] = "BallSocketConstraint"
	dictionary[18] = "Motor6D"
	dictionary[19] = "BasePart"
	dictionary[20] = "Sphere"
	dictionary[21] = "SpawnLocation"
	dictionary[22] = "Brush"
	dictionary[23] = "Unweld"
	dictionary[24] = "Baseplate"
	dictionary[25] = "Part"
	dictionary[26] = "Part0"
	dictionary[27] = "Part1"
	dictionary[28] = "Attachment0"
	dictionary[29] = "Attachment1"
	dictionary[30] = "Color"
	dictionary[31] = "RopeConstraint"
	dictionary[32] = "CFrame"
	-- fill rest of 255 entries
	for i = 33, 255 do
		dictionary[i] = ""
	end
	return dictionary
end

return stringData
