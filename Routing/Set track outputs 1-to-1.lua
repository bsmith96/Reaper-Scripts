--[[
  @description Set track outputs 1-to-1
  @author Ben Smith
  @link    
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 2.1
  @changelog
    # Fix undo block
  @metapackage
  @provides
    [main] . > Set track outputs 1-to-1.lua
    [main] . > Set track outputs 1-to-1 for selected tracks.lua
    [main] . > Set track outputs 1-to-1 ignoring folders.lua
  @about
    # Set track outputs 1-to-1
    Written by Ben Smith - 2021

    ### Info
    * Routes tracks to the same output as their input, allowing quick routing for Virtual Sound Checks in live situations.

    ### Metapackage
    * Set track outputs 1-to-1
      * Sets the output of every track to be the same as the input routing
    * Set track outputs 1-to-1 for selected tracks
      * Sets the output of selected tracks to match input routing
    * Set track outputs 1-to-1 ignoring folders
      * Unroutes folders from the main output, but does not route them to a any output. Assumes they are used for structure.
]]


-- ==================================================
-- ===============  GLOBAL VARIABLES  ===============
-- ==================================================

-- get the script's name and directory
local scriptName = ({reaper.get_action_context()})[2]:match("([^/\\_]+)%.lua$")
local scriptDirectory = ({reaper.get_action_context()})[2]:sub(1, ({reaper.get_action_context()})[2]:find("\\[^\\]*$"))


-- ===========================================
-- ===============  FUNCTIONS  ===============
-- ===========================================

function setRouting(track)
  -- get number of the track's rec input
  trackInput = reaper.GetMediaTrackInfo_Value(track, "I_RECINPUT")

  -- turn off routing to master
  reaper.SetMediaTrackInfo_Value(track, "B_MAINSEND", 0)

  -- turn off all sends
  trackSends = reaper.GetTrackNumSends(track, 1)
  for j = trackSends, 1, -1
  do
    reaper.RemoveTrackSend(track, 1, 0)
  end

  -- turn on routing to output number trackInput for mono inputs
  if trackInput < 1024 then
    trackSend = trackInput+1024
    reaper.CreateTrackSend(track, "")
    reaper.SetTrackSendInfo_Value(track, 1, 0, "I_DSTCHAN", trackSend)
  end

  -- turn on touring to output number trackInput for stereo inputs
  if trackInput >= 1024 then
    trackSend = trackInput-1024
    reaper.CreateTrackSend(track, "")
    reaper.SetTrackSendInfo_Value(track, 1, 0,"I_DSTCHAN", trackSend)
  end
end


-- ==============================================
-- ===============  MAIN ROUTINE  ===============
-- ==============================================

reaper.Undo_BeginBlock()

  -- count tracks in the project
  trackCount = reaper.CountTracks(0)

  -- set track output to the same number as track input

  for i = trackCount, 1, -1
  do
    track = reaper.GetTrack(0, i-1)
    if scriptName:find("ignoring folders") then
      trackDepth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
      if trackDepth <= 0.0 then
        setRouting(track)
      else
        reaper.SetMediaTrackInfo_Value(track, "B_MAINSEND", 0)
      end
    elseif scriptName:find("selected tracks") then
      if reaper.IsTrackSelected(track) == true then
        setRouting(track)
      end
    else
      setRouting(track)
    end
  end

reaper.Undo_EndBlock(scriptName, -1)
