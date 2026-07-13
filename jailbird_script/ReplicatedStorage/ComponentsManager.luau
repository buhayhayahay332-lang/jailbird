
local ReplicatedStorage = game:GetService("ReplicatedStorage");

return {
    Gamepasses = require(ReplicatedStorage.Components.Gamepasses),
    Shop = require(ReplicatedStorage.Components.Shop),
    Inventory = require(ReplicatedStorage.Components.Inventory),
    Settings = require(ReplicatedStorage.Components.Settings),
    Menu = require(ReplicatedStorage.Components.Menu),
    Keybinds = require(ReplicatedStorage.Components.Keybinds),
    Weapon = require(ReplicatedStorage.Components.Weapon),
    Player = require(ReplicatedStorage.Components.Player),
    Ragdoll = require(ReplicatedStorage.Components.Ragdoll),
    HitEffect = require(ReplicatedStorage.Components.HitEffect),
    Rank = require(ReplicatedStorage.Components.Rank)
};