--[[
  This addon attempts to add the mount name and logo a player is currently
  riding to the standard blizzard tooltip for a character when you move your
  mouse over that character.

  This version is a simple functional way to accomplish this goal.
  Future versions should look towards an object oriented approach across
  modules to handle much of the logic.  Will also help I believe to avoid
  the global namespace, though there may be other ways to do that.

  Also, I do not yet understand the formatting for tooltips with regards to
  text that is aligned left or right.  Additional mount information, such as
  whether it is collected, and the source, could possibly be added.

  The blizzard api is hard to crack.  There is not comprehensive documetnation.
  Some of the functionality of lua methods they provide are not documented
  except for in their internal C implementations.  Still, a good resource is
  https://github.com/Gethe/wow-ui-source

  Wiki's online are ok but usually out of date.  Other addons are possible
  sources of inspiration, but can also be out of date in implementations.
]]


--[[
  This function look at player auras to find one which matches a mount.
  Gets called from MT_ProcessAuras, which cycles through this for each aura it
  finds.

  We areally only need spellID, but for accuracy and future development, other
  exposed arguments are saved here in a easier to read list format.
  This reference can be deleted later

  See https://wowpedia.fandom.com/wiki/API_UnitAura
]]
function MT_CheckAurasForMount(
  name,                         -- string
  icon,                         -- number thats file ID
  count,                        -- number of stacks, default 0
  dispelType,                   -- string of 4 types, can be nil
  duration,                     -- number, full duraction in seconds
  expriationTime,               -- number, time aura expires
  source,                       -- string, UnitId that applied aura
  isStealable,                  -- bool, probably not nil?
  nameplateShowPersonal,        -- bool, if aura should show on nameplate
  spellId,                      -- number, probably not nil
  canApplyAura,                 -- bool, if player can apply the aura
  isBossDebuff,                 -- bool, if aura was applied by boss
  castByPlayer,                 -- bool, if aura was applied by player
  nameplateShowAll,             -- bool, if aura should show on all nameplates
  timeMod,                      -- number, scaling factor for calc time left
  attribute1,                   --   these attributes can be specific...
  attribute2                    --   ... to certain auras
  )

  -- mountIds are their own thing
  -- See https://wowpedia.fandom.com/wiki/MountID
  local mountId;
  mountId = C_MountJournal.GetMountFromSpell(spellId); -- new in 10.0 I believe

  -- if we found a mount from a spellID, then add it to the tooltip and exit
  if (mountId ~= nil) then

    -- get mount information
    local mountName,            -- string, not nil
      spellID,                  -- number, not nil
      icon,                     -- number, not nil
      isActive,                 -- bool, not nil
      isUsable,                 -- bool, not nil
      sourceType,               -- number, not nil
      isFavorite,               -- bool, not nil
      isFactionSpecific,        -- bool, not nil
      faction,                  -- number, can be nil
      shouldHideOnChar,         -- bool, not nil
      isCollected,              -- bool, not nil
      mountID,                  -- number, not nil
      isForDragonriding         -- bool, not nil
        = C_MountJournal.GetMountInfoByID(mountId);

    -- simple blank line for formatting
    GameTooltip:AddLine(" ");

    -- formulate the icon string for text processing.
    -- See https://wowpedia.fandom.com/wiki/UI_escape_sequences
    local iconString = "|T" .. icon .. ":25" .. "|t ";

    -- add mount info to the tooltip
    GameTooltip:AddLine(iconString .. mountName);

    -- breaks the loop from AuraUtil because our function returns a value
    return true;
   end
end

-- called when the unit tooltip event is fired, I believe?
function MT_ProcessAuras(self)
  local name, unit, guid = self:GetUnit();  -- guid does not come from this?

  -- ! Early Return
  -- exit early if the unit is not a player
  if (not UnitIsPlayer(unit)) then
    return;
  end

  -- create filter string using helper fuction
  -- mostly here for documentation purposes
  local filterString = AuraUtil.CreateFilterString("HELPFUL");

  --[[ Use AuraUtil to cycle through each aura and check for a mount.
    The 40 number here is the max number  of auras to check that we set.
    This may not be necessary, but its here to limit how much procesing we do
    so we don't get stuck doing a lot of stuff.
    Theres no error reporting or way to show the user what happened if the
    player had too many buffs but indeed did have a mount.

    See https://wowpedia.fandom.com/wiki/API_UnitAura
  ]]
  AuraUtil.ForEachAura(unit, filterString, 40, MT_CheckAurasForMount);

  -- we dont really need a return value, this feels bad =(
end


-- hook into the tooltip event, which fires on specific mousovers,
-- with our own function MT_ProcessAuras
GameTooltip:HookScript("OnTooltipSetUnit", MT_ProcessAuras);