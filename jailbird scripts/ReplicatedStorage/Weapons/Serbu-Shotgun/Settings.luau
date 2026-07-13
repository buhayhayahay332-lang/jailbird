
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "Serbu Shotgun",
    BulletType = "12 Gauge",
    Ammo = 4,
    Bullets = 6,
    FireRate = 425,
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
    Weight = 1.8,
    EffectiveRange = 35,
    VRecoil = 40,
    HRecoil = 18,
    AimRecover = 0.9,
    RecoilPunch = 7,
    VPunchBase = 31,
    HPunchBase = 23,
    DPunchBase = 1,
    AimRecoilReduction = 1,
    PunchRecover = 0.7,
    RecoilPower = 3,
    RecoilPowerStepAmount = 1,
    MinSpread = 3,
    MaxSpread = 12,
    AimInaccuracyStepAmount = 15,
    WalkMultiplier = 0,
    SwayBase = 0.25,
    MaxSway = 2,
    AimZ = 0.4,
    LimbsDamage = 15,
    TorsoDamage = 20,
    HeadDamage = 110,
    PlankAmount = 3,
    DamagePerPlank = 2
};