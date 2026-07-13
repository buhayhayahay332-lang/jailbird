
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "L86 LSW",
    BulletType = "5.56x45mm NATO",
    Ammo = 30,
    Bullets = 1,
    FireRate = 700,
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
    Weight = 4.98,
    EffectiveRange = 900,
    VRecoil = 23,
    HRecoil = 10,
    AimRecover = 0.6,
    RecoilPunch = 0.9,
    VPunchBase = 3.75,
    HPunchBase = 1.5,
    DPunchBase = 1,
    AimRecoilReduction = 5,
    PunchRecover = 0.5,
    RecoilPower = 0.75,
    RecoilPowerStepAmount = 0.25,
    MinSpread = 0,
    MaxSpread = 6,
    AimInaccuracyStepAmount = 1,
    WalkMultiplier = 0,
    SwayBase = 0.25,
    MaxSway = 2,
    AimZ = 0.4,
    LimbsDamage = 22,
    TorsoDamage = 42,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};