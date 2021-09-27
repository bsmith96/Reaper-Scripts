--[[
  @description Set tempo template
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.0
  @changelog
    + Translated from EEL, improved documentation
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
        * Speed = 2
        * Strength = 100
        * Phase = 0.5
        * Direction = positive
        * Phase reset = on seek/loop

    ### User customisation
    * userBPM
      * The user's tempo of choice
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

  reaper.SetCurrentBPM(__proj, userBPM * rotationsPerBeat, true) -- set BPM

  reaper.OnPlayButton() -- trigger the start of the autopanner immediately
  reaper.OnStopButton() -- but don't actually start the playhead running

reaper.Undo_EndBlock(scriptName, 0)