--[[
  @description Toggle routing and solo to master
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.4
  @changelog
    # Bug fix: successfully routes tracks in folders to master by routing and soloing the folder too
  @metapackage
  @provides
    [main] . > bsmith96_Toggle routing and solo to master.lua
  @about
    # Toggle routing and solo to master
    Written by Ben Smith - 2021

    ### Info
    * Routes the selected track/s to the master and solos them.
    * Quickly listen to a bus recording while your reaper is routed for Virtual Sound Checks.
]]


-- =========================================================
-- =================  GLOBAL VARIABLES  ====================
-- =========================================================

local r = reaper

-- get the script's name and directory
local scriptName = ({r.get_action_context()})[2]:match("([^/\\_]+)%.lua$")
local scriptDirectory = ({r.get_action_context()})[2]:sub(1, ({r.get_action_context()})[2]:find("\\[^\\]*$"))


-- =========================================================
-- ======================  FUNCTIONS  ======================
-- =========================================================

function getParent(track)
  parents = {}

  parent = r.GetParentTrack(track)

  while( parent ~= nil )
  do
    table.insert(parents, parent)
    parent = r.GetParentTrack(parent)
  end
  return parents
end

function toggleRouteAndSolo(track)
  if r.GetMediaTrackInfo_Value(track, "B_MAINSEND") == 1 then
    r.SetMediaTrackInfo_Value(track, "B_MAINSEND", 0)
    r.SetMediaTrackInfo_Value(track, "I_SOLO", 0)
  else
    r.SetMediaTrackInfo_Value(track, "B_MAINSEND", 1)
    r.SetMediaTrackInfo_Value(track, "I_SOLO", 1)
  end
end


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


-- ==============================================
-- ===============  MAIN ROUTINE  ===============
-- ==============================================

-- count selected tracks
selectedCount = r.CountSelectedTracks(0)

-- create a table for selected tracks
tracks = {}

-- get selected tracks
for i = selectedCount, 0, -1
do
  track = r.GetSelectedTrack2(0, i, false)
  table.insert(tracks,track)
end

r.Undo_BeginBlock()
  -- toggle master routing + solo
  for _, eachTrack in ipairs(tracks) do
    eachParents = getParent(eachTrack)
    -- toggle based on the current state of the master send
    toggleRouteAndSolo(eachTrack)
    -- toggle all parent tracks
    if eachParents[1] ~= nil then
      for __, eachParent in ipairs(eachParents) do
        toggleRouteAndSolo(eachParent)
      end
    end
  end

r.Undo_EndBlock(scriptName, -1)