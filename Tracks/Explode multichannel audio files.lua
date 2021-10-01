--[[
  @description Explode multichannel audio files non-destructively
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.4
  @changelog
    # Added user identifier to provided file names
  @metapackage
  @provides
    [main] . > bsmith96_Explode multichannel audio files into folder.lua
    [main] . > bsmith96_Explode multichannel audio files into new tracks.lua
    [main] . > bsmith96_Explode multichannel audio files into existing tracks.lua
  @about
    # Explode multichannel audio files non-destructively
    Written by Ben Smith - August 2021

    ### Info
    * Quickly explode multichannel audio files into individual tracks.
    * Allows you to either explode a single track into x tracks, or to leave the selected track in place as a folder and place the individual stems inside it.

    ### Usage
    * Explodes the selected multichannel audio file onto
      * A new set of tracks below the current one, muting the original file.
      * The existing tracks below the current one, muting the original file (e.g. if you have multiple recordings with the same channels).
      * A new set of tracks in a folder of the current one, muting the original file.
]]


-- ===========================================
-- ===============  FUNCTIONS  ===============
-- ===========================================

function copyPasteItem(oldTrack, oldItem, newTrack)
  reaper.SetOnlyTrackSelected(oldTrack)
  reaper.Main_OnCommand(40289, 0) -- Unselect all media items
  reaper.SetMediaItemSelected(oldItem, 1)
  reaper.Main_OnCommand(41173, 0) -- Move cursor at item start
  reaper.Main_OnCommand(40698, 0) -- Copy the item
  reaper.SetOnlyTrackSelected(newTrack)
  reaper.Main_OnCommand(40914, 0) -- Set selected track as last touched
  newItem = reaper.Main_OnCommand(40058, 0) -- Paste item

  -- get new item
  return reaper.GetSelectedMediaItem( newItem, 0 )
end

function nameTrack(originalTrack, track, i)
  _, originalName = reaper.GetSetMediaTrackInfo_String(originalTrack, "P_NAME", "string", 0)

  reaper.GetSetMediaTrackInfo_String(track, "P_NAME", (i+1).." - "..originalName, 1)
end


-- ==================================================
-- ===============  GLOBAL VARIABLES  ===============
-- ==================================================

-- get the script's name and directory
local scriptName = ({reaper.get_action_context()})[2]:match("([^/\\_]+)%.lua$")
local scriptDirectory = ({reaper.get_action_context()})[2]:sub(1, ({reaper.get_action_context()})[2]:find("\\[^\\]*$"))


-- ==============================================
-- ===============  MAIN ROUTINE  ===============
-- ==============================================

reaper.Undo_BeginBlock()

  -- get selected media item
  selectedItem = reaper.GetSelectedMediaItem(0, 0)

  -- get selected track
  selectedTrack = reaper.GetMediaItem_Track(selectedItem)
  selectedTrackID = reaper.CSurf_TrackToID(selectedTrack, 0)

  -- get selected take
  selectedTake = reaper.GetActiveTake(selectedItem)

  -- get PCM source
  selectedPCM = reaper.GetMediaItemTake_Source(selectedTake)

  -- get the number of channels
  channelCount = reaper.GetMediaSourceNumChannels(selectedPCM)


  for i=0, channelCount - 1 do
    if scriptName:find("into new tracks") then
      -- insert new track
      reaper.InsertTrackAtIndex( selectedTrackID + i, true )
      local newTrack = reaper.GetTrack( 0, selectedTrackID + i )

      -- copy/Paste item
      local newItem = copyPasteItem(selectedTrack, selectedItem, newTrack)

      -- set item channel
      reaper.SetMediaItemTakeInfo_Value( reaper.GetActiveTake( newItem ) , "I_CHANMODE", 3 + i)

      -- name track
      nameTrack(selectedTrack, newTrack, i)
    elseif scriptName:find("into existing tracks") then
      -- copy/paste item
      local newItem = copyPasteItem(selectedTrack, selectedItem, reaper.CSurf_TrackFromID(selectedTrackID + 1 + i, false))

      -- set item channel
      reaper.SetMediaItemTakeInfo_Value( reaper.GetActiveTake( newItem ) , "I_CHANMODE", 3 + i)
    elseif scriptName:find("into folder") then
      -- insert new track
      reaper.InsertTrackAtIndex( selectedTrackID + i, true )
      local newTrack = reaper.GetTrack( 0, selectedTrackID + i )

      -- put new track in a folder of the first track
      oldDepth = reaper.GetMediaTrackInfo_Value(selectedTrack, "I_FOLDERDEPTH") -- check original depth
      if i == 0 then
        reaper.SetMediaTrackInfo_Value(selectedTrack, "I_FOLDERDEPTH", 1) -- indents the first new track
      elseif i == (channelCount - 1) then
        reaper.SetMediaTrackInfo_Value(newTrack, "I_FOLDERDEPTH", - 1) -- ends the folder after the last new track
      end

      -- Copy/Paste item
      local newItem = copyPasteItem(selectedTrack, selectedItem, newTrack)

      -- Set item channel
      reaper.SetMediaItemTakeInfo_Value( reaper.GetActiveTake( newItem ) , "I_CHANMODE", 3 + i)

      -- name track
      nameTrack(selectedTrack, newTrack, i)
    end  

  end

  reaper.SetMediaItemInfo_Value(selectedItem, "B_MUTE", 1) -- mute the original file

reaper.Undo_EndBlock(scriptName, -1)