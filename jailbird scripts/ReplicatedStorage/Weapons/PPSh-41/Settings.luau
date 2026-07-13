
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.Types);

return {
    Name = "PPSh-41",
    BulletType = "7.62x25mm Tokarev",
    Ammo = 71,
    Bullets = 1,
    FireRate = 935,
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
    Weight = 3.46,
    EffectiveRange = 400,
    VRecoil = 22,
    HRecoil = 7,
    AimRecover = 0.65,
    RecoilPunch = 0.85,
    VPunchBase = 3.75,
    HPunchBase = 1.5,
    DPunchBase = 1,
    AimRecoilReduction = 5,
    PunchRecover = 0.55,
    RecoilPower = 0.75,
    RecoilPowerStepAmount = 0.25,
    MinSpread = 0,
    MaxSpread = 6,
    AimInaccuracyStepAmount = 1,
    WalkMultiplier = 0,
    SwayBase = 0.15,
    MaxSway = 1.5,
    AimZ = 0.4,
    LimbsDamage = 15,
    TorsoDamage = 18,
    HeadDamage = 150,
    PlankAmount = 1,
    DamagePerPlank = 2
};