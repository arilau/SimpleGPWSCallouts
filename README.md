# SimpleGPWSCallouts
FlyWithLua script for GPWS altitude callouts for X-Plane 11.

## Requirements
The following is required for Simple GPWS Altitude Callouts to work:
* FlyWithLuaNG plugin has to be installed and working.
* X-Plane resources must contain default set of callout sound files (these exist by default)
  * Check that Resources/sounds/alert folder contains callout files (1000ft.wav, 500ft.wav etc.)

## Installation
Installation is simple:
* Copy SimpleGPWSAltitudeCallouts.lua to Resources/plugins/FlyWithLua/Scripts -folder.
* Restart X-plane or reload FlyWithLua.

## Customization
GPWS callouts are enabled only for Cessna 172 by default. Script file can be edited with any text editor to change callout settings. Following settings can be modified:
* Aircraft, where GPWS callouts are enabled
* Default altitudes for callouts
* Aircraft specific altitudes for callouts which override defaults
* GPWS callout sound volume

Please read the comments in script file for more specific customization instructions.
