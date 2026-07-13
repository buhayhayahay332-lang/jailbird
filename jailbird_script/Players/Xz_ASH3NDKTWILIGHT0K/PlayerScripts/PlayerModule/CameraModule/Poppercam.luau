-- https://lua.expert/
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local ZoomController = require(script.Parent:WaitForChild("ZoomController"))
local v1 = FlagUtil.getUserFlag("UserFixCameraFPError")
local t = {}

t.__index = t

local v2 = CFrame.new()

local function cframeToAxis(p1) --[[ cframeToAxis | Line: 17 ]]
	local v1, v2 = p1:ToAxisAngle()

	return v1 * v2
end

local function axisToCFrame(p1) --[[ axisToCFrame | Line: 22 | Upvalues: v2 (copy) ]]
	local Magnitude = p1.Magnitude

	if Magnitude > 0.00001 then
		return CFrame.fromAxisAngle(p1, Magnitude)
	end

	return v2
end

local function extractRotation(p1) --[[ extractRotation | Line: 30 ]]
	local _, _2, _3, v1, v2, v3, v4, v5, v6, v7, v8, v9 = p1:GetComponents()

	return CFrame.new(0, 0, 0, v1, v2, v3, v4, v5, v6, v7, v8, v9)
end

function t.new() --[[ new | Line: 35 | Upvalues: t (copy) ]]
	return setmetatable({
		lastCFrame = nil
	}, t)
end
function t.Step(p1, p2, p3) --[[ Step | Line: 41 | Upvalues: v2 (copy) ]]
	local v1 = p1.lastCFrame or p3

	p1.lastCFrame = p3

	local Position = p3.Position
	local _, _2, _3, v22, v3, v4, v5, v6, v7, v8, v9, v10 = p3:GetComponents()
	local v11 = CFrame.new(0, 0, 0, v22, v3, v4, v5, v6, v7, v8, v9, v10)
	local _4, _5, _6, v12, v13, v14, v15, v16, v17, v18, v19, v20 = v1:GetComponents()
	local v21 = (Position - v1.p) / p2
	local v222, v23 = (v11 * CFrame.new(0, 0, 0, v12, v13, v14, v15, v16, v17, v18, v19, v20):inverse()):ToAxisAngle()
	local v24 = v222 * v23 / p2

	return {
		extrapolate = function(p1) --[[ extrapolate | Line: 56 | Upvalues: v21 (copy), Position (copy), v24 (copy), v2 (ref), v11 (copy) ]]
			local v22 = v24 * p1
			local Magnitude = v22.Magnitude

			return (if Magnitude > 0.00001 then CFrame.fromAxisAngle(v22, Magnitude) else v2) * v11 + (v21 * p1 + Position)
		end,
		posVelocity = v21,
		rotVelocity = v24
	}
end
function t.Reset(p1) --[[ Reset | Line: 69 ]]
	p1.lastCFrame = nil
end

local BaseOcclusion = require(script.Parent:WaitForChild("BaseOcclusion"))
local v3 = setmetatable({}, BaseOcclusion)

v3.__index = v3
function v3.new() --[[ new | Line: 79 | Upvalues: BaseOcclusion (copy), v3 (copy), t (copy) ]]
	local v32 = setmetatable(BaseOcclusion.new(), v3)

	v32.focusExtrapolator = t.new()

	return v32
end
function v3.GetOcclusionMode(p1) --[[ GetOcclusionMode | Line: 85 ]]
	return Enum.DevCameraOcclusionMode.Zoom
end
function v3.Enable(p1, p2) --[[ Enable | Line: 89 ]]
	p1.focusExtrapolator:Reset()
end
function v3.Update(p1, p2, p3, p4, p5) --[[ Update | Line: 93 | Upvalues: v1 (copy), ZoomController (copy) ]]
	local v12 = if v1 then CFrame.lookAlong(p4.p, -p3.LookVector) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1) else CFrame.new(p4.p, p3.p) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1)

	return v12 * CFrame.new(0, 0, (ZoomController.Update(p2, v12, (p1.focusExtrapolator:Step(p2, v12))))), p4
end
function v3.CharacterAdded(p1, p2, p3) --[[ CharacterAdded | Line: 117 ]] end
function v3.CharacterRemoving(p1, p2, p3) --[[ CharacterRemoving | Line: 121 ]] end
function v3.OnCameraSubjectChanged(p1, p2) --[[ OnCameraSubjectChanged | Line: 124 ]] end

return v3