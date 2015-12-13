# Build file for creating the dev container

FROM ubuntu:14.04

# Configure
RUN sudo useradd -m cse_admin
COPY bashrc /home/cse_admin/.bashrc
COPY startup.sh /home/cse_admin/startup.sh
RUN sudo chown cse_admin:cse_admin /home/cse_admin/.bashrc
RUN sudo chown cse_admin:cse_admin /home/cse_admin/startup.sh
RUN sudo su cse_admin -c "chmod a+x /home/cse_admin/startup.sh"

# Add repor for PostGres 9.4
COPY pgdg.list /etc/apt/sources.list.d/.
RUN sudo apt-get -qqy install wget
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O- | sudo apt-key add - 

# Install PostGres 9.4 Client & Python Driver
RUN sudo apt-get -qqy update
RUN sudo apt-get -qqy install libpq-dev python-dev
RUN sudo apt-get -qqy install postgresql-client-9.4
RUN sudo apt-get -qqy install postgresql-server-dev-9.4

# Install & Config Nginx
RUN sudo apt-get -qqy install nginx
COPY cse.conf /etc/nginx/conf.d/.
COPY default /etc/nginx/sites-enabled/.
RUN sudo update-rc.d nginx enable
RUN sudo update-rc.d nginx defaults

# Setup Env
RUN sudo apt-get -qqy install python-setuptools
RUN sudo easy_install pip
RUN sudo pip install psycopg2
RUN sudo pip install virtualenv
RUN sudo su cse_admin -c "/usr/local/bin/virtualenv /home/cse_admin/.virtualenv/cse --system-site-packages"
RUN sudo su cse_admin -c "/home/cse_admin/.virtualenv/cse/bin/pip install flask"
RUN sudo mkdir -p /opt/ccs/ccs-infosec-platform
RUN sudo chown -R cse_admin:cse_admin /opt/ccs

ENTRYPOINT ["/home/cse_admin/startup.sh"]
CMD [""]