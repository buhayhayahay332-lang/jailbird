
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "FN Minimi",
    BulletType = "5.56x45mm NATO",
    Ammo = 75,
    Bullets = 1,
    FireRate = 950,
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
    Weight = 7.1,
    EffectiveRange = 600,
    VRecoil = 45,
    HRecoil = 24,
    AimRecover = 0.55,
    RecoilPunch = 0.9,
    VPunchBase = 4,
    HPunchBase = 2,
    DPunchBase = 1,
    AimRecoilReduction = 3,
    PunchRecover = 0.5,
    RecoilPower = 0.35,
    RecoilPowerStepAmount = 0.2,
    MinSpread = 0.5,
    MaxSpread = 8,
    AimInaccuracyStepAmount = 1.75,
    WalkMultiplier = 0.25,
    SwayBase = 0.05,
    MaxSway = 1,
    AimZ = 0.4,
    LimbsDamage = 40,
    TorsoDamage = 75,
    HeadDamage = 110,
    PlankAmount = 1,
    DamagePerPlank = 2
};