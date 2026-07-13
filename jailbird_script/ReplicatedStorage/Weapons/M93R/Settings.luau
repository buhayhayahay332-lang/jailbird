
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "M93R",
    BulletType = "9x19mm Parabellum",
    Ammo = 20,
    Bullets = 1,
    FireRate = 900,
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
    Weight = 1.17,
    EffectiveRange = 120,
    VRecoil = 29,
    HRecoil = 5,
    AimRecover = 0.9,
    RecoilPunch = 2.5,
    VPunchBase = 1.5,
    HPunchBase = 0.1,
    DPunchBase = 1,
    AimRecoilReduction = 2,
    PunchRecover = 0.7,
    RecoilPower = 1,
    RecoilPowerStepAmount = 0.2,
    MinSpread = 0,
    MaxSpread = 6,
    AimInaccuracyStepAmount = 1.75,
    WalkMultiplier = 0,
    SwayBase = 0.05,
    MaxSway = 1,
    AimZ = 0.4,
    LimbsDamage = 20,
    TorsoDamage = 30,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};