MapVote = {}

MapVote.CurrentMaps = {}
MapVote.Votes = {}

MapVote.Allow = false
MapVote.Color = Color(255, 118, 20)

MapVote.UPDATE_VOTE = 1
MapVote.UPDATE_WIN = 3

-- Use this function to give certain players more voting power.
function MapVote.HasExtraVotePower(ply)
    --[[
    if ply:SteamID() == "STEAM_0:1:48971987" then -- :)
        return true
    end 
    ]]
    return false
end

-- @todo overwrite old
hook.Add("Initialize", "MapVoteConfigSetup", function()
    if SERVER and not file.IsDir("mapvote", "DATA") then
        file.CreateDir("mapvote")
    end
end)

if SERVER then
    AddCSLuaFile()
    AddCSLuaFile("mapvote/cl_mapvote.lua")

    include("mapvote/sv_mapvote_config.lua")
    include("mapvote/sv_mapvote.lua")
    include("mapvote/rtv.lua")
else
    include("mapvote/cl_mapvote.lua")
end
