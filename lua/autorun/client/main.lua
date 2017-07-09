

local function c_playtime_receive(len, ply)
  ply.playtime = tonumber(net.ReadFloat())
end
net.Receive("c_playtime_send", c_playtime_receive)
