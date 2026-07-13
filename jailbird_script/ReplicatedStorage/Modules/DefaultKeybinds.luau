-- https://lua.expert/
require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Utility"))

local KeyCode = Enum.KeyCode
local UserInputType = Enum.UserInputType

return {
	ADSToggle = true,
	LeanToggle = true,
	ADSSensitivity = 1,
	CameraSensitivity = 1,
	PC = {
		Reload = { KeyCode.R.Name, "KeyCode" },
		Jump = { KeyCode.Space.Name, "KeyCode" },
		Crouch = { KeyCode.C.Name, "KeyCode" },
		Run = { KeyCode.LeftShift.Name, "KeyCode" },
		Prone = { KeyCode.LeftControl.Name, "KeyCode" },
		LeanLeft = { KeyCode.Q.Name, "KeyCode" },
		LeanRight = { KeyCode.E.Name, "KeyCode" },
		QuickThrow = { KeyCode.G.Name, "KeyCode" },
		QuickKnife = { KeyCode.V.Name, "KeyCode" },
		SwapTool1 = { KeyCode.One.Name, "KeyCode" },
		SwapTool2 = { KeyCode.Two.Name, "KeyCode" },
		SwapTool3 = { KeyCode.Three.Name, "KeyCode" },
		SwapTool4 = { KeyCode.Four.Name, "KeyCode" },
		Shoot = { UserInputType.MouseButton1.Name, "UserInputType" },
		Aim = { UserInputType.MouseButton2.Name, "UserInputType" },
		InspectTool = { KeyCode.F.Name, "KeyCode" },
		Ping = { KeyCode.Z.Name, "KeyCode" }
	},
	Controller = {
		Jump = { KeyCode.ButtonA.Name, "KeyCode" },
		Run = { KeyCode.ButtonL3.Name, "KeyCode" },
		Crouch = { KeyCode.ButtonB.Name, "KeyCode" },
		Prone = { KeyCode.ButtonB.Name, "KeyCode" },
		LeanLeft = { KeyCode.ButtonL1.Name, "KeyCode" },
		LeanRight = { KeyCode.ButtonR1.Name, "KeyCode" },
		Reload = { KeyCode.ButtonX.Name, "KeyCode" },
		SwapTool = { KeyCode.ButtonY.Name, "KeyCode" },
		Ping = { KeyCode.DPadUp.Name, "KeyCode" },
		Shoot = { KeyCode.ButtonR2.Name, "KeyCode" },
		Aim = { KeyCode.ButtonL2.Name, "KeyCode" },
		QuickKnife = { KeyCode.ButtonR3.Name, "KeyCode" },
		QuickThrow = { KeyCode.DPadLeft.Name, "KeyCode" }
	}
}