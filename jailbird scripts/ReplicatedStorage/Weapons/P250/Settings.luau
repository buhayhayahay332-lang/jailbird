
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "P250",
    BulletType = ".357 SIG",
    Ammo = 15,
    Bullets = 1,
    FireRate = 700,
    GunType = 0,
    ReloadType = 1,
    Mode = "Semi",
    FireModes = {
        ChangeFiremode = false,
        Semi = true,
        Burst = false,
        Auto = false,
        Explosive = false
    },
    Weight = 0.62,
    EffectiveRange = 150,
    VRecoil = 24,
    HRecoil = 5,
    AimRecover = 0.75,
    RecoilPunch = 3,
    VPunchBase = 15,
    HPunchBase = 8,
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
    LimbsDamage = 24,
    TorsoDamage = 35,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};