
util.AddNetworkString("c_playtime_send")

local function c_playtime_init(ply)
  local playtime = 0
  corequery("SELECT * FROM playtime WHERE steamid = '"..ply:SteamID64().."' ", function(data)
		if data[1] != nil then
			ply.playtime = data[1].time
		else
			ply.playtime = 0
      corequery("INSERT INTO playtime (steamid, time) VALUES ("..ply:SteamID64()..", "..ply.playtime..")")
		end
	end)
end
hook.Add("PlayerInitialSpawn", "c_playtime_init", c_playtime_init)

local function c_playtime_count()
  for k,v in pairs(player.GetAll()) do
    if v:IsPlayer() then
      v.playtime = v.playtime + 60
      net.Start()
      net.WriteFloat(v.playtime)
      net.Send(v)
    end
  end
end
timer.Create("c_playtime_counttimer", 60,0, c_playtime_count)

local function c_paytime_update()
  for k,v in pairs(player.GetAll()) do
    v:UpdatePlaytime()
  end
end
timer.Create("c_paytime_updatetimer", 300, 0, c_paytime_update)

local meta = FindMetaTable("Player")
function meta:GetPlaytime()
  if IsValid(self) && self:IsPlayer() then
    return self.playtime
  end
end

function meta:ResetPlaytime()
  if IsValid(self) && self:IsPlayer() then
    self.playtime = 0
    self:UpdatePlaytime()
  end
end

function meta:SetPlaytime(time)
  if IsValid(self) && self:IsPlayer() then
    self.playtime = time
    self:UpdatePlaytime()
  end
end

function meta:UpdatePlaytime()
  if IsValid(self) && self:IsPlayer() then
    corequery("UPDATE playtime SET time = "..self.playtime.." WHERE steamid = '"..self:SteamID64().."' ")
  end
end
