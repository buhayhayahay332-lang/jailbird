
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "AN-94",
    BulletType = "5.45x39mm",
    Ammo = 30,
    Bullets = 1,
    FireRate = 620,
    GunType = 1,
    ReloadType = 1,
    Mode = "Auto",
    FireModes = {
        ChangeFiremode = false,
        Semi = true,
        Burst = false,
        Auto = false,
        Explosive = false
    },
    Weight = 3.3,
    EffectiveRange = 900,
    VRecoil = 22,
    HRecoil = 13,
    AimRecover = 0.65,
    RecoilPunch = 1,
    VPunchBase = 3,
    HPunchBase = 1.2,
    DPunchBase = 1,
    AimRecoilReduction = 5,
    PunchRecover = 0.7,
    RecoilPower = 0.45,
    RecoilPowerStepAmount = 0.2,
    MinSpread = 0,
    MaxSpread = 8,
    AimInaccuracyStepAmount = 1,
    WalkMultiplier = 0,
    SwayBase = 0.25,
    MaxSway = 2,
    AimZ = 0.4,
    LimbsDamage = 40,
    TorsoDamage = 50,
    HeadDamage = 110,
    PlankAmount = 2,
    DamagePerPlank = 2
};