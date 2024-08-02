#!/usr/bin/env bash

function add_user_and_chg_pass()
{
    if id "$1" > /dev/null 2>&1; then
        echo "user found: $1"
    else
        useradd -m -s /bin/bash -G jupyterusers "$1"
        echo "$1:$2" | chpasswd
        ln -s /home/share /home/$1/
    fi

    cp README.md /home/$1/

    if [[ ! -f "/home/$1/bashrc.sh" ]]; then
        cp bashrc.sh /home/$1/
        chown $1:$1 /home/$1/bashrc.sh
        echo "source /home/$1/bashrc.sh" >> /home/$1/.bashrc
    fi

    OCTAVE_JUPTER="/home/$1/.jupyter/octave_kernel_config.py"

    if [[ ! -f $OCTAVE_JUPTER ]]; then
        echo "c.OctaveKernel.inline_toolkit = 'gnuplot'" >> $OCTAVE_JUPTER
    fi
}

[[ ! -d /home/share/ ]] && mkdir /home/share/
chown -R :jupyterusers /home/share
chmod 1770 /home/share

add_user_and_chg_pass "user" "SecretPass*1234"
