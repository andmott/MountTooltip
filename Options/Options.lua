local addonName, MountTooltip = ...;


-- Object to process player auras
MountTooltip.ScanPlayerAuras = {};


function MountTooltip.ScanPlayerAuras:getAuras

function MountTooltip.ScanPlayerAuras:new(object)
  object = object or {};
  setmetatable(object, self);
  self._index = self;
  return object;
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


--[[


object system?


responsibilities
  - cycle through each aura looking and find a mount
  - get mount information and configure how it is displayed

  -
  - display mount information
  - display icon
  - create options

]]