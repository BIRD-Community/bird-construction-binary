local birdConstructionBinary = {}
local constants = require(script.Constants)
local GrowBuffer = require(script.GrowBuffer)
local types = script.Types
birdConstructionBinary.types = types
local stringValue = require(types.string)
local stringValueConfig = {
	valueType = "string",
	defaultValue = "",
	serializer = stringValue,
}

function getInstanceModule(className)
	if not script.Instances:FindFirstChild(className) then
		return false
	end
	local instanceModule = require(script.Instances:FindFirstChild(className))
	if instanceModule == birdConstructionBinary then
		instanceModule = require(`./${className}`)
	end
	return instanceModule
end

function birdConstructionBinary.initDictionary()
	local dictionaries = {}
	for _, valueType in pairs(script.Types:GetChildren()) do
		if valueType:IsA("ModuleScript") then
			dictionaries[valueType.Name] = require(valueType).initDictionary()
		end
	end
	return dictionaries
end



--- rootInstance itself is not serialized
function birdConstructionBinary.serialize(rootInstance, options)
	options = options or {}
	local attributes = options.attributes or {}
	local serializeAttributes = #attributes > 0
	local context = {
		dictionaries = birdConstructionBinary.initDictionary(),
		instanceReferences = {}, -- instance: reference
		backDictionary = {},
		dictionaryWritePositions = {},
	}
	-- create reverse dictionary of indicies
	for name, valueType in pairs(context.dictionaries) do
		context.backDictionary[name] = {}
		for index, value in pairs(valueType) do
			context.backDictionary[name][value] = index
		end
	end
	-- initalize dictionaryWritePositions
	for valueName, table in pairs(context.dictionaries) do
		context.dictionaryWritePositions[valueName] = 1
	end
	--- get value from dictionary.. boolean indicates cache miss/hit
	local function getOrWriteDictionaryValue(valueType, value)
		-- check if value exists in dictionary
		local cachedIndex = context.backDictionary[valueType][value]
		if cachedIndex then
			return cachedIndex, false
		end
		-- miss. write value to dictionaries
		local index = context.dictionaryWritePositions[valueType]
		local previousDictionaryValue = context.dictionaries[valueType][index]
		if previousDictionaryValue then
			context.backDictionary[valueType][previousDictionaryValue] = nil
		else
			warn("Previous dictionary value not found", valueType, index, value)
		end
		context.backDictionary[valueType][value] = index
		context.dictionaries[valueType][index] = value
		context.dictionaryWritePositions[valueType] += 1
		-- if over 255, overflow back to 1
		if index + 1 > 255 then
			context.dictionaryWritePositions[valueType] = 1
		end
		return index, true
	end
	-- prepopulate instance references
	local applicableInstanceCount = 0
	for index, instance in ipairs(rootInstance:GetDescendants()) do
		local instanceModule = getInstanceModule(instance.ClassName)
		if not instanceModule then
			continue
		end
		context.instanceReferences[instance] = applicableInstanceCount + 1
		applicableInstanceCount += 1
	end
	-- create buffer
	local instanceBuffer = GrowBuffer.new()
	-- write header
	instanceBuffer:writestring(constants.magicString) -- magic
	instanceBuffer:writeu8(2) -- version
	instanceBuffer:writeu32(applicableInstanceCount) -- instance count
	local function writeValue(value, valueConfig)
		if valueConfig.valueType == "Reference" then -- special handling for reference value type
			--local value = instance[instanceProp]
			if value and context.instanceReferences[value] ~= nil then
				instanceBuffer:writeu8(1) -- has value
				instanceBuffer:writeu32(context.instanceReferences[value])
			else
				instanceBuffer:writeu8(0) -- no value
			end
		else -- serialize value using value serializer
			--local value = instance[instanceProp]
			local dictionaryIndex, cacheMiss = getOrWriteDictionaryValue(valueConfig.valueType, value)
			if cacheMiss then
				instanceBuffer:writeu8(0) -- include value
				local serializedValueBuffer = valueConfig.serializer.serialize(value)
				instanceBuffer:writebuffer(serializedValueBuffer)
			else
				instanceBuffer:writeu8(dictionaryIndex) -- write index from dictionary
			end
		end
	end
	local function writeInstanceProperty(instance: Instance, instanceProp: string, value: any, valueConfig)
		--instanceBuffer:writeu8(1) -- property exists
		writeValue(instanceProp, stringValueConfig) -- write property name
		writeValue(value, valueConfig) -- write property value
	end
	-- write instances
	for index, instance in ipairs(rootInstance:GetDescendants()) do
		local instanceModule = getInstanceModule(instance.ClassName)
		if not instanceModule then
			continue
		end
		-- write class name
		writeValue(instance.ClassName, stringValueConfig)
		-- get applicable property count
		local applicablePropertyCount = 0
		for name, valueConfig in pairs(instanceModule.values) do
			local value = instance[name]
			if value ~= valueConfig.defaultValue then
				applicablePropertyCount += 1
			end
		end
		if serializeAttributes then
			for attributeName, attributeValue in pairs(instance:GetAttributes()) do
				for index, attributeConfig in pairs(attributes) do
					if attributeName == attributeConfig.name then
						applicablePropertyCount += 1
						break
					end
				end
			end
		end
		instanceBuffer:writeu16(applicablePropertyCount)
		-- write properties
		for name, valueConfig in pairs(instanceModule.values) do
			local value = instance[name]
			if value ~= valueConfig.defaultValue then
				writeInstanceProperty(instance, name, value, valueConfig)
			end
		end
		-- write attributes
		if serializeAttributes then
			for index, attributeConfig in pairs(attributes) do
				local value = instance:GetAttribute(attributeConfig.name)
				if value ~= nil then
					writeInstanceProperty(instance, `${attributeConfig.name}`, value, {
						valueType = attributeConfig.type.name,
						serializer = attributeConfig.type
					})
				end
			end
		end
	end
	return instanceBuffer:toBuffer()
