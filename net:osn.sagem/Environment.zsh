#--------[ Hashes ]-------------------------------------------------
hash -d data=~/W0rk
hash -d targets=/targets

#--------[ Generic Config ]-----------------------------------------
eval $(~data/sagem-script44/set-env.pl 2>/dev/null) && source ~/.env

#--------[ Specific Config ]----------------------------------------
export TARGET_PATH=~targets/target
export KERNEL_PATH_BASE=~data/Kernel/kernel-
export COMP=ARCH=sh\ CROSS_COMPILE=sh4-linux-uclibc-
export STLINUXROOT=/opt/STM/STLinux-2.2/devkit/sh4/

export PATH=$PATH:$STLINUXROOT/bin
export PATH=~/local/bin:~/local/sbin:$PATH

#--------[ Shared Folders ]-----------------------------------------
hash -d K:=/media/osn01001/Projets_STB
hash -d J:=/media/osn02001/Echanges
