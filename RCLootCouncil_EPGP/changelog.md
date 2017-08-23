v1.4.1
Fix lua error that prevent EP, GP, PR to be shown.

v1.4
The result of enabling/disabling custom GP rules is applied immediately while voting frame is open.
Update the default custom GP formula to accomodate the most recent EPGP addon update.

v1.3
Fix a bad LUA error that prevents settings to be shown. (Issue #3)
Thanks for the issue report from Wulfbayne. 
Bidding and custom GP feature should now function correctly.
Sorry about that. I should have found this bug much earlier if I had cleared my saved variable while testing.

v1.2.1
Fix a potential bug in sorting that could cause the game client to stuck in infinite loop(game crash).

v1.2
Add a simple bidding feature. (Disabled by default. Enable this feature in Interface->Addons->RCLootCouncil->EPGP)
Players can send their bidding price to the loot master by sending a note which starts with integer in the RCLootCouncil popup.
Loot Master can see the bidding price and assign GP accordingly.

v1.1.2
BugFix(Issue #2): No longer use global variable "RCVotingFrame".
Display version number in the setting.

v1.1.1
Keep disabling the GP popup of EPGP(dkp reloaded) rather than only disable it once when the addon is loaded.
This should fix the issue that some people still get GP popup of EPGP with this addon.

v1.1
Changes to custom GP rules are applied immediately while voting frame is open.

v1.0.1Beta
Add ruRU (Russian) localization. Thanks to the translation by Uptys.

v1.0Beta
This update requires full restart of the client.
Add Support to create customized GP Points Rule. This feature is in Beta.
The setting is under Interface->RCLootCouncil->EPGP. 
Support enUS, zhCN, zhTW localization.

v0.8.2
Disable the GP popup of "EPGP(dkp reloaded)" when this addon is enabled.

v0.8
Award with GP button is now clickable when the GP value of response/item is 0

v0.7
Improve EP, GP, PR text format.
If EP, GP, PR are unknown, they are shown as "?" instead of 0.
GP text is now grey.
EP text is red if its value is less than MIN_EP, grey otherwise.
PR text shows 4 digits of effective number instead of 4 digits after dot.

v0.6
1. Improve sorting.
   If sorted by PR, PR is sorted in descending order by default.
   If sorted by response, equal response is sorted by PR in descending order.

2. Fix custom GP editbox Focusing issue
   No longer auto focus GP editbox
   The focus of GP editbox is automatically cleared after 3s unused or when rightclick menu opens.

v0.5.3
Fix a bug occurring when realm name contains space.

v0.5.2
Fix a bug in v0.5 that sometimes fails when the player is from the same realm as the ML

v0.5
Hopefully fix the EPGP error for some non-English names and names with space.

v0.4
Now the addon can be used with RCLootCouncil - ExtraUtilities.
You need to fully restart the WoW client after updating to this version.

v0.0.3.2
Add more EPGP Support.

You can now assign GP values to different responses.
There is a GP editbox showing the GP value of the item. You can change it to your custom GP value.
Add a command on the very top of right click menu to award item and add GP to the player according to the GP in the editbox and GP of his response.

v0.0.2
Member whose EP is less than MinEP will be sorted after member whose EP is greater than MinEP
EP, GP and PR information are refreshed when EPGP value is changed.

v0.0.1
Initial release. Show EP, GP and PR in the RCLootCouncil VotingFrame