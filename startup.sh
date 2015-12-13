#!/usr/bin/env bash
service nginx start
sudo su cse_admin -c "/home/cse_admin/.virtualenv/cse/bin/python /opt/ccs/ccs-infosec-platform/cse/manage.py runserver 8000 --settings cse.docker_settings"
