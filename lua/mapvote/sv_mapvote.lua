MapVote.Forced = {}

util.AddNetworkString("RAM_MapVoteStart")
util.AddNetworkString("RAM_MapVoteUpdate")
util.AddNetworkString("RAM_MapVoteCancel")
util.AddNetworkString("RTV_Delay")
util.AddNetworkString("RAM_Init")

hook.Add("Initialize", function()
    net.Start("RAM_Init")
        net.WriteBool(MapVote.Config.Previews.Enabled)
        if MapVote.Config.Previews.Enabled then
            net.WriteString(MapVote.Config.Previews.URL or "")
            net.WriteString(MapVote.Config.Previews.ImageExtension or "")
            net.WriteBool(MapVote.Config.Previews.InitializeWithCurrentMap or true)
        end
    net.Broadcast()
end)

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

local downloaded = file.Find("maps/*.bsp", "GAME")

--[[
    This function pools maps together based on parameters.

    The boolean `strict` parameter enables strict mode, which does the following; 
    - Follows MapVote.Config **unless otherwise specified in parameters.**
    - Does not pool maps that aren't downloaded by the server.

    If strict mode is not enabled and no (or nil) parameters are provided, it will pool maps **ONLY** by if they're part of their respective pools. 
    @todo maybe want to clean up the default values in MapVote.Start
]]
function MapVote.PoolMaps(strict, limit, addcurrent, cooldown, ignoreplys, _debug)
    strict = strict ~= nil and strict or true
    limit  = limit or (strict and MapVote.Config.MapLimit or math.huge)
    addcurrent = addcurrent ~= nil and addcurrent or (strict and MapVote.Config.AllowCurrentMap or true) -- Include the current map?
    cooldown   = cooldown ~= nil   and cooldown   or (strict and MapVote.Config.EnableCooldown  or false) -- Respect map cooldown?
    ignoreplys = ignoreplys ~= nil and ignoreplys or (strict and false or true) -- Ignore the servers current playercount?
    _debug     = _debug ~= nil     and _debug     or false

    local curmap = game.GetMap()
    local curply = #player.GetAll()
    local pools = {}
    
    -- Check (and force) our pool values.
    for pool, test in pairs(MapVote.Pools) do pools[pool] = test() end
    for _, pool in pairs(MapVote.Forced)   do pools[pool] = true   end

    local maps = {
        pooled = {}
        undownloaded = {} -- for debug purposes
    }

    --[[
        Next, check which maps are valid to be pooled.
        !!! IF YOU'RE ADDING PARAMETERS TO MAPS, CHECK THEM IN THIS LOOP !!!
        @todo this is not the most optimized code in the world, and probably warrants a rewrite.
    ]]
    local p = _debug and pairs or RandomPairs 
    for map, opts in p(MapVote.Maps) do
        local shouldadd

        -- First, check if the map is the current map (and if thats allowed or not).
        if not addcurrent and (map == curmap) then continue end

        -- Next, check if the server has this map downloaded. This will NOT disallow the map from being pooled unless in strict mode.
        if not table.HasValue(downloaded, map .. ".bsp") then
            table.insert(maps.undownloaded, map)
            if strict then
                continue
            end
        end

        -- Next, check if the maps on cooldown.
        if cooldown and table.HasValue(recentmaps, map) then continue end

        -- Next, check if the map is in a valid pool. `opts.pooled` can be either a string, array, or function.
        local _type = type(opts.pooled)
        if _type == "string" then
            if pools[opts.pooled] then shouldadd = true end
        elseif _type == "table" then
            for _, pool in ipairs(opts.pooled) do
                if pools[pool] then
                    shouldadd = true
                    break
                end
            end
        elseif _type == "function" then
            if opts.pooled() then shouldadd = true end
        end

        -- Next, check if the map is of a valid playercount.
        if not ignoreplys and (opts.size and MapVote.Config.PlayerTolerance ~= nil) then
            local t = MapVote.Config.PlayerTolerance
            if (opts.size > curply + t) or (opts.size < curply - t) then
                shouldadd = false
            end
        end

        -- Finally, add the map to the pool if it should be added.
        if shouldadd and not table.HasValue(maps.pooled, map) then
            table.insert(maps.pooled, map)
        end

        if #maps.pooled >= limit then break end
    end

    if _debug then
        return maps
    end
    return maps.pooled
end

concommand.Add("mapvote_debug", function(ply, cmd, args, argsstr)
    local maps = MapVote.PoolMaps(false, nil, nil, nil, args[1] == "1", true)
    print("[MapVote] === POOLABLE MAPS ===")
    print(table.concat(maps, ", "))

    if #maps.undownloaded > 0 then
        print("\n[MapVote] WARNING: " .. #maps.undownloaded .. " maps are not located on the server!")
        print(table.concat(maps, ", "))
    end
end, nil, "Prints some debug information about the currently possibly-pooled maps.\nPass \"1\" as an argument to ignore the current player count.")

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
            net.WriteString(MapVote.Config.Previews.URL or "")
            net.WriteString(MapVote.Config.Previews.ImageExtension or "")
            net.WriteBool(MapVote.Config.Previews.InitializeWithCurrentMap or true)
        end
    net.Broadcast()

    local vote_maps = MapVote.PoolMaps(true, limit, current, cooldown)
    if #vote_maps == 0 then
        error("No maps got pooled! Please properly configure your map pools in sv_mapvote_config.lua.\n")
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