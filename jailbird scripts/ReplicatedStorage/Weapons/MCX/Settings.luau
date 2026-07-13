
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "MCX",
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
    Weight = 3.5,
    EffectiveRange = 1100,
    VRecoil = 25,
    HRecoil = 11,
    AimRecover = 0.55,
    RecoilPunch = 0.7,
    VPunchBase = 2.5,
    HPunchBase = 1.7,
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
    MaxSway = 1.5,
    AimZ = 0.4,
    LimbsDamage = 22,
    TorsoDamage = 34,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};