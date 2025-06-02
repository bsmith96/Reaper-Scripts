--[[
  @description Create marker with name via OSC
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.1
  @changelog
    + Correct provided filename
  @metapackage
  @provides
    [main] . > bsmith96_Create marker with name via OSC.lua
    qosc.lua
    Qlab5.ReaperOSC
  @about
    # Create marker with name via OSC
    Written by Ben Smith - June 2025

    ### Info
    * REQUIRES "osc.lua" IN THE SAME PATH
    * Intended for integration between Reaper and QLab, allowing markers when cues are fired when Multitrack Recording a live show

    ### Usage
    * Create a custom OSC shortcut for this script (in the actions menu)
    * Send this OSC trigger with a string as the first argument. This string will become the name of the marker.
    * For QLab integration: 
      * Reaper Preferences > Control/OSC/Web
      * Add a new device
        * Device name: QLab
        * Configure device IP+local port
        * Device Port: 53000
        * Device IP: QLAB IP ADDRESS
        * Local listen port: 53001
        * Local IP: current IP address
        * Allow binding messages to REAPER actions and FX learn: TRUE
        * Pattern config: open config directory
          * Copy the provided file "Qlab5.ReaperOSC" into this directory
        * Pattern config: refresh list, then choose Qlab5
        * Check your QLab settings - you need to ensure Network > OSC Access > No passcode has "view" access
      * Now, Reaper should send a message to QLab whenever you start reaper playback, "/listen/go/name", which asks Reaper to send the cue name whenever "go" is fired.
      * In the actions menu, find this script.
        * Press play on reaper
        * Press "go" on any cue in Qlab
        * This should set the custom shortcut for the action to "/qlab/event/workspace/go/name"

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
local osc = require('qosc')

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