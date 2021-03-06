---
lab:
  title: 05 - Azure AD Privileged Identity Management
  module: Module 01 - Manage Identity and Access
ms.openlocfilehash: 6ef7c51d334587e5e4e7116194fa46f2eb5d1df0
ms.sourcegitcommit: 1da29a6d959a7f91dbbcbabf5ec06869c98fc1f1
ms.translationtype: HT
ms.contentlocale: zh-TW
ms.lasthandoff: 03/30/2022
ms.locfileid: "145195846"
---
# <a name="lab-05-azure-ad-privileged-identity-management"></a>實驗室 05：Azure AD 權限存取識別管理
# <a name="student-lab-manual"></a>學生實驗室手冊

## <a name="lab-scenario"></a>實驗案例

系統要求您建立使用 Azure Privileged Identity Management (PIM) 的概念證明，以啟用 Just-In-Time 系統管理，並控制可執行特殊許可權作業的使用者數目。 具體需求如下：

- 對安全性系統管理員角色建立 aaduser2 Azure AD 使用者的永久指派。 
- 將 aaduser2 Azure AD 使用者設定為符合計費管理員和全域讀者角色的資格。
- 將全域讀者角色啟用設定為必須取得 aaduser3 Azure AD 使用者核准
- 設定全域讀者角色的存取權檢閱並檢閱稽核功能。

> 此實驗室中所有資源使用的都是 **美國東部** 區域。 請與講師確認這是課程中要使用的區域。 

> 請先確認您已完成實驗室 04 再繼續操作：MFA、條件式存取和 AAD 身分識別保護。 您需要使用 Azure AD 租用戶、AdatumLab500-04，以及 aaduser1、aaduser2、aaduser3 使用者帳戶。

## <a name="lab-objectives"></a>實驗室目標

在本實驗室中，您須完成下列練習：

- 練習 1：設定 PIM 使用者和角色。
- 練習 2：啟用需要及不需要核准的 PIM 角色。
- 練習 3：建立存取權檢閱並檢閱 PIM 稽核功能。

## <a name="azure-ad-privileged-identity-management-diagram"></a>Azure AD Privileged Identity Management 圖表

