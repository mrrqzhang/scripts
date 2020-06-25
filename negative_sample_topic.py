import sys
import random
from collections import defaultdict

MAX_POS=10000000

topic = []
with open('../data/topic_neg/topic_tag_map.s1') as f:
    for line in f:
        fields = line.strip('\r\t\n').split('\t')
        t = fields[0]
        topic.append(t.strip('#'))

pos_count=defaultdict(int)

count=0
for line in sys.stdin:
    if count>=MAX_POS: break
    mid, text, tag, tid, judge = line.strip('\r\t\n').split('\t')
    if tag not in topic: continue
    if judge == '0': continue
    count += 1
    random_zero = random.sample(topic, 5)
    if pos_count[tag]>=4000: continue
    sys.stdout.write('%s' % line)
    pos_count[tag] += 1
    for neg in random_zero:
        if neg == tag: continue
        sys.stdout.write('%s\n' % '\t'.join([mid, text, neg, tid, '0']))
