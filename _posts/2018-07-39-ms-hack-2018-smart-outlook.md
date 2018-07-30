---
layout: post
title: "MS Hack 2018 - Smart Outlook"
date: 2018-07-30 17:00:00
categories: hackathon
tags: hackathon office
comments: true
---

In the 2018 MS Hack global Microsoft Hackathon, I joined the *Smart Outlook* project in order to develop a few principles to make your daily work in Outlook more productive. We came up with a few ideas, mainly about enhancing folders, categories, and focus inbox as well as notificaitons about new emails. We build a [mock UI][smart-outlook-demo] to visualize the idea of our solution; the code is available on [Github][smart-outlook-code]. 

## Idea

Employees spend 20 hours/week on email. Common patterns include manually sorting emails, manually maintaining rules, keeping a single folder inbox, storing tons of unread emails. These things cost time.

The following tools are available to categorize emails:

* Custom Folders
* Categories
* Focus Inbox
* Junk Folder

Both *Custom Folders* and *Categories* are set manually or with manually-created rules whereas *Junk Folder* and *Focus Inbox* are set automatically. We receive an email notification for every email received in the inbox.

To make Outlook more efficient, we want to merge *Custom Folders* and *Focus Inbox (Tabs)* into *Smart Tabs*. *Smart Tabs* can be created within hierarchies like traditional folders. Emails can be dragged into *Smart Tabs* like traditional folders and each email can only belong to one single *Smart Tab*. However unlike traditional folders, the number of unread emails is added up with all parent tabs. According to the manual assignment of emails to *Smart Tabs*, a Machine Learning algorithm trains/finetunes a model based on content/subject semantics as well as email and organisational metadata and moves new emails to the most likely tab (or inbox). During setup, common *Smart Tabs* are created for you such as *Team*, *Notificaitons*, *News*, *Org Updates*, *Customers*, *External*, etc.

To focus on only relevant notifications, any of your *Smart Tabs* can be pinned to the top. You will only receive notifications from new emails in your pinned tabs. We merged the UI of the Outlook web client with the UI of Edge browser to create these Tab UI. We built a [mock UI][smart-outlook-demo] to visualize the idea of our solution; the code is available on [Github][smart-outlook-code].

> A blog post about deploying a static website to Azure can be found in the [Azure Blog][azure-static-website].

## Execution

What did we implement on the hackathon:

* Mock UI
    - Smart Tabs: A merge between classic folders and Focus/Other tabs. Mails should be classified automatically (based on previous user interactions) and put into those smart tabs. This tabs will also appear on the left the same folders did.
    - Focus Mode: Smart tabs can be pinned as tabs to the top. Then the user receives notifications solely on the current open tabs.
    ○ UI: We tried to merge functionality of Outlook Windows client and Outlook.com Web client with the simple/clean UI of Edge into a single tab-based email UI
* ML API Endpoint
    - Labeled a custom email dataset
    - Trained simple ML model with semantic features in Python
    - Email classification based on content
    - Deployment to Azure VM
* Outlook Plugin
    - Create *Smart Tabs* programmatically (as folders)
    - Classify incoming messages and move to *Smart Tabs* (as folders)

## Resources

* [Smart Outlook - Demo][smart-outlook-demo]
* [Smart Outlook - Code][smart-outlook-code]

[smart-outlook-demo]: https://mshack2018.z13.web.core.windows.net
[smart-outlook-code]: https://github.com/chaosmail/mshack-2018-smart-outlook
[azure-static-website]: https://azure.microsoft.com/en-us/blog/azure-storage-static-web-hosting-public-preview/