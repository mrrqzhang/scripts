perl /home/ruiqiang/scripts/shiftyp2.pl |\
awk 'BEGIN{FS="\t"}{printf "%s\t%s\t%s\n",$2,$1,$4}' |\
sort |\
 awk 'BEGIN{FS="\t"}{if(NR==1){first=$1"\t"$2; num=$3; } else{if(first==$1"\t"$2) num+=$3; else {print first"\t"num; first=$1"\t"$2;num=$3}}}END {print first"\t"num}'

