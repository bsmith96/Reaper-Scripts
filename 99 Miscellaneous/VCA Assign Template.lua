-- @description VCA assign template
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 2.0
-- @about Edit this script to assign tracks to VCA masters. Could be used on midi recalls, to recall 'scenes', fired by Figure 53 Qlab.

-- @changelog
--   v2.0  + Translated script to LUA
--   v1.0  + init, EEL script

-- User customisation area ----------------

inputs = 48 -- overall number of system inputs, before VCA tracks.
vcas = 8 -- overall number of VCA channels.

-- ENTER YOUR SCRIPT AT THE END -----------

--------- End of user customisation area --


---- Functions

function setVCA(track, VCA)
	tr = reaper.GetTrack(0, (track-1))
	expVCA = 2^(VCA-1)
	reaper.GetSetTrackGroupMembership(tr, "VOLUME_VCA_FOLLOW", expVCA, expVCA)
	reaper.SetMediaTrackInfo_Value(tr, "B_MUTE", 0)
end

function remVCA(track)
	tr = reaper.GetTrack(0, (track-1))
	reaper.SetMediaTrackInfo_Value(tr, "B_MUTE", 1)
	lastVCA = reaper.GetSetTrackGroupMembership(tr, "VOLUME_VCA_FOLLOW", 0, 0)
	reaper.GetSetTrackGroupMembership(tr, "VOLUME_VCA_FOLLOW", lastVCA, 0)
end

function nameVCA(VCA, name, color)
	tr = reaper.GetTrack(0, VCA+inputs-1)
	reaper.GetSetMediaTrackInfo_String(tr, "P_NAME", name, 1)
	reaper.SetTrackColor(tr, color*reaper.ColorToNative(255,86,36))
end

function resetVCA(inputs, vcas)
	a = 0
	for i = inputs, 1, -1
	do
		track = 1 + a
		remVCA(track)
		a = a+1
	end

	b = 0
	for i = vcas, 1, -1
	do
		vca = 1 + b
		nameVCA(vca, "", 0)
		b = b + 1
	end
end


-- Run Script -----------------------------

---- OPTIONS
	-- resetVCA(inputs, vcas) # resets all VCAs, mutes all inputs. Use these specific variables
	-- setVCA(track, VCA) # sets the track to the VCA
		-- e.g. setVCA(1, 1)
	-- remVCA(track) # removes the track from its current VCA
		-- e.g. remVCA(1)
	-- nameVCA(VCA, name, color) # names the VCA and sets its color to either black or colored
		-- e.g. nameVCA(1, "MEN", 1), nameVCA(2, "", 0)

resetVCA(inputs, vcas)
