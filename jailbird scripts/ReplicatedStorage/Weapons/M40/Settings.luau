-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Modules.TypeModules.Types)

return {
	Name = "M40",
	BulletType = "7.62x51mm NATO",
	Ammo = 10,
	Bullets = 1,
	FireRate = 120,
	GunType = 1,
	ReloadType = 1,
	Mode = "Bolt-Action",
	FireModes = {
		ChangeFiremode = false,
		Semi = true,
		Burst = false,
		Auto = false,
		Explosive = false
	},
	Weight = 6.57,
	EffectiveRange = 1600,
	VRecoil = 45,
	HRecoil = 16,
	AimRecover = 0.7,
	RecoilPunch = 6,
	VPunchBase = 2.9,
	HPunchBase = 1.7,
	DPunchBase = 1,
	AimRecoilReduction = 5,
	PunchRecover = 0.6,
	RecoilPower = 0.5,
	RecoilPowerStepAmount = 0.25,
	MinSpread = 0,
	MaxSpread = 9.5,
	AimInaccuracyStepAmount = 0.5,
	WalkMultiplier = 0,
	SwayBase = 0.25,
	MaxSway = 1.5,
	AimZ = 0.4,
	LimbsDamage = 35,
	TorsoDamage = 90,
	HeadDamage = 150,
	PlankAmount = 5,
	DamagePerPlank = 3
}