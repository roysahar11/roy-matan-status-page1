#!/bin/bash
set -e

cd "$(dirname "$0")/.."

# Validate Python version
PYTHON_VERSION=$(python3 -V)
python3 -c 'import sys; exit(1 if sys.version_info < (3, 10) else 0)' || {
  echo "-------------------------------------------------------------------------"
  echo "ERROR: Unsupported Python version: ${PYTHON_VERSION}. Status-Page requires"
  echo "Python 3.10 or later."
  echo "-------------------------------------------------------------------------"
  exit 1
}
echo "Using ${PYTHON_VERSION}"

# Install required Python packages
echo "Installing core dependencies..."
pip install -r --no-cache-dir requirements.txt

# Install optional packages (if any)
if [ -s "local_requirements.txt" ]; then
  echo "Installing local dependencies..."
  pip install -r --no-cache-dir local_requirements.txt
elif [ -f "local_requirements.txt" ]; then
  echo "Skipping local dependencies (local_requirements.txt is empty)"
else
  echo "Skipping local dependencies (local_requirements.txt not found)"
fi

# Apply database migrations
echo "Applying database migrations..."
python3 statuspage/manage.py migrate

# Build the local documentation
echo "Building documentation..."
mkdocs build

# Collect static files
echo "Collecting static files..."
python3 statuspage/manage.py collectstatic --no-input

# Clean up stale data
echo "Cleaning up stale data..."
python3 statuspage/manage.py remove_stale_contenttypes --no-input
python3 statuspage/manage.py clearsessions
python3 statuspage/manage.py clearcache

echo "Docker upgrade complete!" 