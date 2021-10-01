--[[
  @description Set tempo template
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.5
  @changelog
    # Added user identifier to provided file names
  @metapackage
  @provides
    [main] . > bsmith96_Set tempo.lua
  @about
    # Set tempo template
    Written by Ben Smith - September 2021

    ### Info
    * Designed for when using Reaper's built in LFO to control an autopanner, possibly in a live situation as an insert.
    * Edit this script with the tempo you want the autopanner to run at (for example, the tempo or your click track) and trigger it at the start of a bar.

    ### Usage
    * Use ReaSurround as an insert on an "autopanner" track.
      * This track should have its input (ideally mono) fed from a mix on your mixing desk, and should output to each of your 5.1 or 7.1 surround sends.
    * Click Param > FX parameter list > Parameter modulation/midi link
      * in 1 X
        * Enable parameter modulation = true
        * baseline value = far left
        * LFO = true
        * Shape = sine
        * Tempo sync = true
        * Speed = 2
        * Strength = 100
        * Phase = 0.25
        * Direction = positive
        * Phase reset = on seek/loop
      * in 1 Y
        * Enable parameter modulation = true
        * baseline value = far left
        * LFO = true
        * Shape = sine
        * Tempo sync = true
        * Speed = 2
        * Strength = 100
        * Phase = 0.5
        * Direction = positive
        * Phase reset = on seek/loop

    ### User customisation
    * userBPM
      * The user's tempo of choice
      * If you trigger the script with a custom OSC command, and send a number after it between 0 and 1, this value will be multiplied by 1000 and used as the BPM value.
    * rotationsPerBeat
      * How many rotations per beat.
      * i.e. in 4/4 time signature, if this value is `1/4` it will pass the centre at the start of every bar.
]]


-- =========================================================
-- ===============  USER CUSTOMISATION AREA  ===============
-- =========================================================

userBPM = 120

rotationsPerBeat = 1/8

--------- End of user customisation area --


-- =================================================
-- ===============  GLOBAL VARIABLES ===============
-- =================================================

-- get the script's name and directory
local scriptName = ({reaper.get_action_context()})[2]:match("([^/\\_]+)%.lua$")
local scriptDirectory = ({reaper.get_action_context()})[2]:sub(1, ({reaper.get_action_context()})[2]:find("\\[^\\]*$"))


-- ==============================================
-- ===============  MAIN ROUTINE  ===============
-- ==============================================

reaper.Undo_BeginBlock()

  -- Get the value of the OSC command which triggered this script
  is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()

  -- Convert the received value back to an integer
  newTempo = val/16.383

  -- If the conversions were not exact, round the result to the nearest integer
  newTempo = math.floor(newTempo+0.5)

  if val == 0 then
    reaper.SetCurrentBPM(__proj, userBPM * rotationsPerBeat, true) -- set BPM to user variable
  else
    reaper.SetCurrentBPM(__proj, newTempo * rotationsPerBeat, true) -- set BPM to 1000 * OSC value
  end

  reaper.OnPlayButton() -- trigger the start of the autopanner immediately
  reaper.OnStopButton() -- but don't actually start the playhead running

reaper.Undo_EndBlock(scriptName, -1)