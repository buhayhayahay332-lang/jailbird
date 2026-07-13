
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "SKS",
    BulletType = "7.62x39mm",
    Ammo = 10,
    Bullets = 1,
    FireRate = 400,
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
    Weight = 3.85,
    EffectiveRange = 900,
    VRecoil = 42,
    HRecoil = 8,
    AimRecover = 0.6,
    RecoilPunch = 3,
    VPunchBase = 2.5,
    HPunchBase = 1.7,
    DPunchBase = 1,
    AimRecoilReduction = 5,
    PunchRecover = 0.6,
    RecoilPower = 0.5,
    RecoilPowerStepAmount = 0.25,
    MinSpread = 0,
    MaxSpread = 2,
    AimInaccuracyStepAmount = 0.5,
    WalkMultiplier = 0,
    SwayBase = 0.25,
    MaxSway = 1.5,
    AimZ = 0.4,
    LimbsDamage = 40,
    TorsoDamage = 95,
    HeadDamage = 110,
    PlankAmount = 2,
    DamagePerPlank = 3
};