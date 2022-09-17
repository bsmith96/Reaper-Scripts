--[[
  @description Lua util test
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.0
  @changelog
    + Initial version
  @metapackage
  @provides
    [main] . > bsmith96_Test.lua
  @about
    # Test
    Written by Ben Smith - September 2022

    ### Info
    *

    ### Usage
    * 

    ### User customisation
    *
]]


-- =========================================================
-- ===============  USER CUSTOMISATION AREA  ===============
-- =========================================================

--------- End of user customisation area --


-- =========================================================
-- =================  GLOBAL VARIABLES  ====================
-- =========================================================

local r = reaper

-- Load lua utilities
bsmith96_LuaUtils = '/Users/Ben/Documents/Reaper-Scripts/Development/bsmith96_Lua Utilities.lua'
bsmith96_LuaUtils_MinVersion = 1.0
if r.file_exists( bsmith96_LuaUtils ) then 
  dofile( bsmith96_LuaUtils )
  if not bsmith96 or bsmith96.version() < bsmith96_LuaUtils_MinVersion then
    bsmith96.msg('This script requires a newer version of BSmith96 Lua Utilities. Please run:\n\nExtensions > ReaPack > Synchronize Packages',"BSmith96 Lua Utilities");
    return
  end
else
  r.ShowConsoleMsg("This script requires BSmith96 Lua Utilities! Please install them here:\n\nExtensions > ReaPack > Browse Packages > 'BSmith96 Lua Utilities'\n\n")
  return
end

local b = bsmith96

-- get the script's name and directory
local scriptName = ({r.get_action_context()})[2]:match("([^/\\_]+)%.lua$")
local scriptDirectory = ({r.get_action_context()})[2]:sub(1, ({r.get_action_context()})[2]:find("\\[^\\]*$"))


-- =========================================================
-- ======================  FUNCTIONS  ======================
-- =========================================================


-- =========================================================
-- ======================  UTILITIES  ======================
-- =========================================================

-- deliver messages and add new line in console
function dbg(dbg)
  r.ShowConsoleMsg(dbg .. "\n")
end

-- deliver messages using message box
function msg(msg)
  r.MB(msg, scriptName, 0)
end


-- =========================================================
-- ===================  MAIN ROUTINE  ======================
-- =========================================================

r.Undo_BeginBlock()

b.msg("Hello world!")

b.dbg("Test console msg")

b.dbg(r.CountTracks(0))

r.Undo_EndBlock(scriptName, -1)