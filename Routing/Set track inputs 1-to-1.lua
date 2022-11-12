--[[
  @description Set track inputs 1-to-1
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 2.3-b.2022.11.12
  @changelog
    # Fix bug when splitting stereo at the end of a folder
    # Cleanup script - changed `splitStereo:len()` to match other instances of `#splitStereo`
  @metapackage
  @provides
    [main] . > bsmith96_Set track inputs 1-to-1.lua
    [main] . > bsmith96_Set track inputs 1-to-1 for selected tracks.lua
    [main] . > bsmith96_Set track inputs 1-to-1 ignoring folders.lua
  @about
    # Set track inputs 1-to-1
    Written by Ben Smith - July 2021

    ### Info
    * Sets the track input channel sequentially, allowing you to set up projects with high track counts and quickly route the appropriate inputs to them.
    * This is ideal for recording live performances, such as concerts or theatre.

    ### Usage
    * All tracks are presumed mono.
    * To use stereo tracks, append the names with "--2". 
    * Stereo tracks MUST start on odd input.
    * If your stereo tracks start with an even input (i.e. even/odd pair) the script will create *split stereo* tracks, a mono left and a mono right.

    ### User customisation
    * stereoSuffix: "--2"
      * Allows you to customise the naming convention for indicating stereo tracks to the script.
    * stereoSplitSuffix: [".L", ".R"]
      * Customise how stereo tracks which are split to mono are renamed. e.g. "Left", ".L"

    ### Metapackage
    * Set track inputs 1-to-1
      * Sets every track input to the track number
    * Set track inputs 1-to-1 for selected tracks
      * Only affects selected tracks
    * Set track inputs 1-to-1 ignoring folders
      * Assumes folders are used simply for structure, and does not include these.
      * If track 1 is a folder and track 2 is not, track 2 will use input 1.
]]


-- =========================================================
-- ===============  USER CUSTOMISATION AREA  ===============
-- =========================================================

stereoSuffix = "--2" -- suffix appended to tracks to be given stereo inputs

stereoSplitSuffix = {".L", ".R"} -- appended automatically if stereo tracks have to be split into mono

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

function getDepth(track)
  trackDepth = r.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
  return trackDepth
end

function insertTrackAfter(prev)
  prevDepth = getDepth(prev) -- get depth of previous track
  if prevDepth >= 0 then -- if track is the first in a folder, or a normal track
    prevID = r.CSurf_TrackToID(prev, false)
    r.InsertTrackAtIndex(prevID, true)
    new = r.GetTrack(0, prevID)
    return new
  elseif prevDepth < 0 then -- if track is the last in a folder, or a number of folders
    prevID = r.CSurf_TrackToID(prev, false)
    r.InsertTrackAtIndex(prevID - 1, true) -- insert new track above selected
    -- move new track below previous track
    r.SetOnlyTrackSelected(prev)
    r.ReorderSelectedTracks(prevID - 1, 2)
    new = r.GetTrack(0, prevID)
    return new
  end
end

function splitStereo(track)
  -- insert new track after the offending track
  trackLeft = track
  trackRight = insertTrackAfter(track)
  -- get mono input numbers
  trackInputLeft = trackInput - 1024
  trackInputRight = trackInputLeft + 1
  -- set track inputs
  setInput(trackLeft, trackInputLeft)
  setInput(trackRight, trackInputRight)
  -- rename the tracks
  trackName = string.sub(trackName, 1, 0-(#stereoSuffix+1))
  r.GetSetMediaTrackInfo_String(trackLeft, "P_NAME", trackName..stereoSplitSuffix[1], true)
  r.GetSetMediaTrackInfo_String(trackRight, "P_NAME", trackName..stereoSplitSuffix[2], true)
  -- inform the user
  r.ShowMessageBox("Track "..trackName.." requires a stereo input from an even/odd pair of channels. This is not doable, so the script has split this stereo track into 2 mono tracks.", "Routing Mismatch - Track '"..trackName.."'", 0)
end

function checkChannelCount(track)

  -- if track name ends with "--2" interpret it as a stereo track
  _, trackName = r.GetSetMediaTrackInfo_String(track, "P_NAME", 0, false)
  if trackName:sub(-#stereoSuffix) == stereoSuffix then
    return "Stereo", trackName
  else
    return "Mono", trackName
  end
  
end

function setRouting(track, i)

  -- get the number of channels requested (stereo/mono)
  channelCount, trackName = checkChannelCount(track)

  trackInput = i-1+stereoOffset

  if channelCount == "Stereo" then -- if stereo, route appropriately

    trackInput = trackInput + 1024

    -- if a stereo input / track will work
    if (trackInput % 2 == 0) then
      -- set input
      setInput(track, trackInput)
      -- rename track (remove suffix)
      trackName = string.sub(trackName, 1, 0-(#stereoSuffix+1))
      r.GetSetMediaTrackInfo_String(track, "P_NAME", trackName, true)
      -- update stereoOffset
      stereoOffset = stereoOffset+1

    -- if a stereo input / track won't work: SPLIT STEREO
    else
      splitStereo(track)
      -- update trackOffset
      trackOffset = trackOffset+1
    end

  -- if the track is mono 
  else
    setInput(track, trackInput)
  end
  
end

function setInput(track, input)
  r.SetMediaTrackInfo_Value(track, "I_RECINPUT", input)
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

    stereoOffset = 0
    trackOffset = 0
    folderOffset = 0

    -- count tracks in the project
    trackCount = r.CountTracks(0)
    
    -- set input to be the same as track number
    for i = 1, trackCount, 1
    do
      trackNum = i+trackOffset -- trackOffset accounts for additional split-stereo tracks created by the script
      track = r.GetTrack(0, trackNum-1)
      if scriptName:find("selected tracks") then
        if r.IsTrackSelected(track) == true then
          r.SetMediaTrackInfo_Value(track, "I_RECINPUT", i-1)
        end
      elseif scriptName:find("ignoring folders") then
        trackDepth = r.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
        if trackDepth <= 0.0 then
          setRouting(track, trackNum-folderOffset)
        else
          folderOffset = folderOffset+1
        end
      else
        setRouting(track, trackNum)
      end
    end
    
r.Undo_EndBlock(scriptName, -1)
