
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "AKS-74u",
    BulletType = "5.45x39mm",
    Ammo = 30,
    Bullets = 1,
    FireRate = 735,
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
    EffectiveRange = 575,
    VRecoil = 24,
    HRecoil = 10,
    AimRecover = 0.65,
    RecoilPunch = 1,
    VPunchBase = 3,
    HPunchBase = 1.25,
    DPunchBase = 1,
    AimRecoilReduction = 4,
    PunchRecover = 0.35,
    RecoilPower = 0.4,
    RecoilPowerStepAmount = 0.25,
    MinSpread = 0,
    MaxSpread = 8,
    AimInaccuracyStepAmount = 1,
    WalkMultiplier = 0,
    SwayBase = 0.25,
    MaxSway = 2,
    AimZ = 0.4,
    LimbsDamage = 22,
    TorsoDamage = 34,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};