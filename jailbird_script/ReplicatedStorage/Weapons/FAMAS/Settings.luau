
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "FAMAS",
    BulletType = "5.56x45mm NATO",
    Ammo = 25,
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
    Weight = 3.61,
    EffectiveRange = 600,
    VRecoil = 26,
    HRecoil = 11,
    AimRecover = 0.6,
    RecoilPunch = 0.75,
    VPunchBase = 3.75,
    HPunchBase = 1.8,
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
    LimbsDamage = 25,
    TorsoDamage = 35,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};