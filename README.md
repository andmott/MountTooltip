Cursforge URL
https://www.curseforge.com/wow/addons/mount-tooltip

This addon attempts to add the mount name and logo a player is currently
riding to the standard blizzard tooltip for a character when you move your
mouse over that character.

This version is a simple functional way to accomplish this goal.
Future versions should look towards an object oriented approach across
modules to handle much of the logic. Some Object Oriented functionality is
limited by the nature of the tooltip call itself. All of the work must be
done through a few functions passed to blizzard supplied utilities, that
being GameTooltip:HookScript and AuraUtil.ForEachAura.

The blizzard api is hard to crack. There is not comprehensive documentation.
Still, a good resource is https://github.com/Gethe/wow-ui-source

Online wikis are ok but usually out of date. Other addons are possible
sources of inspiration, but can also be out of date in implementations.

Dragonflight also changed up some mount information and the addon landscape
a little with their revamped UI, and most oline wiki's are not up to date
with this information.

Here are a few notes on possible upcoming revisions or features:

- Implement an options interface and logic with saved variables.
- Attempt to write in an object oriented way with modules.
- Customize the output of the tooltip using xml templates and user variables.

  - Turn on or off Icon. Possibly rezise icon as well.
  - Include additional mount information

    - Is Owned or not
    - Source, maybe cost information if purchased

  - Allow user to format the output

- Could attempt to add a right click on a character's nameplate to view the
  mount in the mount collections, or save the mount in a simple list.
