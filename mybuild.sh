#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-cs683-champsim}"
IMAGE_TAG="${IMAGE_TAG:-gcc7}"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKERFILE="${DOCKERFILE:-${PROJECT_ROOT}/Dockerfile}"

L1D_PREFETCHER="${1:-no}"
L2C_REPLACEMENT="${2:-lru}"
BINARY_NAME="${3:-baseline}"

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    cat <<'EOF'
Usage: ./mybuild.sh [l1d_prefetcher] [l2c_replacement] [binary_name]

Examples:
  ./mybuild.sh no lru baseline
  ./mybuild.sh spp lru baseline
  ./mybuild.sh ip_stride lru myrun

This script builds the Docker image defined by Dockerfile and then runs the
ChampSim build inside the container.
EOF
    exit 0
fi

if [[ ! -f "$DOCKERFILE" ]]; then
    echo "Dockerfile not found at: $DOCKERFILE" >&2
    exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is required but not installed or not on PATH." >&2
    exit 1
fi

echo "Building Docker image ${IMAGE_NAME}:${IMAGE_TAG}..."
docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" -f "$DOCKERFILE" "$PROJECT_ROOT"

echo "Building ChampSim inside Docker container..."
docker run --rm \
  -v "${PROJECT_ROOT}:/workspace" \
  -w /workspace \
  "${IMAGE_NAME}:${IMAGE_TAG}" \
  bash -lc "./build_champsim.sh ${L1D_PREFETCHER} ${L2C_REPLACEMENT} ${BINARY_NAME}"

echo "Build completed. Binary is available in ./bin/"
