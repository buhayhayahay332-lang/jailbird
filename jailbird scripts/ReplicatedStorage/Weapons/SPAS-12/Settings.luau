
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "SPAS-12",
    BulletType = "12 Gauge",
    Ammo = 6,
    Bullets = 8,
    FireRate = 250,
    GunType = 0,
    ReloadType = 2,
    Mode = "Pump-Action",
    FireModes = {
        ChangeFiremode = false,
        Semi = true,
        Burst = false,
        Auto = false,
        Explosive = false
    },
    Weight = 4.4,
    EffectiveRange = 55,
    VRecoil = 42,
    HRecoil = 15,
    AimRecover = 0.9,
    RecoilPunch = 8,
    VPunchBase = 31,
    HPunchBase = 23,
    DPunchBase = 1,
    AimRecoilReduction = 1,
    PunchRecover = 1.2,
    RecoilPower = 4,
    RecoilPowerStepAmount = 1,
    MinSpread = 5.5,
    MaxSpread = 12,
    AimInaccuracyStepAmount = 15,
    WalkMultiplier = 0,
    SwayBase = 0.25,
    MaxSway = 2,
    AimZ = 0.4,
    LimbsDamage = 16,
    TorsoDamage = 30,
    HeadDamage = 110,
    PlankAmount = 2,
    DamagePerPlank = 3
};