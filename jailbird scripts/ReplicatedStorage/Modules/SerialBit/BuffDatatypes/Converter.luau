-- https://lua.expert/
require(script.Parent.helpers)

local t = {
	[0] = "u8",
	"u16",
	"u32",
	"i8",
	"i16",
	"i32",
	"f32",
	"f64"
}
local t2 = {
	[0] = Enum.NormalId.Top,
	Enum.NormalId.Bottom,
	Enum.NormalId.Left,
	Enum.NormalId.Right,
	Enum.NormalId.Back,
	Enum.NormalId.Front
}

local function get_number_type(p1) --[[ get_number_type | Line: 47 ]]
	if p1 % 1 == 0 then
		if p1 < 0 then
			if p1 >= -128 then
				return 3, 1
			end

			if p1 >= -32768 then
				return 4, 2
			end

			if p1 >= -2147483648 then
				return 5, 4
			end
		end

		if p1 <= 255 then
			return 0, 1
		end

		if p1 <= 65535 then
			return 1, 2
		end

		if p1 <= 4294967295 then
			return 2, 4
		end
	elseif p1 >= -131072 and p1 <= 131072 then
		return 6, 4
	end

	return 7, 8
end

local t3 = {
	["nil"] = function(p1, p2) --[[ Line: 87 ]]
		return nil
	end,
	boolean = function(p1, p2, p3) --[[ Line: 90 ]]
		local v2 = if p2 then p2 else buffer.create(1)

		buffer.writeu8(v2, p3 or 0, if p1 then 1 else 0)

		return v2
	end,
	number = function(p1, p2, p3) --[[ Line: 97 | Upvalues: t (copy) ]]
		local v1 = p3 or 0
		local v2, v3

		if p1 % 1 == 0 then
			if p1 < 0 and p1 >= -128 then
				v2 = 3
				v3 = 1
			elseif p1 < 0 and p1 >= -32768 then
				v2 = 4
				v3 = 2
			elseif p1 < 0 and p1 >= -2147483648 then
				v2 = 5
				v3 = 4
			elseif p1 <= 255 then
				v2 = 0
				v3 = 1
			elseif p1 <= 65535 then
				v2 = 1
				v3 = 2
			elseif p1 <= 4294967295 then
				v2 = 2
				v3 = 4
			else
				v2 = 7
				v3 = 8
			end
		elseif p1 >= -131072 and p1 <= 131072 then
			v2 = 6
			v3 = 4
		else
			v2 = 7
			v3 = 8
		end

		local v5 = if p2 then p2 else buffer.create(1 + v3)

		buffer.writeu8(v5, v1, v2)
		buffer[("write%*"):format(t[v2])](v5, v1 + 1, p1)

		return v5
	end,
	string = function(p1, p2, p3) --[[ Line: 107 ]]
		local v1 = p3 or 0
		local v2 = #p1
		local v3 = if p2 then p2 else buffer.create(v2 + 2)

		buffer.writeu16(v3, v1, v2)
		buffer.writestring(v3, v1 + 2, p1)

		return v3
	end,
	Vector2 = function(p1, p2, p3) --[[ Line: 116 ]]
		local v1 = p3 or 0
		local v2 = if p2 then p2 else buffer.create(8)

		buffer.writef32(v2, v1, p1.X)
		buffer.writef32(v2, v1 + 4, p1.Y)

		return v2
	end,
	Vector3 = function(p1, p2, p3) --[[ Line: 124 ]]
		local v1 = p3 or 0
		local v2 = if p2 then p2 else buffer.create(12)

		buffer.writef32(v2, v1, p1.X)
		buffer.writef32(v2, v1 + 4, p1.Y)
		buffer.writef32(v2, v1 + 8, p1.Z)

		return v2
	end,
	Vector2int16 = function(p1, p2, p3) --[[ Line: 133 ]]
		local v1 = p3 or 0
		local v2 = if p2 then p2 else buffer.create(4)

		buffer.writei16(v2, v1, p1.X)
		buffer.writei16(v2, v1 + 2, p1.Y)

		return v2
	end,
	Vector3int16 = function(p1, p2, p3) --[[ Line: 141 ]]
		local v1 = p3 or 0
		local v2 = if p2 then p2 else buffer.create(6)

		buffer.writei16(v2, v1, p1.X)
		buffer.writei16(v2, v1 + 2, p1.Y)
		buffer.writei16(v2, v1 + 4, p1.Z)

		return v2
	end
}

