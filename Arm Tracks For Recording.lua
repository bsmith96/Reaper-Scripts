-- Arm tracks for recording ------------------

numberOfTracks = reaper.CountTracks(0)

-- Record arm all tracks except track 1 (e.g. a folder)
for i = numberOfTracks, 2, -1
do
	track = reaper.GetTrack(0,i-1)
	reaper.CSurf_OnRecArmChange(track, -1)
end
