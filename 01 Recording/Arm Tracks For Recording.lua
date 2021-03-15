-- @description Arm tracks for recording
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.1
-- @about Useful when you are regularly arming and disarming the same group of tracks, but do not want to arm every track in the project (e.g. recording a multitrack performance, and you have groups or folders).

-- @changelog
--   v1.1  + replaced trackToArm(track) function with tracksToArm({tracks})
--   v1.0  + init


-- User customisation area ----------------

tracksToArm = {}
rangeToArm = {} -- list only the first and last track number in the range

--------- End of user customisation area --


---- Functions

-- Toggle record arm on a specific track

function armTrack(track)
	track = reaper.GetTrack(0,track-1)
	reaper.CSurf_OnRecArmChange(track, -1)
end


-- Toggle record arm on a range of tracks

function armRange(firstTrack, lastTrack)
	if firstTrack ~= lastTrack then
		for i = lastTrack, firstTrack, -1
		do  
			track = reaper.GetTrack(0,i-1)
			reaper.CSurf_OnRecArmChange(track, -1)
		end
	end
end


-- Toggle record arm on a set of specific tracks

function armTracks(arrayToArm)
	armTrackSize = #arrayToArm
	for i = armTrackSize, 1, -1
	do
		trackNum = arrayToArm[i]
		track = reaper.GetTrack(0, trackNum-1)
		reaper.CSurf_OnRecArmChange(track, -1)
	end
end


-- Run Script -----------------------------

if tracksToArm ~= {} then
	armTracks(tracksToArm)
end

armRangeSize = #rangeToArm
armRangeFirst = rangeToArm[1]
armRangeLast = rangeToArm[armRangeSize]

armRange(armRangeFirst, armRangeLast)
	