![image](https://user-images.githubusercontent.com/91347931/157522920-264ce57e-5c55-4a9d-8f35-e046e1a1e219.png)

## <a name="instructions"></a>指示

### <a name="exercise-1---configure-pim-users-and-roles"></a>練習 1：設定 PIM 使用者和角色

#### <a name="estimated-timing-15-minutes"></a>預估時間：15 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：讓使用者有資格獲派角色。
- 工作 2：將角色設定為須取得核准才能啟用及新增符合資格的成員。
- 工作 3：對角色進行使用者永久性指派。 

#### <a name="task-1-make-a-user-eligible-for-a-role"></a>工作 1：讓使用者有資格獲派角色

在此工作中，您必須讓使用者有資格獲派 Azure AD 目錄角色。

1. 登入 Azure 入口網站： **`https://portal.azure.com/`** 。

    >**注意**：確定您已登入 **AdatumLab500-04** Azure AD 租用戶。 您可以使用 [目錄 + 訂用帳戶] 篩選器切換 Azure AD 租用戶。 確定您是透過具有全域管理員角色的使用者身分登入。
    
    >**注意**：如果您仍然沒有看到 AdatumLab500-04 項目，請按一下 [切換目錄] 連結，選取 [AdatumLab500-04] 行，然後點選 [切換] 按鈕。

2. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入「Azure AD Privileged Identity Management」，然後按下 **Enter** 鍵。

3. 在 [Privileged Identity Management] 刀鋒視窗的 [管理] 區段中，按一下 [Azure AD 角色]。  

4. 在 [AdatumLab500-04 \| 快速入門] 刀鋒視窗的 [管理] 區段中，按一下 [角色]。

5. 在 [AdatumLab500-04 \| 角色] 刀鋒視窗中按一下 [+ 新增指派]。

6. 在 [新增指派] 刀鋒視窗的 [選取角色] 下拉式清單中，選取 [計費管理員]。

7. 按一下 [未選取任何成員] 連結，在 [選取成員] 刀鋒視窗中點選 [aaduser2]，然後按一下 [選取]。

8. 返回 [新增指派] 刀鋒視窗，點選 [下一步]。  

9. 確定 [指派類型] 已設定為 [符合資格]，然後按一下 [指派]。
 
10. 返回 [AdatumLab500-04 \| 角色] 刀鋒視窗的 [管理] 區段，按一下 [指派]。

11. 返回 [AdatumLab500-04 \| 指派] 刀鋒視窗，找到 [合格的指派]、[使用中指派]、[已到期指派]。

12. 在 [合格的指派] 索引標籤上確認 **aaduser2** 顯示為「計費管理員」。 

    >**注意**：在登入期間，aaduser2 有資格使用計費管理員角色。 

#### <a name="task-2-configure-a-role-to-require-approval-to-activate-and-add-an-eligible-member"></a>工作 2：將角色設定為須取得核准才能啟用及新增符合資格的成員

1. 在 Azure 入口網站中巡覽回 [Privileged Identity Management] 刀鋒視窗，然後按一下 [Azure AD 角色]。 

2. 在 [AdatumLab500-04 \| 快速入門] 刀鋒視窗的 [管理] 區段中，按一下 [角色]。

3. 在 [AdatumLab500-04 \| 角色] 刀鋒視窗中，按一下 [全域讀者] 角色項目。 

4. 在 [全域讀者 \| 設定] 刀鋒視窗中，按一下工具列裡的 **設定** 圖示並檢閱該角色的設定，包含多重要素驗證的條件需求。

5. 按一下 **[編輯]** 。

6. 在 [啟用] 索引標籤上，啟用 [需要核准才可啟用] 核取方塊。

7. 按一下 [選取核准者]，在 [選取成員] 刀鋒視窗中點選 [aaduser3]，然後按一下 [選取]。

8. 按一下 [下一步：指派]。

9. 清除 [允許永久合格指派] 核取方塊，其他所有設定則保留預設值。

10. 點選 [下一步：通知]。

11. 檢閱 [通知] 設定，保留所有預設設定，然後按一下 [更新]。

    >**注意**：任何想要使用「全域讀者」角色的人現在都需要取得 aaduser3 的核准。 

12. 在 [全域讀者 \| 指派] 刀鋒視窗中，按一下 [+ 新增指派]。

13. 在 [新增指派] 刀鋒視窗中按一下 [未選取任何成員]，然後在 [選取成員] 刀鋒視窗中點選 [aaduser2]，再按一下 [選取]。

14. 按一下 [下一步] 。 

15. 確定 [指派類型] 已設為 [符合資格]，並檢閱合格持續時間的設定。

16. 按一下 [指派]。

    >**注意**：使用者 aaduser2 符合全域讀者角色的使用資格。 
 
#### <a name="task-3-give-a-user-permanent-assignment-to-a-role"></a>工作 3：對角色進行使用者永久性指派。

1. 在 Azure 入口網站中巡覽回 [Privileged Identity Management] 刀鋒視窗，然後按一下 [Azure AD 角色]。 

2. 在 [AdatumLab500-04 \| 快速入門] 刀鋒視窗的 [管理] 區段中，按一下 [角色]。

3. 在 [AdatumLab500-04 \| 角色] 刀鋒視窗中按一下 [+ 新增指派]。

4. 在 [新增指派] 刀鋒視窗的 [選取角色] 下拉式清單中，選取 [計費管理員]。

5. 在 [新增指派] 刀鋒視窗中按一下 [未選取任何成員]，然後在 [選取成員] 刀鋒視窗中點選 [aaduser2]，再按一下 [選取]。

6. 按一下 [下一步] 。 

7. 檢閱 [指派類型] 設定，然後按一下 [指派]。 

8. 在 [合格的指派] 索引標籤上的 [指派] 頁面，為  **aaduser2** 指派選取 [更新]。 依序選取 [永久合格] 與 [儲存]。

    >**注意**：使用者 aaduser2 現在已具備安全性系統管理員角色的永久資格。
    
### <a name="exercise-2---activate-pim-roles-with-and-without-approval"></a>練習 2：啟用需要及不需要核准的 PIM 角色

#### <a name="estimated-timing-15-minutes"></a>預估時間：15 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：啟用不需要核准的角色。 
- 工作 2：啟用需要核准的角色。 

#### <a name="task-1-activate-a-role-that-does-not-require-approval"></a>工作 1：啟用不需要核准的角色。

在此工作中，您必須啟用不需要核准的角色。

1. 開啟 InPrivate 瀏覽器視窗。

2. 在 InPrivate 瀏覽器視窗中巡覽至 Azure 入口網站，並透過 **aaduser2** 使用者帳戶登入。

    >**注意**：若要登入，您必須提供 **aaduser2** 使用者帳戶的完整名稱，包括您先前在此實驗室記錄的 Azure AD 租用戶 DNS 網域名稱。 使用者名稱的格式為 aaduser2@`<your_tenant_name>`.onmicrosoft.com，其中 `<your_tenant_name>` 是代表您唯一 Azure AD 租用戶名稱的預留位置。 

3. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入「Azure AD Privileged Identity Management」，然後按下 **Enter** 鍵。

4. 在 [Privileged Identity Management] 刀鋒視窗的 [工作] 區段中，按一下 [我的角色]。  

5. 您應該會看到 **aaduser2** 的三個 **符合資格的角色**：**全域讀者**、**安全性系統管理員**、**計費管理員**。 

6. 在顯示 [計費管理員] 角色項目的資料列中，按一下 [啟用]。

7. 如有需要，請按一下 [需要其他驗證。按一下以繼續] 警告，然後按照指示驗證您的身分識別。

8. 在 [啟用 - 計費管理員] 刀鋒視窗中的 [原因] 文字輸入框內，輸入提供啟用理由的文字，然後按一下 [啟用]。

    >**注意**：您在 PIM 中啟用角色後，最多可能需要等待 10 分鐘啟用才會生效。 
    
    >**注意**：一旦啟用角色指派，瀏覽器就會重新整理 (如果發生錯誤，只要使用 **aaduser2** 使用者帳戶登出，再重新登入 Azure 入口網站即可)。

9. 巡覽回 [Privileged Identity Management] 刀鋒視窗，然後在 [工作] 區段中按一下 [我的角色]。  

10. 在 [我的角色 \| Azure AD 角色] 刀鋒視窗中，切換至 [使用中指派] 索引標籤。請注意 **計費管理員** 角色 **已啟用**。

    >**注意**：角色一經啟用，就會在達到 [結束時間] 下方的使用時間限制 (合格持續時間) 時自動停用。

    >**注意**：如果您提早完成管理員工作，可以手動停用角色。

11.  在 [啟用指派] 清單中代表 [計費管理員] 角色的資料列上，按一下 [停用] 連結。 

12.  在 [停用 - 計費管理員] 刀鋒視窗中再按一下 [停用] 加以確認。


#### <a name="task-2-activate-a-role-that-requires-approval"></a>工作 2：啟用需要核准的角色。 

在此工作中，您必須啟用需要核准的角色。

1. 在 InPrivate 瀏覽器視窗中顯示的 Azure 入口網站以 **aaduser2** 使用者的身分登入，然後巡覽回 [Privileged Identity Management \| 快速入門] 刀鋒視窗。 

2. 在 [Privileged Identity Management \| 快速入門] 刀鋒視窗的  [工作] 區段中，按一下 [我的角色]。

3. 在 [我的角色 \| Azure AD 角色] 刀鋒視窗的 [合格的指派] 清單中，於顯示 [全域讀者] 角色的資料列上按一下 [啟用]。 

4. 在 [啟用 - 全域讀者] 刀鋒視窗中的 [原因] 文字輸入框內，輸入提供啟用理由的文字，然後按一下 [啟用]。

5. 在 Azure 入口網站的工具列中按一下 **通知** 圖示，檢視告知您要求正在等待核准的通知。

    >**注意**：特殊權限角色管理員可以隨時檢閱和取消要求。 

6. 在 [我的角色 \| Azure AD 角色] 刀鋒視窗中找出 [安全性系統管理員] 角色，然後按一下 [啟用]。 

7. 按一下 [需要其他驗證。按一下以繼續] 警告。 

8. 按照指示驗證您的身分識別。

    >**注意**：每個工作階段僅需驗證一次。 

9. 返回 Azure 入口網站介面後，在 [啟用 - 安全性系統管理員] 刀鋒視窗中的 [原因] 文字輸入框內輸入啟用理由，然後按一下 [啟用]。  

    >**注意**：自動核准流程應已完成。

10. 返回 [我的角色 \| Azure AD 角色] 刀鋒視窗，按一下 [使用中指派] 索引標籤。請注意 [使用中指派] 內包含 **安全性系統管理員**，但不含 **全域讀者** 角色。

    >**注意**：您現在必須核准全域讀者角色。

11. 以 **aaduser2** 的身分登出 Azure 入口網站。

12. 以 **aaduser3** 的身分登入 Azure 入口網站。

    >**注意**：如果您使用任何一個使用者帳戶進行驗證時遇到問題，您可以透過自己的使用者帳戶重設其密碼或重新設定其登入選項，以登入 Azure AD 租用戶。

13. 在 Azure 入口網站中巡覽至 [Azure AD Privileged Identity Management] (在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入「Azure AD Privileged Identity Management」，然後按下 Enter 鍵)。

14. 在 [Privileged Identity Management \| 快速入門] 刀鋒視窗的  [工作] 區段中，按一下 [核准要求]。

15. 在 [核准要求 \| Azure AD 角色] 刀鋒視窗的 [要求啟用角色] 區段，勾選代表 **aaduser2** 所提出「全域讀者」角色啟用要求的項目核取方塊。 

16. 按一下 [核准]。 在 [核准要求] 刀鋒視窗中的 [原因] 文字輸入框內輸入啟用理由，並記下開始和結束的時間，然後按一下 [確認]。   

    >**注意**：您也可以選擇拒絕要求。

17. 以 **aaduser3** 的身分登出 Azure 入口網站。

18. 以 **aaduser2** 的身分登入 Azure 入口網站

19. 在 Azure 入口網站中巡覽至 [Azure AD Privileged Identity Management] (在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入「Azure AD Privileged Identity Management」，然後按下 Enter 鍵)。

20. 在 [Privileged Identity Management \| 快速入門] 刀鋒視窗的  [工作] 區段中，按一下 [我的角色]。

21. 在 [我的角色 \| Azure AD 角色] 刀鋒視窗中，切換至 [使用中指派] 索引標籤，並確認全域讀者角色已啟用。

    >**注意**：您可能必須重新整理頁面，才能檢視使用中指派的更新清單。

22. 登出並關閉 InPrivate 瀏覽器視窗。

> 結果：您已完成啟用需要及不需要核准的 PIM 角色這項練習。 

### <a name="exercise-3---create-an-access-review-and-review-pim-auditing-features"></a>練習 3：建立存取權檢閱並檢閱 PIM 稽核功能

#### <a name="estimated-timing-10-minutes"></a>預估時間：10 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：在 PIM 中設定 Azure AD 目錄角色的安全性警示
- 工作 2：檢閱 PIM 警示、摘要資訊，以及詳細的稽核資訊

#### <a name="task-1-configure-security-alerts-for-azure-ad-directory-roles-in-pim"></a>工作 1：在 PIM 中設定 Azure AD 目錄角色的安全性警示

在此工作中，您必須降低角色指派過時所帶來的風險。 為達成這個目標，您需要建立 PIM 存取權檢閱，確定指派的角色仍然有效。 具體而言，您必須檢閱全域讀者角色。 

1. 使用您的帳戶登入 Azure 入口網站： **`https://portal.azure.com/`** 。

    >**注意**：確定您已登入 **AdatumLab500-04** Azure AD 租用戶。 您可以使用 [目錄 + 訂用帳戶] 篩選器切換 Azure AD 租用戶。 確定您是透過具有全域管理員角色的使用者身分登入。
    
    >**注意**：如果您仍然沒有看到 AdatumLab500-04 項目，請按一下 [切換目錄] 連結，選取 [AdatumLab500-04] 行，然後點選 [切換] 按鈕。

2. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入「Azure AD Privileged Identity Management」，然後按下 **Enter** 鍵。

3. 巡覽至 [Privileged Identity Management] 刀鋒視窗。 

4. 在 [Privileged Identity Management \| 快速入門] 刀鋒視窗的  [管理] 區段中，按一下 [Azure AD 角色]。

5. 在 [AdatumLab500-04 \| 快速入門] 刀鋒視窗的 [管理] 區段中，按一下 [存取權檢閱]。

6. 在 [AdatumLab500-04 \| 存取權檢閱] 刀鋒視窗中按一下 [新增]：

7. 在 [建立存取權檢閱] 刀鋒視窗中指定下列設定 (將其他設定保留為預設值)： 

   |設定|值|
   |---|---|
   |檢閱名稱|**全域讀者檢閱**|
   |開始日期|今天的日期| 
   |頻率|**一次**|
   |結束日期|本月最後一天|
   |角色，選取特殊權限角色|**全域讀取者**|
   |檢閱者|**選取的使用者**|
   |選取檢閱者|您的帳戶，|

8. 在 [建立存取權檢閱] 刀鋒視窗中按一下 [開始]：
 
    >**注意**：您大約須等待一分鐘才能完成檢閱部署，並讓檢閱出顯示在 [AdatumLab500-04 \| 存取權檢閱] 刀鋒視窗中。 您可能需要重新整理網頁。 檢閱狀態會顯示為 [作用中]。 

9. 在 [AdatumLab500-04 \| 存取權檢閱] 刀鋒視窗的 [全域讀者檢閱] 標題下方，按一下 [全域讀者] 項目。 

10. 在 [全域讀者檢閱] 刀鋒視窗中檢查 [概觀] 頁面。請留意 [進度] 圖表的 [未檢閱] 類別中會顯示單一使用者。 

11. 在 [全域讀者檢閱] 刀鋒視窗的 [管理] 區段按一下 [結果]。   請注意，aaduser2 會列為可存取此角色。

12. 在 [aaduser2] 行按一下 [檢視]，以檢視詳細的稽核記錄，其中包含該使用者所參加 PIM 活動的項目。

13. 巡覽回 [AdatumLab500-04 \| 存取權檢閱] 刀鋒視窗。

14. 在 [AdatumLab500-04 \| 存取權檢閱] 刀鋒視窗的 [工作] 區段按一下 [檢閱存取]，然後點選 [全域讀者檢閱] 項目。 

15. 在 [全域讀者檢閱] 刀鋒視窗中，按一下 [aaduser2] 項目。  

16. 在 [原因] 文字輸入框中輸入核准的依據，然後按一下 [核准] 維持目前的角色成員資格，或者按一下 [拒絕] 撤銷角色成員資格。 

17. 巡覽回 [Privileged Identity Management] 刀鋒視窗，然後在 [管理] 區段中按一下 [Azure AD 角色]。  

18. 在 [AdatumLab500-04 \| 快速入門] 刀鋒視窗的 [管理] 區段中，按一下 [存取權檢閱]。

19. 選取代表 **全域讀者** 檢閱的項目。 請注意，[進度] 圖表已更新並顯示您的檢閱。 

#### <a name="task-2-review-pim-alerts-summary-information-and-detailed-audit-information"></a>工作 2：檢閱 PIM 警示、摘要資訊，以及詳細的稽核資訊。 

在此工作中，您必須檢閱 PIM 警示、摘要資訊，以及詳細的稽核資訊。 

1. 巡覽回 [Privileged Identity Management] 刀鋒視窗，然後在 [管理] 區段中按一下 [Azure AD 角色]。  

2. 在 [AdatumLab500-04 \| 快速入門] 刀鋒視窗的 [管理] 區段中點選 [警示]，再按一下 [設定]。

3. 在 [警示設定] 刀鋒視窗中檢閱預先設定的警示和風險層級。 按一下任一項目即可查看更詳細的資訊。 

4. 返回 [AdatumLab500-04 \| 快速入門] 刀鋒視窗，按一下 [概觀]。 

5. 在 [AdatumLab500-04 \| 概觀]  刀鋒視窗中，檢閱角色啟用、PIM 活動、警示和角色指派的摘要資訊。

6. 在 [AdatumLab500-04 \| 概觀] 刀鋒視窗的 [活動] 區段按一下 [資源稽核]。 

    >**注意**：過去 30 天內的所有特殊權限角色指派及啟用都有稽核歷程記錄。

7. 您可以擷取詳細資訊，包括 **時間**、**要求者**、**動作**、**資源名稱**、**範圍**、**主要目標** 和 **主體**。 

> 結果：您已設定存取權檢閱並檢閱稽核資訊。 

**清除資源**

> 請記得移除您不再使用的任何新建 Azure 資源。 移除未使用的資源可避免產生非預期的費用。 

1. 在 Azure 入口網站中，將 [目錄 + 訂用帳戶] 篩選條件設定為與您部署 **az500-04-vm1** Azure VM 的 Azure 訂用帳戶相關聯的 Azure AD 租用戶。

    >**注意**：如果您沒有看到主要 Azure AD 租用戶項目，請按一下 [切換目錄] 連結，選取您的主要租用戶行，然後按一下 [切換] 按鈕。

2. 在 Azure 入口網站中按一下右上方的第一個圖示，開啟 Cloud Shell。 如果出現提示，請點選 [PowerShell] 與 [建立儲存體]。

3. 確定在 [Cloud Shell] 窗格左上角的下拉式功能表中，已選取 [PowerShell]。

4. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中執行下列指令，以移除您在先前的實驗室中建立的資源群組：
  
    ```powershell
    Remove-AzResourceGroup -Name "AZ500LAB04" -Force -AsJob
    ```

5. 關閉 [Cloud Shell] 窗格。 

6. 返回 Azure 入口網站，使用[目錄 + 訂用帳戶] 篩選器切換至 **AdatumLab500-04** Azure Active Directory 租用戶。

7. 巡覽回 [AdatumLab500-04] Azure Active Directory 刀鋒視窗，然後在 [管理] 區段中按一下 [授權]。

8. 在 [授權 | 概觀] 刀鋒視窗中按一下 [所有產品]，勾選 [Azure Active Directory Premium P2] 核取方塊，再按一下以開啟該項目。

    >**注意**：在實驗室 4 - 練習 2 -工作 4 **將 Azure AD Premium P2 授權指派給 Azure AD 使用者** 中，我們曾將 Premium 授權指派給使用者 **aaduser1、aaduser2 與 aaduser3**，請務必為這些指派的使用者移除 Premium 授權

9. 在 [Azure Active Directory Premium P2 - 經過授權的使用者] 刀鋒視窗中，找出指派過 **Azure Active Directory Premium P2** 授權的使用者帳戶，並勾選其核取方塊。 在頂端窗格中按一下 [移除授權]，接著在確認提示出現時選取 [是]。 

10. 在 Azure 入口網站中巡覽至 [使用者 - 所有使用者] 刀鋒視窗，按一下代表 **aaduser1** 使用者帳戶的項目，然後在 [aaduser1 - 設定檔] 刀鋒視窗中點選 [刪除]。出現確認提示時，請選取 [是]。

11. 重複相同的步驟順序，以刪除您建立的其餘使用者帳戶。

12. 巡覽至 Azure AD 租用戶的 [AdatumLab500-04 - 概觀] 刀鋒視窗，選取 [管理租用戶]，然後在下一個畫面中勾選 [AdatumLab500-04] 旁邊的核取方塊，再選取 [刪除]。 在 [刪除租用戶「AdatumLab500-04」] 刀鋒視窗中點選 [取得刪除 Azure 資源的權限] 連結，然後在 Azure Active Directory 的 [屬性] 刀鋒視窗中，將 [Azure 資源的存取管理] 設為 [是]，再選取 [儲存]。

13. 登出 Azure 入口網站後再次登入。 

14. 巡覽回 [刪除目錄「AdatumLab500-04」] 刀鋒視窗，然後按一下 [刪除]。

    >**注意**：若仍然無法刪除租用戶，且系統擲回「刪除所有授權型訂用帳戶」錯誤，可能是因為有訂用帳戶已連結至租用戶。 在這裡 **免費 Premium P2 授權** 可能會擲回驗證錯誤。 若要解決此問題，請使用全域管理員識別碼從 M365 系統管理中心 >> [您的產品] 以及 **企業市集** 入口網站刪除 Premium P2 授權的試用版訂用帳戶。 另請注意，刪除租用戶需要較長時間。 查看訂用帳戶的結束日期。試用期結束後，請重新前往 Azure Active Directory 並嘗試刪除租用戶。    

> 如需有關這項工作的任何其他資訊，請參閱 [https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/directory-delete-howto](https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/directory-delete-howto)
