# Reaper Scripts

These scripts are designed to be very adaptable - you can easily alter them without delving too deeply into the script, and make them work for your current project.

The easiest way to do this is to keep the scripts in your project's directory (or a subdirectory), and add the name of the project to the start of the filename. This will allow you to easily find all the associated scripts in the actions menu.

You can either edit them in an external text editor before loading them into Reaper, or load them first and edit them in the built in ReaScript editor.

Once you've got all the scripts you want in a folder, go to the actions window (press '?') and select "New action...". Select "Load ReaScript" from the dropdown menu, navigate to your folder and highlight them all at once.

Now you can set keyboard shortcuts or midi triggers for the scripts.

----

## 01 Recording

### Arm All Tracks Within Folders

Automatically arms all tracks in the project, but ignores those which contain other tracks (folders). This allows you to organise your recording session in folders, but still quickly arm all tracks that you want to record onto.

### Arm Tracks For Recording

To be customised to toggle arm/disarm a specific set of tracks. Useful when you are regularly arming and disarming the same group of tracks, but do not want to arm every track in the project (e.g. recording a multitrack performance, and you have groups or folders).

----

## 02 Markers

### Create and name marker

Creates a marker at the time when the script is triggered, which by default asks for user input to name it (like "shift+M"), but crucially, it can be easily adapted to use a preset name, and can be easily triggered by midi.

One use case might be Qlab putting markers when certain cues are triggered and labelling them appropriately. Simply create an action in Reaper – an edited copy of the script, imported into the actions menu – for each specific name (e.g. "START OF SHOW"), and set that to trigger on a certain event (e.g. a particular midi trigger).

----

## 03 Structure

### Put selected tracks in new folder track

Adds a new track above the currently selected group of tracks, and indents the current selection 1 level. Can be set to prompt for a name for the new folder, or to leave the name blank.

----

## 99 Miscellaneous

### VCA Assign Template

A simple script for recalling (as if it were a scene on a digital mixing desk) to assign different inputs to a set of VCAs. This is a template, you create a separate action for every 'scene' you want to recall.

Designed to emulate mixing a musical multitrack without access to a digital mixing desk, but with simple midi fader controllers. To use them like this, I suggest using Qlab to send midi commands, triggering each scene.
