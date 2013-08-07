#!/bin/bash
# Get su permission
sudo su

# Clone the repo
git clone https://github.com/phalcon/cphalcon.git
cd cphalcon

# Get our HEADs to test is an update is necessary
touch /tmp/phalcon-head
INSTALLED_HEAD=$(cat /tmp/phalcon-head)
REPO_HEAD=$(cat .git/refs/heads/master)

if [ "$INSTALLED_HEAD" == "$REPO_HEAD" ]; then
    # Nothing to do here
    echo
    echo 'PHP extension for Phalcon is up to date'
    echo
else
    # Install/Update Phalcon
    echo
    echo 'Building Phalcon'
    echo

    # Run build script
    cd build
    ./install
    wait

    if [ ! -f '/etc/php5/mods-available/phalcon.ini' ]; then
        # Ensure extension is loaded for php-cli and php-fpm
        echo 'extension=phalcon.so' > /etc/php5/mods-available/phalcon.ini
        ln -s /etc/php5/mods-available/phalcon.ini /etc/php5/cli/conf.d/phalcon.ini
        ln -s /etc/php5/mods-available/phalcon.ini /etc/php5/fpm/conf.d/phalcon.ini
    fi

    # Restart php5-fpm and nginx
    echo
    echo 'Restarting web services'
    echo
    service php5-fpm restart
    service nginx restart

    # Update the file that contains the installed HEAD
    cd ../
    cat .git/refs/heads/master > /tmp/phalcon-head

    echo
    echo 'PHP extension for Phalcon has been updated'
    echo
fi

if [ ! -f "/usr/local/bin/phalcon.php" ]; then
    echo
    echo 'Installing/Upating Phalcon dev-tools'
    echo

    git clone https://github.com/phalcon/phalcon-devtools.git /usr/local/bin
    cd /usr/local/bin
    . ./phalcon.sh
    rm phalcon
    ln -s /usr/local/bin/phalcon.php /usr/local/bin/phalcon
fi

# Clean up
exit
cd /home/`whoami`
sudo rm -rf cphalcon