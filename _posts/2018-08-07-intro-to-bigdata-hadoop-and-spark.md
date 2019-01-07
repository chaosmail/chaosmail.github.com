---
layout: post
title: "Introduction to BigData, Hadoop and Spark "
date: 2018-12-27 16:00:00
categories: hadoop
tags: bigdata hadoop spark
comments: true
---

Everyone is speaking about *Big Data* and *Data Lakes* these days. Many IT professionals see [Apache Spark][spark-web] as *the* solution to *every* problem. At the same time, [Apache Hadoop][hadoop-web] has been around for [more than 10 years][hadoop-wiki] and won't go away anytime soon. In this blog post I want to give a brief introduction to Big Data, demystify some of the main concepts such as Map Reduce, and highlight the similarities and differences between Hadoop and Spark.

## Big Data

You hear about Big Data everywhere. But what does it actually mean and what precisely can we do with it? We will try to answer these 2 questions in this section.

*EAJ: In this sections I feel like I am missing something about why Big Data is a relevant topic - instead of starting with "what it is", emphasizing why is it relevant might be a good idea. Maybe from a practical example of how a specific problem turned out to be a "big data" problem (not focusing on the solutions, but the nature of the problems). Discuss how these types of problems become more and more frequent - then move on with how to identify them. Just a bit of spitballing...*


### What is Big Data

What is *Big Data*? Have you ever heard of the popular definition of Big Data with the 3 **V**s? This definition is very common and can be found in many text books and [Wikipedia][bigdata-wiki]. It suggests that your data is *Big* data when one (or all - depending on the definition) of the following criteria are fulfilled:

* **V**olume
* **V**elocity
* **V**ariety

I find this definition very concise and understandable but a bit imprecise which is probably intentional. Here is a more practical definition of what the 3 **V**s stand for, based on my own experiences.

*Volume* describes a large *amount of data* you want to store, process or analyze. If we are speaking in terms of 100s of GBs to TBs to PBs then we are speaking about Big Data. An important aspect to consider, the data growth. As a rule of thumb: If your data is growing by multiple GBs per day, you are probably dealing with Big Data.

*Velocity* means a high *data throughput* to be stored, processed and/or analyzed; often a large amount of data over a short period of time. When we are processing thousands to millions of records per second, then we are most likely speaking of Big Data.

*Variety* stands for the large amount of *different data types* that can be stored, processed or analyzed. This means one aims to process any kind of data, be it binary, text, structured, unstructured, compressed, uncompressed, nested, flat, etc. However, *variety* is rather a consequence of Big Data as all data is eventually stored on a distributed file system and so one has to care about different optimized file formats for different use-cases.

*Big Data* systems are built to handle data of high volume, velocity and variety. Apache Hadoop and Apache Spark are popular Big Data frameworks for large-scale distributed processing. We will learn the similarities and differences in the following sections.

> Please note that other definitions vary slightly and you will find 4 or even more **V**s, such as *Veracity* for example. *Veracity* refers to the trustworthiness of the data and hence describes how useful your data actually is. While these extended definitions are relevant for Big Data, they don't necessarily apply *only* to Big Data systems or require *Big Data* systems in my opinion.

### What can we do with Big Data

* Batch Processing
    * Transformation, Join and Aggregation
    * Analytics: (historical) Analytics, Prediction and Modeling
* Stream Processing
    * Transformation, Join and (temporal) Aggregation
    * Analytics: (real-time) Analytics, Inferencing

### Big Data Analytics

The reason for using Big Data systems is to store and process massive amounts of data. We can categorize these efforts into 3 different use-cases of increasing difficulty. The use cases are:

* Analytics
* Prediction
* Modeling

In classical *Analytics*, we analyze historical/observed data. In Big Data, we analyze massive amounts of such data. A typical question to answer with analytics could be how to compute the number of visitors of the previous season based on all bookings of said season.

