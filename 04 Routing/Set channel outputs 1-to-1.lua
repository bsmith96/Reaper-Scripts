-- @description Set channel outputs 1-to-1
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.1
-- @about Routes tracks to the same output as their input, allowing quick routing for Virtual Sound Checks in live situations.

-- @changelog
--   v1.1  + added the option of routing only selected tracks

-- User customisation area ----------------

ignoreFolders = true -- when true, ignores folder tracks in the project, but still unroutes them from the master. When false, folder tracks will also be routed.

tracksToUse = "all" -- set this to either "all" or "selected"

--------- End of user customisation area --


---- Functions

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


-- Run script -----------------------------

reaper.Undo_BeginBlock()

    -- count tracks in the project
    trackCount = reaper.CountTracks(0)

    -- set track output to the same number as track input

  if ignoreFolders == false then
    for i = trackCount, 1, -1
    do
      track = reaper.GetTrack(0, i-1)
      if tracksToUse == "all" then
        setRouting(track)
      elseif tracksToUse == "selected" then
        if reaper.IsTrackSelected(track) == true then
          setRouting(track)
        end
      end
    end
  elseif ignoreFolders == true then
    for i = trackCount, 1, -1
    do
      track = reaper.GetTrack(0, i-1)
      trackDepth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
      if trackDepth <= 0.0 then
        if tracksToUse == "all" then
          setRouting(track)
        elseif tracksToUse == "selected" then
          if reaper.IsTrackSelected(track) == true then
            setRouting(track)
          end
        end
      end
    end
  end

reaper.Undo_EndBlock("Route channel outputs 1-to-1", 0) -- ##doesn't seem to name the undo item correctly
