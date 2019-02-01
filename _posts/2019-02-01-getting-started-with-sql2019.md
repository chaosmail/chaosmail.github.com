---
layout: post
title: "Getting Started with Microsoft SQL 2019 for Big Data"
date: 2019-02-01 16:00:00
categories: hadoop
tags: bigdata hadoop spark sql2019
comments: true
---

Microsoft latest [SQL Server][sql-server-2019] comes in a new version, the SQL Server Big Data cluster. There are a couple of cool things about this version: (1) it can run on [Kubernetes][kubernetes], (2) it integrates [HDFS][apache-hdfs] (a distributed file storage), and (3) it integrates [Spark][apache-spark] (a distributed compute engine). Hence, SQL Server 2019 for Big Data is a scalable, performant and maintainable SQL platform, Data Warehouse, Data Lake and Data Science platform without compromise. In this blog post I want to give you a quick start tutorial into [SQL 2019 Big data analytics][sql-server-2019-bigdata] and show you how to set it up on Azure Kubernetes Services (AKS), upload some data to HDFS and access the data from SQL and Spark.

## Prerequisites

Currently, SQL 2019 for Big data analytics (the HDFS and Spark integration) is still in private preview. However, you can apply for the [Early Adoption Program][sql-server-2019-early-adoption] which will grant you access to Microsoft's private registry and SQL Server 2019 images. You are also assigned a buddy (a PM on the SQL Server 2019 team) as well as provided access to a private Teams channel. Hence, if you want to try it already today, you should definitely sign up!

### Kubernetes and MSSQL clients

To [deploy a SQL Server 2019 Big Data cluster][sql-server-2019-deploy-bigdata] on AKS (in Region `westeurope`), you need the following tools installed. For this tutorial, I installed all these tools on Ubuntu 18.04 LTS on [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) (Windows Subsystem for Linux).

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [mssqlctl](https://docs.microsoft.com/en-us/sql/big-data-cluster/deploy-install-mssqlctl?view=sqlallproducts-allversions)

To avoid any problems with Kubernetes APIs, I installed the same `kubectl` version as the Kubernetes version on AKS. To get all versions of supported Kubernetes versions, run the following snippet.

```
$ az aks get-versions --location westeurope --output table
KubernetesVersion    Upgrades
-------------------  -----------------------
1.12.4               None available
1.11.6               1.12.4
1.11.5               1.11.6, 1.12.4
1.10.12              1.11.5, 1.11.6
1.10.9               1.10.12, 1.11.5, 1.11.6
1.9.11               1.10.9, 1.10.12
1.9.10               1.9.11, 1.10.9, 1.10.12
1.8.15               1.9.10, 1.9.11
1.8.14               1.8.15, 1.9.10, 1.9.11
```

The `mssqlctl` utility 

### Data Studio

https://docs.microsoft.com/en-us/sql/azure-data-studio/what-is?view=sqlallproducts-allversions
https://docs.microsoft.com/en-us/sql/azure-data-studio/sql-server-2019-extension?view=sqlallproducts-allversions

## Kubernetes Dashboard

```shell
$ kubectl create clusterrolebinding kubernetes-dashboard -n kube-system \
    --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard
```

https://pascalnaber.wordpress.com/2018/06/17/access-dashboard-on-aks-with-rbac-enabled/

```
$ az aks browse --resource-group demos.sql2019 --name sqlbigdata
```

## Examples of SQL Server 2019 Big Data Analytics

### Working with HDFS

### Working with SQL

### Working with Spark

## Resources

[sql-server-2019]: https://www.microsoft.com/en-us/sql-server/sql-server-2019
[sql-server-2019-bigdata]: https://docs.microsoft.com/en-us/sql/big-data-cluster/big-data-cluster-overview?view=sql-server-ver15
[kubernetes]: https://kubernetes.io/
[apache-hdfs]: https://hadoop.apache.org/docs/current1/hdfs_design.html#Introduction
[apache-spark]: http://spark.apache.org/
[sql-server-2019-early-adoption]: https://sqlservervnexteap.azurewebsites.net/
[sql-server-2019-deploy-bigdata]: https://docs.microsoft.com/en-us/sql/big-data-cluster/quickstart-big-data-cluster-deploy?view=sql-server-ver15