In *Prediction*, we analyze the past to build a model that can predict the future. In more general terms, one fits a model on a set of training data to use it for inferring any unknown/unseen observation. We often use statistical methods (such as Generalized Linear Models, Logistic Regression, etc.) as well as Machine Learning (SVM, Gradient Boosted Trees, Deep Learning, etc.) techniques to build these models. A typical question to answer with prediction could be how to forecast the number of visitors for the following season based on all bookings of previous seasons.

*Modeling* builds on both analytics and prediction capabilities. In *Modeling*, the aims is to analyze the past and build a model to predict different possibilities of the future depending on the model parameters. These models are often more complicated than a simple statistical or Machine Learning model and take into account multiple state variables and parameters that can be modified. A typical question to answer with modeling could be how to forecast the number of visitors for the following season if the winter will be two weeks shorter based on all bookings of previous seasons plus additional data sources (weather data, etc.).

*EAJ: for me it makes more sense to distinguish between modelling for the purpose of prediction and modelling for the purpose of gaining insights about mechanisms (often about causality). These are two very different goals, which still work well with your examples. I was about to write up something about intepretable parameters and inference, but that is probably going too deep for this post.*

## Hadoop: HDFS, Yarn and MapReduce

[Apache Hadoop][hadoop-web] is a framework for storing and processing massive amounts of data on commodity hardware. It is a collection of services that sit together in the [Hadoop repository][hadoop-repo].

* HDFS: a distributed file system 
* MapReduce: a framework for distributed processing
* Yarn: a cluster resource manager

**HDFS** (Hadoop Distributed File System) is a distributed file system that stores and replicates data in blobs across multiple nodes in a cluster. HDFS is the open-source implementation of the [Google File System (GFS)][gfs-paper] paper published by Jeff Dean and Sanjay Ghemawat at Google in 2003.

HDFS consists of a *name node* and multiple *data nodes*. The *name node* holds the references to the data blobs and takes care of the file system and meta operations whereas the *data nodes* store the data in blobs on the local file system.

**MapReduce** is a high-level framework for distributed processing of large data sets that abstracts developers' code into *Map* (transformation) and *Reduce* (aggregation) operations. By doing so, the code can automatically run in parallel on a distributed system. MapReduce is an open-source implementation of the [MapReduce: Simplified Data Processing on Large Clusters][mapreduce-paper] paper published by Jeff Dean and Sanjay Ghemawat at Google in 2004.

> Due to the same name of the paper and the open-source implementation, the term *MapReduce* can lead to confusion between the original concept and the framework.

Similar to both Google papers, HDFS and MapReduce were designed and developed to function as one single framework for distributed processing of large data sets. MapReduce takes advantage of data replication in HDFS by moving computations to the same physical machine were the data is stored. In Hadoop 1, the MapReduce services ran directly on the *data nodes* without any resource manager.

**Apache Yarn** (acronym for *Yet Another Resource Negotiator*) is a distributed resource manager and job scheduler for managing the cluster resources (CPUs, RAM, GPUs, etc.) and for scheduling and running distributed jobs on a Hadoop cluster. It was introduced in Hadoop 2 to decouple the MapReduce engine from the cluster resource management and allowed more services to run on-top of Hadoop. Hence, instead of starting services on each of the nodes individually one can submit a service to Yarn which takes care of the resource negotiation, distribution of the service to all requested nodes, execution of the service, log collection, etc.

Yarn consists of a *resource manager* service to negotiate cluster resources and multiple *node manager* services that manage the execution of processes on each of the nodes.

Although not managed in the same repository as Apache Hadoop, I often like to mention Apache Zookeeper as another integral building block of Hadoop. **Apache Zookeeper** is a distributed synchronized transaction-based in-memory key-value store. Many Hadoop services use Zookeeper for storing dynamic configuration (available nodes per partition, current master, etc.), leader election, synchronization, and much more.

Nowadays, there are many other services related to or included in the Hadoop stack. Here is a (small) list of distributed services on Hadoop:

* Batch Processing
  - Hive
  - Pig
  - MapReduce
  - Tez
  - Druid
  - Impala
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

Most of these service run on top of Hadoop because they utilize one or more of its components. Typical examples of reused components are:

