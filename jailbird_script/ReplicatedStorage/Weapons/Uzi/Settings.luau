-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Modules.TypeModules.Types)

return {
	Name = "Uzi",
	BulletType = "9x19mm Parabellum",
	Ammo = 32,
	Bullets = 1,
	FireRate = 600,
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
	Weight = 1.7,
	EffectiveRange = 400,
	VRecoil = 22,
	HRecoil = 12,
	AimRecover = 0.9,
	RecoilPunch = 1,
	VPunchBase = 2,
	HPunchBase = 2,
	DPunchBase = 1,
	AimRecoilReduction = 5,
	PunchRecover = 0.5,
	RecoilPower = 0.5,
	RecoilPowerStepAmount = 0.15,
	MinSpread = 0,
	MaxSpread = 7,
	AimInaccuracyStepAmount = 2,
	WalkMultiplier = 0,
	SwayBase = 0.25,
	MaxSway = 1,
	AimZ = 0.4,
	LimbsDamage = 38,
	TorsoDamage = 42,
	HeadDamage = 110,
	PlankAmount = 1,
	DamagePerPlank = 2
}