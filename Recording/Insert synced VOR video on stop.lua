--[[
  @description Insert synced VOR video
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 0.1-b.2026.02.27
  @changelog
    + Initial beta
  @metapackage
  @provides
    [main] . > bsmith96_Insert synced VOR video.lua
  @about
    # Insert synced VOR video
    Written by Ben Smith - February 2026

    ### Info
    * Using the same macro to start and stop recording on both Reaper and Vor.
    * Ensure Vor saves these videos on a drive accessible over the network by the Reaper computer.
    * When stopped, insert the video, synced with the correct "start" point. 
    * TODO: record dummy track simultaneously with multitrack and replace?

    ### Usage
    * 

    ### User customisation
    *
]]


-- =========================================================
-- ===============  USER CUSTOMISATION AREA  ===============
-- =========================================================

vorTrack = 1 -- Track number on which to place video files
vorFolder = "default" -- Folder location where Vor videos are saved when Vor recordings are stopped
-- Defaults to project folder /vor

--------- End of user customisation area --


-- =========================================================
-- =================  GLOBAL VARIABLES  ====================
-- =========================================================

local r = reaper

-- get the script's name and directory
local scriptName = ({r.get_action_context()})[2]:match("([^/\\_]+)%.lua$")
local scriptDirectory = ({r.get_action_context()})[2]:sub(1, ({r.get_action_context()})[2]:find("\\[^\\]*$"))

-- get default vorFolder
if vorFolder == "default" then
  projectFolder = r.GetProjectPath()
  vorFolder = projectFolder .. "/vor"
end


-- =========================================================
-- ======================  FUNCTIONS  ======================
-- =========================================================

-- Get most recent video in folder
function getNewestFile(folder)
  dbg("-- getNewestFile -- function incomplete")
end

function getItemPosition(item)
  itemPosition = r.GetMediaItemInfo_Value(item, "D_POSITION", 0)
  dbg("Position of item: "..itemPosition)
end

-- Get start time of most recent recording in Reaper
function getReaperLastStartTime()
  dbg("-- getReaperLastStartTime -- function incomplete")
end

-- Insert file on specific track
function insertFileOnTrack(file, track, startTime)
  dbg("-- insertFileOnTrack -- function incomplete")
end


-- =========================================================
-- ======================  UTILITIES  ======================
-- =========================================================

-- Deliver messages and add new line in console
function dbg(dbg)
  r.ShowConsoleMsg(tostring(dbg) .. "\n")
end

-- Deliver messages using message box
function msg(msg, title)
  local title = title or scriptName
  r.MB(tostring(msg), title, 0)
end


-- =========================================================
-- ===================  MAIN ROUTINE  ======================
-- =========================================================

r.Undo_BeginBlock()

-- dbg vor folder
dbg("Vor folder: "..vorFolder)

-- dbg item position function
testItem = r.GetSelectedMediaItem(0,0)
getItemPosition(testItem)

-- Get selected item - i.e. last item recorded
selectedItem = r.GetSelectedMediaItem(0,0) -- apparently this is not efficient and an alternative should be used?

-- Set variable of start time of reaper's last recording
reaperItemStartTime = getItemPosition(selectedItem)

-- Set variable of most recently recorded Vor video file
newestVor = getNewestFile(vorFolder)

-- Insert file on vorTrack
insertFileOnTrack(newestVor, vorTrack, reaperItemStartTime)

r.Undo_EndBlock(scriptName, -1)