--[[
  @description Set channel inputs 1-to-1
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.1
  @changelog
    + Can interpret stereo channels
    - Cannot currently handle stereo channels where tracksToUse is "selected"
  @about
    # Set channel inputs 1-to-1
    Written by Ben Smith - July 2021

    ### Info
    * Sets the track input channel sequentially, allowing you to set up projects with high channel counts and quickly route the appropriate inputs to them.
    * This is ideal for recording live performances, such as concerts or theatre.

    ### Usage
    * All tracks are presumed mono.
    * To use stereo tracks, append the names with "--2". Stereo tracks MUST start on odd input, and if one starts on an even input, the script will alert you and skip an input channel.

    ### User customisation
    * tracksToUse: all / selected.
      * Whether to route all tracks or only selected ones.
    * stereoSuffix: "--2"
      * Allows you to customise the naming convention for indicating stereo tracks to the script.
]]


-- User customisation area ----------------

tracksToUse = "all" -- all or selected

stereoSuffix = "--2" -- suffix appended to tracks to be given stereo inputs

--------- End of user customisation area --


---- Functions

function checkTrackCount(track)

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

  -- get the number of channels requested
  trackCount, trackName = checkTrackCount(track)
  
  trackInput = i-1
  if trackCount == "Stereo" then -- if stereo, a higher number
    trackInput = trackInput + 1024
    if (trackInput % 2 == 0) then
      stereoOffset = stereoOffset+1
    else
      trackInput = trackInput + 1
      stereoOffset = stereoOffset+2
      reaper.ShowMessageBox("Track "..trackName.." requires a stereo input from an even/odd pair of channels. This is not doable, so the script has skipped input channel "..tostring(trackInput-1024)..".", "Routing Mismatch", 0)
    end
    reaper.GetSetMediaTrackInfo_String(track, "P_NAME", string.sub(trackName, 1, 0-(string.len(stereoSuffix)+1)), true) -- renames the channel without the stereo marker
  end
  reaper.SetMediaTrackInfo_Value(track, "I_RECINPUT", trackInput)
  
end


-- Run script -----------------------------

reaper.Undo_BeginBlock()

    stereoOffset = 0

    -- count tracks in the project
    trackCount = reaper.CountTracks(0)
    
    -- set input to be the same as track number
    for i = 1, trackCount, 1
    do
      track = reaper.GetTrack(0, i-1)
      trackCount = checkTrackCount(track)
      if tracksToUse == "all" then -- avoid stereo channels on even/odd pairs. Skips one channel to ensure odd/even.
        setRouting(track, i+stereoOffset)
      elseif tracksToUse == "selected" then
        if reaper.IsTrackSelected(track) == true then
          reaper.SetMediaTrackInfo_Value(track, "I_RECINPUT", i-1)
        end
      end
    end
    
    -- it would be great to make this work for stereo channels too. Maybe name stereo tracks " - 2"?

reaper.Undo_EndBlock("Route channel inputs 1-to-1", 0) -- ##doesn't seem to name the undo item correctly
