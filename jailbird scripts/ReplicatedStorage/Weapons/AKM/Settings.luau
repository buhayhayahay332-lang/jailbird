
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "AKM",
    BulletType = "7.62x39mm",
    Ammo = 30,
    Bullets = 1,
    FireRate = 625,
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
    Weight = 3.3,
    EffectiveRange = 900,
    VRecoil = 27,
    HRecoil = 12,
    AimRecover = 0.65,
    RecoilPunch = 1,
    VPunchBase = 3.75,
    HPunchBase = 1.5,
    DPunchBase = 1,
    AimRecoilReduction = 5,
    PunchRecover = 0.5,
    RecoilPower = 0.55,
    RecoilPowerStepAmount = 0.25,
    MinSpread = 0,
    MaxSpread = 8,
    AimInaccuracyStepAmount = 1,
    WalkMultiplier = 0,
    SwayBase = 0.25,
    MaxSway = 2,
    AimZ = 0.4,
    LimbsDamage = 32,
    TorsoDamage = 45,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};