* HDFS as distributed storage (used in Hive, HBase, etc.)
* Yarn as resource manager (used in Spark, Storm, etc.)
* Zookeeper for synchronization and leader election (used in Kafka, Hive, etc. )
* Hive Metastore as a meta data storage (used in Spark, Impala, etc.)

## Spark: The Evolution of MapReduce

[Apache Spark][spark-web] got [popular in 2014][spark-wiki] as a fast general-purpose compute framework for distributed processing which claimed to be more than 100 times faster than the traditional MapReduce implementation. It provides high level operations for working with distributed data sets which are optimized and executed in-memory of the cluster nodes. Spark runs on top of multiple resource managers such as Yarn or Mesos.

Conceptually, Spark's execution engine is similar to the other distributed processing frameworks:

* [MapReduce: Simplified Data Processing on Large Clusters][mapreduce-paper]
* [Tez: A Unifying Framework for Modeling and Building Data Processing Applications][tez-paper]
* [Impala: A Modern, Open-Source SQL Engine for Hadoop][impala-paper]
* [Spark: A Fault-Tolerant Abstraction for In-Memory Cluster Computing][spark-paper]

*Apache Tez* (Tez is Hindi for *speed*) is [a faster MapReduce engine][tez-blog] based on Apache Yarn that optimizes complex execution graphs into single jobs to avoid intermediate writes to HDFS. It is the default execution engine powering Apache Pig and Apache Hive (a large scale data warehouse solution on top of Hadoop) on the Hortonworks Hadoop distribution.

*Apache Impala* is a [Big Data SQL engine][impala-web-overview] on top of HDFS, HBase and Hive (Metastore) with its own specialized distributed query engine. It is the default engine for Apache Hive on the Cloudera and MapR Hadoop distributions.

As we can see in the following figure, the main differences from the newer processing frameworks (Tez, Impala, and Spark) compared to the traditional MapReduce engine (left) is that they avoid writing intermediate results to HDFS and heavily optimize the execution graph. Another optimization strategy is processing/caching data in memory of the local nodes across the execution graph.

![MapReduce vs. Tez/Impala/Spark]({{ site.baseurl }}/images/hadoop/mr_tez_spark.png "MapReduce vs. Tez/Impala/Spark"){: .image-col-1}

Traditional MapReduce (left) vs. Tez/Impala/Spark optimized engines (right) (Source: [hortonworks.com][tez-blog])

What sets *Apache Spark* aside from the other frameworks, is the in-memory processing engine as well as the rich set of included libraries (GraphX for graph processing, MLib for Machine Learning, Spark Streaming for mini batch streaming, and Spark SQL) and SDKs (Scala, Python, Java, and R). Please note that these libraries are for *distributed* processing, so distributed graph processing, distributed machine learning, etc. out-of-the-box.

The amazing performance of Spark's in-memory engine comes with a trade-off. Tuning and operating Spark pipelines with varying amounts of data requires a [lot of manual tuning of configurations](https://spark.apache.org/docs/latest/tuning.html), digging through log files, and reading books, articles, and blog posts. And since the execution parallelism can be modified in a fine-grained way, one has to configure/set the number of tasks per JVM, the number of JVMs per worker, and the number of workers as well as all the memory settings (heap, shuffle, and storage) for these executors and the driver.

## Summary

We speak about Big Data, when we speak about large volumes (> 10s GB), high velocity (> 10.000s records/second) or large variety (binary, text, unstructured, compressed, etc.) of data. We use Big Data system to store and process massive data sets, e.g. to perform analytics, predictions or modeling.

Apache Hadoop is a collection of services for large-scale distributed storage and processing, mainly HDFS (a distributed filesystem), MapReduce (a processing framework), Apache Yarn (a cluster resource manager), and Apache Zookeeper (a fast distributed key-value storage).

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

> Thanks to [Emil Jorgensen](https://www.linkedin.com/in/emil-jorgensen) and [Bryan Minnock](https://www.linkedin.com/in/bryanminnock).

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