function t3.CFrame(p1, p2, p3) --[[ Line: 150 | Upvalues: t3 (copy) ]]
	local v1 = p3 or 0
	local v2 = if p2 then p2 else buffer.create(24)

	t3.Vector3(p1.Position, v2, v1)
	t3.Vector3(Vector3.new(p1:ToOrientation()), v2, v1 + 12)

	return v2
end
function t3.EnumItem(p1, p2, p3) --[[ Line: 159 | Upvalues: t3 (copy) ]]
	local v1 = p3 or 0
	local v2 = tostring(p1.EnumType)
	local v3 = if p2 then p2 else buffer.create(#v2 + 2 + 4)

	buffer.writeu32(v3, v1, p1.Value)
	t3.string(v2, v3, v1 + 4)

	return v3
end
function t3.Color3(p1, p2, p3) --[[ Line: 168 ]]
	local v1 = p3 or 0
	local v2 = if p2 then p2 else buffer.create(3)
	local v3 = p1:ToHex()
	local v5 = tonumber(string.sub(v3, 1, 2), 16)
	local v7 = tonumber(string.sub(v3, 3, 4), 16)
	local v9 = tonumber(string.sub(v3, 5, 6), 16)

	buffer.writeu8(v2, v1, v5)
	buffer.writeu8(v2, v1 + 1, v7)
	buffer.writeu8(v2, v1 + 2, v9)

	return v2
end
function t3.ColorSequenceKeypoint(p1, p2, p3) --[[ Line: 182 | Upvalues: t3 (copy) ]]
	local v1 = p3 or 0
	local v2 = if p2 then p2 else buffer.create(7)

	buffer.writef32(v2, v1, p1.Time)
	t3.Color3(p1.Value, v2, v1 + 4)

	return v2
end
function t3.ColorSequence(p1, p2, p3) --[[ Line: 190 | Upvalues: t3 (copy) ]]
	local v1 = p3 or 0
	local v2 = #p1.Keypoints
	local v3 = if p2 then p2 else buffer.create(v2 * 7 + 2)

	buffer.writeu16(v3, v1, v2)

	local count = 0

	for v4, v5 in p1.Keypoints do
		t3.ColorSequenceKeypoint(v5, v3, count * 7 + 2 + v1)
		count = count + 1
	end

	return v3
end
function t3.NumberSequenceKeypoint(p1, p2, p3) --[[ Line: 205 ]]
	local v1 = p3 or 0
	local v2 = if p2 then p2 else buffer.create(12)

	buffer.writef32(v2, v1, p1.Value)
	buffer.writef32(v2, v1 + 4, p1.Time)
	buffer.writef32(v2, v1 + 8, p1.Envelope)

	return v2
end
function t3.NumberSequence(p1, p2, p3) --[[ Line: 214 | Upvalues: t3 (copy) ]]
	local v1 = p3 or 0
	local v2 = #p1.Keypoints
	local v3 = if p2 then p2 else buffer.create(v2 * 12 + 2)

	buffer.writeu16(v3, v1, v2)

	local count = 0

	for v4, v5 in p1.Keypoints do
		t3.NumberSequenceKeypoint(v5, v3, count * 12 + 2 + v1)
		count = count + 1
	end

	return v3
end
function t3.Rect(p1, p2, p3) --[[ Line: 229 | Upvalues: t3 (copy) ]]
	local v1 = p3 or 0
	local v2 = if p2 then p2 else buffer.create(16)

	t3.Vector2(p1.Min, v2, v1)
	t3.Vector2(p1.Max, v2, v1 + 8)

	return v2
end
function t3.Ray(p1, p2, p3) --[[ Line: 237 | Upvalues: t3 (copy) ]]
	local v1 = p3 or 0
	local v2 = if p2 then p2 else buffer.create(24)

	t3.Vector3(p1.Origin, v2, v1)
	t3.Vector3(p1.Direction, v2, v1 + 12)

	return v2
end
function t3.PhysicalProperties(p1, p2, p3) --[[ Line: 245 ]]
	local v1 = p3 or 0
	local v2 = if p2 then p2 else buffer.create(20)

	buffer.writef32(v2, v1, p1.Density)
	buffer.writef32(v2, v1 + 4, p1.Friction)
	buffer.writef32(v2, v1 + 8, p1.Elasticity)
	buffer.writef32(v2, v1 + 12, p1.FrictionWeight)
	buffer.writef32(v2, v1 + 16, p1.ElasticityWeight)

	return v2
end
function t3.NumberRange(p1, p2, p3) --[[ Line: 256 ]]
	local v1 = p3 or 0
	local v2 = if p2 then p2 else buffer.create(8)

	buffer.writef32(v2, v1, p1.Min)
	buffer.writef32(v2, v1 + 4, p1.Max)

	return v2
end
function t3.UDim(p1, p2, p3) --[[ Line: 264 ]]
	local v1 = p3 or 0
	local v2 = if p2 then p2 else buffer.create(8)

	buffer.writef32(v2, v1, p1.Scale)
	buffer.writef32(v2, v1 + 4, p1.Offset)

	return v2
end
function t3.UDim2(p1, p2, p3) --[[ Line: 272 | Upvalues: t3 (copy) ]]
	local v1 = p3 or 0
	local v2 = if p2 then p2 else buffer.create(16)

	t3.UDim(p1.X, v2, v1)
	t3.UDim(p1.Y, v2, v1 + 8)

	return v2
end
function t3.BrickColor(p1, p2, p3) --[[ Line: 280 ]]
	local v2 = if p2 then p2 else buffer.create(2)

	buffer.writeu16(v2, p3 or 0, p1.Number)

	return v2
end
function t3.Faces(p1, p2, p3) --[[ Line: 287 ]]
	local v2 = if p2 then p2 else buffer.create(1)
	local v5 = 0 + bit32.band(if p1.Top then 1 else 0, 1)
	local v8 = v5 + bit32.band(bit32.lshift(if p1.Bottom then 1 else 0, 1), 2)
	local v11 = v8 + bit32.band(bit32.lshift(if p1.Left then 1 else 0, 2), 4)
	local v14 = v11 + bit32.band(bit32.lshift(if p1.Right then 1 else 0, 3), 8)
	local v17 = v14 + bit32.band(bit32.lshift(if p1.Back then 1 else 0, 4), 16)

	buffer.writeu8(v2, p3 or 0, v17 + bit32.band(bit32.lshift(if p1.Front then 1 else 0, 5), 32))

	return v2
end
function t3.Font(p1, p2, p3) --[[ Line: 302 | Upvalues: t3 (copy) ]]
	local v1 = p3 or 0
	local v3 = if p2 then p2 else buffer.create(#p1.Family + 2 + 2 + 1)

	buffer.writeu16(v3, v1, p1.Weight.Value)
	buffer.writeu8(v3, v1 + 2, p1.Style.Value)
	t3.string(p1.Family, v3, v1 + 3)

	return v3
end

local t4 = {
	["nil"] = function(p1, p2) --[[ Line: 324 ]]
		return nil
	end,
	boolean = function(p1, p2) --[[ Line: 327 ]]
		return buffer.readu8(p1, p2 or 0) == 1
	end,
	number = function(p1, p2) --[[ Line: 332 | Upvalues: t (copy) ]]
		local v1 = p2 or 0

		return buffer[("read%*"):format(t[buffer.readu8(p1, v1)])](p1, v1 + 1)
	end,
	string = function(p1, p2) --[[ Line: 339 ]]
		local v1 = p2 or 0

		return buffer.readstring(p1, v1 + 2, (buffer.readu16(p1, v1)))
	end,
	Vector2 = function(p1, p2) --[[ Line: 345 ]]
		local v1 = p2 or 0

		return Vector2.new(buffer.readf32(p1, v1), (buffer.readf32(p1, v1 + 4)))
	end,
	Vector3 = function(p1, p2) --[[ Line: 353 ]]
		local v1 = p2 or 0
		local v2 = buffer.readf32(p1, v1)
		local v3 = buffer.readf32(p1, v1 + 4)

		return Vector3.new(v2, v3, (buffer.readf32(p1, v1 + 8)))
	end,
	Vector2int16 = function(p1, p2) --[[ Line: 362 ]]
		local v1 = p2 or 0

		return Vector2int16.new(buffer.readi16(p1, v1), (buffer.readi16(p1, v1 + 2)))
	end,
	Vector3int16 = function(p1, p2) --[[ Line: 370 ]]
		local v1 = p2 or 0

		return Vector3int16.new(buffer.readi16(p1, v1), buffer.readi16(p1, v1 + 2), (buffer.readi16(p1, v1 + 4)))
	end
}

function t4.CFrame(p1, p2) --[[ Line: 379 | Upvalues: t4 (copy) ]]
	local v1 = p2 or 0
	local v2 = t4.Vector3(p1, v1)
	local v3 = t4.Vector3(p1, v1 + 12)

	return (CFrame.identity + v2) * CFrame.fromOrientation(v3.X, v3.Y, v3.Z)
end
function t4.EnumItem(p1, p2) --[[ Line: 387 | Upvalues: t4 (copy) ]]
	local v1 = p2 or 0
	local v2 = buffer.readu32(p1, v1)
	local v3 = t4.string(p1, v1 + 4)

	for v4, v5 in Enum[v3]:GetEnumItems() do
		if v5.Value == v2 then
			return v5
		end
	end

	return warn((("Cannot find EnumItem \'%*\' of \'Enum.%*\'"):format(v2, v3)))
end
function t4.Color3(p1, p2) --[[ Line: 398 ]]
	local v1 = p2 or 0

	return Color3.fromRGB(buffer.readu8(p1, v1), buffer.readu8(p1, v1 + 1), (buffer.readu8(p1, v1 + 2)))
end
function t4.ColorSequenceKeypoint(p1, p2) --[[ Line: 407 | Upvalues: t4 (copy) ]]
	local v1 = p2 or 0

	return ColorSequenceKeypoint.new(buffer.readf32(p1, v1), t4.Color3(p1, v1 + 4))
end
function t4.ColorSequence(p1, p2) --[[ Line: 415 | Upvalues: t4 (copy) ]]
	local v1 = p2 or 0
	local t = {}

	for i = 0, buffer.readu16(p1, v1) - 1 do
		table.insert(t, t4.ColorSequenceKeypoint(p1, i * 7 + 2 + v1))
	end

	return ColorSequence.new(t)
end
function t4.NumberSequenceKeypoint(p1, p2) --[[ Line: 427 ]]
	local v1 = p2 or 0

	return NumberSequenceKeypoint.new(buffer.readf32(p1, v1), buffer.readf32(p1, v1 + 4), (buffer.readf32(p1, v1 + 8)))
end
function t4.NumberSequence(p1, p2) --[[ Line: 436 | Upvalues: t4 (copy) ]]
	local v1 = p2 or 0
	local t = {}

	for i = 0, buffer.readu16(p1, v1) - 1 do
		table.insert(t, t4.NumberSequenceKeypoint(p1, i * 12 + 2 + v1))
	end

	return NumberSequence.new(t)
end
function t4.Rect(p1, p2) --[[ Line: 448 | Upvalues: t4 (copy) ]]
	local v1 = p2 or 0

	return Rect.new(t4.Vector2(p1, v1), t4.Vector2(p1, v1 + 8))
end
function t4.Ray(p1, p2) --[[ Line: 456 | Upvalues: t4 (copy) ]]
	local v1 = p2 or 0

	return Ray.new(t4.Vector3(p1, v1), t4.Vector3(p1, v1 + 12))
end
function t4.PhysicalProperties(p1, p2) --[[ Line: 464 ]]
	local v1 = p2 or 0

	return PhysicalProperties.new(buffer.readf32(p1, v1), buffer.readf32(p1, v1 + 4), buffer.readf32(p1, v1 + 8), buffer.readf32(p1, v1 + 12), (buffer.readf32(p1, v1 + 16)))
end
function t4.NumberRange(p1, p2) --[[ Line: 475 ]]
	local v1 = p2 or 0

	return NumberRange.new(buffer.readf32(p1, v1), (buffer.readf32(p1, v1 + 4)))
end
function t4.UDim(p1, p2) --[[ Line: 483 ]]
	local v1 = p2 or 0

	return UDim.new(buffer.readf32(p1, v1), (buffer.readf32(p1, v1 + 4)))
end
function t4.UDim2(p1, p2) --[[ Line: 491 | Upvalues: t4 (copy) ]]
	local v1 = p2 or 0

	return UDim2.new(t4.UDim(p1, v1), t4.UDim(p1, v1 + 8))
end
function t4.BrickColor(p1, p2) --[[ Line: 499 ]]
	return BrickColor.new((buffer.readu16(p1, p2 or 0)))
end
function t4.Faces(p1, p2) --[[ Line: 504 | Upvalues: t2 (copy) ]]
	local v1 = buffer.readu8(p1, p2 or 0)
	local t = {}

	for v2, v3 in t2 do
		if bit32.extract(v1, v2, 1) ~= 0 then
			table.insert(t, v3)
		end
	end

	return Faces.new(unpack(t))
end
function t4.Font(p1, p2) --[[ Line: 515 | Upvalues: t4 (copy) ]]
	local v1 = p2 or 0
	local v2 = buffer.readu16(p1, v1)
	local v3 = buffer.readu8(p1, v1 + 2)
	local v4 = nil
	local v5 = nil

	for v6, v7 in Enum.FontWeight:GetEnumItems() do
		if v7.Value == v2 then
			v4 = v7

			break
		end
	end

	for v8, v9 in Enum.FontStyle:GetEnumItems() do
		if v9.Value == v3 then
			v5 = v9

			break
		end
	end

	return Font.new(t4.string(p1, v1 + 3), v4, v5)
end

return {
	serializers = t3,
	deserializers = t4
}