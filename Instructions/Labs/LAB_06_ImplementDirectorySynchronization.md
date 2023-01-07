---
lab:
  title: 06 - 實作目錄同步作業
  module: Module 01 - Manage Identity and Access
---

# <a name="lab-06-implement-directory-synchronization"></a>實驗室 06：實作目錄同步作業
# <a name="student-lab-manual"></a>學生實驗室手冊

## <a name="lab-scenario"></a>實驗案例

您收到要求，必須建立概念證明以展示如何將內部部署的 Active Directory Domain Services (AD DS) 環境與 Azure Active Directory (Azure AD) 租用戶整合。 具體而言，您必須：

- 部署裝載 AD DS 網域控制站的 Azure VM，藉此實作單一網域 AD DS 樹系
- 建立並設定 Azure AD 租用戶
- 同步處理 AD DS 樹系與 Azure AD 租用戶

> 此實驗室中所有資源使用的都是**美國東部**區域。 請與講師驗證這是課程中要使用的區域。 

## <a name="lab-objectives"></a>實驗室目標

在本實驗室中，您將完成下列練習：

- 練習 1：部署裝載 Active Directory 網域控制站的 Azure VM
- 練習 2：建立和設定 Azure Active Directory 租用戶
- 練習 3：同步處理 Active Directory 樹系與 Azure Active Directory 租用戶

## <a name="implement-directory-synchronization"></a>實作目錄同步作業

