-- Arm tracks for recording ---------------
-- Author: Ben Smith ----------------------
-- Useful when you are regularly arming and disarming the same group of tracks, but do not want to arm every track in the project (e.g. recording a multitrack performance, and you have groups or folders).


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

-- WIP: Alternative section for individual tracks as an array
--[[
tracksToArm = {1,6,8}

armTrackSize = #tracksToArm
for i = armTrackSize, 1, -1
do
	trackNum = tracksToArm[i]
	track = reaper.GetTrack(0,trackNum-1)
	reaper.CSurf_OnRecArmChange(track, -1)
end
--]]
