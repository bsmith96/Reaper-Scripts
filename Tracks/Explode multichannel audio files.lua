--[[
  @description Explode multichannel audio files non-destructively
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.0.alpha1
  @changelog
    + Initial version
  @metapackage
  @provides
    [main] . > Explode multichannel audio files into folder.lua
    [main] . > Explode multichannel audio files.lua
  @about
    # Explode multichannel audio files non-destructively
    Written by Ben Smith - August 2021

    ### Info
    * Quickly explode multichannel audio files into individual tracks.
    * Allows you to either explode a single track into x tracks, or to leave the selected track in place as a folder and place the individual stems inside it.

    ### Usage
    * 

    ### User customisation
    *
]]


-- =========================================================
-- ===============  USER CUSTOMISATION AREA  ===============
-- =========================================================



--------- End of user customisation area --


-- ===========================================
-- ===============  FUNCTIONS  ===============
-- ===========================================


-- ==============================================
-- ===============  MAIN ROUTINE  ===============
-- ==============================================

-- get selected track
selectedTrack = reaper.GetSelectedTrack2(0, 0, false)
selectedTrackID = reaper.CSurf_TrackToID(selectedTrack, false)

-- get selected media item
selectedItem = reaper.GetSelectedMediaItem(0, 0)

-- get selected take
selectedTake = reaper.GetActiveTake(selectedItem)

-- get PCM source
selectedPCM = reaper.GetMediaItemTake_Source(selectedTake)

-- get the number of channels
channelCount = reaper.GetMediaSourceNumChannels(selectedPCM)


for i=0, channelCount - 1 do
  -- Insert new track
  reaper.InsertTrackAtIndex( selectedTrackID + i, true )
  local newTrack = reaper.GetTrack( 0, selectedTrackID + i )

  -- Copy/Paste item
  reaper.SetOnlyTrackSelected(selectedTrack)
  reaper.Main_OnCommand(40289, 0) -- Unselect all media items
  reaper.SetMediaItemSelected(selectedItem, 1)
  reaper.Main_OnCommand(41173, 0) -- Move cursor at item start
  reaper.Main_OnCommand(40698, 0) -- Copy the item
  reaper.SetOnlyTrackSelected(newTrack)
  reaper.Main_OnCommand(40914, 0) -- Set selected track as last touched
  reaper.Main_OnCommand(40058, 0) -- Paste item

  -- Set item channel
  local newItem = reaper.GetTrackMediaItem( newTrack, 0 )
  reaper.SetMediaItemTakeInfo_Value( reaper.GetActiveTake( newItem ) , "I_CHANMODE", 3 + i)

  --[[
    STILL TO DO IN THIS LOOP:

    * Name new tracks.
    * Differentiate between 2 versions:
      * For normal explode, delete the original
      * For explode into folder, indent the new tracks / outdent again at the end, and mute the original

    STILL TO DO GLOBALLY:

    * Undoblocks.
    * Make sure you can implement the 2 different versions of filename to do something different.
  ]]

end

reaper.SetMediaItemInfo_Value(selectedItem, "B_MUTE", 1)