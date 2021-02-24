-- Arm tracks for recording ---------------
-- Author: Ben Smith ----------------------

numberOfTracks = reaper.CountTracks(0)


-- Toggle record arm on a specific track

function armTrack(track)
	track = reaper.GetTrack(0,track-1)
	reaper.CSurf_OnRecArmChange(track, -1)
end


-- Toggle record arm on a range of tracks

function armRange(firstTrack, lastTrack)
	for i = lastTrack, firstTrack, -1
	do  
		track = reaper.GetTrack(0,i-1)
		reaper.CSurf_OnRecArmChange(track, -1)
	end
end


-- Run Script -----------------------------
-- use the armTrack or armRange functions here to define which tracks you want to record onto. Use the track numbers as they appear on Reaper.

