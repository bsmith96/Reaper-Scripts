--[[
  @description Put selected tracks in a new folder
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.4
  @changelog
    # Added user identifier to provided file names
  @metapackage
  @provides
    [main] . > bsmith96_Put selected tracks in new folder track.lua
    [main] . > bsmith96_Put selected tracks in new folder track and ask for name.lua
  @about
    # Put selected tracks in a new folder
    Written by Ben Smith - 2021

    ### Info
    * Indents the selected tracks and places a new folder track above them
    * Useful for organising large projects quickly.
    * 2 versions - Reaper can prompt you for a name for the new folder or leave it empty.
]]


-- ==================================================
-- ===============  GLOBAL VARIABLES  ===============
-- ==================================================

-- get the script's name and directory
local scriptName = ({reaper.get_action_context()})[2]:match("([^/\\_]+)%.lua$")
local scriptDirectory = ({reaper.get_action_context()})[2]:sub(1, ({reaper.get_action_context()})[2]:find("\\[^\\]*$"))


-- ==============================================
-- ===============  MAIN ROUTINE  ===============
-- ==============================================

reaper.Undo_BeginBlock()

  ---- Get the required information about the tracks

  -- Count selected tracks (relative to 0)
  selectedTrackCount = reaper.CountSelectedTracks(0)-1
  
  -- Create table for all selected tracks
  tracks = {}

  -- Get user data of selected tracks
  for i = 0, selectedTrackCount do
    track = reaper.GetSelectedTrack2(0, i,false)
    table.insert(tracks, reaper.CSurf_TrackToID(track, false))
  end

  -- Compute positions of required tracks
  insertPoint = tracks[1]-1
  firstTrack = tracks[1]
  lastTrack = tracks[#tracks]


  ---- Create the folder and indent the selection

  -- Insert track before the selected tracks (the folder)
  reaper.InsertTrackAtIndex(insertPoint, true)

  -- Convert back to mediatrack format
  firstTrack = reaper.CSurf_TrackFromID(firstTrack, false)
  lastTrack = reaper.CSurf_TrackFromID(lastTrack+1, false)

  -- Get current depth of selected tracks
  depthFirst = reaper.GetMediaTrackInfo_Value(firstTrack, "I_FOLDERDEPTH")
  depthLast = reaper.GetMediaTrackInfo_Value(lastTrack, "I_FOLDERDEPTH")

  -- Indent first track of selection by 1
  reaper.SetMediaTrackInfo_Value(firstTrack,"I_FOLDERDEPTH",depthFirst+1)

  -- Return track after selection to previous indent level
  reaper.SetMediaTrackInfo_Value(lastTrack, "I_FOLDERDEPTH", depthLast-1)


  ---- Name the folder

  if scriptName:find("ask for name") then
  
    -- Get user name for new folder
    retval, folderName_csv = reaper.GetUserInputs("New Folder Name", 1, "Folder name:", "")

    -- Convert new track ID into mediatrack
    newFolder = reaper.CSurf_TrackFromID(insertPoint+1, false)

    -- Name folder
    reaper.GetSetMediaTrackInfo_String(newFolder, "P_NAME", folderName_csv, 1)
    
    reaper.Undo_EndBlock("Put selected tracks in folder \""..folderName_csv.."\"", -1)
  else
    reaper.Undo_EndBlock("Put selected tracks in folder", -1)
  end
