---
title: 線上託管說明
permalink: index.html
layout: home
ms.openlocfilehash: 7ad42e4108b96ec131049fa1035ab1d112d95d90
ms.sourcegitcommit: 2eb153f2856445e5afaa218a012cb92e3d48f24b
ms.translationtype: HT
ms.contentlocale: zh-TW
ms.lasthandoff: 11/16/2021
ms.locfileid: "145195862"
---
# <a name="content-directory"></a>內容目錄

您可以[在這裡下載](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/archive/master.zip)必要的實驗室檔案

下方列出可連至各實驗室活動和示範的超連結。

## <a name="labs"></a>實驗室

{% assign labs = site.pages | where_exp:"page", "page.url contains '/Instructions/Labs'" %}
| 模組 | 實驗室 |
| --- | --- | 
{% for activity in labs  %}| {{ activity.lab.module }} | [{{ activity.lab.title }}{% if activity.lab.type %} - {{ activity.lab.type }}{% endif %}]({{ site.github.url }}{{ activity.url }}) |
{% endfor %}
