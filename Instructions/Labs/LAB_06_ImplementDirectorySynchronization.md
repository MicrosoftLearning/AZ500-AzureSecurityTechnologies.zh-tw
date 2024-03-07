---
lab:
  title: 06 - 實作目錄同步作業
  module: Module 01 - Manage Identity and Access
---

# 實驗室 06：實作目錄同步處理
# 學生實驗室手冊

## 實驗案例

系統要求您建立概念證明，示範如何將內部部署 Microsoft Entra Domain Services 環境與 Microsoft Entra 租使用者整合。 具體而言，您必須：

- 部署裝載 Microsoft Entra Domain Services 網域控制站的 Azure VM，以實作單一網域 Microsoft Entra Domain Services 樹系
- 建立及設定 Microsoft Entra 租使用者
- 同步處理 Microsoft Entra Domain Services 樹系與 Microsoft Entra 租使用者

> 此實驗室中所有資源均使用**美國東部**區域。 請與講師驗證這是課程中要使用的區域。 

## 實驗室目標

在本實驗室中，您將完成下列練習：

- 練習 1：部署裝載 Microsoft Entra ID 網域控制站的 Azure VM
- 練習 2：建立及設定 Microsoft Entra 租使用者
- 練習 3：同步處理 Microsoft Entra 識別碼樹系與 Microsoft Entra 租使用者

## 實作目錄同步作業

![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/5d9cc4c7-7dcd-4d88-920d-9c97d5a482a2)

## 指示

### 練習 1：部署裝載 Microsoft Entra ID 網域控制站的 Azure VM

### 估計時間：10 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：識別 Azure VM 部署的可用 DNS 名稱
- 工作 2：使用 ARM 範本部署裝載 Microsoft Entra ID 網域控制站的 Azure VM

#### 工作 1：識別 Azure VM 部署的可用 DNS 名稱

在此工作中，您必須為 Azure VM 部署識別 DNS 名稱。 

1. 登入 Azure 入口網站：**`https://portal.azure.com/`**。

    >**注意 ** ：使用在您要用於此實驗室的 Azure 訂用帳戶中具有擁有者或參與者角色的帳戶登入Azure 入口網站。

2. 按一下 Azure 入口網站右上方的第一個圖示，開啟 Cloud Shell。 如果出現提示，請點選 [PowerShell]**** 與 [建立儲存體]****。

3. 確認在 [Cloud Shell] 窗格左上角的下拉式功能表中，已選取 [PowerShell]****。

4. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中執行下列指令，以找出可在本練習下一項工作中用於 Azure VM 部署的 DNS 名稱：

    ```powershell
    Test-AzDnsAvailability -DomainNameLabel <custom-label> -Location '<location>'
    ```

    >**注意 ** ：將 `<custom-label>` 預留位置取代為可能全域唯一的有效 DNS 名稱。 將 `<location>` 預留位置替換為您要部署 Azure VM 的區域名稱。該 VM 會用於裝載您要在此實驗室中使用的 Active Directory 網域控制站。

    >**注意 ** ：若要識別您可以布建 Azure VM 的 Azure 區域，請參閱 [**https://azure.microsoft.com/en-us/regions/offers/**](https://azure.microsoft.com/en-us/regions/offers/)

5. 確認命令傳回 **True**。 如果沒有，請以不同的 `<custom-label>` 值重新執行同一個命令，直到命令傳回 **True** 為止。

6. 記錄取得成功結果的 `<custom-label>` 值。 您將在下一個工作中需要它。

7. 關閉 Cloud Shell。

#### 工作 2：使用 ARM 範本部署裝載 Microsoft Entra ID 網域控制站的 Azure VM

在這項工作中，您將部署將裝載 Microsoft Entra ID 網域控制站的 Azure VM

1. 在相同的瀏覽器視窗中開啟另一個瀏覽器索引標籤，然後瀏覽至 **https://github.com/Azure/azure-quickstart-templates/tree/master/application-workloads/active-directory/active-directory-new-domain**。

2. 在 [ ** 使用新的 AD 樹 ** 系建立 Azure VM] 頁面上，按一下 [ ** 部署至 Azure ** ]。 這會將瀏覽器自動重新導向 Azure 入口網站中的 [使用新的 AD 樹系建立 Azure VM]**** 刀鋒視窗。 

3. 在 [使用新的 AD 樹系建立 Azure VM]**** 刀鋒視窗中按一下 [編輯參數]****。

4. 在 [編輯參數]**** 刀鋒視窗中按一下 [載入檔案]****，然後在 [開啟]**** 對話方塊中瀏覽至 **\\\\AllFiles\Labs\\06\\active-directory-new-domain\\azuredeploy.parameters.json** 資料夾，再依序點選 [開啟]**** 與 [儲存]****。

5. 在 [使用新的 AD 樹系建立 Azure VM]**** 刀鋒視窗中指定下列設定 (其他設定請保留現有值)：

   |設定|值|
   |---|---|
   |訂用帳戶|您 Azure 訂閱的名稱|
   |資源群組|按一下 [建立新項目] **** 並輸入以下名稱：**AZ500LAB06**|
   |區域|您在前一項工作識別出的 Azure 區域|
   |管理員使用者名稱|**Student**|
   |管理員密碼|**請使用您在實驗室 04 > 練習 1 > 工作 1 > 步驟 9 建立的個人密碼。**|
   |網域名稱|**adatum.com**|
   |DNS 前置詞|您在前一項工作找出的 DNS 主機名稱|
   |VM 大小|**Standard_D2s_v3**|

6. 在 [使用新的 AD 樹系建立 Azure VM]**** 刀鋒視窗中，按一下 [檢閱 + 建立]****，然後點選 [建立]****。

    >**注意 ** ：不要等待部署完成，而是繼續進行下一個練習。 部署可能需要大約 15 分鐘。 您會在本實驗室的第三項練習中，使用在此工作部署的虛擬機器。

> 結果：完成此練習之後，您已使用 Azure Resource Manager 範本起始裝載 Microsoft Entra ID 網域控制站的 Azure VM 部署


### 練習 2：建立及設定 Microsoft Entra 租使用者 

### 預估時間：20 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：建立 Microsoft Entra 租使用者
- 工作 2：將自訂 DNS 名稱新增至新的 Microsoft Entra 租使用者
- 工作 3：建立具有全域管理員istrator 角色的 Microsoft Entra ID 使用者

#### 工作 1：建立 Microsoft Entra 租使用者

在這項工作中，您將建立新的 Microsoft Entra 租使用者，以在此實驗室中使用。 

1. 在 [Azure 入口網站] ** 頁面頂端 Azure 入口網站的 [搜尋資源、服務和檔] ** 文字方塊中，輸入 ** Microsoft Entra ID ** ，然後按 ** Enter ** 鍵。

2. 在顯示 ** 您目前 Microsoft Entra 租使用者概觀 ** 的刀鋒視窗上，按一下 ** [管理租使用者 ** ]，然後在下一個畫面上，按一下 ** [+ 建立 ** ]。

3. 在 [建立租 ** 使用者] 刀鋒視窗的 ** [ ** 基本] ** 索引標籤上，確定已選取 [Microsoft Entra ID ** ] 選項 ** ，然後按 ** [下一步：組態> ** ]。

4. 在 [建立目錄]**** 刀鋒視窗的 [設定]**** 索引標籤上，指定下列設定：

   |設定|值|
   |---|---|
   |組織名稱|**AdatumSync**|
   |初始網域名稱|包含字母和數字組合的唯一名稱|
   |國家或地區|**美國**|

    >**注意 ** ：記錄初始功能變數名稱。 之後在此實驗中會用到。

    >**注意 ** ：[初始功能變數名稱] ** 文字方塊中的 ** 綠色核取記號會指出您輸入的功能變數名稱是否有效且是唯一的。 (請記錄初始網域名稱以供之後使用)。

5. 按一下 [檢閱 + 建立]  ，然後按一下 [建立]  。

    >**注意 ** ：等候建立新的租使用者。 使用**通知**圖示監視部署狀態。 

#### 工作 2：將自訂 DNS 名稱新增至新的 Azure AD 租使用者

在此工作中，您必須在新的 Azure AD 租用戶中新增自訂 DNS 名稱。 

1. 在 Azure 入口網站的工具列中，按一下 Cloud Shell 圖示右邊的**目錄 + 訂用帳戶**圖示。 

2. 在 [目錄 + 訂閱]**** 刀鋒視窗中選取新建立的 租用戶 [AdatumSync]**** 行，然後按一下 [切換]**** 按鈕。

    >**注意 ** ：如果 ** AdatumSync ** 專案未出現在 ** [目錄 + 訂 ** 用帳戶篩選] 清單中，您可能需要重新整理瀏覽器視窗。

3. 在 [ ** AdatumSync \| Microsoft Entra ID ** ] 刀鋒視窗的 [ ** 管理 ** ] 區段中，按一下 [ ** 自訂功能變數名稱 ** ]。

4. 在 [AdatumSync \| 自訂網域名稱] **** 刀鋒視窗中，按一下 [+ 新增自訂網域]****。

5. 在 [自訂網域名稱]**** 刀鋒視窗的 [自訂網域名稱]**** 文字輸入框中，輸入 **adatum.com**，然後按一下 [新增網域]****。

6. 在 ** [adatum.com] ** 刀鋒視窗中，檢閱執行 Microsoft Entra 功能變數名稱驗證所需的資訊，然後選取 ** [刪除 ** 兩次]。 

    >**注意 ** ：您無法完成驗證程式，因為您沒有 adatum.com ** ** DNS 功能變數名稱。 這不會防止您將 adatum.com ** Microsoft Entra Domain Services 網域與 Microsoft Entra 租使用者同步 ** 處理。 您將針對此用途使用 Microsoft Entra 租使用者的初始 DNS 名稱（名稱結尾 ** 為 onmicrosoft.com ** 尾碼），您在上一個工作中識別的名稱。 不過，請記住，因此，Microsoft Entra Domain Services 網域的 DNS 功能變數名稱和 Microsoft Entra 租使用者的 DNS 名稱將會有所不同。 這表示 Adatum 使用者在登入 Microsoft Entra Domain Services 網域和登入 Microsoft Entra 租使用者時，必須使用不同的名稱。

#### 工作 3：建立具有全域管理員istrator 角色的 Microsoft Entra ID 使用者

在這項工作中，您將新增 Microsoft Entra ID 使用者，並將其指派給 Global 管理員istrator 角色。 

1. 在 [ ** AdatumSync ** Microsoft Entra 租使用者] 刀鋒視窗的 [ ** 管理 ** ] 區段中，按一下 [ ** 使用者 ** ]。

2. 在 [ ** 使用者] |所有使用者 ** 刀鋒視窗，按一下 ** [+ 新增使用者 ** ]，然後按一下 [ ** 建立新使用者 ** ]。

3. 在 [ ** 新增使用者 ** ] 刀鋒視窗上，確定 ** 已選取 [建立使用者 ** ] 選項，在 [基本] 索引標籤上指定下列設定（保留所有其他的預設值），然後按 ** [下一步：屬性] > ** ：

   |設定|值|
   |---|---|
   |使用者名稱|**syncadmin**|
   |名稱|**syncadmin**|
   |密碼|確定已選取 [自動產生密碼]**** 選項，然後按一下 [顯示密碼]****|

    >**注意 ** ：記錄完整的使用者名稱。 您可以按一下 ** 下拉式清單右側的 [複製到剪貼簿 ** ] 按鈕來複製其值，以顯示功能變數名稱，並將它貼到記事本檔中。 之後在此實驗室中會用到。

    >**注意 ** ：按一下 [密碼] 文字方塊右側的 [ ** 複製到剪貼簿 ** ] 按鈕，並將其貼到記事本檔中，以記錄使用者的密碼。 之後在此實驗室中會用到。

4. 在 [ ** 屬性] ** 索引標籤上，捲動至底部，並指定 [使用位置：美國 ** （讓所有其他專案都保留預設值），然後按 ** [下一步： ** 指派> ** 。

5. 在 [ ** 指派] 索引 ** 標籤上，按一下 ** [+ 新增角色 ** ]，搜尋並選取 ** [全域管理員istrator ** ]，然後按一下 [ ** 選取 ** ]。 按一下 [檢閱 + 建立]  ，然後按一下 [建立]  。
   
    >**注意 ** ：需要具有全域管理員istrator 角色的 Azure AD 使用者，才能實作 Microsoft Entra 連線。

6. 開啟 InPrivate 瀏覽器視窗。

7. 流覽至 Azure 入口網站 ** `https://portal.azure.com/` ** ，並使用 ** syncadmin ** 使用者帳戶登入。 出現提示時，請將您稍早在這項工作中記錄的密碼變更為符合複雜度需求的密碼，並記錄它以供日後參考。 系統會在稍後的工作中提示您輸入此密碼。

    >**注意 ** ：若要登入，您必須提供 syncadmin ** 使用者帳戶的完整名稱 ** ，包括您稍早在這項工作中記錄的 Microsoft Entra 租使用者 DNS 功能變數名稱。 此使用者名稱的格式為 syncadmin@ `<your_tenant_name>` .onmicrosoft.com，其中 `<your_tenant_name>` 是代表您唯一 Microsoft Entra 租使用者名稱的預留位置。 

8. 以 **syncadmin** 的身分登出，然後關閉 InPrivate 瀏覽器視窗。

> **結果 ** ：完成此練習之後，您已建立 AMicrosoft Entra 租使用者、瞭解如何將自訂 DNS 名稱新增至新的 Microsoft Entra 租使用者，以及建立具有全域管理員istrator 角色的 Azure AD 使用者。


### 練習 3：同步處理 Microsoft Entra 識別碼樹系與 Microsoft Entra 租使用者

### 預估時間：20 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：準備 Microsoft Entra Domain Services 以進行目錄同步處理
- 工作 2：安裝 Microsoft Entra 連線
- 工作 3：驗證目錄同步處理

#### 工作 1：準備 Microsoft Entra Domain Services 以進行目錄同步處理

在這項工作中，您將連線到執行 Microsoft Entra Domain Services 網域控制站的 Azure VM，並建立目錄同步處理帳戶。 

   > 開始進行此工作前，請確定您在本實驗室第一項練習中啟動的範本部署已完成。

1. 在Azure 入口網站中，將 ** [目錄 + 訂 ** 用帳戶] 篩選設定為與您在此實驗室第一個練習中部署 Azure VM 之 Azure 訂用帳戶相關聯的 Microsoft Entra 租使用者。

2. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件]**** 文字輸入框中輸入「虛擬機器」****，然後按下 **Enter** 鍵。

3. 在 [虛擬機器]**** 刀鋒視窗中按一下 [adVM]**** 項目。 

4. 在 [adVM]**** 刀鋒視窗中按一下 [連線]****，然後在下拉式功能表中點選 [RDP]****。 

5. 在 [ ** IP 位址 ** ] 下拉式清單中，選取 ** [負載平衡器公用 IP 位址 ** ]，然後按一下 [ ** 下載 RDP 檔案 ** ]，並使用它透過遠端桌面連線到 ** adVM ** Azure VM。 出現驗證提示時，請提供下列認證：

   |設定|值|
   |---|---|
   |使用者名稱|**Student**|
   |密碼|**請使用您在實驗室 04 > 練習 1 > 工作 1 > 步驟 9 建立的個人密碼。**|

    >**注意 ** ：等候遠端桌面會話和 ** 伺服器管理員 ** 載入。  

    >**注意 ** ：下列步驟會在 AdVM ** Azure VM 的 ** 遠端桌面會話中執行。

    >**注意 ** ：如果在 ** RDP 刀鋒視窗的 ** [IP 位址] 下拉式清單中無法使用負載平衡器公用 IP 位址 ** ** ，請在 Azure 入口網站中搜尋 ** [公用 IP 位址 ** ]，選取 ** [adPublicIP ** ]，並記下其 IP 位址。 按一下 [開始] 按鈕，輸入 ** MSTSC ** ，然後按 ** Enter ** 以啟動遠端桌面用戶端。 在 [ ** 電腦： ** ] 文字方塊中輸入負載平衡器的公用 IP 位址，然後按一下 ** [連線 ** ]。

6. 在 ** 伺服器管理員 ** 中，按一下 ** [工具 ** ]，然後在下拉式功能表中，按一下 ** [Microsoft Entra ID 管理員istrative Center ** ]。

7. 在 ** Microsoft Entra ID 管理員istrative Center ** 中，按一下 ** [工作 ** ] 窗格中 ** 的 [功能變數名稱 adatum] 下方的 [新增 ** ** ]， ** ** 然後在級聯功能表中，按一下 ** ** [組織單位]。 **

8. 在 [建立組織單位]**** 視窗的 [名稱]**** 文字輸入框內輸入 **ToSync**，然後按一下 [確定]****。

9. 按兩下新建立 ** 的 ToSync ** 組織單位，使其內容出現在 Microsoft Entra ID 管理員istrative Center 主控台的詳細資料窗格中。 

10. 在 [工作]**** 窗格的 [ToSync]**** 區段按一下 [新增]****，然後在串聯功能表中點選 [使用者]****。

11. 在 [建立使用者]**** 視窗中使用下列設定建立新的使用者帳戶 (其他設定請保留現有值)，然後按一下 [確定]****：
    
    |設定|值|
    |---|---|
    |Full Name|**aduser1**|
    |使用者 UPN 登入|**aduser1**|
    |使用者 SamAccountName 登入|**aduser1**|
    |[密碼] 與 [確認密碼]|**請使用您在實驗室 04 > 練習 1 > 工作 1 > 步驟 9 建立的個人密碼。**|
    |其他密碼選項|**密碼永不到期**|


#### 工作 2：安裝 Microsoft Entra 連線

在這項工作中，您會在虛擬機器上安裝 Microsoft Entra 連線。 

1. 在連線至 **adVM** 的遠端桌面工作階段中，使用 Microsoft Edge 前往位於 **https://portal.azure.com** 的 Azure 入口網站，並使用您在上一項練習中建立的 **syncadmin** 使用者帳戶登入。 出現提示時，請指定您在上一個練習中記錄的完整使用者主體名稱和密碼。

2. 在 [Azure 入口網站] ** 頁面頂端 Azure 入口網站的 [搜尋資源、服務和檔] ** 文字方塊中，輸入 ** Microsoft Entra ID ** ，然後按 ** Enter ** 鍵。

3. 在 [Azure 入口網站] ** 的 [AdatumSync \| 概觀 ** ] 刀鋒視窗中，按一下 [管理 ** ** ] 下方左側導覽面板中 ** 的 [Microsoft Entra 連線 ** ]。

4. 在 [ ** Microsoft Entra 連線 \| 開始使用 ** ] 刀鋒視窗中，按一下 ** 左側導覽面板中的 [連線同步 ** 處理]，然後按一下 ** [下載 Microsoft Entra 連線 ** ] 連結。 系統會將您重新導向至 ** Microsoft Entra 連線 ** 下載頁面。

5. 在 [ ** Microsoft Entra 連線下載] ** 頁面上，按一下 [ ** 下載 ** ]。

6. 出現提示時，按一下 [ ** 執行] 啟動 ** Microsoft Entra 連線 ** 精 ** 靈。

7. **在 Microsoft Entra 連線精靈的 ** [歡迎使用 Microsoft Entra 連線 ** ] ** 頁面上，按一下 [我同意授權條款與隱私權注意事項 ** ] 核取方塊 ** ，然後按一下 [ ** 繼續]。 **

8. 在 ** Microsoft Entra 連線 精靈的 ** [Express 設定 ** ] ** 頁面上，按一下 [ ** 自訂 ** ] 選項。

9. 在 [安裝所需的元件]**** 頁面上取消選取所有選用設定選項，然後按一下 [安裝]****。

10. 在 [使用者登入]**** 頁面上確定只啟用 [密碼雜湊同步]****，然後點選 [下一步]****。

11. 在 ** [連線至 Microsoft Entra 識別碼 ** ] 頁面上，使用您在上一個練習中建立的 ** syncadmin ** 使用者帳號憑證進行驗證，然後按 ** [下一步 ** ]。 

12. 在 [連線您的目錄] **** 頁面上按一下 [adatum.com]**** 樹系項目右邊的 [新增目錄]**** 按鈕。

13. 在 [ ** AD 樹系帳戶 ** ] 視窗中，確定已選取 [建立新的 Microsoft Entra ID 帳戶 ** ] 選項 ** 、指定下列認證，然後按一下 [ ** 確定 ** ]：

    |設定|值|
    |---|---|
    |使用者名稱|**ADATUM\\Student**|
    |密碼|**請使用您在實驗室 06 > 練習 1 > 工作 2 中建立的個人密碼**|

14. 返回 [連線您的目錄] **** 頁面，確定 [adatum.com]**** 項目顯示為已設定的目錄，然後點選 [下一步]****

15. 在 [ ** Microsoft Entra ID 登入組態 ** ] 頁面上，請注意警告指出 ** 如果使用者無法使用內部部署認證登入 Microsoft Entra ID，如果 UPN 尾碼不符合已驗證的功能變數名稱 ** ，請啟用 [繼續] 核取方塊 ** ，而不符合所有 UPN 尾碼與已驗證的網域 ** 相符，然後按 ** [下一步 ** ]。

    >**注意 ** ：如先前所述，這是預期的，因為您無法驗證自訂的 Microsoft Entra ID DNS 網域 ** adatum.com ** 。

16. 在 [ ** 網域和 OU 篩選 ** ] 頁面上，按一下 [同步選取的網域和 OU ** ] 選項 ** ，然後清除功能變數名稱 ** 旁的核取方塊 adatum.com ** 。 按一下以展開 ** adatum.com ** ，只選取 ToSync ** OU 旁的 ** 核取方塊，然後按 ** [下一步 ** ]。

17. 在 [專門識別您的使用者]**** 頁面上接受預設設定，然後點選 [下一步]****。

18. 在 [篩選使用者和裝置]**** 頁面上接受預設設定，然後點選 [下一步]****。

19. 在 [選用功能]**** 頁面上接受預設設定，然後點選 [下一步]****。

20. 在 [已可設定]**** 頁面上確定已選取 [在設定完成時開始同步處理程序]**** 核取方塊，然後按一下 [安裝]****。

    >**注意 ** ：安裝大約需要 2 分鐘的時間。

21. 檢閱 [ ** 組態完成 ** ] 頁面上的資訊，然後按一下 ** [結束 ** ] 關閉 ** [Microsoft Entra 連線 ** ] 視窗。


#### 工作 3：驗證目錄同步處理

在此工作中，您必須驗證目錄同步作業可正常運作。 

1. 在 adVM ** 的遠端桌面會話 ** 中，于顯示Azure 入口網站的 Microsoft Edge 視窗中，流覽至 ** Adatum Lab AMicrosoft Entra ID 租使用者的 [所有使用者] ** 刀鋒視窗 。

2. 在 [使用者 \| 所有使用者 (預覽)]**** 刀鋒視窗中，留意包含 **aduser1** 帳戶在內的使用者物件清單。 

   >**注意 ** ：您可能必須等候幾分鐘，然後選取 ** [重新 ** 整理]， ** 讓 aduser1 ** 使用者帳戶出現。

3. **按一下 aduser1 ** 帳戶並選取 ** [屬性 ** ] 索引標籤。向下捲動至 ** [內部部署 ** ] 區段，請注意已啟用 ** 內部部署同步 ** 處理的屬性設定為 [ ** 是 ** ]。

4. 在 [aduser1] ** 刀鋒視窗的 ** ** [作業資訊 ** ] 區段中，請注意 ** ，未設定 Department ** 屬性。

5. 在 adVM 的遠端桌面會話 ** 中，切換至 ** Microsoft Entra ID 管理員istrative Center ** ，在 ToSync ** OU 的物件清單中 ** 選取 aduser1 專案，然後在 ** ** [工作] 窗格 ** 的 [aduser1 ** ** ] 區段中，選取 ** ** [屬性]。 ** **

6. 在 [aduser1]**** 視窗的 [組織]**** 區段中，於 [部門]**** 文字輸入框內輸入**銷售**，然後選取 [確定]****。

7. 在連線至 **adVM** 的遠端桌面工作階段中，啟動 **Windows PowerShell**。

8. **從 管理員istrator：Windows PowerShell ** 主控台，執行下列命令以啟動 Microsoft Entra 連線差異同步處理：

    ```powershell
    Import-Module -Name 'C:\Program Files\Microsoft Azure AD Sync\Bin\ADSync\ADSync.psd1'

    Start-ADSyncSyncCycle -PolicyType Delta
    ```

9. 切換至顯示 aduser1 ** 刀鋒視窗的 ** Microsoft Edge 視窗，重新整理頁面，並記下 Department 屬性設定為 Sales。

    >**注意 ** ：如果 Department ** 屬性仍未設定， ** 您可能需要等候最多三分鐘，然後重新整理頁面。

> **結果 ** ：完成此練習之後，您已備妥 Microsoft Entra Domain Services 以進行目錄同步處理、已安裝 Microsoft Entra 連線，以及已驗證的目錄同步處理。


**清除資源**

>**注意 ** ：從停用 Microsoft Entra ID 同步處理開始

1. 在連線至 **adVM** 的遠端桌面工作階段中，啟動 Windows PowerShell 作為系統管理員。

2. 在 Windows PowerShell 主控台中執行下列指令以安裝 MsOnline PowerShell 模組 (出現提示後，在 [必須輸入 NuGet 提供者才能繼續操作] 對話方塊中輸入 **Yes**，然後按下 Enter 鍵)：

    ```powershell
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module MsOnline -Force
    ```

3. 從 Windows PowerShell 主控台執行下列命令來連線到 AdatumSync Microsoft Entra 租使用者（出現提示時，請使用 ** syncadmin ** 認證登入）：

    ```powershell
    Connect-MsolService
    ```

4. 從 Windows PowerShell 主控台，執行下列命令以停用 Microsoft Entra 連線同步處理：

    ```powershell
    Set-MsolDirSyncEnabled -EnableDirSync $false -Force
    ```

5. 在 Windows PowerShell 主控台中執行下列指令以驗證作業是否已成功：

    ```powershell
    (Get-MSOLCompanyInformation).DirectorySynchronizationEnabled
    ```
    >**注意 ** ：結果應該是 `False` 。 若結果並非如此，請稍候片刻再重新執行這個指令。

    >**注意 ** ：接下來，移除 Azure 資源
6. 關閉遠端桌面工作階段。

7. 在Azure 入口網站中，將 ** [目錄 + 訂 ** 用帳戶] 篩選設定為與您部署 ** adVM ** Azure VM 之 Azure 訂用帳戶相關聯的 Microsoft Entra 租使用者。

8. 在 Azure 入口網站中按一下右上方的第一個圖示，開啟 Cloud Shell。 

9. 在 [Cloud Shell] 窗格左上角的下拉式功能表中選取 [PowerShell]****，並在提示出現時按一下 [確認]****。 

10. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列操作，移除您在此實驗室中建立的資源群組：
  
    ```powershell
    Remove-AzResourceGroup -Name "AZ500LAB06" -Force -AsJob
    ```
11. 關閉 [Cloud Shell] 窗格。

    >**注意 ** ：最後，移除 Microsoft Entra 租使用者
    
    >**附注 2 ** ：刪除租使用者是一個非常困難的程式，因此永遠不會意外或惡意地完成。  換句話說，在此實驗室中通常無法移除租用戶。  儘管這裡列出了刪除租用戶的步驟，但您不需要進行這項作業也能完成此實驗室的工作。 如果您在現實情況下需要移除租用戶，可以在 DOCS.Microsoft.com 上找到說明文章。

12. 回到Azure 入口網站，使用 ** [目錄 + 訂 ** 用帳戶篩選] 切換至 ** AdatumSync ** Microsoft Entra 租使用者。

13. 在 Azure 入口網站中前往 [使用者 - 所有使用者]**** 刀鋒視窗，按一下代表 **asyncadmin** 使用者帳戶的項目，然後在 [syncadmin - 設定檔]**** 刀鋒視窗中點選 [刪除]****。出現確認提示時，請按一下 [是]****。

14. 重複以相同的順序執行上述步驟，以刪除 **aduser1** 使用者帳戶和**內部部署目錄同步處理服務帳戶**。

15. 流覽至 ** Microsoft Entra 租使用者的 [AdatumSync - 概 ** 觀] 刀鋒視窗，按一下 [管理租 ** 使用者]，然後選取 AdatumSync ** 目錄的 ** 核取方塊，按一下 ** [刪除 ** ]，在 [刪除租使用者 'AdatumSync] ** 刀鋒視窗上 ** ，按一下 ** ** [取得刪除 Azure 資源的許可權] 連結 ** ，在 [AMicrosoft Entra] 的 [屬性 ** ] 刀鋒視窗上，將 [Azure 資源的 ** ** 存取管理] 設定 ** 為 ** [是 ** ]，然後按一下 [ ** 儲存 ** ]。

    >**注意 ** ：如果您收到任何警告符號，例如 ** 刪除所有使用者 ** ，然後繼續刪除您所建立的使用者，或警告符號指出 ** 刪除LinkedIn應用程式按一下警告訊息，並確認刪除LinkedIn應用程式 ** ，則必須解決所有警告以傳遞刪除租使用者。

16. 登出 Azure 入口網站後再次登入。 

17. 返回 [刪除租用戶「AdatumSync」]**** 刀鋒視窗，按一下 [刪除]****。

> 如需有關這項工作的任何其他資訊，請參閱 [https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/directory-delete-howto](https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/directory-delete-howto)
