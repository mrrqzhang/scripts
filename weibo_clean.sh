cat  | awk -F '\t' '{gsub(/分享图片/, "", $0); print $0}' | \
	awk -F '\t' '{gsub(/分享视频/, "", $0); print $0}' | \
	awk -F '\t' '{gsub(/微视频/, "", $0); print $0}' | \
	awk '{gsub(/http:[\/\.0-9a-zA-z]+/, "", $0); print $0}' | \
	#awk -F '\t' '{if(length($0)>8) print $0}' | \
	awk '{if(!match($0, "分享我的故事")) print $0; else {printf "\n"}}' | \
	awk '{if(!match($0, "此微博已被删除")) print $0; else {printf "\n"}}' | \
	awk '{if(!match($0, "戳这里")) print $0; else {printf "\n"}}' | \
	awk '{if(!match($0, "微博故事")) print $0; else {printf "\n"}}' | \
	#remove @..
	#perl -pe 's/@.*?[\s\:]//g' | \
	awk '{gsub(/@[^ ]*/,"",$0);print $0}' | \
	perl -pe 's/\[.*?\]//g' |\
        awk '{n=split($0, a, "#"); for(i=1;i<=n;i++)if(i%2==1)printf "%s",a[i];printf "\n"}' | \
	sed "s/\/\///g" 
	