end

function birdConstructionBinary.deserialize(data: buffer, asModel: boolean, options)
	options = options or {}
	local attributes = options.attributes or {} -- ["AttributeName"] = type
	local context = {
		dictionaries = birdConstructionBinary.initDictionary(),
		backDictionary = {},
		dictionaryWritePositions = {},
		instanceReferences = {},
	}
	local deserializedInstances = {}
	-- create reverse dictionary of indicies
	for name, valueType in pairs(context.dictionaries) do
		context.backDictionary[name] = {}
		for index, value in pairs(valueType) do
			context.backDictionary[name][value] = index
		end
	end
	-- initalize dictionaryWritePositions
	for valueName, table in pairs(context.dictionaries) do
		context.dictionaryWritePositions[valueName] = 1
	end
	-- load buffer
	local instanceBuffer = GrowBuffer.new()
	instanceBuffer:writebuffer(data)
	local magic = instanceBuffer:readstring(string.len(constants.magicString))
	assert(magic == constants.magicString, "invalid magic")
	local version = instanceBuffer:readu8()
	local instanceCount = instanceBuffer:readu32()
	local function getOrWriteDictionaryValue(valueType: string, value)
		-- miss. write value to dictionaries
		local index = context.dictionaryWritePositions[valueType]
		local previousDictionaryValue = context.dictionaries[valueType][index]
		if previousDictionaryValue then
			context.backDictionary[valueType][previousDictionaryValue] = nil
		else
			warn("Previous dictionary value not found", valueType, index, value)
		end
		context.backDictionary[valueType][value] = index
		context.dictionaries[valueType][index] = value
		context.dictionaryWritePositions[valueType] += 1
		-- if over 255, overflow back to 1
		if index + 1 > 255 then
			context.dictionaryWritePositions[valueType] = 1
		end
		return index, true
	end
	local function readValue(valueConfig)
		if valueConfig.valueType == "Reference" then -- is a reference
			local hasValue = instanceBuffer:readu8() == 1
			if hasValue then
				return instanceBuffer:readu32()
			else
				return nil
			end
		else
			local dictionaryIndex = instanceBuffer:readu8()
			if dictionaryIndex == 0 then
				local assumedLength = valueConfig.serializer.length
				if assumedLength == "variable" then
					assumedLength = instanceBuffer:readu16() + 2
					instanceBuffer:changeReadCursor(-2)
				end
				local sectionBuffer = instanceBuffer:readbuffer(assumedLength)
				local deserializedValue = valueConfig.serializer.deserialize(sectionBuffer)
				getOrWriteDictionaryValue(valueConfig.valueType, deserializedValue)
				return deserializedValue
			else
				local value = context.dictionaries[valueConfig.valueType][dictionaryIndex]
				return value
			end
		end
	end
	local referenceIndex = {}
	local pendingReferenceInstanceProperties = {} -- instances that have a reference property that points to an instance that hasn't been created yet
	for index = 1, instanceCount do
		local className = readValue(stringValueConfig)
		local instance = Instance.new(className)
		referenceIndex[index] = instance
		local propertyCount = instanceBuffer:readu16()
		local instanceModule = getInstanceModule(className)
		assert(instanceModule, `Module for {className} not found.`)
		for propertyIndex = 1, propertyCount do
			local propertyName = readValue(stringValueConfig)
			-- starts wizh $ (Attribute)
			if string.sub(propertyName, 1, 1) == "$" then
				local attributeName = string.sub(propertyName, 2)
				local attributeConfig = attributes[attributeName]
				if not attributeConfig then
					warn(`Found {propertyName} attribute but it's missing in deserialization options.`)
				else
					instance:SetAttribute(attributeName, readValue({
						valueType = attributeConfig.name,
						serializer = attributeConfig,
					}))
				end
			else
				local valueConfig = instanceModule.values[propertyName]
				local propertyValue = readValue(valueConfig)
				if valueConfig.valueType == "Reference" then
					pendingReferenceInstanceProperties[index] = pendingReferenceInstanceProperties[index] or {}
					pendingReferenceInstanceProperties[index][propertyName] = propertyValue
				else
					instance[propertyName] = propertyValue
				end
			end
		end
		table.insert(deserializedInstances, instance)
	end
	local excemptParent = {}
	for index, value in pendingReferenceInstanceProperties do
		local instance = deserializedInstances[index]
		for propertyName, propertyValue in value do
			instance[propertyName] = referenceIndex[propertyValue]
			if propertyName == "Parent" then
				excemptParent[instance] = true
			end
		end
	end
	
	local model = nil
	if asModel then
		model = Instance.new("Model")
		for _, child in deserializedInstances do
			if not excemptParent[child] then
				child.Parent = model
			end
		end
	end
	return model or deserializedInstances
end

return birdConstructionBinary
