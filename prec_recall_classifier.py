"""Calculate binary classifier prec/rec
INPUT format: text tag label score1 scores2
OUTPUT: precision recall
"""

import sys
from collections import defaultdict

NUM_TOP = 4

THRESHOLD=float(0.75)

VC_BERT=False

def calc_count(truth, pred):
	total = defaultdict(int)
	right = defaultdict(int)
	wrong = defaultdict(int)

	for text in set(truth.keys() + pred.keys()):
		true_set = truth[text]
		pred_set = pred[text]
		for label in true_set: total[label] += 1
		for label in pred_set:
			if label in true_set: right[label] += 1
			else: wrong[label] += 1
	return total, right, wrong

def main():
	total = defaultdict(int)
	right = defaultdict(int)
	wrong = defaultdict(int)

	text_truth = defaultdict(list)
	text_prediction = defaultdict(list)

	for line in sys.stdin:
		fields = line.strip('\r\t\n').split('\t')
		text = fields[1]
		label = fields[2]
		ans = int(fields[3])

		tmp = [ (float(x),i) for i,x in enumerate(fields[4:])]
		score, order = sorted(tmp, key=lambda x:x[0], reverse=True)[0]
		if VC_BERT == True:
		    label_list = label.split(' [SEP] ')
		    text_truth[text].append(label_list[ans])
		    if score <THRESHOLD: continue
		#                    print (true_label, label_list[order])
		    text_prediction[text].append((label_list[order], score))
		else:
		    if ans == 1:
		        text_truth[text].append(label)
		    if score <THRESHOLD: continue
		    if order ==1:
	            text_prediction[text].append((label, score))
	            if ans == 0 : print line


	tmp_text_prediction = defaultdict(list)
	for text in text_prediction:
		tmp_sorted = sorted(text_prediction[text], key=lambda x:x[1], reverse=True)
		tmp_text_prediction[text] = [ tmp_sorted[i][0]  for i in range( min(len(tmp_sorted),NUM_TOP) ) ]


	total, right, wrong = calc_count(text_truth, tmp_text_prediction)

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
