
local v1 = "";

for i = 1, 10 do
    v1 = v1 .. script:GetAttribute("BackupSection" .. i);
end;

return game:GetService("HttpService"):JSONDecode(v1);