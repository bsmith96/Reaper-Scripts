--[[
  @description Set channel inputs 1-to-1
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.2
  @changelog
    # Changed stereo track mismatch handling - now creates a pair of mono tracks if a stereo input is not possible.
    # Improved semantics - difference between "track" and "channel" (within tracks) is now more clear.
  @about
    # Set channel inputs 1-to-1
    Written by Ben Smith - July 2021

    ### Info
    * Sets the track input channel sequentially, allowing you to set up projects with high channel counts and quickly route the appropriate inputs to them.
    * This is ideal for recording live performances, such as concerts or theatre.

    ### Usage
    * All tracks are presumed mono.
    * To use stereo tracks, append the names with "--2". 
    * Stereo tracks MUST start on odd input.
    * If your stereo tracks start with an even input (i.e. even/odd pair) the script will create *split stereo* tracks, a mono left and a mono right.

    ### User customisation
    * tracksToUse: all / selected.
      * Whether to route all tracks or only selected ones.
    * stereoSuffix: "--2"
      * Allows you to customise the naming convention for indicating stereo tracks to the script.
    * stereoSplitSuffix: [" - Left", " - Right"]
      * Customise how stereo channels which are split to mono are renamed. e.g. "Left", ".L"
]]


-- User customisation area ----------------

tracksToUse = "all" -- all or selected

stereoSuffix = "--2" -- suffix appended to tracks to be given stereo inputs

stereoSplitSuffix = {".L", ".R"} -- appended automatically if stereo tracks have to be split into mono

--------- End of user customisation area --


---- Functions

function checkChannelCount(track)

  -- if track name ends with " - 2" interpret it as a stereo channel
  retval, trackName = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", 0, false)
  stereoSuffixReversed = string.reverse(stereoSuffix)
  stereoSuffixReversed = stereoSuffixReversed..".*"
  if string.match(string.reverse(trackName), stereoSuffixReversed) then
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
      trackName = string.sub(trackName, 1, 0-(string.len(stereoSuffix)+1))
      reaper.GetSetMediaTrackInfo_String(track, "P_NAME", trackName, true)
      -- update stereoOffset
      stereoOffset = stereoOffset+1

    -- if a stereo input / track won't work
    else
      -- insert new track after the offending track
      trackID = reaper.CSurf_TrackToID(track, false)
      reaper.InsertTrackAtIndex(trackID, true)
      -- get mono input numbers
      trackInputLeft = trackInput - 1024
      trackInputRight = trackInputLeft + 1
      -- set tracks to variables
      trackLeft = track
      trackRight = reaper.CSurf_TrackFromID((reaper.CSurf_TrackToID(track, false)+1), false)
      -- set track inputs
      setInput(trackLeft, trackInputLeft)
      setInput(trackRight, trackInputRight)
      -- rename the tracks
      trackName = string.sub(trackName, 1, 0-(string.len(stereoSuffix)+1))
      reaper.GetSetMediaTrackInfo_String(trackLeft, "P_NAME", trackName..stereoSplitSuffix[1], true)
      reaper.GetSetMediaTrackInfo_String(trackRight, "P_NAME", trackName..stereoSplitSuffix[2], true)
      -- inform the user
      reaper.ShowMessageBox("Track "..trackName.." requires a stereo input from an even/odd pair of channels. This is not doable, so the script has split this stereo track into 2 mono tracks.", "Routing mismatch", 0)
      -- update trackOffset
      trackOffset = trackOffset+1
    end

  -- if the channel is mono 
  else
    setInput(track, trackInput)
  end
  
end

function setInput(track, input)
  reaper.SetMediaTrackInfo_Value(track, "I_RECINPUT", input)
end


-- Run script -----------------------------

reaper.Undo_BeginBlock()

    stereoOffset = 0
    trackOffset = 0

    -- count tracks in the project
    trackCount = reaper.CountTracks(0)
    
    -- set input to be the same as track number
    for i = 1, trackCount, 1
    do
      trackNum = i+trackOffset -- trackOffset accounts for additional split-stereo tracks created by the script
      track = reaper.GetTrack(0, trackNum-1)
      if tracksToUse == "all" then
        setRouting(track, trackNum)
      elseif tracksToUse == "selected" then
        if reaper.IsTrackSelected(track) == true then
          reaper.SetMediaTrackInfo_Value(track, "I_RECINPUT", i-1)
        end
      end
    end
    
reaper.Undo_EndBlock("Route channel inputs 1-to-1", 0)
