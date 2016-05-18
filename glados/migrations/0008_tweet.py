# -*- coding: utf-8 -*-
# Generated by Django 1.9.2 on 2016-05-17 14:14
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('glados', '0007_faqcategory_position'),
    ]

    operations = [
        migrations.CreateModel(
            name='Tweet',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('username', models.CharField(default='chembl', max_length=20)),
                ('screen_name', models.CharField(default='ChEMBL Database', max_length=20)),
                ('content', models.TextField()),
                ('profile_img_url', models.CharField(max_length=500)),
                ('date', models.DateTimeField()),
            ],
        ),
    ]
