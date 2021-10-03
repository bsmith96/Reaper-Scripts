-- @description Sound Devices MixPre Metadata Tools - Item Name
-- @author Aaron Cendan
-- @version 1.3
-- @metapackage
-- @provides
--   [main] . > acendan_MixPre items BWF description subfield to item name-sTAKE.lua
--   [main] . > acendan_MixPre items BWF description subfield to item name-sSCENE.lua
--   [main] . > acendan_MixPre items BWF description subfield to item name-sFILENAME.lua
--   [main] . > acendan_MixPre items BWF description subfield to item name-sTAPE.lua
--   [main] . > acendan_MixPre items BWF description subfield to item name-sNOTE.lua
-- @link https://aaroncendan.me
-- @about
--   Appends BWF sub-field after hyphen (-) in script name to original item name.

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~ GLOBAL VARS ~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

bwf_field = "zTRK3"

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~ FUNCTIONS ~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function appendMetadata()
  local num_sel_items = reaper.CountSelectedMediaItems(0)
  if num_sel_items > 0 then
    for i=0, num_sel_items - 1 do
      local item = reaper.GetSelectedMediaItem( 0, i )
      local take = reaper.GetActiveTake( item )
      if take ~= nil then 
        local src = reaper.GetMediaItemTake_Source(take)
        local src_parent = reaper.GetMediaSourceParent(src)
        
        --_,somethingIs = reaper.GetMediaFileMetadata(src, "")
        
        --reaper.MB(somethingIs, "", 0 )
        
        if src_parent ~= nil then
          ret, full_desc = reaper.CF_GetMediaSourceMetadata( src_parent, "BWF:Description", "" )
        else
          ret, full_desc = reaper.CF_GetMediaSourceMetadata( src, "BWF:Description", "" )
        end
        
        if ret then
        
          channelNumber = tostring(math.tointeger(reaper.GetMediaItemTakeInfo_Value(take, "I_CHANMODE") - 2))
          -- channelNumber actually wants to be the count of "TRK" not the number on the end.
          
          local start_of_field = string.find( full_desc, bwf_field .. "=" ) + string.len( bwf_field .. "=" )
          --local start_of_field = string.find(full_desc, "zTRK1=") + string.len("zTRK1=")
          local field_to_end = string.sub( full_desc, start_of_field, string.len( full_desc ))
          local end_of_field = start_of_field + string.find( field_to_end , "\r\n")
          local bwf_field_contents = string.sub( full_desc, start_of_field, end_of_field)
          
          --local ret2, original_name = reaper.GetSetMediaItemTakeInfo_String( take, "P_NAME", "", false )
          --local ret2, new_name = reaper.GetSetMediaItemTakeInfo_String( take, "P_NAME", original_name .. " - " .. bwf_field_contents, true )
          local track = reaper.GetMediaItemTrack(item)
          local ret2, original_name = reaper.GetSetMediaTrackInfo_String( track, "P_NAME", "", false )
          local ret2, new_name = reaper.GetSetMediaTrackInfo_String( track, "P_NAME", original_name .. " - " .. bwf_field_contents, true )
        end
      end
    end
  else
    reaper.MB("No items selected!","Append Metadata", 0)
  end
end


function extractFieldScriptName()
  local script_name = ({reaper.get_action_context()})[2]:match("([^/\\_]+)%.lua$")
  bwf_field = zSPEED
end
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~ MAIN ~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
reaper.PreventUIRefresh(1)

reaper.Undo_BeginBlock()

--extractFieldScriptName()

appendMetadata()

reaper.Undo_EndBlock("Append Metadata to Item Names",-1)

reaper.PreventUIRefresh(-1)

reaper.UpdateArrange()
