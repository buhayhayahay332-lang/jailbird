local v_u_1 = game:GetService("Players")
local v_u_2 = game:GetService("RunService")
local v_u_3 = game:GetService("Workspace")
local v_u_4 = {}
v_u_4.__index = v_u_4
function v_u_4.new(p5) -- name: new
	-- upvalues: (copy) v_u_4
	local v6 = v_u_4
	local v7 = setmetatable({}, v6)
	v7.Instance = p5
	v7.UpdateConnection = nil
	v7.Base = nil
	v7.Point = nil
	v7.SourceParticle = nil
	v7.SourceLight = nil
	v7.OriginalPointCFrame = nil
	repeat
		task.wait()
	until p5.PrimaryPart ~= nil
	v7.Base = p5.PrimaryPart
	v7.Point = v7.Base:FindFirstChild("Point")
	v7.SourceParticle = v7.Point and v7.Point:FindFirstChildWhichIsA("ParticleEmitter") or p5:FindFirstChildWhichIsA("ParticleEmitter", true)
	v7.SourceLight = v7.Point and v7.Point:FindFirstChildWhichIsA("PointLight") or p5:FindFirstChildWhichIsA("PointLight", true)
	local v8
	if v7.Point then
		v8 = v7.Point.CFrame or nil
	else
		v8 = nil
	end
	v7.OriginalPointCFrame = v8
	v7:CleanupLegacyHelpers()
	return v7
end
function v_u_4.IsOwnerLocal(p9) -- name: IsOwnerLocal
	-- upvalues: (copy) v_u_1
	local v10 = v_u_1.LocalPlayer
	local v11
	if v10 == nil then
		v11 = false
	else
		v11 = p9.Instance:GetAttribute("Owner") == v10.Name
	end
	return v11
end
function v_u_4.IsFirstPersonInstance(p12) -- name: IsFirstPersonInstance
	-- upvalues: (copy) v_u_3
	local v13
	if v_u_3.CurrentCamera == nil then
		v13 = false
	else
		v13 = p12.Instance:IsDescendantOf(v_u_3.CurrentCamera)
	end
	return v13
end
function v_u_4.ShouldRender(p14) -- name: ShouldRender
	if p14.Instance:GetAttribute("Active") == true then
		return (p14.Instance:GetAttribute("HideForOwner") ~= true or (not p14:IsOwnerLocal() or p14:IsFirstPersonInstance())) and true or false
	else
		return false
	end
end
function v_u_4.CleanupLegacyHelpers(p15) -- name: CleanupLegacyHelpers
	for _, v16 in ipairs(p15.Instance:GetChildren()) do
		if v16:IsA("BasePart") and v16.Name == "LightPoint" then
			v16:Destroy()
		end
	end
end
function v_u_4.RestorePoint(p17) -- name: RestorePoint
	local v18 = p17.SourceParticle
	if v18 and (v18:IsA("ParticleEmitter") or v18:IsA("PointLight")) then
		v18.Enabled = false
	end
	local v19 = p17.SourceLight
	if v19 and (v19:IsA("ParticleEmitter") or v19:IsA("PointLight")) then
		v19.Enabled = false
	end
	if p17.Point and p17.OriginalPointCFrame then
		p17.Point.CFrame = p17.OriginalPointCFrame
	end
end
function v_u_4.Update(p20) -- name: Update
	if p20.Instance and p20.Instance.Parent then
		p20:CleanupLegacyHelpers()
		if p20:ShouldRender() == true then
			local v21 = p20.Instance:GetAttribute("LaserHitPosition")
			if typeof(v21) == "Vector3" then
				if p20.Point and (p20.Base and p20.OriginalPointCFrame) then
					local v22 = p20.SourceParticle
					if v22 and (v22:IsA("ParticleEmitter") or v22:IsA("PointLight")) then
						v22.Enabled = true
					end
					local v23 = p20.SourceLight
					if v23 and (v23:IsA("ParticleEmitter") or v23:IsA("PointLight")) then
						v23.Enabled = true
					end
					p20.Point.WorldCFrame = CFrame.new(v21) * (p20.Base.CFrame.Rotation * p20.OriginalPointCFrame.Rotation)
					return
				else
					local v24 = p20.SourceParticle
					if v24 and (v24:IsA("ParticleEmitter") or v24:IsA("PointLight")) then
						v24.Enabled = false
					end
					local v25 = p20.SourceLight
					if v25 then
						if v25:IsA("ParticleEmitter") or v25:IsA("PointLight") then
							v25.Enabled = false
						end
					end
				end
			else
				p20:RestorePoint()
				return
			end
		else
			p20:RestorePoint()
			return
		end
	else
		p20:RestorePoint()
		return
	end
end
function v_u_4.RefreshState(p_u_26) -- name: RefreshState
	-- upvalues: (copy) v_u_2
	p_u_26:CleanupLegacyHelpers()
	if p_u_26:ShouldRender() == true then
		if p_u_26.UpdateConnection == nil then
			p_u_26.UpdateConnection = v_u_2.RenderStepped:Connect(function()
				-- upvalues: (copy) p_u_26
				p_u_26:Update()
			end)
			return
		end
	else
		if p_u_26.UpdateConnection then
			p_u_26.UpdateConnection:Disconnect()
			p_u_26.UpdateConnection = nil
		end
		p_u_26:RestorePoint()
	end
end
function v_u_4.Init(p_u_27) -- name: Init
	-- upvalues: (copy) v_u_2
	if v_u_2:IsClient() and p_u_27.Instance then
		p_u_27.Instance:GetAttributeChangedSignal("Active"):Connect(function()
			-- upvalues: (copy) p_u_27
			p_u_27:RefreshState()
		end)
		p_u_27.Instance:GetAttributeChangedSignal("HideForOwner"):Connect(function()
			-- upvalues: (copy) p_u_27
			p_u_27:RefreshState()
		end)
		p_u_27.Instance:GetAttributeChangedSignal("LaserHitPosition"):Connect(function()
			-- upvalues: (copy) p_u_27
			p_u_27:RefreshState()
		end)
		p_u_27.Instance.AncestryChanged:Connect(function()
			-- upvalues: (copy) p_u_27
			p_u_27:RefreshState()
		end)
		p_u_27:RefreshState()
	end
end
return v_u_4