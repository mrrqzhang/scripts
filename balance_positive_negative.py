# -*- coding: utf-8 -*-

import sys
from collections import defaultdict

FILE_FIELDS_NUM=5 #input tsv file segments = 4 or 5
MAX_NEG=20000
PN_RATIO=1.2
positive = defaultdict(list)
negative = defaultdict(list)

neg_all = defaultdict(int)

ftrain = open('train.tsv', 'w')
ftest = open('test.tsv', 'w')

for line in sys.stdin:
	fields = line.strip('\r\t\n').split('\t')
	if len(fields)!=FILE_FIELDS_NUM: continue
	key = '\t'.join([fields[0], fields[1]])
	label = fields[2]
	judge = int(fields[FILE_FIELDS_NUM-1])

	if judge==1: positive[label].append((key,1))
	elif judge==0: 
		negative[label].append((key,0))


"""cut neg set"""
for label in negative:
	negative[label] = negative[label][0:MAX_NEG]
	#uniq key
	for key,j in negative[label]: neg_all[key]=1

"""choose testset"""
testset = []
for i,x in enumerate(neg_all.keys()):
	if i%10==0: testset.append(x)


for label in positive:
	pset = positive[label]
	nset = negative[label]
	psub = []
	for s,j in pset:
		if s in neg_all: psub.append((s,j))
		if len(psub) >= PN_RATIO*len(nset): break
	if len(psub)<PN_RATIO*len(nset):
		for s,j in pset:
			if s not in neg_all and (s,j) not in psub: psub.append((s,j))
			if len(psub) >= PN_RATIO*len(nset): break
		#smaller psub set 
		if len(psub)<PN_RATIO*len(nset):
			nset = negative[label][0:int(len(psub)/PN_RATIO)]

	#train+test combined satisfy ballanced requirements
	for s,j in psub+nset:
		#if s in testset:
		#	ftest.write("%s\t%s\t%d\n" % (s, label,j))
		#else:
			ftrain.write("%s\t%s\t%d\n" % (s, label,j))


		
