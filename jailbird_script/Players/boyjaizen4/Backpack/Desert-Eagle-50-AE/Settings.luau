-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Modules.TypeModules.Types)

return {
	Name = "Desert Eagle 50 AE",
	BulletType = ".50 AE",
	Ammo = 8,
	Bullets = 1,
	FireRate = 900,
	GunType = 1,
	ReloadType = 1,
	Mode = "Semi",
	FireModes = {
		ChangeFiremode = false,
		Semi = true,
		Burst = false,
		Auto = false,
		Explosive = false
	},
	Weight = 1.9,
	EffectiveRange = 400,
	VRecoil = 32,
	HRecoil = 12,
	AimRecover = 0.9,
	RecoilPunch = 3,
	VPunchBase = 15,
	HPunchBase = 8,
	DPunchBase = 1,
	AimRecoilReduction = 1,
	PunchRecover = 0.7,
	RecoilPower = 1,
	RecoilPowerStepAmount = 1,
	MinSpread = 0,
	MaxSpread = 8,
	AimInaccuracyStepAmount = 5,
	WalkMultiplier = 0,
	SwayBase = 0.25,
	MaxSway = 1,
	AimZ = 0.4,
	LimbsDamage = 40,
	TorsoDamage = 69,
	HeadDamage = 110,
	PlankAmount = 3,
	DamagePerPlank = 3
}