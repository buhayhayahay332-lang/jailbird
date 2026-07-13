-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Modules.TypeModules.Types)

return {
	Name = "MAC10",
	BulletType = "9x19mm",
	Ammo = 30,
	Bullets = 1,
	FireRate = 1200,
	GunType = 1,
	ReloadType = 1,
	Mode = "Auto",
	FireModes = {
		ChangeFiremode = false,
		Semi = false,
		Burst = false,
		Auto = true,
		Explosive = false
	},
	Weight = 2.94,
	EffectiveRange = 100,
	VRecoil = 26,
	HRecoil = 15,
	AimRecover = 0.85,
	RecoilPunch = 2,
	VPunchBase = 3.25,
	HPunchBase = 2.5,
	DPunchBase = 1,
	AimRecoilReduction = 5,
	PunchRecover = 0.7,
	RecoilPower = 0.5,
	RecoilPowerStepAmount = 0.25,
	MinSpread = 0,
	MaxSpread = 6,
	AimInaccuracyStepAmount = 1.5,
	WalkMultiplier = 0,
	SwayBase = 0.25,
	MaxSway = 1,
	AimZ = 0.4,
	LimbsDamage = 15,
	TorsoDamage = 22,
	HeadDamage = 110,
	PlankAmount = 1,
	DamagePerPlank = 1
}