-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Modules.TypeModules.Types)

return {
	Name = "P90",
	BulletType = "5.7x28mm",
	Ammo = 50,
	Bullets = 1,
	FireRate = 950,
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
	Weight = 2.6,
	EffectiveRange = 400,
	VRecoil = 26.4,
	HRecoil = 9,
	AimRecover = 0.3,
	RecoilPunch = 1,
	VPunchBase = 3.75,
	HPunchBase = 1.5,
	DPunchBase = 1,
	AimRecoilReduction = 5,
	PunchRecover = 0.5,
	RecoilPower = 0.75,
	RecoilPowerStepAmount = 0.25,
	MinSpread = 0,
	MaxSpread = 7,
	AimInaccuracyStepAmount = 1,
	WalkMultiplier = 0,
	SwayBase = 0.25,
	MaxSway = 2,
	AimZ = 0.4,
	LimbsDamage = 12,
	TorsoDamage = 23,
	HeadDamage = 0,
	PlankAmount = 1,
	DamagePerPlank = 2
}