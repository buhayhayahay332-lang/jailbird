local v_u_1 = UDim2.new
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3.new(p4) -- name: new
	-- upvalues: (copy) v_u_3
	local v5 = {
		["Object"] = p4,
		["DragStarted"] = nil,
		["DragEnded"] = nil,
		["Dragged"] = nil,
		["Dragging"] = false
	}
	local v6 = v_u_3
	setmetatable(v5, v6)
	return v5
end
function v_u_3.Enable(p_u_7) -- name: Enable
	-- upvalues: (copy) v_u_1, (copy) v_u_2
	local v_u_8 = p_u_7.Object
	local v_u_9 = nil
	local v_u_10 = nil
	local v_u_11 = nil
	local v_u_12 = false
	p_u_7.InputBegan = v_u_8.InputBegan:Connect(function(p_u_13)
		-- upvalues: (ref) v_u_12, (copy) p_u_7
		if p_u_13.UserInputType == Enum.UserInputType.MouseButton1 or p_u_13.UserInputType == Enum.UserInputType.Touch then
			v_u_12 = true
			local v_u_14 = nil
			v_u_14 = p_u_13.Changed:Connect(function()
				-- upvalues: (copy) p_u_13, (ref) p_u_7, (ref) v_u_12, (ref) v_u_14
				if p_u_13.UserInputState == Enum.UserInputState.End and (p_u_7.Dragging or v_u_12) then
					p_u_7.Dragging = false
					v_u_14:Disconnect()
					if p_u_7.DragEnded and not v_u_12 then
						p_u_7.DragEnded()
					end
					v_u_12 = false
				end
			end)
		end
	end)
	p_u_7.InputChanged = v_u_8.InputChanged:Connect(function(p15)
		-- upvalues: (ref) v_u_9
		if p15.UserInputType == Enum.UserInputType.MouseMovement or p15.UserInputType == Enum.UserInputType.Touch then
			v_u_9 = p15
		end
	end)
	p_u_7.InputChanged2 = v_u_2.InputChanged:Connect(function(p16)
		-- upvalues: (copy) v_u_8, (copy) p_u_7, (ref) v_u_12, (ref) v_u_10, (ref) v_u_11, (ref) v_u_9, (ref) v_u_1
		if v_u_8.Parent == nil then
			p_u_7:Disable()
		else
			if v_u_12 then
				v_u_12 = false
				if p_u_7.DragStarted then
					p_u_7.DragStarted()
				end
				p_u_7.Dragging = true
				v_u_10 = p16.Position
				v_u_11 = v_u_8.Position
			end
			if p16 == v_u_9 and p_u_7.Dragging then
				local v17 = p16.Position - v_u_10
				local v18 = v_u_1(v_u_11.X.Scale, v_u_11.X.Offset + v17.X, v_u_11.Y.Scale, v_u_11.Y.Offset + v17.Y)
				v_u_8.Position = v18
				if p_u_7.Dragged then
					p_u_7.Dragged(v18)
				end
			end
		end
	end)
end
function v_u_3.Disable(p19) -- name: Disable
	p19.InputBegan:Disconnect()
	p19.InputChanged:Disconnect()
	p19.InputChanged2:Disconnect()
	if p19.Dragging then
		p19.Dragging = false
		if p19.DragEnded then
			p19.DragEnded()
		end
	end
end
return v_u_3