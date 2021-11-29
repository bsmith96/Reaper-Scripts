--[[
  @description Arm tracks within selected folder
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.0-beta1
  @changelog
    + Initial version
  @metapackage
  @provides
    [main] . > bsmith96_Rec arm tracks within selected folder.lua
    [main] . > bsmith96_Rec disarm tracks within selected folder.lua
    [main] . > bsmith96_Rec toggle tracks within selected folder.lua
  @about
    # Arm Tracks Within Selected Folder
    Written by Ben Smith - November 2021

    ### Info
    * If the selected tracks is a folder and contains other tracks, this script will arm those tracks
    * If any tracks within the selected track are also folders, the script will not record arm them

    ### Usage
    * Run this script (e.g. by keyboard shortcut) when a folder is selected.
    * This could be useful for e.g. recording only a band, and ignoring vocal mics.
]]


-- =========================================================
-- =================  GLOBAL VARIABLES  ====================
-- =========================================================

-- get the script's name and directory
local scriptName = ({reaper.get_action_context()})[2]:match("([^/\\_]+)%.lua$")
local scriptDirectory = ({reaper.get_action_context()})[2]:sub(1, ({reaper.get_action_context()})[2]:find("\\[^\\]*$"))


-- =========================================================
-- ======================  FUNCTIONS  ======================
-- =========================================================

function getDepth(track)
  track = reaper.GetTrack(0, trackID-1)
  trackDepth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
  return trackDepth
end


-- =========================================================
-- ======================  UTILITIES  ======================
-- =========================================================

-- deliver messages and add new line in console
function dbg(dbg)
  reaper.ShowConsoleMsg(dbg .. "\n")
end

-- deliver messages using message box
function msg(msg)
  reaper.MB(msg, scriptName, 0)
end


-- =========================================================
-- ===================  MAIN ROUTINE  ======================
-- =========================================================

reaper.Undo_BeginBlock()

-- Count tracks in project

trackCount = reaper.CountTracks(0)

-- Get selected track
selectedTrack = reaper.GetSelectedTrack2(0, 0, false)

-- Get track ID
trackID = reaper.CSurf_TrackToID(selectedTrack, false)

totalDepth = 1

for i = trackID+1, trackCount, 1
do
  track = reaper.GetTrack(0, i-1)
  trackDepth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
  if trackDepth <= 0.0 then
    if scriptName:find("toggle") then
      reaper.CSurf_OnRecArmChange(track, -1)
    elseif scriptName:find("disarm") then
      reaper.CSurf_OnRecArmChange(track, 0)
    elseif scriptName:find("arm") then
      reaper.CSurf_OnRecArmChange(track, 1)
    end
  end
  totalDepth = totalDepth + trackDepth
  -- dbg(totalDepth)
  if totalDepth == 0 then
    return
  end
end

reaper.Undo_EndBlock(scriptName, -1)