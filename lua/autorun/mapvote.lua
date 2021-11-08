MapVote = {}

function MapVote.HasExtraVotePower(ply)
	-- Example that gives admins more voting power
	--[[
    if ply:IsAdmin() then
		return true
	end 
    ]]

	return false
end

MapVote.CurrentMaps = {}
MapVote.Votes = {}

MapVote.Allow = false

MapVote.UPDATE_VOTE = 1
MapVote.UPDATE_WIN = 3

if SERVER then
    AddCSLuaFile()
    AddCSLuaFile("mapvote/cl_mapvote.lua")

    include("mapvote/sv_mapvote_config.lua")
    include("mapvote/sv_mapvote.lua")
    include("mapvote/rtv.lua")
else
    include("mapvote/cl_mapvote.lua")
end

hook.Add("Initialize", "MapVoteConfigSetup", function()
    if SERVER then

    end
    --[[
        if not file.IsDir( "mapvote", "DATA") then
        file.CreateDir( "mapvote" )
    end
    if not file.Exists( "mapvote/config.txt", "DATA" ) then
        file.Write( "mapvote/config.txt", util.TableToJSON(MapVoteConfigDefault) )
    end
    ]]
end)