-- Create and name marker -----------------
-- Author: Ben Smith ----------------------
-- Useful to create a new marker when recording. Can be easily called by a midi trigger and can have a default marker name, or can prompt the user to enter one.

-- Variables
markerName_csv = "" -- To use this script to automatically create a specific marker, add the name here
markerTime = reaper.GetPlayPositionEx(0)


if markerName_csv == "" then
  markerName, markerName_csv = reaper.GetUserInputs("Marker Name", 1, "Name,separator,extrawidth=100", "")
end

-- To use this script to automatically set a specific name, 

-- Define function

function createMarker(name)

  if name ~= "" then

    reaper.Undo_BeginBlock()

      reaper.AddProjectMarker(0, false, markerTime, 0, name, -1)

    reaper.Undo_EndBlock(("Add marker \""..name.."\""), -1)
  
  end

end

-- Run script

createMarker(markerName_csv)
