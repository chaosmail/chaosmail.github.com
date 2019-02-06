---
layout: post
title: "Getting Started with Microsoft SQL 2019 for Big Data"
date: 2019-02-01 16:00:00
categories: hadoop
tags: bigdata hadoop spark sql2019
comments: true
---

Microsoft latest [SQL Server][sql-server-2019] comes in a new version, the SQL Server Big Data cluster. There are a couple of cool things about this version: (1) it runs on [Kubernetes][kubernetes], (2) it integrates [HDFS][apache-hdfs] (a distributed file storage), (3) it integrates [Spark][apache-spark] (a distributed compute engine), (4) and both services run behind an [Apache Knox][apache-knox] Gateway (HTTPS application gateway for Hadoop). Hence, SQL Server 2019 for Big Data is a scalable, performant and maintainable SQL platform, Data Warehouse, Data Lake and Data Science platform without compromise. In this blog post I want to give you a quick start tutorial into [SQL 2019 Big data analytics][sql-server-2019-bigdata] and show you how to set it up on Azure Kubernetes Services (AKS), upload some data to HDFS and access the data from SQL and Spark.

## SQL Server 2019 for Big Data


![SQL Server 2019 for Big Data architecture]({{ site.baseurl }}/images/hadoop/SQL-Server-2019-big-data-cluster.png "SQL Server 2019 for Big Data architecture"){: .image-col-1}

https://cloudblogs.microsoft.com/sqlserver/2018/09/25/introducing-microsoft-sql-server-2019-big-data-clusters/

## Installation

Currently, SQL 2019 for Big data analytics (the HDFS and Spark integration) is still in private preview. However, you can apply for the [Early Adoption Program][sql-server-2019-early-adoption] which will grant you access to Microsoft's private registry and SQL Server 2019 images. You are also assigned a buddy (a PM on the SQL Server 2019 team) as well as provided access to a private Teams channel. Hence, if you want to try it already today, you should definitely sign up!

In this section we will go through the prerequisites and installation process as documented in the [SQL Server 2019 installation guidelines][sql-server-2019-deploy-bigdata] for Big Data analytics. In the documentation, you will find a link to a [Python script][sql-server-2019-deploy-bigdata-github] that allows you to spin up SQL 2019 on AKS.

### Prerequisites: Kubernetes and MSSQL clients

To [deploy a SQL Server 2019 Big Data cluster][sql-server-2019-deploy-bigdata] on AKS, you need the following tools installed. For this tutorial, I installed all these tools on Ubuntu 18.04 LTS on [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) (Windows Subsystem for Linux).

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
* [kubectl][install-kubectl]
* [mssqlctl][install-mssqlctl]

To avoid any problems with Kubernetes APIs, it's best to install the same `kubectl` version as the Kubernetes version on AKS. In the SQL Server 2019 docs, the version `1.10.9` is recommended. To get all versions of supported Kubernetes versions, run the following snippet.

```sh
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

Hence, in this case we also [install][install-kubectl] the Kubernetes `1.10.9` client.

```sh
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl=1.10.9-00
```

The `mssqlctl` tool is a handy command-line utility that allows you to create and manage SQL Server 2019 Big Data installations. You can [install it][install-mssqlctl] using pip with the following command:

```sh
$ pip3 install --extra-index-url https://private-repo.microsoft.com/python/ctp-2.2 mssqlctl --user
```

Before you continue, make sure that both `kubectl` and `mssqlctl` commands are available. If they are not, you might restart the current bash session.

### Prerequisites: Azure Data Studio

[Azure Data Studio][azure-data-studio] is a cross-platform management tool for Microsoft databases. It's like SQL Server Management Studio on top of the popular VS Code editor engine, a rich TSQL editor with IntelliSense and Plugin support. Currently, it's the easiest way to connect to the different SQL Server 2019 endpoints (SQL, HDFS, and Spark). To do so, you need to [install Data Studio][azure-data-studio-install] and the [SQL Server 2019 extension][azure-data-studio-install-sql2019].

### Install SQL Server 2019 on AKS

In this section, we will follow the steps from the [installation script][sql-server-2019-deploy-bigdata-github] in order to install SQL Server 2019 for Big Data on AKS. I will give you a bit more details and explanation about the executed steps. If you just want to install SQL Server 2019 for Big Data, you can as well just use the script.

First, we start setting all required parameters for the installation process. For the docker username and password, please use the credentials provided in the Early Adoption program. These will give you access to Microsoft's internal registry with the latest SQL Server 2019 images.

```sh
# Provide your Azure subscription ID
SUBSCRIPTION_ID="***"
# Provide Azure resource group name to be created
GROUP_NAME="demos.sql2019"

