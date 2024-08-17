# Docker Image Packaging Script

This script automates the process of building and publishing a Docker image to the GitHub Container Registry.

## Usage

To use this script, run the following command in your terminal:
```bash
./packaging_script.sh --username <username> --gh_token <gh_token> --image_name <image_name>
```

### Parameters

- `--username`: Your GitHub username.
- `--gh_token`: Your GitHub personal access token with permissions to publish to the GitHub Container Registry.
- `--image_name`: The full name of the Docker image you want to build and publish, like `ghcr.io/cs4alhaider/some-package`.

### Prerequisites

- Ensure you have Docker installed and running on your machine.
- Make the script executable by running:
  ```bash
  chmod +x packaging_script.sh
  ```

## Functionality

1. **Login to GitHub Container Registry**: The script logs in using the provided username and GitHub token.
2. **Get Latest Tag**: It retrieves the latest tag of the specified Docker image from the GitHub Container Registry.
3. **Version Increment**: If no tags are found, it defaults to `1.0.0`. It increments the patch version for the new image tag.
4. **Build and Publish**: The script builds the Docker image with the new tag and pushes it to the GitHub Container Registry.
5. **Tag as Latest**: It tags the newly built image as `latest` and pushes that tag as well.

## Usage in GitHub Actions

You can also integrate this script into your GitHub Actions workflows to automate the building and publishing of Docker images on code changes.

## Author
Created by: Abdullah Alhaider - [GitHub](https://github.comcs4alhaider)

## License

This project is licensed under the MIT License.
