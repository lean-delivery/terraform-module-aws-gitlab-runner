#!/bin/bash -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1


# Add current hostname to hosts file
tee /etc/hosts <<EOL
127.0.0.1   localhost localhost.localdomain `hostname`
EOL

for i in {1..7}
do
  echo "Attempt: ---- " $i
  yum -y update  && break || sleep 60
done

# install OS security updates
cat >> /var/spool/cron/root << EOF
0 3,12 * * * /bin/yum update -y --security -q &> /dev/null
EOF

# Install AWS inspector
curl https://inspector-agent.amazonaws.com/linux/latest/install  | sudo bash

${logging}

${gitlab_runner}
