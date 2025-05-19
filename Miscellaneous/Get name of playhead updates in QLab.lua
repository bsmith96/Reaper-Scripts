--[[
  @description Get name of cue from QLab
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
    # Get cue name from QLab
    Written by Ben Smith - May 2025

    ### Info
    * Using a custom OSC config, this allows you to get the name of the playhead in QLab.
    * This will actually be one cue out and really annoying, but should be a proof of concept.

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

-- debug
--local msg = osc.get()
--if msg then
--    reaper.ShowMessageBox("OSC address: " .. msg.address .. ", argument: " .. (msg.arg and msg.arg or "(nil)"), "Info", 0)
--else
--    reaper.ShowMessageBox("Invalid or no OSC message", "Error", 0)
--end


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

-- Create a marker at the current position, with the args of OSC message as the marker name
r.AddProjectMarker(0,0,r.GetPlayPosition(),0,msg.arg,-1)

-- Send OSC message to QLab to request the cue name from cue ID


r.Undo_EndBlock(scriptName, -1)