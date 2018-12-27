---
layout: post
title: "Introduction to BigData, Hadoop and Spark "
date: 2018-12-27 16:00:00
categories: hadoop
tags: bigdata hadoop spark
comments: true
---

Everyone is speaking about *Big Data* and *Data Lakes* these days. Many technical folks see [Apache Spark][spark-web] as *the* solution to *every* problem. At the same time, [Apache Hadoop][hadoop-web] has been around since [more than 10 years][hadoop-wiki] now and won't go away anytime soon. In this blog post I want to give a brief introduction to Big Data, demystify some of the main concepts such as Map Reduce, and highlight the similarities and differences between Hadoop and Spark.

## Big Data

Big Data is everywhere, we hear it everywhere and we use it everywhere. But what does it actually mean and what precisely can we do with it? We will try to answer these 2 questions in this section.

### What is Big Data

What is *Big Data*? Have you ever heard of the popular definition of Big Data with the 3 **V**s? This definition is very common and can be found in many text books and [Wikipedia][bigdata-wiki]. It suggests that your data is *Big* data when one (or all - depending on the definition) of the following criteria are fulfilled:

* **V**olume
* **V**elocity
* **V**ariety

I find this definition very concise and understandable but a bit imprecise which is probably intentional. Here is a more practical definition of what the 3 **V**s stand for, based on my own experiences.

*Volume* describes a large amount of data you want to store, process or analyze. If we are speaking in terms of 100s of GBs to TBs to PBs then we are speaking about Big Data. An important rule of thumb is also the increase of the data. When your data is growing multiple GBs per day, it is probably Big Data.

*Velocity* means a high data throughput you want to store, process or analyze; often a large amount of data over a short period of time. When we are dealing with processing of 10.000s to 100.000s to millions of records per second, then we are speaking of Big Data.

*Variety* stands for the large amount of different data types that can be stored, processed or analyzed. This means we want to process any kind of data, be it binary, text, structured, unstructured, compressed, uncompressed, nested, flat, etc.

*Big Data* systems are distributed systems that are built to handle these types of data of high volume, velocity and variety. Apache Hadoop and Apache Spark are popular Big Data frameworks for large-scale distributed processing. We will learn the similarities and differences in the following sections.

### What can we do with Big Data

The reason for using Big Data systems is to store and process massive amounts of data. We can categorize these efforts into 3 different use-cases of increasing difficulty. The use cases are:

* Analytics
* Prediction
* Modeling

In classical *Analytics*, we analyze the past. In Big Data, we analyze massive amounts of data from the past. A typical question to answer with analytics could be to compute the number of visitors of the previous season based on all bookings of said season.

In *Prediction*, we analyze the past to build a model that can predict the future (are other unknowns). We often use statistical methods (such as Logistic Regression, etc.) as well as Machine Learning (SVM, Gradient Boosted Trees, Deep Learning, etc.) techniques to build these models. A typical question to answer with prediction could be to forecast the number of visitors for the next season based on all bookings of all previous seasons.

*Modeling* builds on both analytics and prediction capabilities. In *Modeling*, the aims is to analyze the past and build a model to predict different possibilities of the future depending on the model parameters. These models are often more complicated than a simple statistical or Machine Learning model and take into account multiple state variables and parameters that can be modified. A typical question to answer with modeling could be to forecast the number of visitors for the next season if the winter will be two weeks shorter based on all bookings of all previous seasons plus loads of additional data sources (weather data, etc.).

## Hadoop: HDFS, Yarn and MapReduce

[Apache Hadoop][hadoop-web] is a framework for storing and processing massive amounts of data on commodity hardware. It is a collection of services that sit together in the [Hadoop repository][hadoop-repo].

* Hadoop FileSystem (HDFS): a distributed file system
* Apache Yarn: a cluster resource manager
* MapReduce: a high-level framework for distributed processing

