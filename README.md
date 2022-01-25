# anims
A simple NUI emotes panel which supports shared and emote animations.

*[NOTE]*: You must enforce the casino game build (set sv_enforceGameBuild 2060).

## LICENSE
This project does not contain a license, therefore you are not allowed to add one and claim it as yours. You are not allowed to sell this nor re-distribute it, if an issue arises, we will proceed to file a DMCA takedown request. You are not allowed to change/add a license unless given permission by Mauricio Rivera (Bombay). If you want to modify _(does not apply if you want to use it for personal purposes)_ or make an agreement, you can contact Mauricio Rivera (Bombay). Pull requests are accepted as long as they do not contain breaking changes. You can read more about unlicensed repositories [here](https://opensource.stackexchange.com/questions/1720/what-can-i-assume-if-a-publicly-published-project-has-no-license) if questions remain.

### Features
- Maintained.
- Settings page.
- Favorite anims.
- Extended config.
- Simple to add animations.

### Preview
![Image](https://i.imgur.com/rZdEX9C.png)

[Video](https://youtu.be/Gvf9gW8KUdg)


## Acknowledgements
- [dpemotes](https://github.com/andristum/dpemotes) for the overall idea and the actual animations. Without it this wouldn't be possible <3.
- [Ultrahacx](https://github.com/ultrahacx) for the extra custom anims.
- [DivinedDude](https://forum.cfx.re/t/free-addon-11-gangsign-animations-by-mikey/4806838/) gang sign animations

### Locales
- Everything has to be translated manually because I did not want to support different languages with a locales config. However, I will list every line that can be translated.

**LUA**
- [105 | client/nui.lua]
- [141 | client/nui.lua]
- [82 | client/functions.lua]
- [163 | client/functions.lua]
- [13-14 | server/syncing.lua]

**JS**
- [22-33 | html/js/script.js]
- [6-102 | html/js/listeners.js]
- [88-89 | html/js/modules/fetch.js]
- [104-105 | html/js/modules/functions.js]
