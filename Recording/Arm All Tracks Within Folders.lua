--[[
  @description Arm all tracks within folders
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.1
  @changelog
    # Updated commenting to make the script easier to navigate
  @about
    # Arm all tracks within folders
    Written by Ben Smith - 2021

    ### Info
    * Automatically toggles record arming for all tracks, but ignores folders used for organising your session
]]


-- ==============================================
-- ===============  MAIN ROUTINE  ===============
-- ==============================================

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

