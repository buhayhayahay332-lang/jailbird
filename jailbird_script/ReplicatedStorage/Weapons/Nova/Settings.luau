
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "Nova",
    BulletType = "12 Gauge",
    Ammo = 6,
    Bullets = 8,
    FireRate = 225,
    GunType = 1,
    ReloadType = 2,
    Mode = "Pump-Action",
    FireModes = {
        ChangeFiremode = false,
        Semi = true,
        Burst = false,
        Auto = false,
        Explosive = false
    },
    Weight = 4,
    EffectiveRange = 50,
    VRecoil = 32,
    HRecoil = 10,
    AimRecover = 0.9,
    RecoilPunch = 4,
    VPunchBase = 25,
    HPunchBase = 18,
    DPunchBase = 1,
    AimRecoilReduction = 1,
    PunchRecover = 1.2,
    RecoilPower = 3,
    RecoilPowerStepAmount = 1,
    MinSpread = 5,
    MaxSpread = 13,
    AimInaccuracyStepAmount = 15,
    WalkMultiplier = 0,
    SwayBase = 0.25,
    MaxSway = 2,
    AimZ = 0.4,
    LimbsDamage = 15,
    TorsoDamage = 25,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 3
};