#--------[ UserDir ]-------------------------------------------------
[ "$LOGNAME" = "g178241" ] && HOME=~hugues

#--------[ Hashes ]-------------------------------------------------
hash -d work=~/Wr0k
hash -d targets=/targets
hash -d tools=~work/t00lz

#--------[ Generic Config ]-----------------------------------------
eval $(~tools/sagem-script44/set-env.pl 2>/dev/null) && source ~/.env

#--------[ Specific Config ]----------------------------------------
export STLINUXRELEASE=${STLINUXRELEASE:-2.3}

export TARGET_PATH=~targets/target
export KERNEL_PATH_BASE=~work/Kernel/exports/kernel-
export COMP=ARCH=sh\ CROSS_COMPILE=sh4-linux-
export STLINUXBASE=/opt/STM/STLinux-$STLINUXRELEASE
export STLINUXROOT=$STLINUXBASE/devkit/sh4/

export THIRDPARTYLIBS=~work/3rdparty/lib

export PATH=$PATH:$STLINUXROOT/bin
export PATH=$PATH:$STLINUXBASE/host/bin
export PATH=$PATH:/opt/STM/ST40R3.1.1_patch1/bin
export PATH=~/local/bin:~/local/sbin:$PATH

export FORGE=http://g178241@forge-urd44.osn.sagem/svn/

export GET_KERNEL_METHOD=update

#--------[ Shared Folders ]-----------------------------------------
hash -d K:=/media/osn01001/Projets_STB
hash -d J:=/media/osn02001/Echanges
