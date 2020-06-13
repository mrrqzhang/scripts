
import sys

for line in sys.stdin:
    fields = line.strip('\r\t\n').split('\t')
    mid = fields[0]
    text = fields[1]
    tags = fields[2].split(',')
    labels = fields[3].split(',')
    scores = fields[4:]
    for tag,label,score in zip(tags, labels, scores):
        sys.stdout.write('%s\t%s\t%s\t%s\t%s\t%s\n' % (mid, text,tag, label,  str(1-float(score)), score))
