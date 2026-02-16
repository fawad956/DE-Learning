#!/bin/bash

set -ex

# ── 1. Spin up a local HTTP repo server ──────────────────────────────────────
# RPMs are mounted at /var/repo/ambari via docker-compose volume
# We serve /var/repo so the URL becomes http://bigtop_hostname0/ambari/

yum install -y createrepo python3

# Generate yum repo metadata from the mounted RPMs
createrepo /var/repo/ambari

# Start HTTP server serving /var/repo on port 80 (background)
cd /var/repo
nohup python3 -m http.server 80 &>/tmp/reposerver.log &
sleep 5  # give it time to start

# ── 2. Configure the yum repo ─────────────────────────────────────────────────
tee /etc/yum.repos.d/ambari.repo << EOF
[ambari]
name=Ambari Repository
baseurl=http://bigtop_hostname0/ambari
gpgcheck=0
enabled=1
EOF

# Verify the repo is reachable before proceeding
curl -sf http://bigtop_hostname0/ambari/repodata/repomd.xml > /dev/null || {
  echo "ERROR: Repo server not reachable. Check /tmp/reposerver.log"
  cat /tmp/reposerver.log
  exit 1
}

# ── 3. Install packages ───────────────────────────────────────────────────────
yum install -y python3-distro
yum install -y java-17-openjdk-devel
yum install -y java-1.8.0-openjdk-devel
yum install -y ambari-agent

yum install -y python3-psycopg2
yum install -y ambari-server

# ── 4. MySQL ──────────────────────────────────────────────────────────────────
yum -y install https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm
yum -y install mysql-server

rm -rf /var/lib/mysql/*
mysqld --initialize
chown -R mysql:mysql /var/lib/mysql

MYSQL_ROOT_PASS=$(grep -i 'password is generated' /var/log/mysql/mysqld.log | rev | cut -d ':' -f1 | rev | tr -d ' ')

echo 'bind-address=0.0.0.0' >> /etc/my.cnf.d/mysql-server.cnf

systemctl start mysqld.service
systemctl enable mysqld.service

# ── 5. MySQL setup ────────────────────────────────────────────────────────────
cat > /root/ambari-server-setup.sql << 'SQLEOF'
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'ambarirootpass';
CREATE USER 'root'@'%.demo.local' IDENTIFIED WITH caching_sha2_password BY 'ambarirootpass';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%.demo.local';
CREATE USER 'ambari'@'localhost' IDENTIFIED BY 'ambari';
GRANT ALL PRIVILEGES ON *.* TO 'ambari'@'localhost';
CREATE USER 'ambari'@'%' IDENTIFIED BY 'ambari';
GRANT ALL PRIVILEGES ON *.* TO 'ambari'@'%';
CREATE DATABASE ambari CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE hive;
CREATE DATABASE ranger;
CREATE DATABASE rangerkms;
CREATE USER 'hive'@'%' IDENTIFIED BY 'hive';
GRANT ALL PRIVILEGES ON hive.* TO 'hive'@'%';
CREATE USER 'ranger'@'%' IDENTIFIED BY 'ranger';
GRANT ALL PRIVILEGES ON *.* TO 'ranger'@'%' WITH GRANT OPTION;
CREATE USER 'rangerkms'@'%' IDENTIFIED BY 'rangerkms';
GRANT ALL PRIVILEGES ON rangerkms.* TO 'rangerkms'@'%';
FLUSH PRIVILEGES;
SQLEOF

mysql --connect-expired-password -u root -p"${MYSQL_ROOT_PASS}" < /root/ambari-server-setup.sql
mysql --connect-expired-password -uambari -pambari ambari < /var/lib/ambari-server/resources/Ambari-DDL-MySQL-CREATE.sql

# ── 6. Ambari Server setup ────────────────────────────────────────────────────
wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar \
  -O /usr/share/java/mysql-connector-java.jar

ambari-server setup --jdbc-db=mysql --jdbc-driver=/usr/share/java/mysql-connector-java.jar

echo "server.jdbc.url=jdbc:mysql://localhost:3306/ambari?useSSL=true&verifyServerCertificate=false&enabledTLSProtocols=TLSv1.2" \
  >> /etc/ambari-server/conf/ambari.properties

ambari-server setup -s \
  -j /usr/lib/jvm/java-1.8.0-openjdk \
  --ambari-java-home /usr/lib/jvm/java-17-openjdk \
  --database=mysql \
  --databasehost=localhost \
  --databaseport=3306 \
  --databasename=ambari \
  --databaseusername=ambari \
  --databasepassword=ambari

ambari-server start