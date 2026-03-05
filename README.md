# LilyPond Development Docker Environment

This Dockerfile creates a complete development environment for LilyPond based on Ubuntu 24.04 LTS.

## Features

- **Base OS**: Ubuntu 24.04 LTS (Noble Numbat)
- **Build Tools**: Complete GCC toolchain, clang, autoconf, make
- **Dependencies**: All required libraries for LilyPond compilation
- **Font Support**: FontForge, TeX Live, and essential font packages
- **User Setup**: Non-root development user with sudo access
- **Optimized**: Minimal image size with cleanup of unnecessary files

## Quick Start

### Using Docker Compose (Recommended)

1. **Build the image:**
   ```bash
   docker compose build
   ```

2. **Start development shell:**
   ```bash
   docker compose run lilypond-dev
   ```

3. **Build LilyPond:**
   ```bash
   docker compose run lilypond-build
   ```

4. **Run tests:**
   ```bash
   docker compose run lilypond-test
   ```

### Using Docker Directly

1. **Build the image:**
   ```bash
   docker build -t lilypond-dev:24.04 .
   ```

2. **Run the container:**
   ```bash
   docker run -it --rm \
     -v $(pwd):/workspace \
     -w /workspace \
     lilypond-dev:24.04
   ```

## Build LilyPond Inside Container

Once inside the container:

```bash
# Generate configure script (if needed)
./autogen.sh

# Configure with debugging and documentation
./configure --enable-checking --enable-documentation

# Build (uses all available CPU cores)
make -j$(nproc)

# Run tests
make check

# Install (optional)
sudo make install
```

## Customization

### User Configuration

You can customize the development user by setting environment variables:

```bash
# Custom user ID and group ID (useful for file permissions)
export USER_UID=$(id -u)
export USER_GID=$(id -g)
export USERNAME=$(whoami)

docker compose build
```

### Volume Mounts

The docker compose.yml includes these volume mounts:
- `.` → `/workspace` (your LilyPond source code)
- `~/.gitconfig` → `/home/dev/.gitconfig` (your Git configuration)

Add more volumes as needed:
```yaml
volumes:
  - .:/workspace
  - ~/.gitconfig:/home/dev/.gitconfig:ro
  - ~/.ssh:/home/dev/.ssh:ro  # SSH keys for Git operations
  - /path/to/local/fonts:/usr/share/fonts/truetype/custom  # Custom fonts
```

## Included Dependencies

### Build Tools
- GCC, G++, Clang
- Autoconf, Automake, Libtool
- Make, Bison, Flex
- Python 3.10+ with development headers

### Graphics & Fonts
- FontForge with Python bindings
- FreeType, FontConfig, Pango, Cairo
- GhostScript with development libraries
- TeX Live (comprehensive installation)

### System Libraries
- GLib, GObject (for modern GNOME stack)
- libpng, libjpeg, libtiff
- zlib, gettext, libfl

### Fonts
- DejaVu, TeX Gyre, URW Base35
- Liberation, Noto (including CJK and emoji)
- Latin Modern

## Development Workflow

1. **Start container:** `docker compose run lilypond-dev`
2. **Make changes:** Edit files in your host workspace
3. **Build:** `make -j$(nproc)` inside container
4. **Test:** `make check` inside container
5. **Exit:** Type `exit` or press Ctrl+D

## Performance Tips

- Use `make -j$(nproc)` to utilize all CPU cores
- Mount source code as a volume for instant file sync
- Use Docker's build cache for faster rebuilds
- Consider using `docker compose up -d` for background development

## Troubleshooting

### Permission Issues
If you encounter permission problems, rebuild with your user ID:
```bash
export USER_UID=$(id -u)
export USER_GID=$(id -g)
docker compose build --no-cache
```

### Missing Dependencies
The Dockerfile includes all dependencies from the official Ubuntu 22.04 build, updated for 24.04. If you encounter missing packages, you can install them inside the container:
```bash
sudo apt-get update && sudo apt-get install package-name
```

### Memory Issues
For large builds, increase Docker's memory allocation in Docker Desktop settings.

## Comparison with Official Dockerfile

This Dockerfile is based on `docker/base/Dockerfile.ubuntu-22.04` but includes:
- Ubuntu 24.04 LTS base
- Updated package versions
- Additional TeX Live packages for better documentation support
- More comprehensive font collection
- Development user configuration
- Optimized layer caching
