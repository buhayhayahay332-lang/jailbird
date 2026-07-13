-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Modules.TypeModules.Types)

return {
	Name = "ASR",
	BulletType = ".45 ACP",
	Ammo = 33,
	Bullets = 1,
	FireRate = 800,
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
	Weight = 2.49,
	EffectiveRange = 700,
	VRecoil = 23,
	HRecoil = 10,
	AimRecover = 0.5,
	RecoilPunch = 1,
	VPunchBase = 2.5,
	HPunchBase = 1,
	DPunchBase = 1,
	AimRecoilReduction = 3.5,
	PunchRecover = 0.3,
	RecoilPower = 0.4,
	RecoilPowerStepAmount = 0.3,
	MinSpread = 0,
	MaxSpread = 8,
	AimInaccuracyStepAmount = 1,
	WalkMultiplier = 0,
	SwayBase = 0.25,
	MaxSway = 2,
	AimZ = 0.4,
	LimbsDamage = 19,
	TorsoDamage = 29,
	HeadDamage = 110,
	PlankAmount = 1,
	DamagePerPlank = 2
}