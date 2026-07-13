
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "PP-19-01",
    BulletType = "9x19mm Parabellum",
    Ammo = 30,
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
    Weight = 2.1,
    EffectiveRange = 400,
    VRecoil = 22,
    HRecoil = 9,
    AimRecover = 0.45,
    RecoilPunch = 1,
    VPunchBase = 1,
    HPunchBase = 0.3,
    DPunchBase = 1,
    AimRecoilReduction = 3.5,
    PunchRecover = 0.5,
    RecoilPower = 0.25,
    RecoilPowerStepAmount = 0.2,
    MinSpread = 0,
    MaxSpread = 5,
    AimInaccuracyStepAmount = 1.5,
    WalkMultiplier = 0,
    SwayBase = 0.05,
    MaxSway = 1,
    AimZ = 0.4,
    LimbsDamage = 27,
    TorsoDamage = 35,
    HeadDamage = 150,
    PlankAmount = 1,
    DamagePerPlank = 2
};