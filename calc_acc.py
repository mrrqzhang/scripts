def get_id(x):
	return int(x)
#	for i,v in enumerate(x.split(',')):
#		if int(v)==1: return i

def main():
	total = defaultdict(int)
	right = defaultdict(int)
	wrong = defaultdict(int)

	for line in sys.stdin:
		fields = line.strip('\r\t\n').split('\t')
		labels = fields[3].split(' [SEP] ')
		ans = get_id(fields[4])
		tmp = [ (float(x),i) for i,x in enumerate(fields[5:])]
		score, order = sorted(tmp, key=lambda x:x[0], reverse=True)[0]
		ts = labels[ans]		
		total[ts] += 1
		if score <0.3: continue
		if order == ans:
			right[labels[ans]] += 1
		else:
			wrong[labels[order]] += 1

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

