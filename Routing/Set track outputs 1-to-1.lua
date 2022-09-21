--[[
  @description Set track outputs 1-to-1
  @author Ben Smith
  @link    
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 2.3
  @changelog
    # Routes the master to alternative outputs (default to the last stereo pair, can be edited in the script) unless these are taken up by channels.
  @metapackage
  @provides
    [main] . > bsmith96_Set track outputs 1-to-1.lua
    [main] . > bsmith96_Set track outputs 1-to-1 for selected tracks.lua
    [main] . > bsmith96_Set track outputs 1-to-1 ignoring folders.lua
  @about
    # Set track outputs 1-to-1
    Written by Ben Smith - 2021

    ### Info
    * Routes tracks to the same output as their input, allowing quick routing for Virtual Sound Checks in live situations.
    * Also routes the master to alternative outputs: by default, the last stereo pair of the audio device (unless taken up by 1-to-1 channel routing), but can be customised by editing the _User Customisation Area_ in the script

    ### Metapackage
    * Set track outputs 1-to-1
      * Sets the output of every track to be the same as the input routing
    * Set track outputs 1-to-1 for selected tracks
      * Sets the output of selected tracks to match input routing
    * Set track outputs 1-to-1 ignoring folders
      * Unroutes folders from the main output, but does not route them to a any output. Assumes they are used for structure.
]]


-- =========================================================
-- ===============  USER CUSTOMISATION AREA  ===============
-- =========================================================

masterOutputChannelOption = "last" -- options: "first", "last" (both a stereo pair at the start or end of the audio device), or a number, which is the first of a stereo pair

--------- End of user customisation area --


-- ==================================================
-- ===============  GLOBAL VARIABLES  ===============
-- ==================================================

local r = reaper

-- get the script's name and directory
local scriptName = ({r.get_action_context()})[2]:match("([^/\\_]+)%.lua$")
local scriptDirectory = ({r.get_action_context()})[2]:sub(1, ({r.get_action_context()})[2]:find("\\[^\\]*$"))


-- ===========================================
-- ===============  FUNCTIONS  ===============
-- ===========================================

function setRouting(track)
  -- get number of the track's rec input
  trackInput = r.GetMediaTrackInfo_Value(track, "I_RECINPUT")

  -- turn off routing to master
  r.SetMediaTrackInfo_Value(track, "B_MAINSEND", 0)

  -- turn off all sends
  trackSends = r.GetTrackNumSends(track, 1)
  for j = trackSends, 1, -1
  do
    r.RemoveTrackSend(track, 1, 0)
  end

  -- turn on routing to output number trackInput for mono inputs
  if trackInput < 1024 then
    trackSend = trackInput+1024
    r.CreateTrackSend(track, "")
    r.SetTrackSendInfo_Value(track, 1, 0, "I_DSTCHAN", trackSend)
  end

  -- turn on touring to output number trackInput for stereo inputs
  if trackInput >= 1024 then
    trackSend = trackInput-1024
    r.CreateTrackSend(track, "")
    r.SetTrackSendInfo_Value(track, 1, 0,"I_DSTCHAN", trackSend)
  end
end

function setMaster(opt)
  -- get master track
  masterTrack = r.GetMasterTrack(0)

  -- get current send/s
  masterTrackSends = r.GetTrackNumSends(masterTrack, 1)

  -- remove existing send/s
  for k = masterTrackSends, 1, -1
  do
    r.RemoveTrackSend(masterTrack, 1, 0)
  end

  -- get information about audio device
  if opt == "last" then
    outputCount = r.GetNumAudioOutputs()
    outputValue = outputCount - 2
  elseif opt == "first" then
    outputValue = 0
  elseif tonumber(opt) ~= nil then
    outputValue = opt-1
  else
    msg("Error, please check script", "ERROR")
  end

  -- check the "master" doesn't clash with the last track
  lastTrackID = r.CountTracks(0) - 1
  lastTrack = r.GetTrack(0, lastTrackID)
  lastTrackSend = r.GetTrackSendInfo_Value(lastTrack, 1, 0, "I_DSTCHAN")
  if lastTrackSend >= 1024 then
    lastTrackSend = lastTrackSend - 1023
  end
  if lastTrackSend < outputValue then
    r.CreateTrackSend(masterTrack, "")
    r.SetTrackSendInfo_Value(masterTrack, 1, 0, "I_DSTCHAN", outputValue)
  else
    msg("There was not space to route the master, so it has been unrouted", "Notification")
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

r.Undo_BeginBlock()

  -- count tracks in the project
  trackCount = r.CountTracks(0)

  -- set track output to the same number as track input

  for i = trackCount, 1, -1
  do
    track = r.GetTrack(0, i-1)
    if scriptName:find("ignoring folders") then
      trackDepth = r.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
      if trackDepth <= 0.0 then
        setRouting(track)
      else
        r.SetMediaTrackInfo_Value(track, "B_MAINSEND", 0)
      end
    elseif scriptName:find("selected tracks") then
      if r.IsTrackSelected(track) == true then
        setRouting(track)
      end
    else
      setRouting(track)
    end
  end

  setMaster(masterOutputChannelOption)

r.Undo_EndBlock(scriptName, -1)