![image](https://user-images.githubusercontent.com/91347931/157525374-8f740f14-c2db-47b3-98f8-7feb9bc122b5.png)

## <a name="instructions"></a>Instructions

### <a name="exercise-1-deploy-an-azure-vm-hosting-an-active-directory-domain-controller"></a>練習 1：部署裝載 Active Directory 網域控制站的 Azure VM

### <a name="estimated-timing-10-minutes"></a>預估時間：10 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：識別 Azure VM 部署可用的 DNS 名稱
- 工作 2：使用 ARM 範本部署裝載 Active Directory 網域控制站的 Azure VM

#### <a name="task-1-identify-an-available-dns-name-for-an-azure-vm-deployment"></a>工作 1：識別 Azure VM 部署可用的 DNS 名稱

在此工作中，您必須為 Azure VM 部署識別 DNS 名稱。 

1. 登入 Azure 入口網站 **`https://portal.azure.com/`** 。

    >**注意**：登入 Azure 入口網站時使用的帳戶，必須在您用於這個實驗室的 Azure 訂用帳戶中具有「擁有者」或「參與者」角色。

2. 按一下 Azure 入口網站右上方的第一個圖示，開啟 Cloud Shell。 如果出現提示，請點選 [PowerShell] 與 [建立儲存體]。

3. 確定在 [Cloud Shell] 窗格左上角的下拉式功能表中，已選取 [PowerShell]。

4. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中執行下列指令，以找出可在本練習下一項工作中用於 Azure VM 部署的 DNS 名稱：

    ```powershell
    Test-AzDnsAvailability -DomainNameLabel <custom-label> -Location '<location>'
    ```

    >**注意**：將 `<custom-label>` 預留位置替換為可能是全域唯一的有效 DNS 名稱。 將 `<location>` 預留位置替換為您要部署 Azure VM 的區域名稱。該 VM 會用於裝載您要在此實驗室中使用的 Active Directory 網域控制站。

    >**注意**：若要識別可以佈建 Azure VM 的 Azure 區域，請參閱 [ **https://azure.microsoft.com/en-us/regions/offers/** ](https://azure.microsoft.com/en-us/regions/offers/)

5. 確認命令傳回 **True**。 如果沒有，請以不同的 `<custom-label>` 值重新執行同一個命令，直到命令傳回 **True** 為止。

6. 記錄取得成功結果的 `<custom-label>` 值。 您將在下一個工作中需要它。

7. 關閉 Cloud Shell。

#### <a name="task-2-use-an-arm-template-to-deploy-an-azure-vm-hosting-an-active-directory-domain-controller"></a>工作 2：使用 ARM 範本部署裝載 Active Directory 網域控制站的 Azure VM

在此工作中，您必須部署要裝載 Active Directory 網域控制站的 Azure VM

1. 在相同的瀏覽器視窗中開啟另一個瀏覽器索引標籤，然後瀏覽至 **https://github.com/Azure/azure-quickstart-templates/tree/master/application-workloads/active-directory/active-directory-new-domain** 。

2. 在 [建立新的 Windows VM，以及建立新的 AD 樹系、網域和 DC] 頁面上，按一下 [部署到 Azure]。 這會將瀏覽器自動重新導向 Azure 入口網站中的 [使用新的 AD 樹系建立 Azure VM] 刀鋒視窗。

3. 在 [使用新的 AD 樹系建立 Azure VM] 刀鋒視窗中按一下 [編輯參數]。

4. 在 [編輯參數]刀鋒視窗中按一下 [載入檔案]，然後在 [開啟] 對話方塊中瀏覽至 **\\\\AllFiles\Labs\\06\\active-directory-new-domain\\azuredeploy.parameters.json** 資料夾，再依序點選 [開啟] 與 [儲存]。

5. 在 [使用新的 AD 樹系建立 Azure VM] 刀鋒視窗中指定下列設定 (其他設定請保留現有值)：

   |設定|值|
   |---|---|
   |訂用帳戶|您 Azure 訂閱的名稱|
   |資源群組|按一下 [建立新項目] 並輸入以下名稱：**AZ500LAB06**|
   |區域|您在前一項工作識別出的 Azure 區域|
   |管理員使用者名稱|**Student**|
   |管理員密碼|**請使用您在實驗室 04 > 練習 1 > 工作 1 > 步驟 9 中建立的個人密碼。**|
   |網域名稱|**adatum.com**|
   |DNS 前置詞|您在前一項工作找出的 DNS 主機名稱|
   |VM 大小|**Standard_D2s_v3**|

6. 在 [使用新的 AD 樹系建立 Azure VM] 刀鋒視窗中，按一下 [檢閱 + 建立]，然後點選 [建立]。

    >**注意**：不需等待部署完成，請直接進行下一項練習。 部署可能需要大約 15 分鐘。 您會在本實驗室的第三項練習中，使用在此工作部署的虛擬機器。

> 結果：完成本練習就代表您已使用 Azure Resource Manager 範本起動用於裝載 Active Directory 網域控制站的 Azure VM 部署


### <a name="exercise-2-create-and-configure-an-azure-active-directory-tenant"></a>練習 2：建立和設定 Azure Active Directory 租用戶 

### <a name="estimated-timing-20-minutes"></a>預估時間：20 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：建立 Azure Active Directory (AD) 租用戶
- 工作 2：在新的 Azure AD 租用戶中新增自訂 DNS 名稱
- 工作 3：使用全域管理員角色建立 Azure AD 使用者

#### <a name="task-1-create-an-azure-active-directory-ad-tenant"></a>工作 1：建立 Azure Active Directory (AD) 租用戶

在此工作中，您會建立要用於此實驗室的新 Azure AD 租用戶。 

1. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入 **Azure Active Directory**，然後按下 **Enter** 鍵。

2. 在顯示您目前 Azure AD 租用戶的 [概觀] 刀鋒視窗中，按一下 [管理租用戶]，然後在下一個畫面中點選 [+ 建立]。  

3. 在 [建立租用戶] 刀鋒視窗的 [基本] 索引標籤上，確定已選取 [Azure Active Directory] 選項，然後按一下 [下一步:   **設定 >]** 。

4. 在 [建立目錄] 刀鋒視窗的 [設定] 索引標籤上，指定下列設定：

   |設定|值|
   |---|---|
   |組織名稱|**AdatumSync**|
   |初始網域名稱|包含字母和數字組合的唯一名稱|
   |國家或區域|**美國**|

    >**注意**：請記錄初始網域名稱。 之後在此實驗室中會用到。

    >**注意**：[初始網域名稱] 文字輸入框中如顯示綠色核取記號，即代表您輸入的是有效且唯一的網域名稱。 (請記錄初始網域名稱以供之後使用)。

5. 按一下 [檢閱 + 建立]  ，然後按一下 [建立]  。

    >**注意**：等待新租用戶建立完成。 使用**通知**圖示監視部署狀態。 

#### <a name="task-2-add-a-custom-dns-name-to-the-new-azure-ad-tenant"></a>工作 2：在新的 Azure AD 租用戶中新增自訂 DNS 名稱

在此工作中，您必須在新的 Azure AD 租用戶中新增自訂 DNS 名稱。 

1. 在 Azure 入口網站的工具列中，按一下 Cloud Shell 圖示右邊的**目錄 + 訂閱**圖示。 

2. 在 [目錄 + 訂閱] 刀鋒視窗中選取新建立的 租用戶 [AdatumSync] 行，然後按一下 [切換] 按鈕。

    >**注意**：如果 **AdatumSync** 項目未出現在 [目錄 + 訂閱] 篩選清單中，您可能需要重新整理瀏覽器視窗。

3. 在 [AdatumSync \| Azure Active Directory] 刀鋒視窗的 [管理] 區段中，按一下 [自訂網域名稱]。

4. 在 [AdatumSync \| 自訂網域名稱] 刀鋒視窗中，按一下 [+ 新增自訂網域]。

5. 在 [自訂網域名稱] 刀鋒視窗的 [自訂網域名稱] 文字輸入框中，輸入 **adatum.com**，然後按一下 [新增網域]。

6. 在 [adatum.com] 刀鋒視窗中，檢閱執行 Azure AD 網域名稱驗證所需的資訊，然後選取 [刪除] 兩次。 

    >**注意**：您將無法完成驗證程序，因為您並非 **adatum.com** DNS 網域名稱的擁有者。 但這不會妨礙您同步處理 **adatum.com** AD DS 網域與 Azure AD 租用戶。 為了進行同步處理，您必須使用在前一項工作中識別的 Azure AD 租用戶的初始 DNS 名稱 (結尾為 **onmicrosoft.com** 的名稱)。 不過請注意，使用這種方法會導致 AD DS 網域的 DNS 網域名稱與 Azure AD 租用戶的 DNS 網域名稱不同。 換句話說，Adatum 使用者在登入 AD DS 網域和登入 Azure AD 租用戶時，必須分別使用不同的名稱。

#### <a name="task-3-create-an-azure-ad-user-with-the-global-administrator-role"></a>工作 3：使用全域管理員角色建立 Azure AD 使用者

在此工作中，您必須新增 Azure AD 使用者，並為其指派全域管理員角色。 

1. 在 [AdatumSync] Azure AD 租用戶刀鋒視窗的 [管理] 區段中，按一下 [使用者]。

2. 在 [使用者 \| 所有使用者] 刀鋒視窗中，按一下 [+ 新增使用者]。 

3. 在 [新增使用者] 刀鋒視窗中，確定已選取 [建立使用者] 選項並指定下列設定 (其他設定請保留預設值)，然後按一下 [建立]：

   |設定|值|
   |---|---|
   |使用者名稱|**syncadmin**|
   |名稱|**syncadmin**|
   |密碼|確定已選取 [自動產生密碼] 選項，然後按一下 [顯示密碼]|
   |群組|**已選取 0 個群組**|
   |角色|依序點選 [使用者]、[全域管理員] 與 [選取]|
   |使用位置|**美國**|  

    >**注意**：記錄完整使用者名稱。 您可以在顯示網域名稱的下拉式清單右側點選 [複製到剪貼簿] 按鈕以複製其值。 

    >**注意**：記錄使用者密碼。 之後在此實驗室中會用到。 

    >**注意**：唯有具備全域管理員角色的 Azure AD 使用者才能實作 Azure AD Connect。

4. 開啟 InPrivate 瀏覽器視窗。

5. 前往 Azure 入口網站，使用 **syncadmin** 使用者帳戶登入。 出現提示後，將您先前在此工作中記錄的密碼變更為 **Pa55w.rd1234**。

    >**注意**：若要登入，您必須提供 **syncadmin** 使用者帳戶的完整名稱，包括您先前在此工作中記錄的 Azure AD 租用戶 DNS 網域名稱。 使用者名稱的格式為 syncadmin@`<your_tenant_name>`.onmicrosoft.com，其中 `<your_tenant_name>` 是代表您唯一 Azure AD 租用戶名稱的預留位置。 

6. 以 **syncadmin** 的身分登出，然後關閉 InPrivate 瀏覽器視窗。

> **結果**：完成此練習就代表您已建立 Azure AD 租用戶，了解如何為新的 Azure AD 租用戶新增自訂 DNS 名稱，並建立了具有全域管理員角色的 Azure AD 使用者。


### <a name="exercise-3-synchronize-active-directory-forest-with-an-azure-active-directory-tenant"></a>練習 3：同步處理 Active Directory 樹系與 Azure Active Directory 租用戶

### <a name="estimated-timing-20-minutes"></a>預估時間：20 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：為目錄同步作業準備 AD DS
- 工作 2：安裝 Azure AD Connect
- 工作 3：驗證目錄同步作業

#### <a name="task-1-prepare-ad-ds-for-directory-synchronization"></a>工作 1：為目錄同步作業準備 AD DS

在此工作中，您必須連線至執行 AD DS 網域控制站的 Azure VM，並建立目錄同步處理帳戶。 

   > 開始進行此工作前，請確定您在本實驗室第一項練習中啟動的範本部署已完成。

1. 在 Azure 入口網站中，將 [目錄 + 訂閱] 篩選條件設定為 Azure AD 租用戶，該 Azure AD 租用戶應與您在本實驗室第一項練習中部署 Azure VM 的 Azure 訂閱相關聯。

2. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入**虛擬機器**，然後按下 **Enter** 鍵。

3. 在 [虛擬機器] 刀鋒視窗中按一下 [adVM] 項目。 

4. 在 [adVM] 刀鋒視窗中按一下 [連線]，然後在下拉式功能表中點選 [RDP]。 

5. **IP 位址**參數請選取 [負載平衡器公用 IP 位址]，然後點選 [下載 RDP 檔案]，再使用該檔案透過遠端桌面連線至 **adVM** Azure VM。 出現驗證提示時，請提供下列認證：

   |設定|值|
   |---|---|
   |使用者名稱|**Student**|
   |密碼|**請使用您在實驗室 04 > 練習 1 > 工作 1 > 步驟 9 中建立的個人密碼。**|

    >**注意**：等待遠端桌面工作階段和**伺服器管理員**載入。  

    >**注意**：下列步驟須在連線至 **adVM** Azure VM 的遠端桌面工作階段中執行。 

6. 在 [伺服器管理員] 中，依序點選 [本機伺服器] 與 [IE 增強的安全組態]。

7. 在 [Internet Explorer 增強式安全性設定] 對話方塊中將兩個選項都設定為 [關閉]，然後按一下 [確定]。

8. 啟動 Internet Explorer，前往 **https://www.microsoft.com/en-us/edge/business/download** 下載 Microsoft Edge 安裝二進位檔，然後執行安裝作業，並為網頁瀏覽器套用預設設定。

9. 在 [伺服器管理員] 中按一下 [工具]，然後在下拉式功能表裡按一下 [Active Directory 管理中心]。

10. 在 [Active Directory 管理中心] 中按一下 [adatum (本機)]，接著在 [工作] 窗格的網域名稱 [adatum (本機)] 下方點選 [新增]，再按一下串聯功能表中的 [組織單位]。

11. 在 [建立組織單位] 視窗的 [名稱] 文字輸入框內輸入 **ToSync**，然後按一下 [確定]。

12. 按兩下新建立的 [ToSync] 組織單位，其內容會顯示在 Active Directory 管理中心主控台的詳細資料窗格中。 

13. 在 [工作] 窗格的 [ToSync] 區段按一下 [新增]，然後在串聯功能表中點選 [使用者]。

14. 在 [建立使用者] 視窗中使用下列設定建立新的使用者帳戶 (其他設定請保留現有值)，然後按一下 [確定]：

   |設定|值|
   |---|---|
   |全名|**aduser1**|
   |使用者 UPN 登入|**aduser1**|
   |使用者 SamAccountName 登入|**aduser1**|
   |[密碼] 與 [確認密碼]|**請使用您在實驗室 04 > 練習 1 > 工作 1 > 步驟 9 中建立的個人密碼。**|
   |其他密碼選項|**密碼永不到期**|

#### <a name="task-2-install-azure-ad-connect"></a>工作 2：安裝 Azure AD Connect

在此工作中，您必須在虛擬機器上安裝 AD Connect。 

1. 在連線至 **adVM** 的遠端桌面工作階段中，使用 Microsoft Edge 前往位於 **https://portal.azure.com** 的 Azure 入口網站，並使用您在上一項練習中建立的 **syncadmin** 使用者帳戶登入。 出現提示後，指定所您記錄的完整使用者名稱和 **Pa55w.rd1234** 密碼。

2. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入 **Azure Active Directory**，然後按下 **Enter** 鍵。

3. 在 Azure 入口網站的 [AdatumSync \| 概觀] 刀鋒視窗中，按一下 [Azure AD Connect]。

4. 在 [AdatumSync \| Azure AD Connect] 刀鋒視窗中按一下 [下載 Azure AD Connect] 連結。 系統會將您重新導向 **Microsoft Azure Active Directory Connect** 下載頁面。

5. 在 [Microsoft Azure Active Directory Connect] 下載頁面上，按一下 [下載]。

6. 出現提示後，按一下 [執行] 即可啟動 [Microsoft Azure Active Directory Connect] 精靈。

7. 在 [Microsoft Azure Active Directory Connect] 精靈的 [歡迎使用 Azure AD Connect] 頁面勾選 [我同意授權條款和隱私權注意事項]，然後按一下 [繼續]。

8. 在 [Microsoft Azure Active Directory Connect] 精靈的 [快速設定] 頁面上，按一下 [自訂] 選項。

9. 在 [安裝所需的元件] 頁面上取消選取所有選用設定選項，然後按一下 [安裝]。

10. 在 [使用者登入] 頁面上確定只啟用 [密碼雜湊同步]，然後點選 [下一步]。

11. 在 [連線到 Azure AD] 頁面上，使用您在上一項練習中建立的 **syncadmin** 使用者帳戶認證進行驗證，然後點選 [下一步]。 

12. 在 [連線您的目錄] 頁面上按一下 [adatum.com] 樹系項目右邊的 [新增目錄] 按鈕。

13. 在 [AD 樹系帳戶] 視窗中確定已選取 [建立新的 AD 帳戶]，然後指定下列認證，並按一下 [確定]：

   |設定|值|
   |---|---|
   |使用者名稱|**ADATUM\\Student**|
   |密碼|**請使用您在實驗室 06 > 練習 1 > 工作 2 中建立的個人密碼**|

14. 返回 [連線您的目錄] 頁面，確定 [adatum.com] 項目顯示為已設定的目錄，然後點選 [下一步]

15. 留意 [Azure AD 登入設定] 頁面上的警告：**若 UPN 尾碼與已驗證的網域不符，使用者將無法以內部部署認證登入 Azure AD**，並啟用 [不將所有 UPN 尾碼比對至已驗證網域就繼續] 核取方塊，然後點選 [下一步]。

    >**注意**：如同先前所述，這是預料中的情況，因為您無法驗證自訂 Azure AD DNS 網域 **adatum.com**。

16. 在 [網域與 OU 篩選] 頁面上點選 [同步所選取的網域及 OU] 選項，這樣系統就會勾選網域名稱 **adatum.com**。展開 [adatum.com] 以檢視 [ToSync]。 清除所有核取方塊，僅勾選 [ToSync] OU 旁邊的核取方塊，然後點選 [下一步]。

17. 在 [專門識別您的使用者] 頁面上接受預設設定，然後點選 [下一步]。

18. 在 [篩選使用者和裝置] 頁面上接受預設設定，然後點選 [下一步]。

19. 在 [選用功能] 頁面上接受預設設定，然後點選 [下一步]。

20. 在 [已可設定] 頁面上確定已選取 [在設定完成時開始同步處理程序] 核取方塊，然後按一下 [安裝]。

    >**注意**：安裝應該需要大約 2 分鐘。

21. 檢閱 [設定完成] 頁面上的資訊，然後按一下 [結束] 關閉 [Microsoft Azure Active Directory Connect] 視窗。


#### <a name="task-3-verify-directory-synchronization"></a>工作 3：驗證目錄同步作業

在此工作中，您必須驗證目錄同步作業可正常運作。 

1. 在連線至 **adVM** 的遠端桌面工作階段中，透過 Microsoft Edge 視窗中顯示的 Azure 入口網站前往 Adatum 實驗室 Azure AD 租用戶的 [使用者 - 所有使用者 (預覽)] 刀鋒視窗。

2. 在 [使用者 \| 所有使用者 (預覽)] 刀鋒視窗中，留意包含 **aduser1** 帳戶在內的使用者物件清單。 

>**注意**：您可能需要等待數分鐘並選取 [重新整理]，**aduser1** 使用者帳戶才會出現。

3. 選取 [aduser1] 帳戶。在 [設定檔 > 身分識別] 區段中留意 [來源] 屬性是否已設定為 [Windows Server AD]。

4. 在 [aduser1 \| 設定檔] 刀鋒視窗的 [作業資訊] 區段中，留意 [部門] 屬性尚未設定。

5. 在連線至 **adVM** 的遠端桌面工作階段中，切換至 [Active Directory 管理中心]，並在 **ToSync** OU 的物件清單中選取 [aduser1] 項目。接著，在 [工作] 窗格的 [aduser1] 區段選取 [屬性]。

6. 在 [aduser1] 視窗的 [組織] 區段中，於 [部門] 文字輸入框內輸入**銷售**，然後選取 [確定]。

7. 在連線至 **adVM** 的遠端桌面工作階段中，啟動 **Windows PowerShell**。

8. 在**系統管理員：Windows PowerShell** 主控台中執行下列指令，以啟動 Azure AD Connect 差異同步處理：

    ```powershell
    Import-Module -Name 'C:\Program Files\Microsoft Azure AD Sync\Bin\ADSync\ADSync.psd1'

    Start-ADSyncSyncCycle -PolicyType Delta
    ```

9. 切換至顯示 [aduser1 \| 設定檔] 刀鋒視窗的 Microsoft Edge 視窗。重新整理頁面後，請留意 [部門] 屬性已設定為 [銷售]。

    >**注意**：如果 [部門] 屬性仍然顯示為未設定，您可能需要稍候片刻再重新整理頁面。

> **結果**：完成本練習就代表您已為目錄同步作業備妥 AD DS，安裝了 Azure AD Connect，並完成目錄同步處理的驗證。


**清除資源**

>**注意**：請先停用 Azure AD 同步處理

1. 在連線至 **adVM** 的遠端桌面工作階段中，啟動 Windows PowerShell 作為系統管理員。

2. 在 Windows PowerShell 主控台中執行下列指令以安裝 MsOnline PowerShell 模組 (出現提示後，在 [必須輸入 NuGet 提供者才能繼續操作] 對話方塊中輸入 **Yes**，然後按下 Enter 鍵)：

    ```powershell
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module MsOnline -Force
    ```

3. 在 Windows PowerShell 主控台中執行下列指令以連線至 AdatumSync Azure AD 租用戶 (出現提示後，請使用 **syncadmin** 認證登入)：

    ```powershell
    Connect-MsolService
    ```

4. 在 Windows PowerShell 主控台中執行下列指令以停用 Azure AD Connect 同步處理：

    ```powershell
    Set-MsolDirSyncEnabled -EnableDirSync $false -Force
    ```

5. 在 Windows PowerShell 主控台中執行下列指令以驗證作業是否已成功：

    ```powershell
    (Get-MSOLCompanyInformation).DirectorySynchronizationEnabled
    ```
    >**注意**：結果應為 `False`。 若結果並非如此，請稍候片刻再重新執行這個指令。

    >**注意**：接下來請移除 Azure 資源
6. 關閉遠端桌面工作階段。

7. 在 Azure 入口網站中，將 [目錄 + 訂閱] 篩選條件設定 Azure AD 租用戶，該 Azure AD 租用戶應與您部署 **adVM** Azure VM 的 Azure 訂閱相關聯。

8. 在 Azure 入口網站中按一下右上方的第一個圖示，開啟 Cloud Shell。 

9. 在 [Cloud Shell] 窗格左上角的下拉式功能表中選取 [PowerShell]，並在提示出現時按一下 [確認]。 

10. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列指令，移除您在此實驗室中建立的資源群組：
  
    ```powershell
    Remove-AzResourceGroup -Name "AZ500LAB06" -Force -AsJob
    ```
11. 關閉 [Cloud Shell] 窗格。

    >**注意**：最後，請移除 Azure AD 租用戶
    
    >**附註 2**：刪除租用戶的流程被設計得非常困難，因此絕不可能因意外或惡意刪除租用戶。  換句話說，在此實驗室中通常無法移除租用戶。  儘管這裡列出了刪除租用戶的步驟，但您不需要進行這項作業也能完成此實驗室的工作。 如果您在現實情況下需要移除租用戶，可以在 DOCS.Microsoft.com 上找到說明文章。

12. 返回 Azure 入口網站，使用 [目錄 + 訂閱] 篩選器切換至 **AdatumSync** Azure Active Directory 租用戶。

13. 在 Azure 入口網站中前往 [使用者 - 所有使用者] 刀鋒視窗，按一下代表 **asyncadmin** 使用者帳戶的項目，然後在 [syncadmin - 設定檔] 刀鋒視窗中點選 [刪除]。出現確認提示時，請按一下 [是]。

14. 重複以相同的順序執行上述步驟，以刪除 **aduser1** 使用者帳戶和**內部部署目錄同步處理服務帳戶**。

15. 前往 Azure AD 租用戶的 [AdatumSync - 概觀] 刀鋒視窗，按一下 [管理租用戶] 並勾選 [AdatumSync] 目錄的核取方塊，接著點選 [刪除]。在 [刪除租用戶「AdatumSync」] 刀鋒視窗中按一下 [取得刪除 Azure 資源的權限] 連結，然後在 Azure Active Directory 的 [屬性] 刀鋒視窗中，將 [Azure 資源的存取管理] 設定為 [是]，再按一下 [儲存] 。

    >**注意**：進行刪除作業時若收到如**刪除所有使用者**之類的警告訊息，請繼續執行刪除您所建立的使用者。若出現**刪除 LinkedIn 應用程式**的警告訊息，請按一下該訊息並確認刪除 LinkedIn 應用程式。您必須解決所有警告才能成功刪除租用戶。

16. 登出 Azure 入口網站後再次登入。 

17. 返回 [刪除租用戶「AdatumSync」] 刀鋒視窗，按一下 [刪除]。

> 如需有關這項工作的任何其他資訊，請參閱 [https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/directory-delete-howto](https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/directory-delete-howto)
