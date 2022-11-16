--[[ See README.md for overview of the project. ]]--

--[[
  Blizzard wraps all of our code in a function, which is passed two arguments.
  These arguments can be accessed through the elipses shorthand,
  The first variable is a string containing the name of our addon.
  The second is a table whose scope is limited to this addon
  (or the function blizzard implements as the addon).
  This table is the same across all files in the addon, and is a simple way to
  share data across files without relying on a global namespace.
]]--
local addonName, MountTooltip = ...;

--[[
  This function look at player auras to find one which matches a mount.
  Gets called from MountTooltip.ProcessAuras, which cycles through this for
  each aura it finds.

  We areally only need spellID, but for accuracy and future development, other
  exposed arguments are saved here in a easier to read list format.
  This reference can be deleted later

  See https://wowpedia.fandom.com/wiki/API_UnitAura
]]--
function MountTooltip.CheckAurasForMount(
  name,                         -- string
  icon,                         -- number thats file ID
  count,                        -- number of stacks, default 0
  dispelType,                   -- string of 4 types, can be nil
  duration,                     -- number, full duraction in seconds
  expriationTime,               -- number, time aura expires
  source,                       -- string, UnitId that applied aura
  isStealable,                  -- bool, probably not nil?
  nameplateShowPersonal,        -- bool, if aura should show on nameplate
  spellID,                      -- number, probably not nil
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
  local mountID;
  mountID = C_MountJournal.GetMountFromSpell(spellID); -- new in 10.0 I believe

  -- if we found a mount from a spellID, then add it to the tooltip and exit
  if (mountID ~= nil) then

    -- get mount information
    local mount = MountTooltip.Mount:new();
    local foundMountInfo = mount:getMountInfo(mountID);

    -- make sure we actually found the mount information
    if (not foundMountInfo) then
      return true;
    end

    -- simple blank line for formatting
    GameTooltip:AddLine(" ");

    -- formulate the icon string for text processing, ending space is important
    -- See https://wowpedia.fandom.com/wiki/UI_escape_sequences
    local iconString = "|T" .. mount.icon .. ":25" .. "|t ";

    -- add mount info to the tooltip
    GameTooltip:AddLine(iconString .. mount.name);

    -- breaks the loop from AuraUtil because our function returns a value
    return true;
   end
end

-- called when the unit tooltip event is fired
function MountTooltip.ProcessAuras(self)
  local name, unit = self:GetUnit();

  -- ! Early Return
  -- exit early if the unit is nil or false, or if the unit is not a player
  -- probably a better way to do this
  if ( not unit or not UnitIsPlayer(unit)) then
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
  AuraUtil.ForEachAura(unit, filterString, 40, MountTooltip.CheckAurasForMount);

  -- we dont really need a return value, this feels bad =(
  -- probably need to look at GameTooltip:HookScript for return values
end

-- hook into the tooltip event, which fires on specific mousovers,
-- with our own function MT_ProcessAuras
--GameTooltip:HookScript("OnShow", MountTooltip.ProcessAuras );

-- new funtion for accessing this event
TooltipDataProcessor.AddTooltipPostCall(
  Enum.TooltipDataType.Unit, MountTooltip.ProcessAuras
);