**HDFS** (Hadoop FileSystem) is a distributed filesystem that stores and replicates data across multiple nodes. HDFS is the open-source implementation of the [Google File System (GFS)][gfs-paper] paper published by Jeff Dean and Sanjay Ghemawat in 2003. It consists of a *name node* (master) and multiple *data node* services (client, usually 1 per node). The *name node* stores the references to the data blobs and takes care of the filesystem management, meta operations and file access operations. The *data nodes* are responsible for storing the data blobs on the local filesystem of the nodes.

**MapReduce** is a [theoretical concept for distributed processing][mapreduce-paper] published by Jeff Dean and Sanjay Ghemawat in 2004 and an open-source implementation in the repository of Apache Hadoop. Both, the  open-source implementation of MapReduce as well as HDFS were a cornerstone of Hadoop 1 and responsible for its success. We will learn a bit more about the MapReduce concept in the subsequent section.

**Apache Yarn** is a distributed resource manager and job scheduler responsible for managing the node resources (CPU and RAM) of the cluster and for scheduling jobs on the cluster. It consists of a *resource manager* (master) and multiple *node manager* services (client, 1 per node). Yarn (acronym for *Yet Another Resource Negotiator*) was added in Hadoop 2 to decouple the MapReduce engine from the cluster resource management.

As an application developer, one usually doesn't communicate with Yarn directly but with a framework or processing/execution engine on top of Yarn such as MapReduce, Tez or Spark. Analysts and Data Scientists often use a higher-level abstraction or API for distributing the code on the cluster and to access the data, such as Hive, Pig or Spark SQL.

Although not managed in the same repository as Apache Hadoop, I often like to mention Apache Zookeeper as another integral building block of Hadoop. **Apache Zookeeper** is a distributed synchronized transaction-based in-memory key-value store. Many Hadoop services use Zookeeper for storing dynamic configuration (available nodes per partition, current master, etc.), leader election, synchronization, and much more.

There are many other services related or included with the Hadoop stack. Most of these service either run on top of HDFS and/or Yarn or leverage Zookeeper for synchronization and leader election. Here is a (small) list of distributed Hadoop services:

* Batch Processing
  - Hive
  - Pig
  - MapReduce
  - Tez
  - Spark
* Stream processing
  - Storm
  - Flink
  - Spark Streaming
* Data Storage
  - HDFS (File Store)
  - HBase (NoSql)
  - Cassandra (NoSQL)
  - Accumulo (NoSQL)
  - Kafka (Log Store)
  - Solr (Inverted Document Index)

Please keep in mind, that some of the above services don't necessarily need the Hadoop stack to run (e.g. Spark can run locally as a single process on top of a local filesystem).

## MapReduce: Map, Reduce and Shuffle

The MapReduce concept is an important milestone in the history of distributed processing. Hence, we will discuss it in a bit more detail in this section.

## Spark: The Evolution of MapReduce

[Apache Spark][spark-web] got [popular in 2014][spark-wiki] as a fast general-purpose compute framework for distributed processing which claimed to be more than 100 times faster than the traditional MapReduce implementation. It provides high level operations for working with distributed data sets which are optimized and executed in-memory of the cluster nodes. Spark runs on top of multiple resource managers such as Yarn or Mesos and can even run locally as a single process (standalone execution mode).

Conceptually, Spark is similar to the other distributed processing frameworks:

* [MapReduce: Simplified Data Processing on Large Clusters][mapreduce-paper]
* [Tez: A Unifying Framework for Modeling and Building Data Processing Applications][tez-paper]
* [Impala: A Modern, Open-Source SQL Engine for Hadoop][impala-paper]
* [Spark: A Fault-Tolerant Abstraction for In-Memory Cluster Computing][spark-paper]

*Apache Tez* (Tez is Hindi for *speed*) is [a faster MapReduce engine][tez-blog] based on Apache Yarn that optimizes complex execution graphs into single jobs to avoid intermediate writes to HDFS. It is the default execution engine powering Apache Pig and Apache Hive (a large scale data warehouse solution on top of Hadoop) on the Hortonworks Hadoop distribution.

