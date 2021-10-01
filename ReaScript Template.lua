--[[
  @description
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.0
  @changelog
    + Initial version
  @provides . > bsmith96_{filename.lua}
  @about
    # {Package name}
    Written by Ben Smith - {Month Year}

    ### Info
    *

    ### Usage
    * 

    ### User customisation
    *
]]


-- =========================================================
-- ===============  USER CUSTOMISATION AREA  ===============
-- =========================================================

--------- End of user customisation area --


-- ===========================================
-- ===============  FUNCTIONS  ===============
-- ===========================================


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



reaper.Undo_EndBlock(scriptName, 0)