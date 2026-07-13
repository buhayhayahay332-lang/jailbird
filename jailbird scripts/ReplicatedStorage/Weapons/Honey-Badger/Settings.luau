
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "Honey Badger",
    BulletType = ".300 AAC Blackout",
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
    Weight = 2.9,
    EffectiveRange = 700,
    VRecoil = 26.5,
    HRecoil = 9,
    AimRecover = 0.6,
    RecoilPunch = 0.8,
    VPunchBase = 3.75,
    HPunchBase = 1.5,
    DPunchBase = 1,
    AimRecoilReduction = 5,
    PunchRecover = 0.5,
    RecoilPower = 0.75,
    RecoilPowerStepAmount = 0.25,
    MinSpread = 0,
    MaxSpread = 4,
    AimInaccuracyStepAmount = 1,
    WalkMultiplier = 0,
    SwayBase = 0.25,
    MaxSway = 2,
    AimZ = 0.4,
    LimbsDamage = 22,
    TorsoDamage = 47,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};