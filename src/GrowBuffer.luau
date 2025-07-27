local GrowBuffer = {}
GrowBuffer.__index = GrowBuffer

function GrowBuffer.new(initialCapacity)
	local capacity = initialCapacity or 1024
	local buff = buffer.create(capacity)
	local used = 0
	local read = 0
	return setmetatable({
		buffer = buff,
		capacity = capacity,
		used = used,
		read = read,
	}, GrowBuffer)
end

function GrowBuffer:toBuffer(): buffer
	local buff = buffer.create(self.used)
	buffer.copy(buff, 0, self.buffer, 0, self.used)
	return buff
end

function GrowBuffer:expand(newCapacity: number)
	local newBuffer = buffer.create(newCapacity)
	buffer.copy(newBuffer, 0, self.buffer, 0, self.used)
	self.capacity = newCapacity
	self.buffer = newBuffer
end

function GrowBuffer:writei8(value: number)
	if self.used + 1 > self.capacity then
		self:expand(self.capacity * 2)
	end
	buffer.writei8(self.buffer, self.used, value)
	self.used += 1
end

function GrowBuffer:writei16(value: number)
	if self.used + 2 > self.capacity then
		self:expand(self.capacity * 2)
	end
	buffer.writei16(self.buffer, self.used, value)
	self.used += 2
end

function GrowBuffer:writei32(value: number)
	if self.used + 4 > self.capacity then
		self:expand(self.capacity * 2)
	end
	buffer.writei32(self.buffer, self.used, value)
	self.used += 4
end

function GrowBuffer:writeu8(value: number)
	if self.used + 1 > self.capacity then
		self:expand(self.capacity * 2)
	end
	buffer.writeu8(self.buffer, self.used, value)
	self.used += 1
end

function GrowBuffer:writeu16(value: number)
	if self.used + 2 > self.capacity then
		self:expand(self.capacity * 2)
	end
	buffer.writeu16(self.buffer, self.used, value)
	self.used += 2
end

function GrowBuffer:writeu32(value: number)
	if self.used + 4 > self.capacity then
		self:expand(self.capacity * 2)
	end
	buffer.writeu32(self.buffer, self.used, value)
	self.used += 4
end

function GrowBuffer:writef32(value: number)
	if self.used + 4 > self.capacity then
		self:expand(self.capacity * 2)
	end
	buffer.writef32(self.buffer, self.used, value)
	self.used += 4
end

function GrowBuffer:writef64(value: number)
	if self.used + 8 > self.capacity then
		self:expand(self.capacity * 2)
	end
	buffer.writef64(self.buffer, self.used, value)
	self.used += 8
end

function GrowBuffer:writestring(value: string)
	local length = #value
	if self.used + length > self.capacity then
		self:expand(self.capacity * 2 + length)
	end
	buffer.writestring(self.buffer, self.used, value)
	self.used += length
end

function GrowBuffer:writebuffer(value: buffer)
	local length = buffer.len(value)
	if self.used + length > self.capacity then
		self:expand(self.capacity * 2 + length)
	end
	buffer.copy(self.buffer, self.used, value, 0, length)
	self.used += length
end

-- read mezhods

function GrowBuffer:readi8(): number
	local value = buffer.readi8(self.buffer, self.read)
	self.read += 1
	return value
end

function GrowBuffer:readi16(): number
	local value = buffer.readi16(self.buffer, self.read)
	self.read += 2
	return value
end

function GrowBuffer:readi32(): number
	local value = buffer.readi32(self.buffer, self.read)
	self.read += 4
	return value
end

function GrowBuffer:readu8(): number
	local value = buffer.readu8(self.buffer, self.read)
	self.read += 1
	return value
end

function GrowBuffer:readu16(): number
	local value = buffer.readu16(self.buffer, self.read)
	self.read += 2
	return value
end

function GrowBuffer:readu32(): number
	local value = buffer.readu32(self.buffer, self.read)
	self.read += 4
	return value
end

function GrowBuffer:readf32(): number
	local value = buffer.readf32(self.buffer, self.read)
	self.read += 4
	return value
end

function GrowBuffer:readf64(): number
	local value = buffer.readf64(self.buffer, self.read)
	self.read += 8
	return value
end

function GrowBuffer:readstring(length: number): string
	local value = buffer.readstring(self.buffer, self.read, length)
	self.read += length
	return value
end

function GrowBuffer:readbuffer(length: number): buffer
	local value = buffer.create(length)
	buffer.copy(value, 0, self.buffer, self.read, length)
	self.read += length
	return value
end

function GrowBuffer:changeReadCursor(num): number
	self.read = self.read + num
	return self.read
end

return GrowBuffer
