# Seeing Things
Simply slap _any_ model with `Mirage` tag and the script will do everything for you!

## Setting Up
Download the latest release from the "Releases" page. You will find a `.rbxm` file which contains the module.

Drag-n-drop the `.rbxm` file into the Roblox Studio. A `MirageController` module script should appear in a DataModel as a child of `Workspace` instance.

You need to put the module either into `StarterLocalPlayerScripts` or `ReplicatedStorage`. 
To make it work, simply `require()` the module inside the `LocalScript`.

The returning value of a required module will return a typed `MirageController` singleton with some methods in it.

## Configuration
The distance of mirage and transparency can be configured via attributes:

- `MinMirageDistance` – The minimal distance at which the mirage is **opaque**
- `MaxMirageDistance` – The maximum distance at which the mirage is **fully transparent**
- `MinTransparency` – The minimum transparency
- `MaxTransparency` – The maximum transparency