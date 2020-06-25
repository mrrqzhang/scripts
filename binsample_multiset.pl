"""
 generate random sample for multiple set by bin
""" 

import sys
from collections import defaultdict
import random

if len(sys.argv)<3:
    print "usage: binsample_multiset.py inputfile #bin #sample #set(optional)" 
    exit -1



#input file dict
dictind=defaultdict(int)  
binnum = int(sys.argv[1]) 
totalnum = int(sys.argv[2])

multisetnum=1
if sys.argv[3]: multisetnum = int(sys.argv[3])

result_set = [[] for i in range(multisetnum) ]
max_cnt=0
with open(sys.argv[0],'r') as f:
    for line in f:
        fields = line.strip('\r\t\n').split('\t')
        lastcnt = float(fields[len(fields)-1])
        dictind[line.strip('\r\t\n')] = lastcnt
        if max_cnt < lastcnt: max_cnt = lastcnt




samplenum=0 ;
samp = int(totalnum/binnum)  ;
if totalnum>samp*binnum: binnum += 1 
step = max_cnt/binnum


loopnum=0 ;
zerobm=0 ;
saved = defaultdict()


while samplenum < totalnum :
      loopnum=0 ;
      zerobm=0 ;
      for bn in range(binnum+1, 1, -1):     
            loopnum++ 
        
            array=[] 
            bs = step*(bn-1) 
            es = step*bn 
            an=0 ;
            key=0 ;
            foreach key in dictind :
                  if key in  saved: continue  #being sampled
                  
                  val = dictind[key] 
                  if val>=bs && val<es :
                      array.append(key) 
                      an += 1 
            if an==0:
                 zerobm += 1
                 if zerobm==loopnum && bn==1: 
                    exit -1 # all bins are empty
                 continue
        
            insert = [ [0] for si in range(multisetnum) ] 
            remains = [ loopnum*samp-len(result_set[i]) for i in range(multisetnum) ]
            if not any(remains): 
                for si in range(multisetnum):
                    print "set1:\n", "\n".join(result_set[si])
                    
            for si in range(multisetnum):
                r = random.randint(0,an)
                if array[r]!=-1 &&  insert[si]<remains[si]:
                    result_set[si].append( array[r] )
                    insert[si]+=1
                    array[r] = -1
                    saved[array[r]] = 1
                    
                    
                    
            while i != remains:
                  r =random.randint(0,an)  
                  if array[r]!=-1  :
                    	print "array[r]\n" 
                    	saved[array[r]]=1 
                    	array[r] = -1 
                    	i += 1 
                    	totalnum += 1 
                    	if totalnum == samplenum :
                    	       exit()
                    	
                    	if i==an:
                    	       break
        




#if($totalnum<$samplenum) { 
#  print "\n\n\n#### Warning: some bin's sample is less than average samples. reduce sample number or reduce bin number. #########\n" ;
#}
  
