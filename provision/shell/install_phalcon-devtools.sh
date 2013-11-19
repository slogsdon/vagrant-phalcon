#!/bin/bash
# Get su permission

echo '### Phalcon dev-tools ###'

sudo su

PTOOLSPATH=/opt/phalcon-devtools

if [ -d "${PTOOLSPATH}/.git" ]; then
    echo
    echo 'Upating Phalcon dev-tools'
    echo

    cd ${PTOOLSPATH}
    git pull --rebase
else
    echo
    echo 'Installing Phalcon dev-tools'
    echo

    if [ -d "${PTOOLSPATH}" ]; then
        ls -A1 ${PTOOLSPATH} | xargs -I {} rm -rf ${PTOOLSPATH}/{}
    else
        mkdir -p ${PTOOLSPATH}
    fi

    git clone --depth=1 https://github.com/phalcon/phalcon-devtools.git ${PTOOLSPATH}

    echo -e "#!/bin/sh\nphp ${PTOOLSPATH}/phalcon.php \$*" > /usr/local/bin/phalcon
    chmod +x /usr/local/bin/phalcon

    if [ -f "/etc/bash.bashrc" ]; then
        echo "PATH=\$PATH:${PTOOLSPATH}" >> /etc/bash.bashrc
        echo "PTOOLSPATH=${PTOOLSPATH}" >> /etc/bash.bashrc
    fi

    if [ -f "/etc/bashrc" ]; then
        echo "PATH=\$PATH:${PTOOLSPATH}" >> /etc/bashrc
        echo "PTOOLSPATH=${PTOOLSPATH}" >> /etc/bashrc
    fi

    if [ -d "/etc/bash_completion.d" ]; then
        ln -sf ${PTOOLSPATH}/phalcon-completion.bash /etc/bash_completion.d/phalcon-completion.bash
    fi
fi


# Clean up
exit

cd /home/`whoami`
