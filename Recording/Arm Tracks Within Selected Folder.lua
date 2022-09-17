--[[
  @description Arm tracks within selected folder
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 2.1
  @changelog
    # Bug fix when one track is the end of multiple nested folders
  @metapackage
  @provides
    [main] . > bsmith96_Rec arm tracks within selected folder.lua
    [main] . > bsmith96_Rec disarm tracks within selected folder.lua
    [main] . > bsmith96_Rec toggle tracks within selected folder.lua
  @about
    # Arm Tracks Within Selected Folder
    Written by Ben Smith - November 2021 - Updated September 2022

    ### Info
    * Run this script with a folder track selected to arm all tracks within that folder, which are not folders themselves.
    * Run this script with a child track selected to arm all peers within the parent folder.
    * Run this script with a top level track, or no track, selected to arm all tracks within folders.

    ### Usage
    * Run this script (e.g. by keyboard shortcut) when a folder track is selected, a child track is selected, or without any tracks selected, as a shortcut to arming different sections of a template.
    * This could be useful for e.g. recording only a band, and ignoring vocal mics.
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

function getDepth(track)
  track = r.GetTrack(0, trackID-1)
  trackDepth = r.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
  return trackDepth
end

function toggleArm(j)
  track = r.GetTrack(0, j-1)
  trackDepth = r.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
  if trackDepth <= 0.0 then
    if scriptName:find("toggle") then
      r.CSurf_OnRecArmChange(track, -1)
    elseif scriptName:find("disarm") then
      r.CSurf_OnRecArmChange(track, 0)
    elseif scriptName:find("Rec arm") then
      r.CSurf_OnRecArmChange(track, 1)
    else
      r.CSurf_OnRecArmChange(track, -1)
    end
  end
  return trackDepth
end


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

-- Count tracks in project
trackCount = r.CountTracks(0)

-- Get selected track
selectedTrack = r.GetSelectedTrack2(0, 0, false)

-- Check if selected track is a folder
if selectedTrack ~= nil then
  selectedTrackDepth = r.GetMediaTrackInfo_Value(selectedTrack, "I_FOLDERDEPTH")
  if selectedTrackDepth <=0 then
    selectedTrack = r.GetParentTrack(selectedTrack) -- if available, use the parent track as the folder. If there is no parent (i.e. top level), it will be set to "nil" and the script will run as if no track is selected.
  end
end

if selectedTrack == nil then -- arm all tracks within folders
  for i = trackCount, 1, -1
  do
    toggleArm(i)
  end
else -- arm tracks wtihin the selected or parent folder, including all tracks wtihin folders if there is no parent
  -- Get track ID
  trackID = r.CSurf_TrackToID(selectedTrack, false)

  -- Set initial variable value
  totalDepth = 1

  for i = trackID+1, trackCount, 1
  do
    toggleArm(i)
    totalDepth = totalDepth + trackDepth
    if totalDepth <= 0 then
      return
    end
  end
end

r.Undo_EndBlock(scriptName, -1)