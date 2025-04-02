#!/bin/bash
set -e

# # Activate virtual environment (actually unnecessary when running a container image)
# source /opt/status-page/venv/bin/activate

# Apply database migrations - REQUIRES UPDATE - make migration conditional and not on each restart
echo "Applying database migrations..."
python /opt/status-page/statuspage/manage.py migrate

# Update or create superuser using credentials from Secrets Manager
if [ -n "$DJANGO_SUPERUSER_USERNAME" ] && [ -n "$DJANGO_SUPERUSER_PASSWORD" ]; then
    echo "Updating/Creating superuser..."
    python /opt/status-page/statuspage/manage.py shell -c "
from django.contrib.auth import get_user_model;
User = get_user_model();
user, created = User.objects.update_or_create(
    username='$DJANGO_SUPERUSER_USERNAME',
    defaults={
        'is_superuser': True,
        'is_staff': True,
        'email': '$DJANGO_SUPERUSER_EMAIL'
    }
);
user.set_password('$DJANGO_SUPERUSER_PASSWORD');
user.save();
print('Superuser created' if created else 'Superuser updated');
"
fi

# Execute the command passed to docker run
exec "$@"