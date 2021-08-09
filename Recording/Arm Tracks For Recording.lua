--[[
	@description Arm tracks for recording
	@author Ben Smith
	@link
		Author     https://www.bensmithsound.uk
		Repository https://github.com/bsmith96/Reaper-Scripts
	@version 1.2
	@changelog
		# Updated commenting to make the script easier to navigate
	@about
		# Arm tracks for recording
		Written by Ben Smith - 2021

		### Info
		* Arm a specific set of tracks for recording – customise a version of this script for use with your project.
		* Useful when you are regularly arming and disarming the same group of tracks, but do not want to arm every track in the project (e.g. recording a multitrack performance, and you have groups or folders).
		* "Arm all tracks within folders" is more useful, if that is what you need this for.

		### User customisation
		* tracksToArm
			* A list of all tracks you wish to toggle.
		* rangeToArm
			* A range of tracks which should all be toggled.
]]


-- =========================================================
-- ===============  USER CUSTOMISATION AREA  ===============
-- =========================================================

tracksToArm = {}
rangeToArm = {} -- list only the first and last track number in the range

--------- End of user customisation area --


-- ===========================================
-- ===============  FUNCTIONS  ===============
-- ===========================================

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


-- ==============================================
-- ===============  MAIN ROUTINE  ===============
-- ==============================================

if tracksToArm ~= {} then
	armTracks(tracksToArm)
end

armRangeSize = #rangeToArm
armRangeFirst = rangeToArm[1]
armRangeLast = rangeToArm[armRangeSize]

armRange(armRangeFirst, armRangeLast)
	
