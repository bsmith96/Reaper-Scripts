--[[
  @description Locate to marker by OSC
  @author Ben Smith
  @link 
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.0
  @changelog
    + Initial version
  @about
    # Locate to marker ID via OSC
    Written by Ben Smith - July 2021

    ### Info
    * The default option for moving the Reaper's playhead to a particular marker only works with the order of markers.
    * This script allows you to specify a marker number (i.e. marker ID) to navigate to.

    ### Usage
    * Trigger this script via OSC (either a custom command, or /action).
    * As an argument in your OSC command, include the marker ID you wish to locate to divided by 1000.
      * E.g. for marker 21, send `/action/XXXXXX 0.021`.
    * This is because the reaper.get_action_context() command will only return the value of an OSC message if it is between 0 and 1.
    * The resolution of the interpreted value is 16383.
]]


-- Run Script -----------------------------

-- Get the value of the OSC command which triggered this script
is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()

-- Convert the received value back to an integer
markerCue = val/16.383

-- If the conversions were not exact, round the result to the nearest integer
markerCue = math.floor(markerCue+0.5)

-- Go to marker with the decoded ID
reaper.GoToMarker(0, markerCue, false)
