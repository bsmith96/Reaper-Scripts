--[[
  @description Lua Utilities
  @author Ben Smith
  @link
    Author     https://www.bensmithsound.uk
    Repository https://github.com/bsmith96/Reaper-Scripts
  @version 1.0
  @changelog
    + Initial version
  @metapackage
  @provides
    [main] . > bsmith96_Lua Utilities.lua
  @about
    # Lua Utilities
    Written by Ben Smith - September 2022

    ### Info
    * Utilities to call in Lua scripts
    * Inspired by, and some scripts adapted from, ACendan. 
]]

--[[
-- Load lua utilities
bsmith96_LuaUtils = reaper.GetResourcePath()..'/Scripts/BSmith96 Scripts/Development/bsmith96_Lua Utilities.lua'
bsmith96_LuaUtils_MinVersion = 1.0
if reaper.file_exists( bsmith96_LuaUtils ) then 
  dofile( bsmith96_LuaUtils )
  if not bsmith96 or bsmith96.version() < bsmith96_LuaUtils_MinVersion then
    bsmith96.msg('This script requires a newer version of BSmith96 Lua Utilities. Please run:\n\nExtensions > ReaPack > Synchronize Packages',"BSmith96 Lua Utilities");
    return
  end
else
  reaper.ShowConsoleMsg("This script requires BSmith96 Lua Utilities! Please install them here:\n\nExtensions > ReaPack > Browse Packages > 'BSmith96 Lua Utilities'\n\n")
  return
end
]]

bsmith96 = {}

function bsmith96.version()
  --local file = io.open((reaper.GetResourcePath()..'/Scripts/BSmith96 Scripts/Development/acendan_Lua Utilities.lua'):gsub('\\','/'),"r")
  local file = io.open(('/Users/Ben/Documents/Reaper-Scripts/Development/bsmith96_Lua Utilities.lua'):gsub('\\','/'), "r")
  local vers_header = "  @version "
  io.input(file)
  local t = 0
  for line in io.lines() do
    if line:find(vers_header) then
      t = line:gsub(vers_header,"")
      break
    end
  end
  io.close(file)
  return tonumber(t)
end

-- =========================================================
-- ===================  DEBUG & MESSAGES  ==================
-- =========================================================
-- Deliver messages and add new line in console
function bsmith96.dbg(dbg)
  reaper.ShowConsoleMsg(tostring(dbg) .. "\n")
end

-- Deliver messages using message box
function bsmith96.msg(msg, title)
  local title = title or "BSmith96 Info"
  reaper.MB(tostring(msg), title, 0)
end

-- Rets to bools // returns Boolean
function bsmith96.retToBool(ret)
  if ret == 1 then return true else return false end
end


-- =========================================================
-- ==================  VALUE MANIPULATION  =================
-- =========================================================

-- Check if an input string starts with another string // returns Boolean
function bsmith96.stringStarts(str, start)
  return str:sub(1, #start) == start
end

-- Check if an input string ends with another string // returns Boolean
function bsmith96.stringEnds(str, ending)
  return ending == "" or str:sub(-#ending) == ending
end

-- Pattern escaping gsub alternative that works with hyphens and other lua stuff // returns String
-- https://stackoverflow.com/a/29379912
function bsmith96.stringReplace(str, what, with)
  what = string.gsub(what, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1") -- escape pattern
  with = string.gsub(with, "[%%]", "%%%%") -- escape replacement
  return string.gsub(str, what, with)
end

-- Split a string into multiple return values by a separator
-- local part1, part2, part3 = acendan.stringSplit("blah|blah|blah", "%|", 3)
function bsmith96.stringSplit(str, sep, reps)
  sep = sep and sep or ","
  if not bsmith96.stringEnds(str, sep) then str = str .. sep end
  return str:match(("([^" .. sep .. "]*)" .. sep):rep(reps))
end

-- remove trailing and leading whitespace from string.
-- http://en.wikipedia.org/wiki/Trim_(programming)
function bsmith96.removeLeadTrailWhitespace(s)
  -- from PiL2 20.4
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- Round the input value // returns Number
function bsmith96.roundValue(input)
  return math.floor(input + 0.5)
end


-- =========================================================
-- ===================  TRACK UTILITIES  ===================
-- =========================================================

-- Copy and paste a media item from one track to another (/Tracks/Explode multichannel audio files.lua)
function bsmith96.copyPasteItem(oldTrack, oldItem, newTrack)
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

-- Set a tracks' input channel
function setInput(track, input)
  reaper.SetMediaTrackInfo_Value(track, "I_RECINPUT", input)
end

-- Returns the folder depth of a track
function getDepth(track)
  track = reaper.GetTrack(0, trackID-1)
  trackDepth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
  return trackDepth
end

-- =========================================================

return bsmith96