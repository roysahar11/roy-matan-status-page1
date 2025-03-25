# Generated by Django 4.2.1 on 2023-06-07 14:18

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):
    dependencies = [
        ("subscribers", "0003_subscriber_incident_notifications_subscribed_only"),
        ("extras", "0003_webhook_and_more"),
    ]

    operations = [
        migrations.AddField(
            model_name="webhook",
            name="subscriber",
            field=models.ForeignKey(
                blank=True,
                null=True,
                on_delete=django.db.models.deletion.CASCADE,
                to="subscribers.subscriber",
            ),
        ),
    ]
