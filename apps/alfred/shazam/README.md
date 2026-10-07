# Shazam for Alfred

Type `shazam` in Alfred and choose **Recognize Music**. Its subtitle is
“Identify a song with Shazam, then search Spotify”; the workflow name remains
**Shazam**. The **Shazam to Spotify** macOS shortcut recognizes the song,
displays its title and artist, then offers:

- **Search in Spotify** — passes the recognized title and artist directly to
  Open URLs as a Spotify search URI. This is a search, not an exact-track link
  or autoplay.
- **Copy song and artist** — copies the result to the clipboard.

Requires Alfred Powerpack and the Spotify app. Approve any first-run permissions.
There are no Apple Music actions, Spotify API credentials, or wrapper app.
The original **Shazam shortcut** is preserved unchanged.

## Sources and installation

- `info.plist`: Alfred workflow source. The installed copy lives in Alfred's active
  synced preferences at `workflows/user.workflow.local-mubuntu-shazam/`.
- `icon.png`: 1024×1024 transparent PNG converted from the user-selected
  `~/Pictures/icons/1password/shazam.icns`. A matching `shazam.png` is saved beside
  that original. Rebuild with
  `sips -s format png ~/Pictures/icons/1password/shazam.icns --out icon.png`.
- `build_shortcut.py`: native Shortcut source, using only Python's standard library.
  It validates control flow, output references, and direct search wiring when
  run; no script runs during music recognition.

On this Mac (macOS 27.0.1, verified October 6, 2026), the intermediate Text,
URL Encode, and URL actions failed as missing and produced no query. The shortcut
instead embeds Shazam's title/artist variables directly in the menu, clipboard,
and Open URLs actions. The direct Open URLs path was tested with a fixed song
query and visibly changed Spotify's search results.

Bootstrap does not install this workflow automatically. To rebuild and import the
shortcut from this directory:

```sh
workdir=$(mktemp -d)
python3 build_shortcut.py "$workdir/unsigned.shortcut"
shortcuts sign --mode anyone --input "$workdir/unsigned.shortcut" \
  --output "$workdir/Shazam to Spotify.shortcut"
open "$workdir/Shazam to Spotify.shortcut"
```

Apple's signing service receives the generated shortcut for validation. It contains
only these native actions, not personal library data. Confirm the import in
Shortcuts, retaining the name **Shazam to Spotify** used by Alfred.

To package the Alfred workflow for import:

```sh
zip /tmp/Shazam.alfredworkflow info.plist icon.png
open /tmp/Shazam.alfredworkflow
```

## Menu bar

The standalone Music Recognition menu-bar icon is independent of this workflow.
On this Mac, open Control Center → Edit Controls, then drag the Shazam icon off
the menu bar. Keep its Control Center entry if desired. The menu-bar setting has
not been changed by this setup.
