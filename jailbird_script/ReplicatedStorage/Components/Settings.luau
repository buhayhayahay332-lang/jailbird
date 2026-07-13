
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Config = require(ReplicatedStorage.Config);
local u1 = {
    MobileSettings = {
        Aim = 0,
        Crouch = 0,
        Jump = 0,
        Knife = 0,
        LeanLeft = 0,
        LeanRight = 0,
        Prone = 0,
        Reload = 0,
        Shoot = 0,
        ShootStatic = 0,
        Sprint = 0,
        Swap = 0,
        Ping = 0,
        JoystickRectangle = 0
    },
    MobileSettingsProperties = { "XSize", "YSize", "XPosition", "YPosition" }
};

function u1.EditSettings(p2, p3) -- Line: 28
    -- upvalues: u1 (copy)
    if p3.Single == true then
        u1.EditSingleSetting(p2, p3);

        return;
    end;

    u1.EditAllSettings(p2, p3);
end;

function u1.EditAllSettings(p4, p5) -- Line: 37
    -- upvalues: Config (copy), ReplicatedStorage (copy)
    local Settings = p4.PlayerData.Settings;

    if p5 ~= nil then
        for i, v in pairs(p5) do
            if Settings:GetAttribute(i) ~= nil then
                Settings:SetAttribute(i, v);

                if i == "FieldOfView" then
                    Settings:SetAttribute(i, (math.clamp(v, Config.MinFieldOfView, Config.MaxFieldOfView)));
                elseif i == "Brightness" then
                    Settings:SetAttribute(i, (math.clamp(v, Config.MinBrightness, Config.MaxBrightness)));
                elseif i == "BackgroundMusicVolume" or (i == "Sensitivity" or i == "ADSSensitivity") then
                    Settings:SetAttribute(i, (math.clamp(v, 0, 1)));
                elseif i == "ConsoleHSensitivity" or i == "ConsoleVSensitivity" then
                    Settings:SetAttribute(i, (math.clamp(v, 1, 5)));
                elseif i == "PlayerHighlight" then
                    Settings:SetAttribute(i, (math.clamp(v, 0, 0.8)));
                end;
            end;
        end;
    end;

    ReplicatedStorage.Events.Notification:FireClient(p4, "Loading", "Settings saved.", 1.5, 0.03);
end;

function u1.EditSingleSetting(p6, p7) -- Line: 67
    -- upvalues: ReplicatedStorage (copy)
    local Settings = p6.PlayerData.Settings;

    if p7 ~= nil and (typeof(p7.Value) ~= "table" and Settings:GetAttribute(p7.Name)) then
        Settings:SetAttribute(p7.Name, p7.Value);

        if p7.Name == "Graphics" then
            Settings:SetAttribute("GraphicsSelected", true);
        end;
    end;

    ReplicatedStorage.Events.Notification:FireClient(p6, "Loading", "Settings saved.", 1.5, 0.03);
end;

function u1.EditMobileSettings(p8, p9) -- Line: 84
    -- upvalues: u1 (copy), ReplicatedStorage (copy)
    local MobileSettings = p8.PlayerData.MobileSettings;

    if p9 ~= nil then
        for i, v in pairs(p9) do
            local v10 = false;

            for i2, _ in pairs(u1.MobileSettings) do
                for _, v2 in pairs(u1.MobileSettingsProperties) do
                    if i == i2 .. v2 then
                        v10 = true;
                    end;
                end;
            end;

            if MobileSettings:GetAttribute(i) ~= nil or v10 then
                MobileSettings:SetAttribute(i, v);
            end;
        end;
    end;

    ReplicatedStorage.Events.Notification:FireClient(p8, "Loading", "Mobile settings saved.", 1.5, 0.03);
end;

return u1;