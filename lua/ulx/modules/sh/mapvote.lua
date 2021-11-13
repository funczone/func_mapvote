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
]]
local function forcemappool(calling_ply, pool, unforced)
    local action = unforced and "unforced" or "forced"

    if(pool == "") then
        local pools = {}
        for _pool, _ in pairs(MapVote.Pools) do
            table.insert(pools, _pool)
        end 
        ULib.tsayColor(calling_ply, false, MapVote.Color, "[MapVote] ", Color(255, 255, 255), "Pools: " .. table.concat(pools, ", "))
        return
    end

    if not MapVote.Pools[pool] then
        ULib.tsayError(calling_ply, "This map pool doesn't exist!")
        return
    end

    if not unforced and table.HasValue(MapVote.Forced, pool) then
        ULib.tsayError(calling_ply, "Pool \"" .. pool .. "\" is already forced into the mapvote!")
        return
    elseif unforced and not table.HasValue(MapVote.Forced, pool) then
        ULib.tsayError(calling_ply, "Pool " .. pool .. " is not forced into the mapvote!")
        return
    end

    if should_unforce then
        MapVote.Forced[pool] = nil
    else
        table.insert(MapVote.Forced, pool)
    end
    ulx.fancyLogAdmin(calling_ply, true, "#A " .. action .. " map pool \"" .. pool .. "\"" .. (unforced and " from " or " into ") .. "the map rotation.")
end
local forcemappoolcmd = ulx.command(CATEGORY_NAME, "forcemappool", forcemappool, "!forcemappool")
forcemappoolcmd:addParam{ type=ULib.cmds.StringArg, hint="pool", ULib.cmds.takeRestOfLine }
forcemappoolcmd:defaultAccess(ULib.ACCESS_ADMIN)
forcemappoolcmd:help("Forces a map pool to be in play during the next map vote.\n\nNo input will print the current map pools to the chat.")
forcemappoolcmd:setOpposite("unforcemappool", {_, _, true}, "!unforcemappool")