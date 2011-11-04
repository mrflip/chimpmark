
Your goal is to have the

* your IO bus fully saturated, but without contention
* the CPU needle pegged to 100% on all cores, but without task thrashing
* RAM fully utilized, but without swapping

Assumptions

* The machine has no swap (or that if it does, we don't ever want to be using it)
* The machines are fully dedicated to hadoop; there is no contention for memory or CPU with other processes.

We'll discuss three different clusters:

* The *balanced cluster*: this has to give reasonable performance on all types of tasks: memory-intensive, io-intensive, cpu-intensive.
* The *map-heavy cluster*: runs CPU-bound tasks, many of which run with either zero reducers or very CPU-modest reducers (eg only a uniq pass on the reduce). Examples of this: parsing terabytes of HTML or log files, or pushing data throug a machine-learning or corpus-analysis 'black box'. These jobs imply very low memory demands, little worry about spill protection, and the need to maximize map-side CPU utilization.
* The *reduce-bound cluster*: severe memory constraints on the reduce side, and minimal CPU load all around.  This cluster needs to optimize sort and shuffle, pay close attention to IO and maximize efficient use of memory, especially on the reduce side.

h2. How many tasks?

h3. How to set defaults

You should set the number of map and reduce tasks so that it fully utilizes the CPU:

  mapred.tasktracker.map.tasks.maximum    := node_map_tasks
  mapred.tasktracker.reduce.tasks.maximum := node_reduce_tasks
  node_tasks = node_map_tasks + node_reduce_tasks
  cluster_

You want the number of running tasks to be the same as the number of cores.

* For the _map-heavy cluster_, set node_map_tasks to the number of cores. Depending on your memory constraints, set the reducers as low as 1 or 2. You'll lose some performance if your mappers have all finished and only the reducers are running, but benefit from full utilization on the heavier map phase.

* For the _reduce-bound cluster_, let the memory constraints govern the number of tasks.

* If you have very short tasks -- a few seconds, short enough that job setup time is significant -- run slightly more mappers than you would otherwise. (My un-measured guess is one extra mapper + another per 8 cores).
** Also consider setting @mapred.job.reuse.jvm.num.tasks := -1@. If this is 1 (the default), then JVMs are not reused (1 task per JVM). If it is -1, there is no limit to the number of tasks a JVM can run (of the same job). One can also specify some value greater than 1.

* If you are running in a streaming context, you might want to run either fewer or more tasks per node! Start with the defaults and follow tuning instructions below.

* Swapping and Java VM options: http://www.mail-archive.com/common-user@hadoop.apache.org/msg05462.html

If you have a lot of data coming off Amazon s3, you may want to turn up mapred.min.split.size. The default block size for the s3hdfs is 32MB; a 1TB input dataset gives 30k map tasks -- yikes! Instead, bump the mapred.min.split.size up. With a high-memory low-cpu machine like the m2.xlarge (our machine of choice) you can set this as large as 512MB, turning up the io.sort.mb (so that you don't get spill) and bob's your uncle.

h3. Cluster and per-job limits on tasktracker slots

* mapred.tasktracker.reduce.tasks.maximum          1
* mapred.tasktracker.map.tasks.maximum             2
* mapred.max.reduces.per.node                     -1
* mapred.max.maps.per.node                        -1  -- can be set per-job. see https://issues.apache.org/jira/browse/HADOOP-5170
* mapred.max.maps.per.cluster                     -1
* mapred.max.reduces.per.cluster                  -1  -- can be set per-job. see https://issues.apache.org/jira/browse/HADOOP-5170
* mapred.jobtracker.maxtasks.per.job              -1  -- used chiefly as a cap to protect jobtracker VM from overheating

h3. Tuning checks

A definition: _Active worker_ means either the task workers or (if streaming) its child process -- that is, not the tasktracker or the datanode, and not any other job on the machine

* Visit one or two random nodes and launch @htop@. Follow its progress through the whole job.
** Only active workers should consume more than a few percent of CPU. 
** You'd like to see the CPU meter pegged at 100% on all cores. This means there are enough tasks running.
** Each active worker should be trying to use 100% of its core. On the _map-heavy cluster_, active workers should be sitting at 60-100% of CPU. On the _balanced cluster_, 40% or more is OK. On the _reduce-bound cluster_, we don't care too much. If your typical situation is something like '10 active workers on two cores, each using 18%', consider lowering the number of total tasks.

* watch the logs -- anything funny crop up?

* how much time is spent in the reducer -- both from the point the last mapper completes, and from the point in each reducer that its copy completes? If this is short relative to everything else, you can afford fewer reducers than cores.


h2. How much memory

h3. Parameters in question

* @java_max_heap@: the @-Xmx=XXXm@ parameter in @mapred.child.java.opts@. Memory cap for the worker java processes
* @mapred.child.ulimit@: max memory for the worker process and all child processes (for instance, streaming workers).
* @node_tasks@: may need to be reduced 

* @HADOOP_HEAPSIZE@ in hadoop_env.sh

You can count on your input being one block big in general:

<pre>
  dfs.block.size    := 134217728    # 128M
  fs.s3.block.size  :=  67108864
  avg_map_input_mb   = 128
</pre>

* a smaller block size will lead to more map tasks per job
* a larger block size will lead to early spill and more map-side memory pressure

mapred.job.reduce.input.buffer.percent
mapred.job.shuffle.input.buffer.percent
mapred.job.shuffle.merge.percent
mapred.job.reduce.markreset.buffer.percent
mapred.inmem.merge.threshold                    1000


* mapred.reduce.parallel.copies -- Reducer threads for copying from mapper.  Unclear when this should be increased -- should it be ~ equal to number of map_tasks?

* mapred.job.tracker.handler.count              10  -- The number of server threads for the JobTracker. 
* dfs.namenode.handler.count                    10  -- rec 64
* dfs.datanode.handler.count                     3  -- set this to about 1.5*node_tasks (assuming 1 datanode per node_tasks workers, this should establish a good equilibrium number of handlers)
* tasktracker.http.threads                      66  -- rec 40

* mapred.local.dir -- a _local_ path. point it to a fast local drive, preferably several
* hadoop.tmp.dir -- a _local_ path. point it to a fast local drive.

mapred.reduce.copy.backoff                      300

mapred.merge.recordsBeforeProgress              10000

mapred.output.compress
io.seqfile.sorter.recordlimit           1000000
io.seqfile.compress.blocksize           1000000

io.mapfile.bloom.size
io.mapfile.bloom.error.rate
io.file.buffer.size                             65536    -- a solid default
local.cache.size                           10_737_418_240
pig.spill.size.threshold                        5 000 000
pig.spill.gc.activation.size                   40 000 000
topology.script.number.args

raw comparators

mapred.task.profile
mapred.task.profile.params

file descriptor ulimit
java.net.preferIPv4Stack=true

In practice, we just use the the total tasks' heap size  to :

<pre>
  node_tasks * java_max_heap =~ 0.9 * available ram
</pre>

This mapred.child.ulimit  defends against a runaway child task eating all your ram. It must be *greater than* java_max_heap. Set it at 2 to 3 times the java_max_heap -- give yourself some breathing room, as you can adjust the mapred.java.child.opts per-job but not the mapred.child.ulimit limit.


The total sort buffers for all must fit in heap with room to spare. There's more discussion of java_max_heap below, under 'JVM Tuning'.

<pre>
  io.sort.mb << java_max_heap
</pre>

<pre>
  echo 1   > /proc/sys/vm/overcommit_memory
  echo 100 > /proc/sys/vm/overcommit_ratio
</pre>
  

h3. Minimize map-side spills


This is good:

<pre>
        2010-07-10 19:29:07,386 INFO org.apache.hadoop.mapred.MapTask: io.sort.mb = 280
        2010-07-10 19:29:07,906 INFO org.apache.hadoop.mapred.MapTask: data buffer = 164416720/205520896
        2010-07-10 19:29:07,906 INFO org.apache.hadoop.mapred.MapTask: record buffer = 4404019/5505024
        2010-07-10 19:30:02,565 INFO org.apache.hadoop.mapred.MapTask: Starting flush of map output
        2010-07-10 19:30:08,091 INFO org.apache.hadoop.util.NativeCodeLoader: Loaded the native-hadoop library
        2010-07-10 19:30:08,093 INFO org.apache.hadoop.io.compress.zlib.ZlibFactory: Successfully loaded & initialized native-zlib library
        2010-07-10 19:30:08,094 INFO org.apache.hadoop.io.compress.CodecPool: Got brand-new compressor
        2010-07-10 19:30:43,144 INFO org.apache.hadoop.mapred.MapTask: Finished spill 0
        2010-07-10 19:30:43,147 INFO org.apache.hadoop.mapred.TaskRunner: Task:attempt_201007101502_0006_m_000040_0 is done. And is in the process of commiting
        2010-07-10 19:30:43,150 INFO org.apache.hadoop.mapred.TaskRunner: Task 'attempt_201007101502_0006_m_000040_0' done.
</pre>

This is bad:

<pre>
        2010-07-10 20:37:31,355 INFO org.apache.hadoop.mapred.MapTask: io.sort.mb = 280
        2010-07-10 20:37:31,816 INFO org.apache.hadoop.mapred.MapTask: data buffer = 164416720/205520896
        2010-07-10 20:37:31,816 INFO org.apache.hadoop.mapred.MapTask: record buffer = 4404019/5505024
        2010-07-10 20:38:22,882 INFO org.apache.hadoop.mapred.MapTask: Spilling map output: record full = true
        2010-07-10 20:38:22,882 INFO org.apache.hadoop.mapred.MapTask: bufstart = 0; bufend = 100992858; bufvoid = 205520896
        2010-07-10 20:38:22,882 INFO org.apache.hadoop.mapred.MapTask: kvstart = 0; kvend = 4404019; length = 5505024
        2010-07-10 20:38:48,302 INFO org.apache.hadoop.util.NativeCodeLoader: Loaded the native-hadoop library
        2010-07-10 20:38:48,303 INFO org.apache.hadoop.io.compress.zlib.ZlibFactory: Successfully loaded & initialized native-zlib library
        2010-07-10 20:38:48,304 INFO org.apache.hadoop.io.compress.CodecPool: Got brand-new compressor
        2010-07-10 20:39:13,523 INFO org.apache.hadoop.mapred.MapTask: Finished spill 0
        2010-07-10 20:39:49,654 INFO org.apache.hadoop.mapred.MapTask: Spilling map output: record full = true
        2010-07-10 20:39:49,654 INFO org.apache.hadoop.mapred.MapTask: bufstart = 100992858; bufend = 201882339; bufvoid = 205520896
        2010-07-10 20:39:49,654 INFO org.apache.hadoop.mapred.MapTask: kvstart = 4404019; kvend = 3303013; length = 5505024
        2010-07-10 20:40:39,941 INFO org.apache.hadoop.mapred.MapTask: Finished spill 1
        2010-07-10 20:41:03,286 INFO org.apache.hadoop.mapred.MapTask: Starting flush of map output
        2010-07-10 20:41:33,125 INFO org.apache.hadoop.mapred.MapTask: Finished spill 2
        2010-07-10 20:41:33,354 INFO org.apache.hadoop.mapred.Merger: Merging 3 sorted segments
        2010-07-10 20:41:33,359 INFO org.apache.hadoop.io.compress.CodecPool: Got brand-new decompressor
        2010-07-10 20:41:33,361 INFO org.apache.hadoop.io.compress.CodecPool: Got brand-new decompressor
        2010-07-10 20:41:33,362 INFO org.apache.hadoop.io.compress.CodecPool: Got brand-new decompressor
        2010-07-10 20:41:33,362 INFO org.apache.hadoop.mapred.Merger: Down to the last merge-pass, with 3 segments left of total size: 925614 bytes
        2010-07-10 20:41:34,832 INFO org.apache.hadoop.mapred.Merger: Merging 3 sorted segments
        2010-07-10 20:41:34,835 INFO org.apache.hadoop.mapred.Merger: Down to the last merge-pass, with 3 segments left of total size: 857190 bytes
        2010-07-10 20:41:36,085 INFO org.apache.hadoop.mapred.Merger: Merging 3 sorted segments
        2010-07-10 20:41:36,087 INFO org.apache.hadoop.mapred.Merger: Down to the last merge-pass, with 3 segments left of total size: 902202 bytes
        ... another 100+ seconds in merge ...
</pre>

You'd like to have only one spill per map task. Sez @tlipcon:

bq. "You're unlikely to see a big difference in performance unless you cut down
   the number of spills from >1 to 1, or >io.sort.factor to <io.sort.factor. The
   difference between 3 spills and 5 spills is not huge, in my experience, since
   you're still writing the same amount of data to disk."

To get to the magic one-spill number, run your job for long enough that some mappers complete. In the jobtracker window, follow the link under map/complete in the top table, and visit the counters for a couple tasks. Estimate from there the average map output records and bytes.

<pre>
  avg_record_size        := avg_map_output_bytes / avg_map_output_records
  io.sort.spill.percent  := 0.80 # by default; leave this alone
  io.sort.record.percent  > 16 / (16 + avg_record_size)
  io.sort.mb              > map_output_bytes / ((1 - io.sort.record.percent) * io.sort.spill.percent)
</pre>

* "Increasing io.sort.factor benefits reduce -- the last batch of streams (equal to io.sort.factor) are sent to the reduce function without merging" [2]
* Is there some benefit to having io.sort.factor > num nodes?

<pre>
  def calc_io_sort_options map_output_bytes, map_output_recs
    io_sort_record_percent = 16 / (16 + (map_output_bytes.to_f / map_output_recs.to_f))
    # edge it up a little, and round
    io_sort_record_percent = (105 * io_sort_record_percent).round / 100.0
    io_sort_spill_percent  = 0.80
    io_sort_bytes          = map_output_bytes / (io_sort_spill_percent * (1 - io_sort_record_percent))
    io_sort_mb             = io_sort_bytes / (1024*1024)
    { :io_sort_record_percent => io_sort_record_percent,
      :io_sort_mb             => io_sort_mb,
      :io_sort_factor         => io_sort_mb / 10.0,
      :io_sort_spill_percent  => io_sort_spill_percent,
    }
  end
</pre>


h3. Reduce-side spills

  fs.inmemory.size.mb           determines size of merge buffer allocated by the framework
  io.sort.factor                number of segments to keep in memory before writing to disk



h3. JVM Tuning

# -XX:+UseCompressedOops -XX:MaxNewSize=200m -XX:+UseParallelGC -XX:ParallelGCThreads=2
# -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode
# -server -XX:+AggressiveOpts 
# export HADOOP_OPTS=-server 

* Don't set the heap size to totally stack up the machine -- you need to leave some overhead for system cache and buffers -- it's possible to totally hose throughput by putting the machine into IO-contention hell.
* If you are on Linux and run no swap, you *definitely* want to fix the vm @overcommit_memory@ and @overcommit_ratio@. If you do run swap, you should also look at the vm's @swappiness@ setting.
* If you blindly increase the heap size, 

#                     -XX:+UseParallelGC -XX:ParallelGCThreads=2 -XX:MaxNewSize=200m
# -XX:SurvivorRatio=8 -XX:+UseParallelGC -XX:ParallelGCThreads=20 -XX:+UseParallelOldGC
# Use NUMA if available (-XX:+UseNUMA)
# and -XX:+UseTLAB

* JVM to use -XX:+UseLargePages needs to set kernel options too: http://andrigoss.blogspot.com/2008/02/jvm-performance-tuning.html
* 
* Java GC tuning: http://java.sun.com/javase/technologies/hotspot/gc/gc_tuning_6.html#icms
** -XX:+UseConcMarkSweepGC -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+HeapDumpOnOutOfMemoryError -Xloggc:/var/log/hadoop/gc-hadoop.log
** Scott Carey: "I have found some notes that suggest that -XX:-ReduceInitialCardMarks will 
work around some known crash problems with 6u18, but that may be unrelated."


h2. IO optimization


h3. Map-side compression

  mapred.compress.map.output	        true
  mapred.output.compress	        false
  mapred.map.output.compression.codec
  mapred.output.compression.codec	org.apache.hadoop.io.compress.DefaultCodec
  mapred.output.compression.type	BLOCK



h2. Avoiding Master process bottlenecks


tasktracker.http.threads

mapred.reduce.slowstart.completed.maps
mapred.map.tasks.speculative.execution  true


h2. Other tuning

????

h2. References:

[1] Hadoop Performance Tuning - Milind Bhandarkar, Suhas Gogate, Viraj Bhat
[2] Sanjay Sharma Advanced Hadoop Tuning and Optimizations  http://www.slideboom.com/presentations/116540/PPT-on-Advanced-Hadoop-Tuning-n-Optimisation
[3] Todd Lipcon, many helpful advice sessions on #hadoop IRC
[4] http://www.mentby.com/todd-lipcon/iosortmb-configuration.html
[5] http://www.cloudera.com/blog/2009/03/configuration-parameters-what-can-you-just-ignore/
