
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "PP Bizon",
    BulletType = "9x19mm Parabellum",
    Ammo = 53,
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
    Weight = 2.1,
    EffectiveRange = 500,
    VRecoil = 22,
    HRecoil = 10,
    AimRecover = 0.65,
    RecoilPunch = 1.5,
    VPunchBase = 1.5,
    HPunchBase = 0.3,
    DPunchBase = 1,
    AimRecoilReduction = 3.5,
    PunchRecover = 0.5,
    RecoilPower = 0.25,
    RecoilPowerStepAmount = 0.2,
    MinSpread = 0,
    MaxSpread = 6.2,
    AimInaccuracyStepAmount = 1.75,
    WalkMultiplier = 0,
    SwayBase = 0.05,
    MaxSway = 1,
    AimZ = 0.4,
    LimbsDamage = 31,
    TorsoDamage = 35,
    HeadDamage = 150,
    PlankAmount = 1,
    DamagePerPlank = 2
};