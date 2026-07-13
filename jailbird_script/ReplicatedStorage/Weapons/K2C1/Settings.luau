
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "K2A1",
    BulletType = "5.56x45mm NATO",
    Ammo = 30,
    Bullets = 1,
    FireRate = 750,
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
    Weight = 3.52,
    EffectiveRange = 1000,
    VRecoil = 28,
    HRecoil = 9,
    AimRecover = 0.7,
    RecoilPunch = 0.6,
    VPunchBase = 2.3,
    HPunchBase = 1.9,
    DPunchBase = 1,
    AimRecoilReduction = 5,
    PunchRecover = 0.45,
    RecoilPower = 0.4,
    RecoilPowerStepAmount = 0.25,
    MinSpread = 0,
    MaxSpread = 6,
    AimInaccuracyStepAmount = 0.4,
    WalkMultiplier = 0,
    SwayBase = 0.25,
    MaxSway = 1.5,
    AimZ = 0.4,
    LimbsDamage = 19,
    TorsoDamage = 42,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};