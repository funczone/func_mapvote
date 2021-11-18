RTV = MapVote.RTV or {}
RTV.TotalVotes = 0
RTV._ActualWait = CurTime() + RTV.Wait

function RTV.ShouldChange()
    return RTV.TotalVotes >= math.Round(#player.GetAll() * RTV.VoteRatio)
end

function RTV.RemoveVote()
    RTV.TotalVotes = math.Clamp(RTV.TotalVotes - 1, 0, math.huge)
end

function RTV.Start()
    if GAMEMODE_NAME == "terrortown" then
        net.Start("RTV_Delay")
        net.Broadcast()

        hook.Add("TTTEndRound", "MapvoteDelayed", function()
            MapVote.Start()
        end)
    elseif GAMEMODE_NAME == "deathrun" then
        net.Start("RTV_Delay")
        net.Broadcast()

        hook.Add("RoundEnd", "MapvoteDelayed", function()
            MapVote.Start()
        end)
    else
        PrintMessage(HUD_PRINTTALK, "The vote has been rocked, map vote imminent!")
        timer.Simple(4, function()
            MapVote.Start()
        end)
    end
end


function RTV.AddVote( ply )
    if RTV.CanVote(ply) then -- @todo not sure if this if block is needed at all. function is only ran from CountVote which already calls this
        RTV.TotalVotes = RTV.TotalVotes + 1
        ply.hasRTVd = true
        MsgN(ply:Nick().." has voted to Rock the Vote.")
        PrintMessage(HUD_PRINTTALK, ply:Nick() .. " has voted to Rock the Vote. (" .. RTV.TotalVotes .. "/" .. math.Round(#player.GetAll() * RTV.VoteRatio) .. ")")
        if RTV.ShouldChange() then
            RTV.Start()
        end
    end
end

hook.Add( "PlayerDisconnected", "Remove RTV", function(ply)
    if ply.hasRTVd then
        RTV.RemoveVote()
    end

    timer.Simple( 0.1, function()
        if RTV.ShouldChange() then
            RTV.Start()
        end
    end)
end)

function RTV.CanVote( ply )
    local plyCount = #player.GetAll()
    
    if RTV._ActualWait >= CurTime() then
        return false, "You must wait a bit before voting!"
    end

    if ply.hasRTVd then
        return false, "You have already voted to Rock the Vote!"
    end

    if RTV.ChangingMaps then
        return false, "There has already been a vote, the map is going to change!"
    end

    if plyCount < RTV.MinPlayers then
        return false, "You need more players before you can rock the vote!"
    end

    return true
end

function RTV.CountVote( ply )
    local can, err = RTV.CanVote(ply)
    if not can then
        ply:PrintMessage(HUD_PRINTTALK, err)
        return
    end
    RTV.AddVote(ply)
end

concommand.Add("rtv_start", RTV.CountVote)

hook.Add("PlayerSay", "RTV Chat Commands", function(ply, text)
    if table.HasValue(RTV.ChatCommands, string.lower(text)) then
        RTV.CountVote(ply)
        return ""
    end
end)