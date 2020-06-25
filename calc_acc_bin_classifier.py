"""Calculate binary classifier prec/rec
INPUT format: text tag label score1 scores2
OUTPUT: precision recall
"""

import sys
from collections import defaultdict

THRESHOLD=0.9
def main():
	total = defaultdict(int)
	right = defaultdict(int)
	wrong = defaultdict(int)

	for line in sys.stdin:
		fields = line.strip('\r\t\n').split('\t')
                label = fields[2]
		ans = int(fields[3])
                
		tmp = [ (float(x),i) for i,x in enumerate(fields[4:])]
		score, order = sorted(tmp, key=lambda x:x[0], reverse=True)[0]
                if ans == 1:
		    total[label] += 1
		    if score < THRESHOLD: continue
		    if order == 1:
			right[label] += 1
		    else:
			wrong[label] += 1
                else:
                    if score <THRESHOLD: continue
                    if order ==1 :
                        print(line)
                        wrong[label] += 1

	sum_tn,sum_rn,sum_wn=0,0,0
	for key in total.keys():
		tn = total[key]
		rn = 0 if key not in right else right[key]
		wn = 0 if key not in wrong else wrong[key]
		sum_tn += tn
		sum_rn += rn
		sum_wn += wn
		if rn==0 and wn==0: continue
		sys.stdout.write('%s\t%d\t%d\t%d\t%f\t%f\n' % (key, rn, wn, tn, rn*1.0/(rn+wn),rn*1.0/tn))
	sys.stdout.write('sum:\t%d\t%d\t%d\t%f\t%f\n' % ( sum_rn, sum_wn, sum_tn, sum_rn*1.0/(sum_rn+sum_wn),sum_rn*1.0/sum_tn))

if __name__ == "__main__": 
	main()

