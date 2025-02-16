# [Game title]
[Game description]

_Note: This repo is not intended for contributing. Its only purpose is to provide a ready-made template to create games with Lua and LÖVE framework for iOS without the need for time consuming setup._

[![LÖVE](https://img.shields.io/badge/LÖVE-11.4-gold)](#)
[![Xcode](https://img.shields.io/badge/Xcode-13.1-gold)](#)

If you are new to [LÖVE](https://love2d.org) - it's a straightforward and easy-to-learn game development framework with a basic run loop, events and graphics. It doesn't limit your creativity as some engines do. And if you're into coding, you can create your new game literally in days, even if you had no prior experience with the [Lua language](https://www.lua.org/start.html). You just need four (or two) steps to start:
1. Install the tools
2. Create the repo
3. Change Apple Developer team and app bundle identifier
4. Distribute to TestFlight

As your games will be getting more complex, you might want to apply a little structure into the written code and I welcome you to read my article on [Clean architecture based on LÖVE example](https://medium.com/@yankalbaska/clean-architecture-in-game-development-e57542a96e5e). 

_Replace the above text with your new game description._

## Development Environment Setup
Developing iOS games with [LÖVE framework](https://love2d.org) consists of 2 parts: 
- `build` - a preset xcode project used for installing on a simulator and distribution (only distribution-specific changes will be required),
- `src` - the sources for the game, used for the development and to create the final `.love` file. Most of the creative work will be done in this folder only.

After running the sources locally, you zip the `/src` source folder contents (without the folder itself) and rename `.zip` file into `.love`. This file is later used in the iOS simulator or XCode project bundle to distribute in TestFlight / App Store.  

### 1. Install LÖVE framework for macOS
To be able to run and compile LÖVE games you need to install the framework/app.
1. Download the latest version of LÖVE from [the website](http://love2d.org/#download), choose: MacOS 64-bit zipped.
2. Unzip the app and move it into the **Applications** folder.
3. To be able to call `love` from terminal in IDE and see console output, add alias to `~/.zshrc`:
```
alias love="/Applications/love.app/Contents/MacOS/love"
```
4. Check that it works with `love --version`
5. If macOS (e.g. 15.3) is preventing you from running the executable because it was downloaded from the internet and not checked for malware, go to Settings > Privacy & Security. Locate `"love" was blocked to protect your Mac.` and click **Open Anyway**.
<img width="700" alt="security-prompt" src="https://github.com/user-attachments/assets/3dabf77f-4745-49a8-a2b7-ea63174fddfe" />

### 2. Install IDEs
- Install [VSCode](https://code.visualstudio.com/download) (for development)
- Install [XCode from the Map App Store](https://apps.apple.com/us/app/xcode/id497799835) (required only for iOS distribution)

### 3. Install VSCode plugins
If you use this repo, plugin settings will already be configured, just install them into VSCode.

3.1. Install VSCode plugin [Lua Language Server](https://marketplace.visualstudio.com/items?itemName=sumneko.lua)

It will automatically (at least upon restart) ask you to configure your project to run with LOVE when it detects certain keywords. After applied, it will result in `.vscode/settings.json` file:
```
{
    "Lua.runtime.version": "LuaJIT",
    "Lua.runtime.special": {
        "love.filesystem.load": "loadfile"
    },
    "Lua.workspace.library": [
        "${3rd}/love2d/library"
    ]
}
```
3.2. (Optional) To run games from IDE with a shortcut, install [Love 2D Support](https://marketplace.visualstudio.com/items?itemName=pixelbyte-studios.pixelbyte-love2d) plugin and configure its path to Love executable (same as alias you provided earlier) `/Applications/love.app/Contents/MacOS/love` which is also added to workspace settings file above.

### 4. Create a new repository
You can create your own game from [this template repo](https://github.com/kujunda-seda/template-love-game).

### 5. (Optional) Update preset project sources (for iOS distribution only)
If a new version of LÖVE framework comes out, you may want to update the `build` part of this repo before or during development. Otherwise it's already configured and you can skip this step: 
1. Clone [LÖVE repo](https://github.com/love2d/love) containing the sources and a preset XCode project into a separate folder:
```
mkdir temp-love
cd temp-love
git clone git@github.com:love2d/love.git
```
2. Copy `src` and `platform/xcode` folders into the `build` folder in your/this repo. You can skip `platform/unix` and other files.
3. Download the required iOS libraries from https://love2d.org > Other downloads > iOS > libraries. Unzip the archive and move the `iOS/libraries` folder into the `build/platform/xcode/ios` folder. Full instructions are at the [LÖVE website](https://love2d.org/wiki/Getting_Started#iOS), but this will suffice. 
4. Don't forget to reconfigure the project after as outlined in the Distribution section below.

## Running locally
In VSCode:
1. Save recent changes to Lua files
2. Focus on any `.lua` file
3. press **Cmd-L**

## Debugging
In VSCode Terminal run:
`love src`.
In addition to running the project, it will output `print` statements into the console.  
You can also use a separate debugging plugin for VSCode [Local Lua Debugger](https://marketplace.visualstudio.com/items?itemName=tomblind.local-lua-debugger-vscode) if you need.

## Distribution
1. Before you can configure XCode, you'll need an Apple Developer account at [developer.apple.com](https://developer.apple.com/account) and a new [bundle identifier](https://developer.apple.com/account/resources/identifiers/list) for the app.

2. Open `love.xcodeproj` in XCode.
3. With your project selected in sidebar, choose `love-ios` from Targets > Signing & Capabilities and select:

- \+ Automatically manage signing
- Team (if you log in with your developer account, you will see it in drop down)
- Bundle identifier (copy it from https://developer.apple.com/account/resources/identifiers/list)

There are 2 options to test the game:
#### Option 1. Airdrop - quick for local testing
The easiest way to test your game on iOS Simulator or device is running `love-ios` in XCode and drag-and-dropping or air-dropping the `.love` file straight into the app. You will have a list of apps you dropped earlier and can start any of them.

#### Option 2. Fusing a single game - for TestFlight and App Store
2.1. Select `love-ios` in Targets for your project > Build Phases > Copy Bundle Resources and link to your `.love` file:
"+" > Add Others > find `.love` file (can be outside of XCode project path) > select the options:
  - Copy items if needed
  - Create folder references

2.2. (Optional, but desired) Change the name: File inspector (right sidebar) for project > Identity and Type > Name. Proceed with the renaming of the linked files and targets as well.  

2.3. (Optional, but desired) Change the `Version` in the project > Identity settings, e.g. `1.0` or `0.0.1`.

2.4  (Optional) Change the icon of the app by providing required images in Project > Images > iOS AppIcon (see Apple Guidelines for it).

2.5. In the main screen top bar select `[name]-ios` target > Any iOS Device, run menu Product > Archive. Your app is now good to be distributed in TestFlight with **Distribute App**.
