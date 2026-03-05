#!/bin/bash

# LilyPond Docker Build Script
# This script provides easy commands for building and developing LilyPond in Docker

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
}

# Function to build the Docker image
build_image() {
    print_status "Building LilyPond development Docker image..."
    
    # Set user ID and group ID for proper file permissions
    export USER_UID=${USER_UID:-$(id -u)}
    export USER_GID=${USER_GID:-$(id -g)}
    export USERNAME=${USERNAME:-$(whoami)}
    
    print_status "Using user ID: $USER_UID, group ID: $USER_GID, username: $USERNAME"
    
    if docker-compose build; then
        print_success "Docker image built successfully!"
    else
        print_error "Failed to build Docker image"
        exit 1
    fi
}

# Function to start development shell
dev_shell() {
    print_status "Starting LilyPond development shell..."
    docker-compose run --rm lilypond-dev
}

# Function to build LilyPond
build_lilypond() {
    print_status "Building LilyPond..."
    docker-compose run --rm lilypond-build
}

# Function to run tests
run_tests() {
    print_status "Running LilyPond tests..."
    docker-compose run --rm lilypond-test
}

# Function to clean up
cleanup() {
    print_status "Cleaning up Docker containers and images..."
    docker-compose down --rmi all --volumes --remove-orphans 2>/dev/null || true
    docker system prune -f
    print_success "Cleanup completed!"
}

# Function to show help
show_help() {
    echo "LilyPond Docker Development Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  build      Build the Docker image"
    echo "  shell      Start development shell"
    echo "  make       Build LilyPond inside container"
    echo "  test       Run tests"
    echo "  clean      Clean up Docker resources"
    echo "  help       Show this help message"
    echo ""
    echo "Environment variables:"
    echo "  USER_UID   User ID (default: current user ID)"
    echo "  USER_GID   Group ID (default: current group ID)"
    echo "  USERNAME   Username (default: current username)"
    echo ""
    echo "Examples:"
    echo "  $0 build                    # Build the image"
    echo "  $0 shell                    # Start development shell"
    echo "  USER_UID=1000 $0 build      # Build with specific user ID"
}

# Main script logic
case "${1:-help}" in
    build)
        check_docker
        build_image
        ;;
    shell)
        check_docker
        dev_shell
        ;;
    make)
        check_docker
        build_lilypond
        ;;
    test)
        check_docker
        run_tests
        ;;
    clean)
        check_docker
        cleanup
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
