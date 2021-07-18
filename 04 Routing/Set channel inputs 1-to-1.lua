-- @description Set channel inputs 1-to-1
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @about Simply sets track input to the same audio input as its track number.


-- User customisation area ----------------

tracksToUse = "all" -- all or selected

--------- End of user customisation area --


-- Run script -----------------------------

reaper.Undo_BeginBlock()

    -- count tracks in the project
    trackCount = reaper.CountTracks(0)
    
    -- set input to be the same as track number
    for i = trackCount, 1, -1
    do
      track = reaper.GetTrack(0, i-1)
      if tracksToUse == "all" then
        reaper.SetMediaTrackInfo_Value(track, "I_RECINPUT", i-1)
      elseif tracksToUse == "selected" then
        if reaper.IsTrackSelected(track) == true then
          reaper.SetMediaTrackInfo_Value(track, "I_RECINPUT", i-1)
        end
      end
    end
    
    -- it would be great to make this work for stereo channels too. Maybe name stereo tracks " - 2"?

reaper.Undo_EndBlock("Route channel inputs 1-to-1", 0) -- ##doesn't seem to name the undo item correctly
