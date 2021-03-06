-- Put selected tracks in a new folder ----
-- Author: Ben Smith ----------------------
-- Indents the selected tracks into a newly created folder track

-- User customisation area ----------------

askForName = true

--------- End of user customisation area --

reaper.Undo_BeginBlock()
  ---- Get the required information about the tracks

  -- Count selected tracks (relative to 0)
  selectedTrackCount = reaper.CountSelectedTracks(0)-1
  
  -- Create table for all selected tracks
  tracks = {}

  -- Get user data of last of selected tracks
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

  -- Select final track of selection
  reaper.SetOnlyTrackSelected(lastTrack, 1)

  -- Return track after selection to previous indent level
  reaper.SetMediaTrackInfo_Value(lastTrack, "I_FOLDERDEPTH", depthLast-1)

  if askForName == true then
    ---- Name the folder [optional]
  
    -- Get user name for new folder [optional]
    retval, folderName_csv = reaper.GetUserInputs("New Folder Name", 1, "Folder name:", "")

    -- Convert new track ID into mediatrack [optional]
    newFolder = reaper.CSurf_TrackFromID(insertPoint+1, false)

    -- Name folder [optional]
    reaper.GetSetMediaTrackInfo_String(newFolder, "P_NAME", folderName_csv, 1)
    
    reaper.Undo_EndBlock("Put selected tracks in folder \""..folderName_csv.."\"", 0)
  else
    reaper.Undo_EndBlock("Put selected tracks in folder", 0)
  end
