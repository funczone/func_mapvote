-- edit this if you want to change the default preview image
local errimg = "data:image/png;base64,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"

surface.CreateFont("RAM_VoteFont", {
    font = "Trebuchet MS",
    size = 19,
    weight = 700,
    antialias = true,
    shadow = true
})

surface.CreateFont("RAM_VoteFontCountdown", {
    font = "Tahoma",
    size = 32,
    weight = 700,
    antialias = true,
    shadow = true
})

surface.CreateFont("RAM_VoteSysButton", 
{    font = "Marlett",
    size = 13,
    weight = 0,
    symbol = true,
})

MapVote.Previews = {}
net.Receive("RAM_Init", function(len, ply)
    local previews = net.ReadBool()
    if previews then
        MapVote.Previews.Enabled = true
        MapVote.Previews.DBURL = net.ReadString()
        MapVote.Previews.ImageExtension = net.ReadString()
        MapVote.Previews.InitializeWithCurrentMap = net.ReadBool()
    end
end)

MapVote.EndTime = 0
MapVote.Panel = false

net.Receive("RAM_MapVoteStart", function(len, ply)
    MapVote.CurrentMaps = {}
    MapVote.Allow = true
    MapVote.Votes = {}
    
    local amt = net.ReadUInt(32)
    
    for i = 1, amt do
        local map = net.ReadString()
        
        MapVote.CurrentMaps[#MapVote.CurrentMaps + 1] = map
    end
    
    MapVote.EndTime = CurTime() + net.ReadUInt(32)

    if(IsValid(MapVote.Panel)) then
        MapVote.Panel:Remove()
    end

    MapVote.Panel = vgui.Create("VoteScreen")
    MapVote.Panel:SetMaps(MapVote.CurrentMaps)
end)

net.Receive("RAM_MapVoteUpdate", function()
    local update_type = net.ReadUInt(3)
    
    if(update_type == MapVote.UPDATE_VOTE) then
        local ply = net.ReadEntity()
        
        if(IsValid(ply)) then
            local map_id = net.ReadUInt(32)
            MapVote.Votes[ply:SteamID()] = map_id
        
            if(IsValid(MapVote.Panel)) then
                MapVote.Panel:AddVoter(ply)
            end
        end
    elseif(update_type == MapVote.UPDATE_WIN) then      
        if(IsValid(MapVote.Panel)) then
            MapVote.Panel:Flash(net.ReadUInt(32))
        end
    end
end)

net.Receive("RAM_MapVoteCancel", function()
    if IsValid(MapVote.Panel) then
        MapVote.Panel.maximButton:Remove()
        MapVote.Panel.minimButton:Remove()
        MapVote.Panel:Remove()
    end
end)

net.Receive("RTV_Delay", function()
    chat.AddText(Color( 102,255,51 ), "[MapVote]", Color( 255,255,255 ), " The vote has been rocked, map vote will begin on round end.")
end)

local PANEL = {}

function PANEL:Init()
    self:ParentToHUD()
    
    self.Canvas = vgui.Create("Panel", self)
    self.Canvas:MakePopup()
    self.Canvas:SetKeyboardInputEnabled(false)

    self.countDown = vgui.Create("DLabel", self.Canvas)
    self.countDown:SetTextColor(color_white)
    self.countDown:SetFont("RAM_VoteFontCountdown")
    self.countDown:SetText("")
    self.countDown:SetPos(0, 14)
    
    self.mapList = vgui.Create("DPanelList", self.Canvas)
    self.mapList:SetDrawBackground(false)
    self.mapList:SetSpacing(4)
    self.mapList:SetPadding(4)
    self.mapList:EnableHorizontal(true)
    self.mapList:EnableVerticalScrollbar()
    
    self.maximButton = vgui.Create("DButton")
    self.maximButton:SetText("+")
    self.maximButton.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255, 127))
    end
    self.maximButton.DoClick = function()
        self:SetVisible(true)
        self.maximButton:SetVisible(false)
        self.minimButton:SetVisible(true)
    end

    self.minimButton = vgui.Create("DButton")
    self.minimButton:SetText("-")
    self.minimButton.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255, 127))
    end
    self.minimButton.DoClick = function()
        self:SetVisible(false)
        self.maximButton:SetVisible(true)
        self.minimButton:SetVisible(false)
    end

    if MapVote.Previews.Enabled then
        local html = "<html><head><style>body { margin: 0; background-color: #222222 } #preview { height: 100%; width: 100%; }</style></head><body><img id='preview' src='" .. errimg .. "' onerror='err(this)'><script>function err(a) { a.src = '" .. errimg .. "' };</script></body></html>"

        self.mapPreview = vgui.Create("DHTML", self.Canvas)
        self.mapPreview:SetHTML(html)

        if MapVote.Previews.InitializeWithCurrentMap then
            self.mapPreview:RunJavascript("document.getElementById('preview').src = '" .. MapVote.Previews.DBURL .. game.GetMap() .. "." .. MapVote.Previews.ImageExtension .. "'")
        end
    end

    self.Voters = {}
