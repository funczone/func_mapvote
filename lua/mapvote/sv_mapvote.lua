util.AddNetworkString("RAM_MapVoteStart")
util.AddNetworkString("RAM_MapVoteUpdate")
util.AddNetworkString("RAM_MapVoteCancel")
util.AddNetworkString("RTV_Delay")
util.AddNetworkString("RAM_Init")

MapVote.Continued = false
MapVote.Forced = {} -- forced map pools

net.Receive("RAM_MapVoteUpdate", function(len, ply)
    if(MapVote.Allow) then
        if(IsValid(ply)) then
            local update_type = net.ReadUInt(3)
            
            if(update_type == MapVote.UPDATE_VOTE) then
                local map_id = net.ReadUInt(32)
                
                if(MapVote.CurrentMaps[map_id]) then
                    MapVote.Votes[ply:SteamID()] = map_id
                    
                    net.Start("RAM_MapVoteUpdate")
                        net.WriteUInt(MapVote.UPDATE_VOTE, 3)
                        net.WriteEntity(ply)
                        net.WriteUInt(map_id, 32)
                    net.Broadcast()
                end
            end
        end
    end
end)

local recentmaps = {}
if file.Exists("mapvote/recentmaps.txt", "DATA") then recentmaps = util.JSONToTable(file.Read("mapvote/recentmaps.txt", "DATA")) end

function MapVote.Start(length, current, limit)
    length = length or MapVote.Config.TimeLimit or 28
    current = current or MapVote.Config.AllowCurrentMap or false
    limit = limit or MapVote.Config.MapLimit or 24

    local cooldown = MapVote.Config.EnableCooldown or true
    local cooldownnum = MapVote.Config.MapsBeforeRevote or 3
    local extra = MapVote.Config.ExtraVotePower or 2
    local curmap = game.GetMap()

    net.Start("RAM_Init")
        net.WriteBool(MapVote.Config.Previews.Enabled)
        if MapVote.Config.Previews and MapVote.Config.Previews.Enabled then
            net.WriteString(MapVote.Config.Previews.DBURL or "")
            net.WriteString(MapVote.Config.Previews.ImageExtension or "")
            net.WriteBool(MapVote.Config.Previews.InitializeWithCurrentMap or true)
        end
    net.Broadcast()

    local pooled_maps = {}
    local vote_maps = {}
    local downloaded = file.Find("maps/*.bsp", "GAME")

    if #MapVote.Pools > 0 then error("No map pools configured - you need to add atleast *one*. See MapVote.Pools in sv_mapvote_config.lua for more information.") end
    
    for _, pool in pairs(MapVote.Pools) do
        local good = pool.goal()
        if good == true then
            for __, map in pairs(pool.maps) do
                if MapVote.Maps[map] and (not table.HasValue(pooled_maps, map)) then table.insert(pooled_maps, map) end
            end
        end
    end

    for _, p in pairs(MapVote.Forced) do -- since this is handled by a ulx command, we assume every pool exists
        local pool = MapVote.Pools[p]
        for __, map in pairs(pool.maps) do
            if MapVote.Maps[map] and (not table.HasValue(pooled_maps, map)) then table.insert(pooled_maps, map) end
        end
    end

    if #pooled_maps > 0 then
        for _, map in RandomPairs(pooled_maps) do
            if not current or (current and curmap ~= map) then
                if not cooldown or (cooldown and not table.HasValue(recentmaps, map)) then
                    table.insert(vote_maps, map)
                    if limit and #vote_maps >= limit then break end
                end
            end
        end
    else
        error("No maps got pooled - see MapVote.Pools in sv_mapvote_config.lua for more information.\n")
    end
    
    net.Start("RAM_MapVoteStart")
        net.WriteUInt(#vote_maps, 32)
        for _, map in pairs(vote_maps) do net.WriteString(map) end
        net.WriteUInt(length, 32)
    net.Broadcast()
    
    MapVote.Allow = true
    MapVote.CurrentMaps = vote_maps
    MapVote.Votes = {}
    
    timer.Create("RAM_MapVote", length, 1, function()
        MapVote.Allow = false
        local map_results = {}
        
        for k, v in pairs(MapVote.Votes) do
            if not map_results[v] then
                map_results[v] = 0
            end
            
            for k2, v2 in pairs(player.GetAll()) do
                if(v2:SteamID() == k) then
                    if MapVote.HasExtraVotePower(v2) then
                        map_results[v] = map_results[v] + extra
                    else
                        map_results[v] = map_results[v] + 1
                    end
                end
            end
            
        end
        
        if #recentmaps == cooldownnum then
            table.remove(recentmaps)
        end

        if not table.HasValue(recentmaps, curmap) then
            table.insert(recentmaps, 1, curmap)
        end
    
        file.Write("mapvote/recentmaps.txt", util.TableToJSON(recentmaps))

        local winner = table.GetWinningKey(map_results) or 1
        
        net.Start("RAM_MapVoteUpdate")
            net.WriteUInt(MapVote.UPDATE_WIN, 3)
            net.WriteUInt(winner, 32)
        net.Broadcast()
        
        local map = MapVote.CurrentMaps[winner]

        timer.Simple(4, function()
            if not table.HasValue(downloaded, map .. ".bsp") then
                local fb = MapVote.FallbackMap and (table.HasValue(downloaded, MapVote.FallbackMap .. ".bsp") and MapVote.FallbackMap) or "gm_construct"
                ErrorNoHalt("Map " .. map .. " not located on the server! Falling back to " .. fb .. "...")
                map = fb
            end
            hook.Run("MapVoteChange", map)
            RunConsoleCommand("changelevel", map)
        end)
    end)
end

hook.Add("Shutdown", "RemoveRecentMaps", function()
    if file.Exists("mapvote/recentmaps.txt", "DATA") then
        file.Delete("mapvote/recentmaps.txt")
    end
end)

function MapVote.Cancel()
    if MapVote.Allow then
        MapVote.Allow = false

        net.Start("RAM_MapVoteCancel")
        net.Broadcast()

        timer.Destroy("RAM_MapVote")
    end
end