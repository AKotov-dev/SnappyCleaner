**SnappyCleaner** - program for comprehensive garbage clearing in the system

Performs the following actions:
- Delete not active kernel's
- Temporary root files
- User basket
- Temporary user files
- Recent User Documents
- Directory-URPMI cache
- Directory-DNF cache
- Mozilla FireFox cache
- Google Chrome Cache
- Opera Browser Cache
- Chromium browser Cache
- PaleMoon Browser Cache
- Orphaned packages (optional)
- Search for orphans of arbitrary packages
- scleaner --auto (clean up without kernels and orphans)
- Repairs the RPM database

After installation, SnappyCleaner goes to the `Utilities-System` menu and starts with a shortcut, or with the `scleaner` command from under a normal user (`scleaner --auto` - cleaning without taking into account kernels and orphans). Requires `root` privileges.

Developed and tested only on Mageia Linux-7/8/9.

![](https://github.com/AKotov-dev/SnappyCleaner/blob/main/ScreenShot2.png)
