
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "SCAR SSR",
    BulletType = "7.62x51mm NATO",
    Ammo = 20,
    Bullets = 1,
    FireRate = 900,
    GunType = 1,
    ReloadType = 1,
    Mode = "Semi",
    FireModes = {
        ChangeFiremode = false,
        Semi = true,
        Burst = false,
        Auto = false,
        Explosive = false
    },
    Weight = 5.05,
    EffectiveRange = 1600,
    VRecoil = 26,
    HRecoil = 15,
    AimRecover = 0.7,
    RecoilPunch = 2,
    VPunchBase = 4.3,
    HPunchBase = 2.2,
    DPunchBase = 1.5,
    AimRecoilReduction = 5,
    PunchRecover = 0.6,
    RecoilPower = 0.75,
    RecoilPowerStepAmount = 0.25,
    MinSpread = 0,
    MaxSpread = 6,
    AimInaccuracyStepAmount = 1,
    WalkMultiplier = 0,
    SwayBase = 0.25,
    MaxSway = 2,
    AimZ = 0.4,
    LimbsDamage = 40,
    TorsoDamage = 80,
    HeadDamage = 110,
    PlankAmount = 2,
    DamagePerPlank = 3
};