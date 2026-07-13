-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Modules.TypeModules.Types)

return {
	Name = "Scorpion Evo 3",
	BulletType = "9x19mm Parabellum",
	Ammo = 25,
	Bullets = 1,
	FireRate = 1150,
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
	Weight = 2.7,
	EffectiveRange = 240,
	VRecoil = 32.4,
	HRecoil = 14,
	AimRecover = 0.65,
	RecoilPunch = 1.2,
	VPunchBase = 3.75,
	HPunchBase = 1.5,
	DPunchBase = 1,
	AimRecoilReduction = 5,
	PunchRecover = 0.6,
	RecoilPower = 0.75,
	RecoilPowerStepAmount = 0.25,
	MinSpread = 0,
	MaxSpread = 7,
	AimInaccuracyStepAmount = 1,
	WalkMultiplier = 0,
	SwayBase = 0.25,
	MaxSway = 2,
	AimZ = 0.4,
	LimbsDamage = 24,
	TorsoDamage = 32,
	HeadDamage = 110,
	PlankAmount = 1,
	DamagePerPlank = 2
}