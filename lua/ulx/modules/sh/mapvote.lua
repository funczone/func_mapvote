local CATEGORY_NAME = "MapVote"
MapVote.Forced = MapVote.Forced or {}

--[[
# ulx mapvote
Instantiates a map vote.
]]
local function mapvote( calling_ply, votetime, should_cancel )
    if not should_cancel then
        MapVote.Start(votetime, nil, nil, nil)
        ulx.fancyLogAdmin( calling_ply, "#A called a votemap!" )
    else
        MapVote.Cancel()
        ulx.fancyLogAdmin( calling_ply, "#A canceled the votemap" )
    end
end

local mapvotecmd = ulx.command( CATEGORY_NAME, "mapvote", mapvote, "!mapvote" )
mapvotecmd:addParam{ type=ULib.cmds.NumArg, min=15, default=25, hint="time", ULib.cmds.optional, ULib.cmds.round }
mapvotecmd:addParam{ type=ULib.cmds.BoolArg, invisible=true }
mapvotecmd:defaultAccess( ULib.ACCESS_ADMIN )
mapvotecmd:help( "Instantiates a map vote." )
mapvotecmd:setOpposite( "unmapvote", {_, _, true}, "!unmapvote" )

--[[
# ulx forcemappool
Forces a map pool to be in play during the next map vote.
@todo this is like *kinda* functional but also very broken
]]
local function forcemappool(calling_ply, pool, should_unforce)
    if MapVote.Forced[pool] ~= nil then
        ULib.tsayError(calling_ply, "This pool does not exist - use a pool from the help text of the command.")
    end

    local action = "forced"
    if should_unforce then
        action = "unforced"
        MapVote.Forced[pool] = nil
    else
        table.insert(MapVote.Forced, pool)
    end
    ulx.fancyLogAdmin(calling_ply, true, "#A " .. action .. " map pool \"" .. pool .. "\"" .. action == "forced" and " into " or " from " .. "the map rotation.")
end
local forcemappoolcmd = ulx.command(CATEGORY_NAME, "forcemappool", forcemappool, "!forcemappool")
forcemappoolcmd:addParam{ type=ULib.cmds.StringArg, hint="pool", ULib.cmds.takeRestOfLine, completes=curpools }
forcemappoolcmd:defaultAccess(ULib.ACCESS_ADMIN)
forcemappoolcmd:help("Forces a map pool to be in play during the next map vote.\n\nCurrent pools: " .. table.concat(MapVote.Forced, ", "))
forcemappoolcmd:setOpposite("unforcemappool", {_, _, true}, "!unforcemappool")