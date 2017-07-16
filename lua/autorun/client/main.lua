
local function c_playtime_receive(len, ply)
  ply.playtime = tonumber(net.ReadFloat())
end
net.Receive("c_playtime_send", c_playtime_receive)

local meta = FindMetaTable("Player")
function meta:GetPlaytime()
  if self:IsPlayer() then
    return ply.playtime
  end
end
