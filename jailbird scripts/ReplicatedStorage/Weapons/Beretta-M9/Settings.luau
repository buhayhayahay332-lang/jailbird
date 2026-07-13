
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "Beretta M9",
    BulletType = "9x19mm Parabellum",
    Ammo = 15,
    Bullets = 1,
    FireRate = 900,
    GunType = 0,
    ReloadType = 1,
    Mode = "Semi",
    FireModes = {
        ChangeFiremode = false,
        Semi = true,
        Burst = false,
        Auto = false,
        Explosive = false
    },
    Weight = 0.97,
    EffectiveRange = 100,
    VRecoil = 22,
    HRecoil = 4,
    AimRecover = 0.9,
    RecoilPunch = 3,
    VPunchBase = 7,
    HPunchBase = 4,
    DPunchBase = 1,
    AimRecoilReduction = 1,
    PunchRecover = 0.7,
    RecoilPower = 1,
    RecoilPowerStepAmount = 0.5,
    MinSpread = 0,
    MaxSpread = 6,
    AimInaccuracyStepAmount = 2.5,
    WalkMultiplier = 0,
    SwayBase = 0.25,
    MaxSway = 1,
    AimZ = 0.4,
    LimbsDamage = 18,
    TorsoDamage = 30,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 1
};