
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "AS VAL",
    BulletType = "9x39mm SP-6",
    Ammo = 30,
    Bullets = 1,
    FireRate = 850,
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
    Weight = 3.54,
    EffectiveRange = 800,
    VRecoil = 27,
    HRecoil = 12,
    AimRecover = 0.7,
    RecoilPunch = 1,
    VPunchBase = 3.5,
    HPunchBase = 1.4,
    DPunchBase = 1,
    AimRecoilReduction = 4,
    PunchRecover = 0.45,
    RecoilPower = 0.5,
    RecoilPowerStepAmount = 0.35,
    MinSpread = 0,
    MaxSpread = 8,
    AimInaccuracyStepAmount = 1,
    WalkMultiplier = 0,
    SwayBase = 0.25,
    MaxSway = 2,
    AimZ = 0.4,
    LimbsDamage = 25,
    TorsoDamage = 36,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};