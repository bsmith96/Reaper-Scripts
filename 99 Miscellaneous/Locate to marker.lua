-- @description Locate to marker
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @about Locate to a marker ID via OSC. (default /marker only uses the order of markers, not the number assigned to them)

-- Trigger this script via OSC (either custom or /action) and include a value afterwards. This value should be the marker number you wish to locate to divided by 1000. e.g. marker 21 is 0.021

-- The reaper.get_action_context() command returns the value of an OSC message as if it were between 0 and 1, with a resolution of 16383.


-- Run Script -----------------------------

-- Get the value of the OSC command which triggered this script
is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()

-- Convert the received value back to an integer
markerCue = val/16.383

-- If the conversions were not exact, round the result to the nearest integer
markerCue = math.floor(markerCue+0.5)

-- Go to marker with the decoded ID
reaper.GoToMarker(0, markerCue, false)
