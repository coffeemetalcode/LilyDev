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

### 1. Configure Your LilyPond Source Path

Copy the example environment file and configure your LilyPond source directory:

```bash
# Navigate to the docker directory
cd docker

# Copy the template
cp .env.example .env

# Edit the .env file to point to your LilyPond repository
nano .env
```

In the `docker/.env` file, set `LILYPOND_SOURCE_PATH` to the absolute path of your LilyPond source repository:

```bash
# Example configurations:
LILYPOND_SOURCE_PATH=/home/user/projects/lilypond
# LILYPOND_SOURCE_PATH=/Users/username/git/lilypond
# LILYPOND_SOURCE_PATH=C:\Users\username\git\lilypond
```

### 2. Build and Run
(For persisting a build and installation across development sessions in the Docker container, see *Install to Source Directory (Recommended)* below)

Navigate to the `docker/` directory first:

```bash
cd docker
```

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

**Note**: All docker compose commands must be run from the `docker/` directory where `docker-compose.yml` and `.env` are located.

### Using Docker Directly

1. **Build the image:**
   ```bash
   docker build -t lilypond-dev:24.04 docker/
   ```

2. **Run the container:**
   ```bash
   docker run -it --rm \
     -v /path/to/your/lilypond:/workspace \
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

<!-- TODO: this might not work, and even if it did, it might be bad advice -->
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
- `${LILYPOND_SOURCE_PATH}` → `/workspace` (your LilyPond source code - configured in `.env`)
- `~/.gitconfig` → `/home/dev/.gitconfig` (your Git configuration, read-only)

The `LILYPOND_SOURCE_PATH` environment variable is defined in the `docker/.env` file, allowing each developer to point to their own LilyPond repository location.

Add more volumes as needed:
```yaml
volumes:
  - ${LILYPOND_SOURCE_PATH}:/workspace
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

## Persistent Installation Solution

### Install to Source Directory (Recommended)

Install LilyPond to `/home/dev/lilypond/install`. The result is a fresh installation on your host machine in `$LILYPOND_SOURCE_PATH/install/`. A persistent `$PATH` variable is set up in the Dockerfile to point to this command, and it should work after the first time you build and install from inside the running Docker image.

```bash
# Configure with custom install prefix
./configure --prefix=/home/dev/lilypond/install --enable-checking --enable-documentation

# Build and install
make -j$(nproc)
make install
```

**Benefits:**
- Installation persists across container restarts
- No additional volume mounts needed
- Keeps build artifacts with source code
- Separate from LilyPond installations on your host machine
  - You could alias a command like `lilypond-dev` to `$LILYPOND_SOURCE_PATH/lilypond/install/bin/lilypond` if you want to invoke it from your host machine without running the Docker container

**Usage:**
- `lilypond` command available automatically (PATH set in Dockerfile)
- Installation located at: `/home/dev/lilypond/install/`
- Use full path if needed: `/home/dev/lilypond/install/bin/lilypond`

## Development Workflow

1. **Navigate to docker directory:** `cd docker`
2. **Start container:** `docker compose run lilypond-dev`
3. **Make changes:** Edit files in your host workspace (configured in `docker/.env`)
4. **Build:** `make -j$(nproc)` inside container
5. **Test:** `make check` inside container
6. **Exit:** Type `exit` or press Ctrl+D

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
