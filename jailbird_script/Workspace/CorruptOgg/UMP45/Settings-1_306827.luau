
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "UMP45",
    BulletType = ".45 ACP",
    Ammo = 30,
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
    Weight = 2.3,
    EffectiveRange = 250,
    VRecoil = 23,
    HRecoil = 5,
    AimRecover = 0.7,
    RecoilPunch = 0.8,
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
    SwayBase = 0.05,
    MaxSway = 1,
    AimZ = 0.4,
    LimbsDamage = 30,
    TorsoDamage = 35,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};