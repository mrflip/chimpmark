


Identity mapper         Wukong          `which cat`             pig
Identity reducer        wukong          `which cat`             pig
* no skew
* data/reducer > ram

Do a sort|uniq on 150GB






* 1.8 GB bz2, S3 => HDFS                                1m55s
* 1.8 GB bz2, HDFS => HDFS                              1m10s

TokyoTyrant, 1 node => 4 m1.large (Balancer)            15_000 inserts/sec

TokyoTyrant, 20 tasks => 4 m1.large (Balancer)           2_000 inserts/sec



===========================================================================
