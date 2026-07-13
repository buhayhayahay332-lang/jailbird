
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "MP5",
    BulletType = "9x19mm Parabellum",
    Ammo = 30,
    Bullets = 1,
    FireRate = 800,
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
    Weight = 2.54,
    EffectiveRange = 450,
    VRecoil = 24,
    HRecoil = 6,
    AimRecover = 0.8,
    RecoilPunch = 0.8,
    VPunchBase = 2,
    HPunchBase = 2,
    DPunchBase = 1,
    AimRecoilReduction = 5,
    PunchRecover = 0.5,
    RecoilPower = 0.5,
    RecoilPowerStepAmount = 0.15,
    MinSpread = 0,
    MaxSpread = 6,
    AimInaccuracyStepAmount = 2,
    WalkMultiplier = 0,
    SwayBase = 0.25,
    MaxSway = 1,
    AimZ = 0.4,
    LimbsDamage = 20,
    TorsoDamage = 42,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};