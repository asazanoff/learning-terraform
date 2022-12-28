#cloud-config
users:
  - name: admin
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
      
package_update: true

packages:
  - apache2

runcmd:
  - host_name=`curl http://169.254.169.254/latest/meta-data/hostname`
  - myip=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
  - echo "<h2>Web server $host_name with ip $myip</h2><br>Built by Terraform<br>Owner is ${ownerName}" > /var/www/html/index.html
  - sudo service httpd start