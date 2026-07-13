
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "HK416",
    BulletType = "5.56x45mm NATO",
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
    Weight = 3.52,
    EffectiveRange = 900,
    VRecoil = 24,
    HRecoil = 10,
    AimRecover = 0.7,
    RecoilPunch = 0.7,
    VPunchBase = 1.8,
    HPunchBase = 1.4,
    DPunchBase = 1,
    AimRecoilReduction = 5,
    PunchRecover = 0.5,
    RecoilPower = 0.5,
    RecoilPowerStepAmount = 0.25,
    MinSpread = 0,
    MaxSpread = 6,
    AimInaccuracyStepAmount = 0.5,
    WalkMultiplier = 0,
    SwayBase = 0.25,
    MaxSway = 1.2,
    AimZ = 0.4,
    LimbsDamage = 22,
    TorsoDamage = 41,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};