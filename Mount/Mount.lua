local addonName, MountTooltip = ...;

-- parameters for mount objects, table used for metatable
MountTooltip.Mount = {
  name = "",
  spellID = "",
  icon = "",
  isActive = "",
  isUsable = "",
  sourceType = "",
  isFavorite = "",
  faction = "",
  shouldHideOnChar = "",
  isCollected = "",
  mountID = "",
  isForDragonriding = "",
  creatureDisplayInfoID = "";
  description = "";
  source = "";
  isSelfMount = "";
  mountTypeID = "";
  uiModelSceneID = "";
  animID = "";
  spellVisualKitID = "";
  disablePlayerMountPreview = "";
};

-- constructor
function MountTooltip.Mount:new(object)
  object = object or {};
  setmetatable(object, self);
  self.__index = self;
  return object;
end


-- simply sets mount information,
-- returns true if successful, false if no mount was found
function MountTooltip.Mount:getMountInfo(checkMountID)
  local foundMountInfo = false;

  -- create temporary variables to store mount information in
  -- we only save to the object if name is not nil
  local name, spellID, icon, isActive, isUsable, sourceType, isFavorite,
    isFactionSpecific, faction, shouldHideOnChar, isCollected, mountID,
    isForDragonriding;

  -- make sure mount ID is a number
  if ( type(checkMountID) == "number" ) then
    name,                     -- string, not nil
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
    = C_MountJournal.GetMountInfoByID(checkMountID);
  end

    if ( type(checkMountID) == "number" ) then
    creatureDisplayInfoID,
    description,
    source,
    isSelfMount,
    mountTypeID,
    uiModelSceneID,
    animID,
    spellVisualKitID,
    disablePlayerMountPreview
    = C_MountJournal.GetMountInfoExtraByID(checkMountID);
  end


  -- see if name is not nil, then store the data
  if (name) then
    foundMountInfo = true;

    self.name = name;
    self.spellID = spellID;
    self.icon = icon;
    self.isActive = isActive;
    self.isUsable = isUsable;
    self.sourceType = sourceType;
    self.isFavorite = isFavorite;
    self.isFactionSpecific = isFactionSpecific;
    self.faction = faction;
    self.shouldHideOnChar = shouldHideOnChar;
    self.isCollected = isCollected;
    self.mountID = mountID;
    self.isForDragonriding = isForDragonriding;
    self.creatureDisplayInfoID = creatureDisplayInfoID;
    self.description = description;
    self.whereFrom = source;

  end

  return foundMountInfo;
end
