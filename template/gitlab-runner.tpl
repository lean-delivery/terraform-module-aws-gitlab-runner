mkdir -p /etc/gitlab-runner
cat > /etc/gitlab-runner/config.toml <<- EOF

${runners_config}

EOF

curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | bash
yum install gitlab-runner-${gitlab_runner_version} -y
curl -L https://github.com/docker/machine/releases/download/v${docker_machine_version}/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && \
  chmod +x /tmp/docker-machine && \
  cp /tmp/docker-machine /usr/local/bin/docker-machine && \
  ln -s /usr/local/bin/docker-machine /usr/bin/docker-machine

gitlab-runner register \
  --non-interactive \
  --name "${runners_name}" \
  --url "${gitlab_url}" \
  --registration-token "${runners_token}" \
  --limit ${runners_limit} \
  --executor "docker+machine" \
  --docker-image "${runners_image}" \
  --docker-privileged="${runners_privilled}" \
  --docker-disable-cache="false" \
  --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" \
  --docker-volumes "/cache" \
  --docker-shm-size "0" \
  --cache-type "s3" \
  --cache-s3-server-address "s3.amazonaws.com" \
  --cache-s3-bucket-name "${bucket_name}" \
  --cache-s3-bucket-location "${aws_region}" \
  --cache-s3-insecure="false" \
  --machine-idle-nodes "${runners_idle_count}" \
  --machine-idle-time "${runners_idle_time}" \
  --machine-machine-driver "amazonec2" \
  --machine-machine-name "runner-%s" \
  --machine-machine-options "amazonec2-instance-type=${runners_instance_type}" \
  --machine-machine-options "amazonec2-region=${aws_region}" \
  --machine-machine-options "amazonec2-vpc-id=${runners_vpc_id}" \
  --machine-machine-options "amazonec2-subnet-id=${runners_subnet_id}" \
  --machine-machine-options "amazonec2-zone=${runners_availability_zone}" \
  --machine-machine-options "amazonec2-private-address-only=${runners_use_private_address}" \
  --machine-machine-options "amazonec2-request-spot-instance=true" \
  --machine-machine-options "amazonec2-spot-price=${runners_spot_price_bid}" \
  --machine-machine-options "amazonec2-security-group=${runners_security_group_name}" \
  --machine-machine-options "amazonec2-iam-instance-profile=${instance_profile_name}" \
  --machine-machine-options "amazonec2-tags=environment,${environment}" \
  --machine-machine-options "amazonec2-monitoring=${runners_monitoring}" \
  --machine-machine-options "amazonec2-root-size=${runners_root_size}" \
  --machine-off-peak-timezone "${runners_off_peak_timezone}" \
  --machine-off-peak-idle-count "${runners_off_peak_idle_count}" \
  --machine-off-peak-idle-time "${runners_off_peak_idle_time}" \
  --machine-off-peak-periods "${runners_off_peak_periods}" \
  --run-untagged \
  --locked="false" \
  --tag-list "docker,aws, ${runner_environment_tag}"

service gitlab-runner restart
chkconfig gitlab-runner on
