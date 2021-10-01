--[[
  @description Arm all tracks within folders
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.4
  @changelog
    # Added user identifier to provided file names
  @metapackage
  @provides
    [main] . > bsmith96_Rec arm all tracks within folders.lua
    [main] . > bsmith96_Rec disarm tracks within folders.lua
    [main] . > bsmith96_Rec toggle tracks within folders.lua  
  @about
    # Arm all tracks within folders
    Written by Ben Smith - 2021

    ### Info
    * Automatically toggles record arming for all tracks, but ignores folders used for organising your session
]]


-- ==================================================
-- ===============  GLOBAL VARIABLES  ===============
-- ==================================================

-- get the script's name and directory
local scriptName = ({reaper.get_action_context()})[2]:match("([^/\\_]+)%.lua$")
local scriptDirectory = ({reaper.get_action_context()})[2]:sub(1, ({reaper.get_action_context()})[2]:find("\\[^\\]*$"))


-- ==============================================
-- ===============  MAIN ROUTINE  ===============
-- ==============================================

-- Count tracks in project

trackCount = reaper.CountTracks(0)

reaper.Undo_BeginBlock()

-- Toggle record arm state of tracks if they don't contain other tracks

for i = trackCount, 1, -1
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
end

reaper.Undo_EndBlock(scriptName, -1)

