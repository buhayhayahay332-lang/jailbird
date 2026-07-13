
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "Vector",
    BulletType = ".45 ACP",
    Ammo = 25,
    Bullets = 1,
    FireRate = 1050,
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
    VRecoil = 30,
    HRecoil = 13,
    AimRecover = 0.65,
    RecoilPunch = 1.5,
    VPunchBase = 3.75,
    HPunchBase = 1.5,
    DPunchBase = 1,
    AimRecoilReduction = 3,
    PunchRecover = 0.6,
    RecoilPower = 0.9,
    RecoilPowerStepAmount = 0.4,
    MinSpread = 0,
    MaxSpread = 7,
    AimInaccuracyStepAmount = 1,
    WalkMultiplier = 0,
    SwayBase = 0.25,
    MaxSway = 2,
    AimZ = 0.4,
    LimbsDamage = 20,
    TorsoDamage = 24,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};