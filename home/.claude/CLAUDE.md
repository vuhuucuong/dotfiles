# Global Claude Rules

## WSL Path Handling

IMPORTANT: When the user's message contains ANY Windows-style file path (containing backslashes or a drive letter like `C:\`), you MUST immediately and automatically:
1. Convert it to WSL path: replace `X:\` with `/mnt/x/` (lowercased), replace all `\` with `/`
2. If the path is an image file (`.png`, `.jpg`, `.jpeg`, `.gif`, `.webp`, `.bmp`), call the Read tool on it RIGHT AWAY in your very first response — do NOT ask, do NOT wait, do NOT explain first.

Example: `C:\Users\vuhuu\Pictures\Screenshots\foo.png` → `/mnt/c/Users/vuhuu/Pictures/Screenshots/foo.png`

This must happen as your FIRST action before any other response text.
