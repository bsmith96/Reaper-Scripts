-- Create marker --------------------------
-- Author: Ben Smith ----------------------
-- Easily create a marker during playback or recording with a midi trigger.

-- Define function

function createMarker()

  markerTime = reaper.GetPlayPositionEx(0)
  
  reaper.Undo_BeginBlock()
  
    reaper.AddProjectMarker(0,false,markerTime,0,"",-1)
  
  reaper.Undo_EndBlock("Add marker", -1)
  
end

-- Run script

createMarker()
