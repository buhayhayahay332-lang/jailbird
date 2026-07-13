
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "MP7",
    BulletType = "4.6x30mm",
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
    Weight = 2.1,
    EffectiveRange = 450,
    VRecoil = 21,
    HRecoil = 6,
    AimRecover = 0.65,
    RecoilPunch = 0.75,
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
    MaxSway = 1,
    AimZ = 0.4,
    LimbsDamage = 19,
    TorsoDamage = 27,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};