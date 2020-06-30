export LESS="-x4" #tabspace=4  
export HISTSIZE=  #unlimited
export HISTFILESIZE=  
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8  
export LESSCHARSET=utf-8
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export PYTHONIOENCODING=UTF-8
#export https_proxy=https://httpproxy-res.blue.ygrid.yahoo.com:4080
#export http_proxy=http://httpproxy-res.blue.ygrid.yahoo.com:4080

alias srcbas="source ~/.bashrc"
alias ll="ls -l -r -t"
export hp="echo \`hostname\`:\`pwd\`"
function hpf() {
echo `eval $hp`/$1
}
function pf() {
echo `pwd`/$1
}


export HADOOP_CONF_DIR=/home/gs/conf/current
alias hstream='hadoop jar $HADOOP_HOME/hadoop-streaming.jar -Dmapred.job.queue.name='$QUEUE

alias gpu196='ssh root@10.85.242.196 -p 33'
alias gpu44='ssh root@10.87.216.44 -p 33'
alias gpu17='ssh root@10.87.219.17 -p 33'
alias gpu70='ssh root@10.87.216.70 -p 33'
alias gpu40='ssh root@10.87.216.40'
alias gpu131='ssh root@10.87.52.131 -p 33'
alias tongdao='ssh ruiqiang5@dx1.c.sina.com'
alias python='/usr/local/bin/python3'

alias pip='/usr/local/bin/pip3'

alias do='ssh root@178.128.145.254'
alias jdserver='ssh -p 80 Ruiqiang.Zhang@jps.jd.com'
alias yarnlist="yarn application -list  | grep ruiqiang"
alias yarnkill="yarn application -kill"
alias rm="rm -i"
alias mq="mapred queue -showacls"
alias hfs='hadoop fs'
alias hls='hadoop fs -ls'
alias hrm='hadoop fs -rm'
alias hrmr='hadoop fs -rm -r'
alias hput='hadoop fs -put'
alias hget='hadoop fs -get'
alias hpush='hadoop fs -copyFromLocal'
alias hpull='hadoop fs -copyToLocal'
alias hcat='hadoop fs -cat'
alias hmkdir='hadoop fs -mkdir'
alias hcp='hadoop fs -cp'
alias hchmod='hadoop fs -chmod'
alias hmv='hadoop fs -mv'
alias hgetmerge='hadoop fs -getmerge'
#alias hkill='hadoop job -kill'
alias hkill='mapred job -kill'
alias hlist='hadoop job -list'
alias hstatus='hadoop job -status'
# below from narayanb
alias hstream='hadoop jar $HADOOP_HOME/hadoop-streaming.jar -Dmapred.job.queue.name='$QUEUE
alias hcount='hadoop dfs -count'
alias htext='hadoop fs -text'

# concatenate all part files in given directory
hpartcat () { hadoop fs -cat $1/part-* ; }

# concatenate all part files in given directory, piped to less
hpartless () { hadoop fs -cat $1/part-* | less ; }
# get total size of files in given directory
# note: doesn't recurse, gives only sum of first-level files
#hdu () { hadoop fs -ls $1 | awk '{tot+=$5} END {print tot}' ; }
alias hdu='hadoop fs -du -h'
alias hdjobs='mapred job -list | grep ruiqiang'
alias hdjobsall="mapred job -list"
alias locpy=~/.localpython/bin/python


export JAVA_HOME=$(/usr/libexec/java_home)

PS1="\H [\W] $ "

