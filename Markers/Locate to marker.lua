--[[
  @description Locate to marker by OSC
  @author Ben Smith
  @link 
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.2
  @changelog
    # Updated documentation
  @about
    # Locate to marker ID via OSC
    Written by Ben Smith - July 2021

    ### Info
    * The default option for moving the Reaper's playhead to a particular marker only works with the order of markers.
    * This script allows you to specify a marker number (i.e. marker ID) to navigate to.

    ### Usage
    * Trigger this script via OSC. You will need to set a custom trigger.
      * Select a custom command to trigger the action. 
      * Go into the actions list, select the action, and next to the "shortcuts" list, click "add".
      * Send the command (this will ignore any value attached).
    * As an argument in your OSC command, include the marker ID you wish to locate to divided by 1000.
      * E.g. for marker 21, send `/reaper/marker_cue 0.021`.
    * This is because the reaper.get_action_context() command will only return the value of an OSC message if it is between 0 and 1.
    * The resolution of the interpreted value is 16383.
    * This script is intended to be used in conjuction with Figure 53's *QLab* software, and [this script](https://github.com/bsmith96/Qlab-Scripts/blob/master/Tech%20Rehearsals/Locate%20to%20Reaper%20Marker.applescript) within Qlab.
]]


-- ==============================================
-- ===============  MAIN ROUTINE  ===============
-- ==============================================

-- Get the value of the OSC command which triggered this script
is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()

-- Convert the received value back to an integer
markerCue = val/16.383

-- If the conversions were not exact, round the result to the nearest integer
markerCue = math.floor(markerCue+0.5)

-- Go to marker with the decoded ID
reaper.GoToMarker(0, markerCue, false)