# Provide Azure region
AZURE_REGION="westeurope"
# Provide VM size for the AKS cluster
VM_SIZE="Standard_L4s"
# Provide number of worker nodes for AKS cluster
AKS_NODE_COUNT="3"
# Provide Kubernetes version
KUBERNETES_VERSION="1.10.9"

# This is both Kubernetes cluster name and SQL Big Data cluster name
# Provide name of AKS cluster and SQL big data cluster
CLUSTER_NAME="sqlbigdata"
# This password will be use for Controller user, Knox user and SQL Server Master SA accounts
# Provide password to be used for Controller user, Knox user and SQL Server Master SA accounts
PASSWORD="MySQLBigData2019"
# Provide username to be used for Controller user
CONTROLLER_USERNAME="admin"

# Private Microsoft registry
DOCKER_REGISTRY="private-repo.microsoft.com"
DOCKER_REPOSITORY="mssql-private-preview"
DOCKER_IMAGE_TAG="latest"

# Provide your Docker username
DOCKER_USERNAME="***"
# Provide your Docker password
DOCKER_PASSWORD="***"
```

Now, we can go ahead and create the AKS cluster.

```sh
$ az aks create --name $CLUSTER_NAME --resource-group $GROUP_NAME --generate-ssh-keys \
    --node-vm-size $VM_SIZE --node-count $AKS_NODE_COUNT --kubernetes-version $KUBERNETES_VERSION
```

If you run this script for the first time, you can skip the following step. However, if you create multiple AKS clusters with the same name, you first need to clean the credentials.

```sh
$ kubectl config unset "clusters.$CLUSTER_NAME"
$ kubectl config unset "users.clusterAdmin_${GROUP_NAME}_${CLUSTER_NAME}"
```
In the next step, we retrieve the credentials for the cluster. This will register the credentials in the `kubectl` config.

```sh
$ az aks get-credentials --name $CLUSTER_NAME --resource-group $GROUP_NAME --admin
```

In order to access the Kubernetes dashboard, we also need to create a role binding. I took this line from [Pascal Naber's blog post](https://pascalnaber.wordpress.com/2018/06/17/access-dashboard-on-aks-with-rbac-enabled/).

```sh
$ kubectl create clusterrolebinding kubernetes-dashboard -n kube-system \
    --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard
```

Next, we can open the Kuerbenetes dashboard for the newly created AKS cluster and see if everything looks fine. To do so, we can forward the required ports to localhost.

```sh
$ az aks browse --resource-group $GROUP_NAME --name $CLUSTER_NAME
```

The Kuerbenetes dashboard should now be available via [http://localhost:8001](http://localhost:8001). I recommend you to open it and take a look to verify everything is green.

Finally, we can deploy SQL Server 2019 for Big Data on the Kubernetes cluster. This is quite easy using the `mssqlctl` command-line utility.

```sh
$ mssqlctl create cluster $CLUSTER_NAME
```

Great, that was it! You are now ready to get started.

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
[apache-knox]: https://knox.apache.org/
[sql-server-2019-early-adoption]: https://sqlservervnexteap.azurewebsites.net/
[sql-server-2019-deploy-bigdata]: https://docs.microsoft.com/en-us/sql/big-data-cluster/quickstart-big-data-cluster-deploy?view=sql-server-ver15
[sql-server-2019-deploy-bigdata-github]: https://github.com/Microsoft/sql-server-samples/blob/master/samples/features/sql-big-data-cluster/deployment/aks/deploy-sql-big-data-aks.py
[install-kubectl]: https://kubernetes.io/docs/tasks/tools/install-kubectl/
[install-mssqlctl]: https://docs.microsoft.com/en-us/sql/big-data-cluster/deploy-install-mssqlctl?view=sqlallproducts-allversions

[azure-data-studio]: https://docs.microsoft.com/en-us/sql/azure-data-studio/what-is?view=sqlallproducts-allversions
[azure-data-studio-install]: https://docs.microsoft.com/en-us/sql/azure-data-studio/download?view=sqlallproducts-allversions
[azure-data-studio-install-sql2019]: https://docs.microsoft.com/en-us/sql/azure-data-studio/sql-server-2019-extension?view=sqlallproducts-allversions