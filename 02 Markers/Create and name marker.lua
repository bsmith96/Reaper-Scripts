-- @description Create and name marker
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @about Useful to create a new marker when recording. Can be easily called by a midi trigger and can have a default marker name, or can prompt the user to enter one.


-- User customisation area ----------------

markerName_csv = "" -- Add the name here

--------- End of user customisation area --


-- Define marker time

markerTime = reaper.GetPlayPositionEx(0)


---- Functions

function createMarker(name)
  if name ~= "" then
    reaper.Undo_BeginBlock()
      reaper.AddProjectMarker(0, false, markerTime, 0, name, -1)
    reaper.Undo_EndBlock(("Add marker \""..name.."\""), -1)
  end
end


-- Run script -----------------------------

-- Get marker name through user input if no name is provided in the script

if markerName_csv == "" then
  markerName, markerName_csv = reaper.GetUserInputs("Marker Name", 1, "Name,separator,extrawidth=100", "")
end

-- Create marker

createMarker(markerName_csv)
