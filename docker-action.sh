#!/bin/bash

# This script is used to build and publish a Docker image to GitHub Container Registry

# Created by: @cs4alhaider - Abdullah Alhaider

# Usage:
# $ ./packaging_script.sh --username <username> --gh_token <gh_token> --image_name <image_name>

# Ensure that you have the necessary permissions to execute the script. 
# You can set the executable permission using: chmod +x packaging_script.sh

# Default value for username
username=""
gh_token=""
image_name=""

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --username) username="$2"; shift ;;
        --gh_token) gh_token="$2"; shift ;;
        --image_name) image_name="$2"; shift ;;
        *) echo "⚠️ Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check if username is provided
if [[ -z "$username" ]]; then
    echo "⚠️ Error: No username provided. Use --username <name>."
    exit 1
fi

# Check if GH_TOKEN is set
if [ -z "$gh_token" ]; then
    echo "⚠️ Error: GitHub token is not set. Use --gh_token <token>"
    exit 1
fi

if [[ -z "$image_name" ]]; then
    echo "⚠️ Error: No image name provided. Use --image_name <name>"
    exit 1
fi


# Function to build and publish Docker image using GitHub CLI
build_and_publish_docker_image() {
    echo "Logging in to GitHub Container Registry using username: $username..."
    docker login --username $username --password $gh_token ghcr.io

    # Get the latest tag from the existing images
    echo "Getting the latest tag from the existing images..."

    local latest_tag=$(docker images --filter "reference=$image_name" --format "{{.Tag}}" | sort -V | tail -n 2 | head -n 1)
    echo "Latest tag: $latest_tag"

    # make sure latest_tag is not empty or <none> otherwise set it to 1.0.0
    if [[ -z "$latest_tag" || "$latest_tag" == "<none>" ]]; then
        latest_tag="1.0.0"
    fi

    # Increment the tag version according to semantic versioning and make it the latest
    # split the tag into major, minor, and patch
    IFS='.' read -r major minor patch <<< "$latest_tag"
    local new_tag="${major}.${minor}.${patch}"
    # increment the patch version
    new_tag=$(echo "$new_tag" | awk -F. -v OFS=. '{$NF++;print}')
    echo "New tag: $new_tag"

    echo "Building Docker image ==> $image_name:$new_tag"
    # Build the Docker image
    docker build -t "$image_name:$new_tag" .
    docker push "$image_name:$new_tag"

    # Tag the new image as latest
    echo "Tagging image as latest..."
    docker tag "$image_name:$new_tag" "$image_name:latest"

    echo "Pushing Docker image ==> $image_name:$new_tag"
    docker push "$image_name:latest"
}

# Build and publish the Docker image with the latest release tag
build_and_publish_docker_image