end

function PANEL:PerformLayout()
    local cx, cy = chat.GetChatBoxPos()
    
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    
    local extra = math.Clamp(300, 0, ScrW() - 640)
    self.Canvas:StretchToParent(0, 0, 0, 0)
    self.Canvas:SetWidth(640 + extra)
    self.Canvas:SetHeight(ScrH()) -- cy - 60
    self.Canvas:SetPos(0, 0)
    self.Canvas:CenterHorizontal()
    self.Canvas:SetZPos(0)
    
    self.mapList:StretchToParent(0, 90, 0, 0)
    self.mapList:SetZPos(2)

    self.maximButton:SetPos((ScrW() - 24) - 2, 2)
    self.maximButton:SetSize(24, 20)
    self.maximButton:SetVisible(false)

    self.minimButton:SetPos((ScrW() - 24) - 2, 2)
    self.minimButton:SetSize(24, 20)
    self.minimButton:SetVisible(true)

    -- note to all who view this; positioning this w/ correct scaling was hell
    if MapVote.Previews.Enabled then
        -- buttons are 24px tall, 8 px between dpanellist borders, 4px in between each button
        local buttonrows = math.max(math.ceil(#self.mapList:GetItems() / 2), 1)
        local mppadding = 15
        local vpos = (90 + (buttonrows * 24) + ((buttonrows - 1) * 4) + 8) + mppadding

        local idealres = { x = 852, y = 480 }
        local ratio = math.min(((ScrH() - vpos - mppadding) / idealres["y"]), 1)
        self.mapPreview:SetWidth(idealres["x"] * ratio)
        self.mapPreview:SetHeight(idealres["y"] * ratio)

        local mlwidth = ((285 + (math.Clamp(300, 0, ScrW() - 640) / 2)) * 2) + (4 * 3)
        local hpos = ((mlwidth + (idealres["x"] * ratio)) / 2) - idealres["x"] * ratio
        self.mapPreview:SetPos(hpos, vpos)

        self.mapPreview:SetZPos(1)
        self.mapPreview:SetVisible(true)
    end
end

local heart_mat = Material("icon16/heart.png")
local star_mat = Material("icon16/star.png")
local shield_mat = Material("icon16/shield.png")

function PANEL:AddVoter(voter)
    for k, v in pairs(self.Voters) do
        if(v.Player and v.Player == voter) then
            return false
        end
    end
    
    local icon_container = vgui.Create("Panel", self.mapList:GetCanvas())
    local icon = vgui.Create("AvatarImage", icon_container)
    icon:SetSize(16, 16)
    icon:SetZPos(1000)
    icon:SetTooltip(voter:Name())
    icon_container.Player = voter
    icon_container:SetTooltip(voter:Name())
    icon:SetPlayer(voter, 16)

    if MapVote.HasExtraVotePower(voter) then
        icon_container:SetSize(40, 20)
        icon:SetPos(21, 2)
        icon_container.img = star_mat
    else
        icon_container:SetSize(20, 20)
        icon:SetPos(2, 2)
    end

    icon_container.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(255, 0, 0, 80))
        
        if(icon_container.img) then
            surface.SetMaterial(icon_container.img)
            surface.SetDrawColor(Color(255, 255, 255))
            surface.DrawTexturedRect(2, 2, 16, 16)
        end
    end
    
    table.insert(self.Voters, icon_container)
end

function PANEL:Think()
    for k, v in pairs(self.mapList:GetItems()) do
        v.NumVotes = 0
    end
    
    for k, v in pairs(self.Voters) do
        if(not IsValid(v.Player)) then
            v:Remove()
        else
            if(not MapVote.Votes[v.Player:SteamID()]) then
                v:Remove()
            else
                local bar = self:GetMapButton(MapVote.Votes[v.Player:SteamID()])
                
                if(MapVote.HasExtraVotePower(v.Player)) then
                    bar.NumVotes = bar.NumVotes + 2
                else
                    bar.NumVotes = bar.NumVotes + 1
                end
                
                if(IsValid(bar)) then
                    local CurrentPos = Vector(v.x, v.y, 0)
                    local NewPos = Vector((bar.x + bar:GetWide()) - 21 * bar.NumVotes - 2, bar.y + (bar:GetTall() * 0.5 - 10), 0)
                    
                    if(not v.CurPos or v.CurPos ~= NewPos) then -- new map
                        v:MoveTo(NewPos.x, NewPos.y, 0.3)
                        v.CurPos = NewPos
                    end
                end
            end
        end
    end
    
    local timeLeft = math.Round(math.Clamp(MapVote.EndTime - CurTime(), 0, math.huge))
    
    self.countDown:SetText(tostring(timeLeft or 0).." seconds")
    self.countDown:SizeToContents()
    self.countDown:CenterHorizontal()
end

function PANEL:SetMaps(maps)
    self.mapList:Clear()
    
    for k, v in RandomPairs(maps) do
        local button = vgui.Create("DButton", self.mapList)
        button.ID = k
        button:SetText(v)
        
        button.DoClick = function()
            if MapVote.Previews.Enabled then
                local previewurl = MapVote.Previews.DBURL .. v .. "." .. MapVote.Previews.ImageExtension
                self.mapPreview:RunJavascript("document.getElementById('preview').src = '" .. previewurl .. "'")
            end

            net.Start("RAM_MapVoteUpdate")
                net.WriteUInt(MapVote.UPDATE_VOTE, 3)
                net.WriteUInt(button.ID, 32)
            net.SendToServer()
        end
        
        do
            local Paint = button.Paint
            button.Paint = function(s, w, h)
                local col = Color(255, 255, 255, 10)
                
                if(button.bgColor) then
                    col = button.bgColor
                end
                
                draw.RoundedBox(4, 0, 0, w, h, col)
                Paint(s, w, h)
            end
        end
        
        button:SetTextColor(color_white)
        button:SetContentAlignment(4)
        button:SetTextInset(8, 0)
        button:SetFont("RAM_VoteFont")
        
        local extra = math.Clamp(300, 0, ScrW() - 640)
        
        button:SetDrawBackground(false)
        button:SetTall(24)
        button:SetWide(285 + (extra / 2))
        button.NumVotes = 0
        
        self.mapList:AddItem(button)
    end
end

function PANEL:GetMapButton(id)
    for k, v in pairs(self.mapList:GetItems()) do
        if(v.ID == id) then return v end
    end
    
    return false
end

function PANEL:Paint()
    --Derma_DrawBackgroundBlur(self)
    
    local CenterY = ScrH() / 2
    local CenterX = ScrW() / 2
    
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(0, 0, ScrW(), ScrH())
end

function PANEL:Flash(id)
    self:SetVisible(true)

    local bar = self:GetMapButton(id)
    
    if(IsValid(bar)) then
        timer.Simple( 0.0, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "hl1/fvox/blip.wav" ) end )
        timer.Simple( 0.2, function() bar.bgColor = nil end )
        timer.Simple( 0.4, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "hl1/fvox/blip.wav" ) end )
        timer.Simple( 0.6, function() bar.bgColor = nil end )
        timer.Simple( 0.8, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "hl1/fvox/blip.wav" ) end )
        timer.Simple( 1.0, function() bar.bgColor = Color( 100, 100, 100 ) end )
    end
end

derma.DefineControl("VoteScreen", "MapVote vote screen", PANEL, "DPanel")