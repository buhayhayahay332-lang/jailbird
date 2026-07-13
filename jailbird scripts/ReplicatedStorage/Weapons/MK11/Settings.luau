-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Modules.TypeModules.Types)

return {
	Name = "MK11",
	BulletType = "7.62x51mm NATO",
	Ammo = 10,
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
	Weight = 6.93,
	EffectiveRange = 1300,
	VRecoil = 22,
	HRecoil = 15,
	AimRecover = 0.7,
	RecoilPunch = 1,
	VPunchBase = 4,
	HPunchBase = 2,
	DPunchBase = 1,
	AimRecoilReduction = 5,
	PunchRecover = 0.5,
	RecoilPower = 0.75,
	RecoilPowerStepAmount = 0.25,
	MinSpread = 0,
	MaxSpread = 6,
	AimInaccuracyStepAmount = 1,
	WalkMultiplier = 0,
	SwayBase = 0.25,
	MaxSway = 2,
	AimZ = 0.4,
	LimbsDamage = 22,
	TorsoDamage = 37,
	HeadDamage = 110,
	PlankAmount = 2,
	DamagePerPlank = 3
}