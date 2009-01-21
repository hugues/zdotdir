#--------[ UserDir ]-------------------------------------------------
[ "$LOGNAME" = "g178241" ] && HOME=~hugues

#--------[ Hashes ]-------------------------------------------------
hash -d work=~/Wr0k
hash -d targets=/targets
hash -d tools=~work/t00lz

#--------[ Generic Config ]-----------------------------------------
#eval $(~tools/sagem-script44/set-env.pl 2>/dev/null)
source ~/.env

#--------[ Specific Config ]----------------------------------------

#STLinux 2.2
#export STLINUXRELEASE=${STLINUXRELEASE:-2.2}
#export ST40RELEASE=${ST403RELEASE:-3.1.1_patch1}
#STLinux 2.3
export STLINUXRELEASE=${STLINUXRELEASE:-2.3}
export ST40RELEASE=${ST403RELEASE:-4.1.1}

export STLINUXBASE=/opt/STM/STLinux-$STLINUXRELEASE
export STLINUXROOT=$STLINUXBASE/devkit/sh4/

export FORGE=http://g178241@forge-urd44.osn.sagem/svn/
export GET_KERNEL_METHOD=update

export KERNEL_PATH_BASE=~work/Kernel/exports/
export COMP=ARCH=sh\ CROSS_COMPILE=sh4-linux-
export TARGET_PATH=~targets/target


export THIRDPARTYLIBS=~work/3rdparty/lib

export PATH=$PATH:$STLINUXROOT/bin
export PATH=$PATH:$STLINUXBASE/host/bin
export PATH=$PATH:/opt/STM/ST40R$ST40RELEASE/bin
export PATH=~/local/bin:~/local/sbin:$PATH

#--------[ Shared Folders ]-----------------------------------------
hash -d K:=/media/osn01001/Projets_STB
hash -d J:=/media/osn02001/Echanges
