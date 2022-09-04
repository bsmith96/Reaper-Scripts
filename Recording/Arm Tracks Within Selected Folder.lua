--[[
  @description Arm tracks within selected folder
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 2.0-beta1
  @changelog
    # Improved functionality for different selections.
    + If no track is selected, arms all tracks within folders
    + If a child is selected, arms all peers
    + If a top level track is selected, arms all tracks within folders
    # If installed directly rather than via Reapack, toggles arm state of tracks
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

function toggleArm(j)
  track = reaper.GetTrack(0, j-1)
  trackDepth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
  if trackDepth <= 0.0 then
    if scriptName:find("toggle") then
      reaper.CSurf_OnRecArmChange(track, -1)
    elseif scriptName:find("disarm") then
      reaper.CSurf_OnRecArmChange(track, 0)
    elseif scriptName:find("Rec arm") then
      reaper.CSurf_OnRecArmChange(track, 1)
    else
      reaper.CSurf_OnRecArmChange(track, -1)
    end
  end
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

-- Check if selected track is a folder
if selectedTrack ~= nil then
  selectedTrackDepth = reaper.GetMediaTrackInfo_Value(selectedTrack, "I_FOLDERDEPTH")
  if selectedTrackDepth <=0 then
    selectedTrack = reaper.GetParentTrack(selectedTrack) -- if available, use the parent track as the folder. If there is no parent (i.e. top level), it will be set to "nil" and the script will run as if no track is selected.
  end
end

if selectedTrack == nil then -- arm all tracks within folders
  for i = trackCount, 1, -1
  do
    toggleArm(i)
  end
else -- arm tracks wtihin the selected or parent folder, including all tracks wtihin folders if there is no parent
  -- Get track ID
  trackID = reaper.CSurf_TrackToID(selectedTrack, false)

  -- Set initial variable value
  totalDepth = 1

  for i = trackID+1, trackCount, 1
  do
    toggleArm(i)
    totalDepth = totalDepth + trackDepth
    if totalDepth == 0 then
      return
    end
  end
end

reaper.Undo_EndBlock(scriptName, -1)