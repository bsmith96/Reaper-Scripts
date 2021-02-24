

-- Count selected tracks (relative to 0)
selectedTrackCount = reaper.CountSelectedTracks(0)-1

-- Get user data of selected tracks
for i = 0, selectedTrackCount do
  track = reaper.GetSelectedTrack2(0, i,false)
end

-- Convert to ID of selected tracks (seems to return the bottom track
track = reaper.CSurf_TrackToID(track, false)

-- Compute the position above the first track that is selected
insertPoint = track-selectedTrackCount-1

-- Insert track before the selected tracks
reaper.InsertTrackAtIndex(insertPoint, true)

-- This has been achieved by making a macro with the same name, using SWS actions. Continue trying?



