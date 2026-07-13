
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "TEC-9",
    BulletType = "9x19mm Parabellum",
    Ammo = 20,
    Bullets = 1,
    FireRate = 1000,
    GunType = 0,
    ReloadType = 1,
    Mode = "Auto",
    FireModes = {
        ChangeFiremode = false,
        Semi = false,
        Burst = false,
        Auto = true,
        Explosive = false
    },
    Weight = 1.4,
    EffectiveRange = 75,
    VRecoil = 25,
    HRecoil = 14,
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
    LimbsDamage = 19,
    TorsoDamage = 29,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};