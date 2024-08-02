# Helper file for managing .bashrc (and don't forget it!).
# Add a line `source ${HOME}/bashrc` to the end of .bashrc.
# Follow the instructions below to enable some software.

# Support parallelism.
export OMPI_MCA_btl_vader_single_copy_mechanism=none

# It is generally usefull to have this for many reasons.
export PATH="${HOME}/.local/bin:${PATH}"

# If you need Cantera, uncomment next line.
# source /opt/cantera/bin/setup_cantera

# If you need OpenCalphad, uncomment next lines.
# export OCHOME=/opt/opencalphad
# export PATH="${OCHOME}:${PATH}"

# If you need OpenFOAM, uncomment ONE of the next lines.
# source /usr/lib/openfoam/openfoam2112/etc/bashrc
# source /opt/openfoam9/etc/bashrc

# If you need SU2, uncomment next line.
# source /opt/SU2/bashrc

# If you installed Rust, uncomment next line.
# source ${HOME}/.cargo/env

# Practical aliases
alias ls='ls --color=auto'
alias ll='ls -alh'
alias l='ls -lh'
alias cls='clear'
alias pip='pip3'
alias python='python3'
alias ipython='ipython3'
