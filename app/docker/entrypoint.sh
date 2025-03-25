#!/bin/bash
set -e

# Apply database migrations
echo "Applying database migrations..."
python /opt/status-page/statuspage/manage.py migrate

# Create superuser if environment variables are set
if [ -n "$SUPERUSER_USERNAME" ] && [ -n "$SUPERUSER_PASSWORD" ]; then
    echo "Creating superuser..."
    python /opt/status-page/statuspage/manage.py shell -c "
from django.contrib.auth import get_user_model;
User = get_user_model();
if not User.objects.filter(username='$SUPERUSER_USERNAME').exists():
    User.objects.create_superuser('$SUPERUSER_USERNAME', '$SUPERUSER_EMAIL', '$SUPERUSER_PASSWORD');
    print('Superuser created');
else:
    print('Superuser already exists');
"
fi

# Execute the command passed to docker run
exec "$@"