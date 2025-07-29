local cframeData = {}

cframeData.length = 12 * 4

function cframeData.serialize(value: CFrame)
	local buff = buffer.create(cframeData.length)
	local t = {value:GetComponents()}
	for i = 1, #t do
		buffer.writef32(buff, (i - 1) * 4, t[i])
	end
	return buff
end

function cframeData.deserialize(buff: buffer)
	local t = {}
	for i = 1, 12 do
		table.insert(t, buffer.readf32(buff, (i - 1) * 4))
	end
	return CFrame.new(unpack(t))
end

function cframeData.initDictionary()
	local dictionary = {}
	for i = 1, 255 do
		local cf
		if i == 1 then
			cf = CFrame.new()
		else
			cf = CFrame.new(i - 1, i, i)
		end
		dictionary[i] = cf
	end
	return dictionary
end

cframeData.name = script.Name

return cframeData
