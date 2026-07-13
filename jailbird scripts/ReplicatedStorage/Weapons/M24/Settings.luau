
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "M24",
    BulletType = ".338 Lapua Magnum",
    Ammo = 6,
    Bullets = 1,
    FireRate = 75,
    GunType = 1,
    ReloadType = 1,
    Mode = "Bolt-Action",
    FireModes = {
        ChangeFiremode = false,
        Semi = true,
        Burst = false,
        Auto = false,
        Explosive = false
    },
    Weight = 5.6,
    EffectiveRange = 3000,
    VRecoil = 40,
    HRecoil = 12,
    AimRecover = 0.7,
    RecoilPunch = 0.6,
    VPunchBase = 2.9,
    HPunchBase = 1.7,
    DPunchBase = 1,
    AimRecoilReduction = 5,
    PunchRecover = 0.6,
    RecoilPower = 0.5,
    RecoilPowerStepAmount = 0.25,
    MinSpread = 0,
    MaxSpread = 9,
    AimInaccuracyStepAmount = 0.5,
    WalkMultiplier = 0,
    SwayBase = 0.25,
    MaxSway = 1.5,
    AimZ = 0.4,
    LimbsDamage = 50,
    TorsoDamage = 100,
    HeadDamage = 150,
    PlankAmount = 6,
    DamagePerPlank = 3
};