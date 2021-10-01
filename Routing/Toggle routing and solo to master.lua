--[[
  @description Toggle routing and solo to master
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.2
  @changelog
    # Fix undo block
  @about
    # Toggle routing and solo to master
    Written by Ben Smith - 2021

    ### Info
    * Routes the selected track/s to the master and solos them.
    * Quickly listen to a bus recording while your reaper is routed for Virtual Sound Checks.
]]


-- ==============================================
-- ===============  MAIN ROUTINE  ===============
-- ==============================================

-- count selected tracks
selectedCount = reaper.CountSelectedTracks(0)

-- create a table for selected tracks
tracks = {}

-- get selected tracks
for i = selectedCount, 0, -1
do
  track = reaper.GetSelectedTrack2(0, i, false)
  table.insert(tracks,track)
end

reaper.Undo_BeginBlock()

  -- toggle master routing + solo
  for _, eachTrack in ipairs(tracks) do
    -- toggle both based on the current state of the master send
    if reaper.GetMediaTrackInfo_Value(eachTrack, "B_MAINSEND") == 1 then
      reaper.SetMediaTrackInfo_Value(eachTrack, "B_MAINSEND", 0)
      reaper.SetMediaTrackInfo_Value(eachTrack, "I_SOLO", 0)
    else
      reaper.SetMediaTrackInfo_Value(eachTrack, "B_MAINSEND", 1)
      reaper.SetMediaTrackInfo_Value(eachTrack, "I_SOLO", 1)
    end
  end

reaper.Undo_EndBlock("Route tracks to master", -1)