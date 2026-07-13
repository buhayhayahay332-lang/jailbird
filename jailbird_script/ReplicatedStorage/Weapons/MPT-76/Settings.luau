
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "MPT-76",
    BulletType = "7.62x51mm NATO",
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
    Weight = 3.75,
    EffectiveRange = 1200,
    VRecoil = 25,
    HRecoil = 8,
    AimRecover = 0.65,
    RecoilPunch = 1,
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
    MaxSway = 2,
    AimZ = 0.4,
    LimbsDamage = 25,
    TorsoDamage = 43,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};