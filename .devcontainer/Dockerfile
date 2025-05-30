FROM infrastructurebuilder/ansible-container:0.15
ENV HOME="/root"
ENV PATH="${HOME}/.local/bin:${PATH}"
RUN <<SCRIPT1
dnf -y update
echo "alias ll='ls -l'" >> ${HOME}/.bashrc
echo "alias python='python3'" >> ${HOME}/.bashrc
dnf -y install git gcc-c++ python3-devel which
dnf -y install gcc-gfortran
SCRIPT1
