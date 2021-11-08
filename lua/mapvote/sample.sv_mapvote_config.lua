--[[
# MapVote Config
See readme.md for general information. 

## **FIRST THINGS FIRST...**
- Change this files name to `sv_mapvote_config.lua` (remove the `sample`). This will make it usable.
- **This addon will replace your current map system.** Mainly meaning, if you have them on fastdl, you'll have to find them on the Steam Workshop, or add them to the workshop yourself.
  - If you don't want to do this, consider [the original addon](https://github.com/tyrantelf/gmod-mapvote) or [my fork with only map previews](https://github.com/funczone/mapvote_with_previews).
]]
-- Original config. See: https://github.com/tyrantelf/gmod-mapvote#ttt-and-deathrun-setup
MapVote.Config = {
    RTVPlayerCount = 3      -- number, the minimum number of players that need to be online for RTV to work.
    EnableCooldown = true   -- boolean, whether to remove a map from voting for a while after it's played.
    MapsBeforeRevote = 3    -- number, the number of maps that must be played before a map is in the vote menu again (if EnableCooldown is true)
    MapLimit = 24           -- number, the number of maps shown on the vote screen.
    TimeLimit = 28          -- number, how long the vote is shown for.
    AllowCurrentMap = false -- boolean, to allow a the current map in the map vote list.
    ExtraVotePower = 2      -- integer, how much extra vote power a user has
    Previews = {            -- table, preview settings
        Enabled = true,             -- boolean, are previews enabled?
        ImageExtension = "jpg",     -- string, the image extension each map preview is formatted as
        DBURL = "https://example.com/assets/maps/", -- string, where the images are hosted
        InitializeWithCurrentMap = false -- boolean, whether or not we initalize the mapvote preview image with our current map (by default, it is a checkerboard image)
    }
}

--[[
# Map Preview Configuration
1) In your config, enable previews by setting `Previews.Enabled` to `true`.

2) Host a folder on a webserver somewhere that has *direct* links of map preview images you want to display on the mapvote screen - a service like Google Drive will not work. Change `Previews.DBURL` to this folders URL.
  - The images name must be the same as the maps name (and must equal your configured image extension); for example, the map `ttt_xmas_nipperhouse` would be named `ttt_xmas_nipperhouse.jpg` on the webserver. 

3) Set the `Previews.ImageExtension` table property to the image extension. Note that The images must be all of the same format, and they must be browser friendly; .vtf images will not work.
]]

--[[
# Map Pools
This allows you to add specific maps to your map pool based on certain server conditions.

MapVote.Pools: A table of tables, with each key being a pool ID. Each nested table has the following properties;
  - "maps": An array of map names in the pool.
  - "goal": A function run at Mapvote.Start() that determines if the pool is part of the mapvote. Returns true if the pool should be part of the next map vote, false if not.

```lua
-- example
MapVote.Pools = {
    general = {
        maps = {"ttt_skyscraper"},
        goal = function()
            return true
        end
    },
    christmas = {
        maps = {"ttt_xmas_nipperhouse"},
        goal = function()
            local month =  os.date("%B", os.time())
            return month == "December" or month == "January"
        end
    }
}
```
]]
MapVote.Pools = {}

--[[
# Maps
A table listing maps to their corresponding workshop IDs.

## Instructions
- First, the server must have these maps downloaded; this can be done by creating a Steam Workshop collection (or link this theoretical collection to an existing collection you're already using), and put 'em in there.
- Then simply set the convar `host_workshop_collection` to the ID of the workshop collection you just made.
The user will download each map as they are loaded on the server; a fallback map will be used if it does not exist on the server.

```lua
-- example
MapVote.Maps = {
    ["ttt_skyscraper"]       = "253328815",
    ["ttt_xmas_nipperhouse"] = "1149578586"
}
```
]]
MapVote.Maps = {}

--[[
These two maps are special.
- MapVote.FallbackMap: The default map to "fallback" to if a current map isn't located on the server. If the fallback fails, it is hardcoded to go to gm_construct.
- MapVote.StartingMap: The starting map when your server launches. 
]]
MapVote.FallbackMap = "gm_construct"
MapVote.StartingMap = "gm_construct"
