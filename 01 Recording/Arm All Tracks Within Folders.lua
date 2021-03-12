-- Arm all tracks within folders ----------
-- Author: Ben Smith ----------------------
-- Automatically arms all tracks, but ignores tracks that contain other tracks.

-- Count tracks in project

trackCount = reaper.CountTracks(0)

-- Toggle record arm state of tracks if they don't contain other tracks

for i = trackCount, 1, -1
do
  track = reaper.GetTrack(0, i-1)
  trackDepth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
  if trackDepth <= 0.0 then
    reaper.CSurf_OnRecArmChange(track, -1)
  end
end

