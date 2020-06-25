
samplefile=firstData_dir/tag1_Dec

cat man_tag1/manual_201912* | awk -F '\t' '{if(!match($0, "分享图片")) print $0} gsub(/分享图片/, "", $0)' | awk -F '\t' '{if(!match($0, "分享视频")) print $0} gsub(/分享视频/, "", $0)' | awk -F '\t' '{if(!match($0, "微视频")) print $0} gsub(/微视频/, "", $0)' | awk '{if(!match($0, "http:")) print $0} gsub(/http:[\/\.0-9a-zA-z]+/, "", $0)' | awk -F '\t' '{if(length($4)>8) print $0}' | sort -u > tmpfile
grep -v 分享我的故事 tmpfile | grep -v 此微博已被删除 | grep -v 戳这里 | grep -v 微博故事 | grep -v newTagCategory_999 > $samplefile

shuf $samplefile > tmpfile
mv tmpfile $samplefile

all_cnt=`awk 'END{print NR}' $samplefile`
traincnt=`expr $all_cnt / 10 \* 9`
testcnt=`expr $all_cnt / 9`
head -$traincnt $samplefile > $samplefile.train
tail -$testcnt $samplefile > $samplefile.test
