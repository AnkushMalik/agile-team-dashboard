#!/usr/bin/env bash

echo 'solver.allowVendorChange = true' >> /etc/zypp/zypp.conf

# packages
zypper -q ar -f http://download.opensuse.org/repositories/devel:/languages:/ruby/openSUSE_Leap_42.2/devel:languages:ruby.repo
zypper -q --gpg-auto-import-keys --non-interactive ref
zypper -q -n in -t pattern devel_basis
zypper -q -n in libopenssl-devel readline-devel \
    postgresql94-server postgresql94-devel libxml2-devel libxslt-devel ruby2.4-devel \
    python-matplotlib python-matplotlib-tk python-PyYAML

# Download font needed by Trollolo to avoid warnings
wget -O ~/.fonts/Humor-Sans.ttf "https://github.com/shreyankg/xkcd-desktop/raw/master/Humor-Sans.ttf"
rm ~/.cache/matplotlib/fontList.cache

# postgresql
echo -e "\nsetting up postgresl...\n"
systemctl start postgresql
systemctl enable postgresql

sed -i 's/local.*all.*all.*peer/local    all         all                               trust/' /var/lib/pgsql/data/pg_hba.conf
sed -i 's/host.*all.*all.*32.*ident/host    all         all          127\.0\.0\.1\/32         trust/' /var/lib/pgsql/data/pg_hba.conf
sed -i 's/host.*all.*all.*128.*ident/host    all         all         ::1\/128               trust/' /var/lib/pgsql/data/pg_hba.conf

systemctl restart postgresql

echo -e "\nsetting up ruby...\n"
su - vagrant -c "ln -sf /usr/bin/ruby.ruby2.4 /home/vagrant/bin/ruby"

echo -e "\ndisabling versioned gem binary names...\n"
echo 'install: --no-format-executable' >> /etc/gemrc

echo -e "\ninstalling your bundle...\n"
gem.ruby2.4 install bundler
gem.ruby2.4 install foreman
su - vagrant -c "cd /vagrant/; bundle install"

echo -e "\nSetting up your database from config/database.yml...\n"
cp /vagrant/config/database.yml.example /vagrant/config/database.yml
su - postgres -c 'psql -c "create role bsteam with superuser createdb login;";'
su - postgres -c "psql -c \"alter role bsteam with password 'opensuse';\";"

su - vagrant -c "cd /vagrant/; bundle exec rake db:setup"

echo -e "\nProvisioning of your TEAM DASHBOARD rails app done!"
echo -e "To start your development TEAM DASHBOARD run: vagrant exec foreman start\n"
