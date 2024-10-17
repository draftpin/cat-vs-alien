# cat-vs-alien
Cat VS Alien Telegram CryptoBot AutoGame (Windows AutoIT Script + compiled ready-to-use EXE-file) 

Since the game is abandoned (no updates from developers for 1 month, i got lvl 100+, chats are full of spammers), i'm releasing this script for everyone publicly

Technically it is AutoIT script searching pixel every 5 minutes (configurable) by its color, so only for **WINDOWS** , configured for use with TelegramDesktop client but you can easily reconfigure to use with any client or even browser using config file

## ![Result](result.gif)

## Features  
| Feature                                                     | Supported  |
|---------------------------------------------------------------|:----------------:|
| Daily Auto-Restart (def 3 AM, change via config file)         |        ✅        |
| Claim online bonuses                                          |        ✅        |
| Free Auto-Merge every hour                                    |        ✅        |
| Auto-Claim 100% bonus / 400% bonuses                          |        ✅        |
| Auto-Claim gold bonus (rarely but it does)                    |        ✅        |

Does not play PVP arena, spin roulette, daily tasks and actions spending gems - feel free to use them as you want after bot collects them every day automatically! 

## How to run:

# Easy way:
1. Download CatVsAlien.ini and CatVsAlien.exe (or only CatVsAlien.exe)
2. Run CatVsAlien.exe
3. To pause/unpause script right-click on tray icon (see video below)

# Hard way:
1. Download [AutoIT](https://www.autoitscript.com/site/autoit/downloads/)
2. Clone repository and start CatVsAlien.au3 with AutoIT
3. In this way you can see logs, start/stop/edit and adopt script for your own needs inside AutoIT editor

# Important:
- Script is searching pixel , so it will *ACTIVATE* window, do not touch it at the time script works or you will see unpredictable results (script can click on incorrect buttons)!
- By changing config file you can make it working once per minute, once per hour and adopt it for other Telegram clients or browser as you want. To get information about window and text, use AutoIT window info tool
- Works with only one window

# TODO
Use technics that find and click on pixel without activating window (not possible via AutoIT API but possible with WinAPI) 

