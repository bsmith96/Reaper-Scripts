--[[
  @description
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.0
  @changelog
    + Initial version
  @metapackage
  @provides
    [main] . > bsmith96_{filename}.lua
  @about
    # {Package name}
    Written by Ben Smith - {Month Year}

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

-- get the script's name and directory
local scriptName = ({r.get_action_context()})[2]:match("([^/\\_]+)%.lua$")
local scriptDirectory = ({r.get_action_context()})[2]:sub(1, ({r.get_action_context()})[2]:find("\\[^\\]*$"))
local scriptFolder = scriptDirectory:gsub(scriptName..".lua", "")

package.path = scriptFolder .. '?.lua'

-- Require the osc module
local osc = require('osc')

-- =========================================================
-- ======================  FUNCTIONS  ======================
-- =========================================================


-- =========================================================
-- ======================  UTILITIES  ======================
-- =========================================================

-- Deliver messages and add new line in console
function dbg(dbg)
  r.ShowConsoleMsg(tostring(dbg) .. "\n")
end

-- Deliver messages using message box
function msg(msg, title)
  local title = title or scriptName
  r.MB(tostring(msg), title, 0)
end


-- =========================================================
-- ===================  MAIN ROUTINE  ======================
-- =========================================================

r.Undo_BeginBlock()

-- get OSC message
local msg = osc.get()


local newName = msg.arg


dbg("didn't work")

r.Undo_EndBlock(scriptName, -1)