*Apache Impala* is a [Big Data SQL engine][impala-web-overview] on top of HDFS, HBase and Hive (Metastore) with its own specialized distributed query engine. It is the default engine for Apache Hive on the Cloudera and MapR Hadoop distributions.

What sets *Apache Spark* aside from the other frameworks, is the in-memory processing engine as well as the rich set of included libraries (GraphX for graph processing, MLib for Machine Learning, Spark Streaming for mini batch streaming, and Spark SQL) and SDKs (Scala, Python, Java, and R). Please note that these libraries are for distributed processing, so distributed graph processing, distributed machine learning, etc. out-of-the-box.

The amazing performance of Spark's in-memory engine comes with a trade-off. Tuning and operating Spark pipelines with varying amounts of data requires a lot of manual configuration, going through log files, and reading books, articles, and blog posts. And since the execution parallelism can be modified in a fine-grained way, one has to configure the number of tasks per JVM, the number of JVMs per worker, and the number of workers as well as all the memory settings (heap, shuffle, and storage) for these executors and the driver.

## Summary

We speak about Big Data, when we speak about large volumes (> 10s GB), high velocity (> 10.000s records/second) or large variety (binary, text, unstructured, compressed, etc.) of data. We use Big Data system to store and process massive data sets, e.g. to perform analytics, predictions or modeling.

Apache Hadoop is a collection of services for large-scale distributed storage and processing, mainly HDFS (a distributed filesystem), Apache Yarn (a cluster resource manager), MapReduce (a processing framework) and Apache Zookeeper (a fast distributed key-value storage).

Apache Spark is a fast (100 times faster than traditional MapReduce) distributed in-memory processing engine with high-level APIs, libraries for distributed graph processing and machine learning, and SDKs for Scala, Java, Python and R. It also has support for SQL and streaming.

## Resources

* [Big Data - Wikipedia][bigdata-wiki]
* [Apache Hadoop - Wikipedia][hadoop-wiki]
* [Apache Spark - Wikipedia][spark-wiki]
* [Apache Spark - Website][spark-web]
* [Apache Hadoop - Website][hadoop-web]
* [Apache Hadoop - Github Repository][hadoop-repo]
* [Apache Impala - Website (Overview)][impala-web-overview]
* [The Google File System (2003)][gfs-paper]
* [MapReduce: Simplified Data Processing on Large Clusters (2004)][mapreduce-paper]
* [Introducing Tez - Hortonworks Blog][tez-blog]
* [Resilient Distributed Datasets: A Fault-Tolerant Abstraction for In-Memory Cluster Computing (2011)][spark-paper]
* [Apache Tez: A Unifying Framework for Modeling and Building Data Processing Applications (2015)][tez-paper]
* [Impala: A Modern, Open-Source SQL Engine for Hadoop (2015)][impala-paper]

[bigdata-wiki]: https://en.wikipedia.org/wiki/Big_data
[hadoop-wiki]: https://en.wikipedia.org/wiki/Apache_Hadoop
[spark-wiki]: https://en.wikipedia.org/wiki/Apache_Spark
[spark-web]: http://spark.apache.org/
[hadoop-web]: https://hadoop.apache.org/
[hadoop-repo]: https://github.com/apache/hadoop
[impala-web-overview]: https://impala.apache.org/overview.html
[gfs-paper]: https://ai.google/research/pubs/pub51
[mapreduce-paper]: https://ai.google/research/pubs/pub62
[spark-paper]: https://www2.eecs.berkeley.edu/Pubs/TechRpts/2011/EECS-2011-82.pdf
[tez-blog]: https://de.hortonworks.com/blog/introducing-tez-faster-hadoop-processing/
[tez-paper]: http://web.eecs.umich.edu/~mosharaf/Readings/Tez.pdf
[impala-paper]: http://cidrdb.org/cidr2015/Papers/CIDR15_Paper28.pdf