# Convert to WebP – Raycast Script

A Raycast script for converting images to WebP format with [Squoosh](https://squoosh.app/)-like quality.

## Features

- Convert JPG, PNG, TIFF, GIF, BMP → WebP
- Squoosh-like compression quality (default: 82)
- Batch processing – convert multiple files at once
- Shows total space saved

## Requirements

- macOS
- [Raycast](https://raycast.com/)
- cwebp (libwebp)

## Installation

### 1. Install libwebp

```bash
brew install webp
```

### 2. Add script to Raycast

1. Open Raycast (`⌘ + Space`)
2. Type "Script Commands" → select "Add Directories"
3. Create a folder for scripts (e.g. `~/raycast-scripts`)
4. Copy `convert-to-webp.sh` to that folder
5. Make it executable:

```bash
chmod +x ~/raycast-scripts/convert-to-webp.sh
```

## Usage

1. Select images in Finder
2. Open Raycast (`⌘ + Space`)
3. Type "Convert to WebP"
4. (Optional) Enter quality (75-95)
5. Press Enter

`.webp` files will be created in the same folder as originals.

## Quality Settings

| Value | Description | Use case |
|-------|-------------|----------|
| 90-95 | Highest quality | Photography, portfolio |
| 82 | **Default** (Squoosh-like) | General purpose |
| 75-80 | Balanced | Websites, blogs |
| 60-70 | Small size | Thumbnails, icons |

## Compression Settings

The script uses optimal cwebp settings similar to Squoosh:

```
-q 82        # Quality (0-100)
-m 6         # Maximum compression effort
-sharp_yuv   # Better RGB→YUV color conversion
-af          # Auto-filter for better quality
```

## Supported Formats

| Input | Output |
|-------|--------|
| .jpg, .jpeg | .webp |
| .png | .webp |
| .tiff, .tif | .webp |
| .gif | .webp |
| .bmp | .webp |

## Example

```
Before: photo.jpg     (2.4 MB)
After:  photo.webp    (420 KB)
Saved:  ~82%
```

## Troubleshooting

### "Install webp: brew install webp"
libwebp library is missing. Install via Homebrew:
```bash
brew install webp
```

### "Select files in Finder"
The script requires selected files in an active Finder window.

### Script doesn't appear in Raycast
1. Check if the scripts folder is added in Raycast
2. Check permissions: `chmod +x convert-to-webp.sh`
3. Reload Raycast: `⌘ + ,` → Extensions → Reload

## License

MIT

## Author

Marcin Tymków

