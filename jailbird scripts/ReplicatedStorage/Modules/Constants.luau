-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Modules.TypeModules.Types)

local t = {
	SKIRMISH = "Skirmish",
	RANKED = "Ranked",
	CUSTOM = "Custom",
	CASUAL = "Casual",
	INVASION = "Invasion",
	RAID = "Raid",
	ACTION_PRIORITY = 100000,
	ACTION_QUICKTHROW = "JBQuickThrow",
	ACTION_QUICKKNIFE = "JBQuickKnife",
	ACTION_INSPECT = "JBInspect",
	ACTION_RELOAD = "JBReload",
	ACTION_VAULT = "JBVault",
	ACTION_SWAP = "JBSwap",
	ACTION_PING = "JBPing",
	ACTION_CROUCH = "JBCrouch",
	ACTION_RUN = "JBRun",
	ACTION_LEAN = "JBLean",
	ACTION_PRONE = "JBProne",
	ACTION_SHOOT = "JBShoot",
	ACTION_AIM = "JBAim",
	TOOL_PRIMARY = 1,
	TOOL_SECONDARY = 2,
	TOOL_KNIFE = 3,
	TOOL_GRANADE = 4
}

table.freeze(t)

return t