import sys
import tensorflow as tf

tfrecord=sys.argv[1]

for example in tf.python_io.tf_record_iterator(tfrecord):
    result  = tf.train.Example.FromString(example)
    print(result)
#    for key,val in result.features.feature.items():
#        print (key, val)
