export m_SVIM=/users/picard/local/share/vim/syntax
export m_VIM_USER_NAME="H. Hiegel"

export LOGCHECK=0 # Don't want to get fucked up by this trick...

hash -d data=/data/$USER
hash -d workset=~data/workset
hash -d targets=/targets/$USER

export TARGET_PATH=~targets/target
export KERNEL_PATH=~data/forge/kernel
source ~/.env
eval $(~data/sagem-script44/set-env.pl 2>&-)
