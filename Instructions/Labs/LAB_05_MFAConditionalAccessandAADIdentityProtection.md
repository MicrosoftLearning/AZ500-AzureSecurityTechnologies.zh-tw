---
lab:
  title: 04 - MFA 和條件式存取
  module: Module 01 - Manage Identity and Access
---

# 實驗室 05：MFA 和條件式存取
# 學生實驗室手冊

## 實驗案例

您收到要求，必須為用於增強 Azure Active Directory (Azure AD) 驗證的功能建立概念證明。 具體而言，您必須評估：

- Azure AD 多重要素驗證
- Azure AD 條件式存取
- Azure AD 條件式存取風險型原則

> 此實驗室中所有資源均使用**美國東部**區域。 請與講師驗證這是課程中要使用的區域。 

## 實驗室目標

在本實驗室中，您將完成下列練習：

- 練習 1：使用 Azure Resource Manager 範本部署 Azure VM
- 練習 2：實作 Azure MFA
- 練習 3：實作 Azure AD 條件式存取原則 
- 練習 4：實作 Azure AD Identity Protection

## MFA - 條件式存取 - 身分識別保護圖表

![image](https://user-images.githubusercontent.com/91347931/157518628-8b4a9efe-0086-4ec0-825e-3d062748fa63.png)

## 指示

## 實驗室檔案：

- **\\Allfiles\\Labs\\04\\az-500-04_azuredeploy.json**
- **\\Allfiles\\Labs\\04\\az-500-04_azuredeploy.parameters.json** 

### 練習 1：使用 Azure Resource Manager 範本部署 Azure VM

### 估計時間：10 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：使用 Azure Resource Manager 範本部署 Azure VM。

#### 工作 1：使用 Azure Resource Manager 範本部署 Azure VM

在這項工作中，您必須使用 ARM 範本建立虛擬機器。 本實驗室的最後一項練習會使用此虛擬機器。 

1. 登入 Azure 入口網站：**`https://portal.azure.com/`**。

    >**注意**：使用您用於此實驗室的 Azure 訂用帳戶中具有擁有者或參與者角色的帳戶，以及與該訂用帳戶相關聯的 Azure AD 租使用者中的全域 管理員 istrator 角色來登入 Azure 入口網站。

2. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入****「部署自訂範本」****。

    >**注意**：您也可以從 **Marketplace** 清單中選取 **[範本部署] （使用自定義範本**進行部署）。

3. 在 [自訂部署****] 刀鋒視窗中按一下 ****[在編輯器中建置您自己的範本] 選項。

4. 在 [編輯範本****] 刀鋒視窗中按一下 [載入檔案]****，找出 **\\Allfiles\\Labs\\04\\az-500-04_azuredeploy.json** 檔案，然後按一下 [開啟]****。

    >**注意**：檢閱範本的內容，並注意它會部署裝載 Windows Server 2019 Datacenter 的 Azure VM。

5. 在 [編輯範本****] 刀鋒視窗中按一下 [儲存****]。

6. 返回 [自訂部署] 刀鋒視窗，然後按一下 [編輯參數]。

7. 在 [編輯參數****] 刀鋒視窗中按一下 [載入檔案****]，找出 **\\Allfiles\\Labs\\04\\az-500-04_azuredeploy.parameters.json** 檔案，然後按一下 [開啟****]。

    >**注意**：檢閱參數檔案的內容，指出 adminUsername 和 adminPassword 值。

8. 在 [編輯參數] 刀鋒視窗上按一下 [儲存]。********

9. 在 [自訂部署****] 刀鋒視窗中，確認已指定下列設定 (其他設定請保留預設值)：

   >**注意**：您必須建立唯一的密碼，以用於建立課程其餘部分的 VM（虛擬機）。 密碼長度必須至少為 12 個字元，且符合定義的複雜度需求（密碼必須有下列 3 個：1 個小寫字元、1 個大寫字元、1 個數位和 1 個特殊字元）。 [VM 密碼需求](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/faq#what-are-the-password-requirements-when-creating-a-vm-)。 請記下密碼。

   |設定|值|
   |---|---|
   |訂用帳戶|您要在此實驗室中使用的 Azure 訂閱名稱|
   |資源群組|按一下 ****[新建]，然後輸入以下名稱：**AZ500LAB04**|
   |位置|**美國東部**|
   |VM 大小|**Standard_D2s_v3**|
   |虛擬機器名稱|**az500-04-vm1**|
   |管理員使用者名稱|**Student**|
   |管理員密碼|**請建立您自己的密碼，並加以記錄以供日後參考。系統會提示您輸入此密碼以取得必要的實驗室存取權。**|
   |虛擬網路名稱|**az500-04-vnet1**|

   >**注意**：若要識別您可以布建 Azure VM 的 Azure 區域，請參閱 [**https://azure.microsoft.com/en-us/regions/offers/**](https://azure.microsoft.com/en-us/regions/offers/)

10. 按一下 [檢閱 + 建立]****，然後按一下 [建立]****。

    >**注意**：不要等待部署完成，而是繼續進行下一個練習。 您在本實驗室的最後一項練習中會使用此部署中包含的虛擬機器。

> 結果：您已起始 Azure VM **az500-04-vm1** 的範本部署，您將在此實驗室的最後一個練習中使用。


### 練習 2：實作 Azure MFA

### 預估時間：30 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：建立新的 Azure AD 租使用者。
- 工作 2：啟動 Azure AD 進階版 P2 試用版。
- 工作 3：建立 Azure AD 使用者和群組。
- 工作 4：將 Azure AD 進階版 P2 授權指派給 Azure AD 使用者。
- 工作 5：設定 Azure MFA 設定。
- 工作 6：驗證 MFA 設定

#### 工作 1：建立新的 Azure AD 租使用者

在此工作中，您必須建立新的 Azure AD 租用戶。 

1. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入****「Azure Active Directory」****，然後按下 **Enter** 鍵。

2. 在顯示您目前 Azure AD 租用戶的 [概觀] 刀鋒視窗中，按一下 [管理租用戶]，然後在下一個畫面中點選 [+ 建立]。************

3. 在 [建立租**使用者] 刀鋒視窗的 **[**基本] 索引**標籤上，確定已選取 [Azure Active Directory **] 選項**，然後按 **[下一步：組態] >**。

4. 在 [建立租用戶]**** 刀鋒視窗的 [設定]**** 索引標籤上，指定下列設定：

   |設定|值|
   |---|---|
   |組織名稱|**AdatumLab500-04**|
   |初始網域名稱|包含字母和數字組合的唯一名稱|
   |國家或地區|**美國**|

    >**注意**：記錄初始功能變數名稱。 之後在此實驗中會用到。

5. 按一下 [檢閱 + 建立]，然後按一下 [建立]。
6. 在 [請協助我們證明您不是機器人] 刀鋒視窗中新增 Captcha 驗證碼****，然後按一下 [提交****] 按鈕。 

    >**注意**：等候建立新的租使用者。 使用**通知**圖示監視部署狀態。 


#### 工作 2：啟用 Azure AD 進階版 P2 試用版

在此工作中，您必須註冊 Azure AD Premium P2 試用版。 

1. 在 Azure 入口網站的工具列中，按一下 Cloud Shell 圖示右邊的**目錄 + 訂用帳戶**圖示。 

2. 在 [目錄 + 訂用帳戶****] 刀鋒視窗中，按一下新建立的租用戶 **AdatumLab500-04**，然後點選 ****[切換] 按鈕將其設定為目前的目錄。

    >**注意**：如果 **AdatumLab500-04** 專案未出現在 **[目錄 + 訂** 用帳戶篩選] 列表中，您可能需要重新整理瀏覽器視窗。

3. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入****「Azure Active Directory」****，然後按下 **Enter** 鍵。 在 ****[AdatumLab500-04] 刀鋒視窗的 [管理****] 區段中，按一下 [授權****]。

4. 在 [**** 授權 \| 概觀] 刀鋒視窗的 [管理****] 區段中，按一下 [所有產品****]，然後點選 [+ 試用/購買****]。

5. 在 [啟用****] 刀鋒視窗的 [Azure AD Premium P2] 區段中，按一下 [免費試用****]，然後點選 [啟用****]。


#### 工作 3：建立 Azure AD 使用者和群組。

在這項工作中，您必須建立三位使用者：aaduser1 (全域管理員)、aaduser2 (使用者) 以及 aaduser3 (使用者)。 您將需要每個使用者的用戶主體名稱和密碼，以供後續工作使用。 

1. 返回**** [AdatumLab500-04] Azure Active Directory 刀鋒視窗，然後在 [管理****] 區段中按一下 [使用者****]。

2. 在 [ **使用者 \| 所有使用者]** 刀鋒視窗上，按兩下 **[+ 新增使用者** ]，然後按兩下 [ **建立新使用者**]。 

3. 在 [ **新增使用者** ] 刀鋒視窗上，確定 **已選取 [建立使用者** ] 選項，然後在 [基本] 索引標籤上指定下列設定（讓所有其他專案都保留預設值），然後按 **[下一步：屬性] >**：

   |設定|值|
   |---|---|
   |使用者主體名稱|**aaduser1**|
   |名稱|**aaduser1**|
   |密碼|確定已選取 [自動產生密碼 **] 選項**|
   
      >**注意**：記錄完整的用戶主體名稱。 您可以按下顯示功能變數名稱之下拉式清單右側的 [ **複製到剪貼簿** ] 按鈕，以複製其值。 之後在此實驗室中會用到。
   
      >**注意**：記錄用戶的密碼。 按下文字框右側的 [ **複製到剪貼簿** ] 按鈕，即可複製其值。 之後在此實驗室中會用到。 
   
4. 在 [**屬性]** 索引標籤上，捲動至底部，並指定 [使用位置：美國 **]，然後按 **[下一步]：** 指派>**。

5. 在 [**指派] 索引**標籤上，按兩下 **[+ 新增角色**]，然後搜尋並選取 **[全域 管理員 istrator**]。 按兩下 [選取 **] 和 **[** 檢閱 + 建立**]，然後按兩下 [**建立**]。

6. 返回 [**** 使用者 \| 所有使用者] 刀鋒視窗，按一下 ****[+ 新增使用者]。 

7. 在 [ **新增使用者** ] 刀鋒視窗上，確定 **已選取 [建立使用者** ] 選項，並指定下列設定（讓所有其他設定都保留預設值），然後按 **[下一步：屬性] >**：

   |設定|值|
   |---|---|
   |使用者主體名稱|**aaduser2**|
   |名稱|**aaduser2**|
   |密碼|確定已選取 [自動產生密碼 **] 選項**| 

    >**注意**：記錄完整的用戶主體名稱和密碼。

8. 在 [**屬性]** 索引標籤上，捲動至底部，並指定 [使用位置：**美國** （讓所有其他專案都保留預設值），然後按兩下 [**檢閱 + 建立]，然後按兩下 [**建立****]。

9. 返回 [**** 使用者 \| 所有使用者] 刀鋒視窗，按一下 ****[+ 新增使用者]。 

10. 在 [ **新增使用者** ] 刀鋒視窗上，確定 **已選取 [建立使用者** ] 選項，並指定下列設定（讓所有其他設定都保留預設值），然後按 **[下一步：屬性] >**：

    |設定|值|
    |---|---|
    |使用者主體名稱|**aaduser3**|
    |名稱|**aaduser3**|
    |密碼|確定已選取 [自動產生密碼 **] 選項**|

    >**注意**：記錄完整的用戶主體名稱和密碼。

11. 在 [**屬性]** 索引標籤上，捲動至底部並指定 [使用位置：**美國** （讓所有其他專案都保留預設值），然後按兩下 **[檢閱 + 建立]，然後按兩下 **[建立****]。

    >**注意**：此時，您應該會在 [使用者 **] 頁面上列出**三個新使用者。 
    
#### 工作 4：將 Azure AD 進階版 P2 授權指派給 Azure AD 使用者

在此工作中，您必須為每位使用者指派 Azure Active Directory Premium P2 授權。

1. 在 [使用者 \| 所有使用者]**** 刀鋒視窗中，按一下代表您使用者帳戶的項目。 

2. 在顯示使用者帳戶屬性的刀鋒視窗上，按一下 [編輯屬性]****。  確認 [使用位置] 已設定為 **[美國**]。 如果沒有，請設定使用位置，然後按兩下 [ **儲存**]。

3. 返回**** [AdatumLab500-04] Azure Active Directory 刀鋒視窗，然後在 [管理****] 區段中按一下 [授權****]。

4. 在 [授權 \| 概觀****] 刀鋒視窗上，按一下 [所有產品****]，勾選 [Azure Active Directory Premium P2****] 核取方塊，然後按一下 [+ 指派****]。

5. 在 [指派授權]**** 刀鋒視窗上，按一下 [+ 新增使用者與群組]****。

6. 在 [使用者****] 刀鋒視窗中選取 [aaduser1]****、[aaduser2]、[aaduser3]**** 和您的使用者帳戶，然後按一下 [選取****]。****

7. 回到 [**指派授權]** 刀鋒視窗，按兩下 **[指派選項**]，確定所有選項都已啟用，按兩下 [**檢閱 + 指派]，然後按兩下 [**指派****]。

8. 登出 Azure 入口網站，再使用同一個帳戶重新登入。 （此步驟是必要的，才能讓授權指派生效。

    >**注意**：此時，您已將 Azure Active Directory 進階版 P2 授權指派給您將在此實驗室中使用的所有用戶帳戶。 請務必先登出，再重新登入。 

#### 工作 5：設定 Azure MFA 設定。

在此工作中，您必須設定 MFA 並且為 aaduser1 啟用 MFA。 

1. 在 Azure 入口網站中，返回 [AdatumLab500-04]**** Azure Active Directory 租用戶的刀鋒視窗。

    >**注意**：請確定您使用的是 AdatumLab500-04 Azure AD 租使用者。

2. 返回**** [AdatumLab500-04] Azure Active Directory 租用戶的刀鋒視窗，然後在 [管理****] 區段中按一下 [安全性****]。

3. 在 [安全性 \| 使用者入門]**** 刀鋒視窗的 [管理]**** 區段中，按一下 [多重要素驗證]****。

4. 在 [多重要素驗證 \| 使用者入門]**** 刀鋒視窗中按一下 [其他雲端式多重要素驗證設定]**** 連結。 

    >**注意**：這將會開啟新瀏覽器索引標籤，並顯示 [多重要素驗證]**** 頁面。

5. 在 [多重要素驗證]**** 頁面上按一下 [服務設定]**** 索引標籤。檢閱 [驗證選項]****。 請注意，[電話簡訊]、[行動應用程式的通知]、[來自行動應用程式或硬體 Token 的驗證碼] 已啟用。************ 按一下 [儲存]，然後點選 [關閉]。********

6. 切換至 **[使用者**] 索引卷標，按兩下 aaduser1** 專案，按兩下 ****[啟用**] 連結，並在出現提示時按兩下 **[啟用多重要素驗證**]，然後按兩下 [**關閉**]。

7. 請注意，******aaduser1** 的 [Multi-Factor Auth 狀態] 資料行現在**已啟用**。

8. 按一下 ****[aaduser1]。請注意，此時也會顯示 ****[施行] 選項。 

    >**注意**：將用戶狀態從 [已啟用] 變更為 [強制] 只會影響不支援 Azure MFA 的舊版 Azure AD 整合應用程式，而且一旦狀態變更為 [強制]，就需要使用應用程式密碼。

9. 選取 [aaduser1] 項目後，請按一下 [管理使用者設定] 並檢閱可用選項：******** 

   - 要求選取的使用者再次提供連絡方法。

   - 刪除所選取使用者所產生的所有現有應用程式密碼。

   - 在所有記住的裝置上還原多重要素驗證。

10. 按兩下 **[取消**]，然後切換回瀏覽器索引標籤，其中顯示 **Azure 入口網站 中的 [Multi-Factor Authentication \| 用戶入門]** 刀鋒視窗。

11. 在 [設定] 區段按一下 [詐騙警示]。********

12. 在 [多重要素驗證 \| 詐騙警示****] 刀鋒視窗中，指定下列設定：

    |設定|值|
    |---|---|
    |允許使用者提交詐騙警示|**開啟**|
    |自動封鎖回報詐騙的使用者|**開啟**|
    |初始問候期間用於回報詐騙的代碼|**0**|

13. 按一下 [儲存]

    >**注意**：此時，您已針對 aaduser1 啟用 MFA，並設定詐騙警示設定。 

14. 流覽回 AdatumLab500-04** Azure Active Directory 租使用者刀鋒視窗，在 **[管理**] 區段中，按兩下 **[內容**]，接著**按兩下刀鋒視窗底部的 [管理安全性預設值] 連結，在 [啟用安全性預設值****] 刀鋒視窗上**，按兩下 **[停用**]。** 選取 **[我的組織使用條件式存取** ] 作為 *停用*的原因，按兩下 [ **儲存**]，讀取警告，然後按兩下 [ **停用**]。

    >**注意**：請確定您已登入 **AdatumLab500-04** Azure AD 租使用者。 您可以使用 [目錄 + 訂用帳戶]**** 篩選器切換 Azure AD 租用戶。 確定您是透過具有 Azure AD 租用戶全域管理員角色的使用者身分登入。

#### 工作 6：驗證 MFA 設定

在此工作中，您必須進行 aaduser1 使用者帳戶登入測試，藉此驗證 MFA 設定。 

1. 開啟 InPrivate 瀏覽器視窗。

2. 流覽至 Azure 入口網站，**`https://portal.azure.com/`** 並使用 aaduser1** 用戶帳戶登入。** 

    >**注意**：若要登入，您必須提供 aaduser1** 使用者帳戶的完整名稱**，包括您稍早在此實驗室中記錄的 Azure AD 租使用者 DNS 功能變數名稱。 使用者名稱的格式為 aaduser1@`<your_tenant_name>`.onmicrosoft.com，其中 `<your_tenant_name>` 是代表您唯一 Azure AD 租用戶名稱的預留位置。 

3. 出現提示時，在 [需要更多資訊] 對話方塊中點選 [下一步]。********

    >**注意**：瀏覽器會話將會重新導向至 **[其他安全性驗證** ] 頁面。

4. 在 [保持您的帳戶安全****] 頁面上點選 [我想要設定其他方法****] 連結，然後在 [要使用何種方法?]**** 下拉式清單中依序選取 [電話****] 與 [確認****]。

5. 在 [保持您的帳戶安全****] 頁面上選取您的國家或地區，接著在 [請輸入電話號碼****] 區域輸入您的行動電話號碼。確認已選取 [以簡訊傳送代碼給我]**** 選項，然後點選 [下一步****]。
 
6. 在 [保持您的帳戶安全****] 頁面上輸入您透過行動電話簡訊收到的驗證碼，接著點選 [下一步****]。

7. 在 [保持您的帳戶安全****] 頁面上確定驗證成功後，點選 [下一步****]。

8. 如果系統提示您輸入其他驗證方法，請按兩下 **[我想使用不同的方法**]，從下拉式清單中選取 **[電子郵件** ]，按兩下 [ **確認**]，提供您想要使用的電子郵件地址，然後按 [ **下一步**]。 收到對應的電子郵件後，在電子郵件本文中找出並提供驗證碼，接著按一下 [完成****]。

9. 出現提示時，請變更您的密碼。 請務必記下新密碼。

10. 確認您已成功登入 Azure 入口網站。

11. 以 **aaduser1** 的身分登出，然後關閉 InPrivate 瀏覽器視窗。

> 結果：您已建立新的 AD 租使用者、設定 AD 用戶、設定 MFA，以及測試使用者的 MFA 體驗。 


### 練習 3：實作 Azure AD 條件式存取原則 

### 預估時間：15 分鐘

在本練習中，您將會完成下列工作： 

- 工作 1：設定條件式存取原則。
- 工作 2：測試條件式存取原則。

#### 工作 1：設定條件式存取原則。 

在此工作中，您必須檢閱條件式存取原則設定，並建立原則，要求登入 Azure 入口網站時必須使用 MFA。 

1. 在 Azure 入口網站中，返回 [AdatumLab500-04]**** Azure Active Directory 租用戶的刀鋒視窗。

2. 在 ****[AdatumLab500-04] 刀鋒視窗的 [管理****] 區段中，按一下 [安全性****]。

3. 在 [安全性 \| 使用者入門]**** 刀鋒視窗的 [保護****] 區段中，按一下 [條件式存取****]。 在左側導覽面板中，按兩下 [ **原則**]。

4. 在 [ **條件式存取 \| 原則]** 刀鋒視窗上，按兩下 [ **+ 新增原則**]。 

5. 在 [新增] 刀鋒視窗中，指定下列設定：****

   - 在 [新增]**** 文字輸入框中，輸入 **AZ500Policy1**
    
   - 在 [使用者] 底下 **，按兩下 [**0 已選取**使用者和**群組]。 在 [包含] 下方的 [啟用**選取使用者和群組] >>選取 **[使用者和群組**] 複選框，在 [選取使用者和群組****] 刀鋒視窗上**，選取 **[aaduser2**] 複選框，然後按兩下 [**選取**]。
    
   - 在 [目標資源] 下 **，按兩下 [**未選取**目標資源]，按兩下 [**選取應用程式**] 下的 [選取]，按兩下 [**無**]。** 在 [**選取**] 刀鋒視窗上，選取 Microsoft Azure 管理的**複選框**，然後按兩下 [**選取**]。 

     >**注意**：檢閱此原則會影響 Azure 入口網站存取權的警告。
    
   - 在 [條件] 底**下，按兩下 **[選取** 0 個條件]，在 [登入風險 **] 底下**，按兩下 [**未設定**]。** 在 [ **登入風險** ] 刀鋒視窗中，檢閱風險層級，但不會進行任何變更，並關閉 [ **登入風險** ] 刀鋒視窗。
    
   - 在 [裝置平臺]** 底下**，按兩下 **[未設定**]，檢閱可包含但未進行任何變更的裝置平臺，然後按兩下 [**完成**]。
    
   - 在 [位置] 底下 **，按兩下 [**未設定**] 並檢閱位置選項，而不進行任何**變更。
    
   - 在 **[存取控制 **] 區段中的 **[授**與] 下，按兩下已**選取**的0個控件。 在 [ **授與]** 刀鋒視窗上，選取 [ **需要多重要素驗證]** 複選框，然後按兩下 [ **選取]**
    
   - 將 [啟用原則]**** 設定為 [開啟]****。

6. 在 [ **新增]** 刀鋒視窗上，按兩下 [ **建立**]。 

    >**注意**：此時，您有條件式存取原則，需要 MFA 才能登入 Azure 入口網站。 

#### 工作 2：測試條件式存取原則。

在此工作中，您必須以 **aaduser2** 的身分登入 Azure 入口網站，並確認必須使用 MFA。 在繼續進行下一項練習前，您必須先刪除此原則。 

1. 開啟 InPrivate Microsoft Edge 視窗。

2. 在新瀏覽器視窗中，流覽至 Azure 入口網站，**`https://portal.azure.com/`** 並使用 aaduser2** 用戶帳戶登入。**

3. 出現提示時，在 [需要更多資訊] 對話方塊中點選 [下一步]。********

    >**注意**：瀏覽器會話會重新導向至 [ **保護您的帳戶安全** ] 頁面。
    
4. 在 [保持您的帳戶安全****] 頁面上點選 [我想要設定其他方法****] 連結，然後在 [要使用何種方法?]**** 下拉式清單中依序選取 [電話****] 與 [確認****]。

5. 在 [保持您的帳戶安全****] 頁面上選取您的國家或地區，接著在 [請輸入電話號碼****] 區域輸入您的行動電話號碼。確認已選取 [以簡訊傳送代碼給我]**** 選項，然後點選 [下一步****]。

6. 在 [保持您的帳戶安全****] 頁面上輸入您透過行動電話簡訊收到的驗證碼，接著點選 [下一步****]。

7. 在 [保持您的帳戶安全****] 頁面上確定驗證成功後，點選 [下一步****]。

8. 在 [保護您的帳戶安全]**** 頁面上按一下 [完成]****。

9. 出現提示時，請變更您的密碼。 請務必記下新密碼。

10. 確認您已成功登入 Azure 入口網站。

11. 以 **aaduser2** 的身分登出，然後關閉 InPrivate 瀏覽器視窗。

    >**注意**：您現在已確認新建立的條件式存取原則會在 aaduser2 登入 Azure 入口網站 時強制執行 MFA。

12. 回到顯示 Azure 入口網站的瀏覽器視窗，返回 [AdatumLab500-04]**** Azure Active Directory 租用戶刀鋒視窗。

13. 在 ****[AdatumLab500-04] 刀鋒視窗的 [管理****] 區段中，按一下 [安全性****]。

14. 在 [安全性 \| 使用者入門]**** 刀鋒視窗的 [保護****] 區段中，按一下 [條件式存取****]。 在左側導覽面板中，按兩下 [ **原則**]。

15. 在 [條件式存取 \| 原則]**** 刀鋒視窗中按一下 **AZ500Policy1** 旁邊的省略符號，然後點選 [刪除****]。出現確認提示後，按一下 [是]。****

    >**注意**：結果：在此練習中，您會實作條件式存取原則，以在使用者登入 Azure 入口網站 時要求 MFA。 

>結果：您已設定及測試 Azure AD 條件式存取。

### 練習 4：在條件式存取中部署風險型原則

### 預估時間：30 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：在 Azure 入口網站 中檢視 Azure AD Identity Protection 選項
- 工作 2：設定用戶風險原則
- 工作 3：設定登入風險原則
- 工作 4：針對 Azure AD Identity Protection 原則模擬風險事件 
- 工作 5：檢閱 Azure AD Identity Protection 報告

#### 工作 1：啟用 Azure AD Identity Protection

在此工作中，您必須在 Azure 入口網站中檢視 Azure AD Identity Protection 選項。 

1. 如有需要，請登入 Azure 入口網站 **`https://portal.azure.com/`**。

    >**注意**：請確定您已登入 **AdatumLab500-04** Azure AD 租使用者。 您可以使用 [目錄 + 訂用帳戶]**** 篩選器切換 Azure AD 租用戶。 確定您是透過具有 Azure AD 租用戶全域管理員角色的使用者身分登入。

#### 工作 2：設定用戶風險原則

在此工作中，您必須建立使用者風險原則。 

1. 流覽至 **AdatumLab500-04 Azure AD 租使用者>**安全性** > **條件式存取 > ****原則。****

2. 按兩下 **[+ 新增原則**]。

3. 在 [名稱]**** 文字方塊中，鍵入原則名稱 **AZ500Policy2**。

4. 在 [指派使用者 **]** > **底下**，按兩下 [**0 已選取**使用者和群組]。

5. 在 [包含] 下，按兩下 [**選取使用者和群組]，按兩下 **[使用者和群組****]，選取 **aaduser2** 和 **aaduser3**，然後按兩下 [**選取**]。****

6. 在 [排除]** 下**，按兩下 [**使用者和群組**]，選取 **aaduser1**，然後按兩下 [**選取**]。 

7. 在 [目標資源] 下 **，按兩下 **[未選取**目標資源]，確認**下拉式清單中已選取 [雲端應用程式**]，然後在 [包含 **] 下**選取 [**所有雲端應用程式**]。**

8. 在 [條件] 底**下，按兩下 **[選取** 0 個條件]，在 [用戶風險 **] 底下**，按兩下 [**未設定**]。** 在 [**用戶風險]** 刀鋒視窗上，將 [設定 **] 設定**為 [**是**]。

9. 在 [ **設定強制執行**原則所需的用戶風險等級] 下，選取 [ **高**]。

10. 按一下**完成**。

11. 在 **[存取控制 **] 區段中的 **[授**與] 下，按兩下已**選取**的0個控件。 在 [ **授與]** 刀鋒視窗上，確認已 **選取 [授與存取** 權]。

12. 選取 [需要多重要素驗證]****** 和 [需要變更密碼]**。

13. 按一下 [選取]。

14. 在 [工作階段] 底下 **，按兩下**已選取的 0 個**** 控件。 選取 **[登入頻率** ]，然後選取 **[每次**]。

15. 按一下 [選取]。

16. 確認 **[啟用原則** ] 設定為 **[僅限**報表]。

17. 按一下 [建立]**** 以啟用您的原則。

#### 工作 3：設定登入風險原則

1. 流覽至 **AdatumLab500-04 Azure AD 租使用者>**安全性** > **條件式存取> ****原則。****

2. 選取 [+ 新增原則]。

3. 在 [名稱]**** 文字方塊中，鍵入原則名稱 **AZ500Policy3**。

4. 在 [指派使用者 **]** > **底下**，按兩下 [**0 已選取**使用者和群組]。

5. 在 [包含] 下，按兩下 [**選取使用者和群組]，按兩下 **[使用者和群組****]，選取 **aaduser2** 和 **aaduser3**，然後按兩下 [**選取**]。****

6. 在 [排除] 下 **，按兩下 [**使用者和群組**] 選取 **aaduser1**，然後按兩下 [**選取****]。 

7. 在 [目標資源] 下 **，按兩下 **[未選取**目標資源]，確認**下拉式清單中已選取 [雲端應用程式**]，然後在 [包含 **] 下**選取 [**所有雲端應用程式**]。**

8. 在 [條件] 底**下，按兩下 **[選取** 0 個條件]，在 [登入風險 **] 底下**，按兩下 [**未設定**]。** 在 [**登入風險]** 刀鋒視窗上，將 [設定 **] 設定**為 [**是**]。

9. 在 [選取此原則將套用的登入風險層級]**** 下方，選取 [高]**** 和 [中]****。

10. 按一下**完成**。

11. 在 **[存取控制 **] 區段中的 **[授**與] 下，按兩下已**選取**的0個控件。 在 [ **授與]** 刀鋒視窗上，確認已 **選取 [授與存取** 權]。   

12. 選取 **[需要多重要素驗證**]。

13. 按一下 [選取]。

14. 在 [工作階段] 底下 **，按兩下**已選取的 0 個**** 控件。 選取 **[登入頻率** ]，然後選取 **[每次**]。

15. 按一下 [選取]。

16. 確認您的設定，並將 [啟用原則]**** 設定為 [開啟]****。

17. 按一下 [建立]**** 以啟用您的原則。

#### 工作 4：針對 Azure AD Identity Protection 原則模擬風險事件 

> 開始進行此工作前，請確定您在練習 1 中啟動的範本部署已完成。 該部署內含名為 **az500-04-vm1** 的 Azure VM。 

1. 在 Azure 入口網站 中，將 **[目錄 + 訂**用帳戶] 篩選器設定為與您部署 **az500-04-vm1** Azure VM 之 Azure 訂用帳戶相關聯的 Azure AD 租使用者。

2. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件]**** 文字輸入框中輸入「虛擬機器」****，然後按下 **Enter** 鍵。

3. 在 [虛擬機器] 刀鋒視窗中按一下 **az500-04-vm1** 項目。**** 

4. 在 **[az500-04-vm1]** 刀鋒視窗上，按兩下 **[連線**]。 確認您位於 [ **RDP** ] 索引標籤上。

5. 按一下 [下載 RDP 檔案]****，然後使用該檔案透過遠端桌面連線至 **az500-04-vm1** Azure 虛擬機器。 出現驗證提示時，請提供下列認證：

    |設定|值|
    |---|---|
    |使用者名稱|**Student**|
    |密碼|**請使用您在實驗室 04 > 練習 1 > 工作 1 > 步驟 9 建立的個人密碼。**|

    >**注意**：等候遠端桌面會話和 **伺服器管理員** 載入。  

    >**注意**：下列步驟會在 az500-04-vm1** Azure VM 的**遠端桌面會話中執行。 

6. 在 [伺服器管理員]**** 中，依序點選 [本機伺服器]**** 與 [IE 增強的安全組態]****。

7. 在 [Internet Explorer 增強式安全性設定****] 對話方塊中將兩個選項都設定為 [關閉****]，然後按一下 [確定****]。

8. 啟動 **Internet Explorer**，按一下工具列中的齒輪圖示，然後依序點選 [安全性] 與 [InPrivate 瀏覽]。********

9. 在 InPrivate Internet Explorer 視窗中前往位於 **https://www.torproject.org/projects/torbrowser.html.en** 的 ToR 瀏覽器專案。

10. 使用預設設定下載並安裝 ToR 瀏覽器的 Windows 版本。 

11. 安裝完成後，啟動 ToR 瀏覽器、在初始頁面上使用 **[連線**] 選項，然後瀏覽至位於 **https://myapps.microsoft.com**的應用程式 存取面板。

12. 出現提示時，嘗試使用 **aaduser3** 帳戶登入。 

    >**注意**：您會看到您的登入遭到**封鎖的訊息**。 這是預期情況，因為此帳戶未設定多重要素驗證，因為與 ToR 瀏覽器使用相關聯的登入風險增加，因此此帳戶是必要的。

13. 在 ToR 瀏覽器中，選取返回箭號，以 **您稍早在此實驗室中建立並設定多重要素驗證的 aaduser1** 帳戶登入。

    >**注意**：這次，您會看到偵測到**的**可疑活動訊息。 同樣地，這是預期的，因為此帳戶已設定多重要素驗證。 由於使用 ToR 瀏覽器時登入風險會增加，因此您必須使用多重要素驗證。

14. 選擇 [驗證]**** 選項，並指定您要透過簡訊還是通話驗證自己的身分。

15. 完成驗證並確定您已成功登入應用程式存取面板。

16. 關閉 RDP 工作階段。 

    >**注意**：此時，您嘗試了兩個不同的登入。接下來，您將檢閱 Azure Identity Protection 報告。

#### 工作 5：檢閱 Azure AD Identity Protection 報告

在此工作中，您要檢閱透過 ToR 瀏覽器登入產生的 Azure AD Identity Protection 報告。

1. 返回 Azure 入口網站，使用[目錄 + 訂用帳戶****] 篩選器切換至 **AdatumLab500-04** Azure Active Directory 租用戶。

2. 在 ****[AdatumLab500-04] 刀鋒視窗的 [管理****] 區段中，按一下 [安全性****]。

3. 在 [安全性 \| 使用者入門]**** 刀鋒視窗的 [報告****] 區段按一下 [有風險的使用者****]。 

4. 檢閱報告並找出參考 **aaduser3** 使用者帳戶的所有項目。

5. 在 [安全性 \| 使用者入門]**** 刀鋒視窗的 [報告****] 區段按一下 [具風險的登入****]。 

6. 檢閱報告並找出透過 **aaduser3** 使用者帳戶登入的所有對應項目。

7. 按一下 [報告****] 下方的 [風險偵測****]。

8. 檢閱報告並找出代表透過匿名 IP 位址登入且由 ToR 瀏覽器產生的所有項目。 

    >**注意**：風險可能需要 10-15 分鐘才會顯示在報告中。

> **結果**：您已啟用 Azure AD Identity Protection、設定用戶風險原則和登入風險原則，以及模擬風險事件來驗證 Azure AD Identity Protection 設定。

**清除資源**

> 我們必須移除您不再使用的身分識別保護資源。 

請按照下列步驟停用 **AdatumLab500-04** Azure AD 租用戶中的身分識別保護原則。

1. 在 Azure 入口網站中，返回 [AdatumLab500-04]**** Azure Active Directory 租用戶的刀鋒視窗。

2. 在 ****[AdatumLab500-04] 刀鋒視窗的 [管理****] 區段中，按一下 [安全性****]。

3. 在 [安全性 \| 使用者入門]**** 刀鋒視窗的 [保護****] 區段中，按一下 [身分識別保護****]。

4. 在 [身分識別保護 \| 概觀]**** 刀鋒視窗中按一下 [使用者風險原則]****。

5. 在 [Identity Protection \| 使用者風險原則 **] 刀鋒視窗上，將 [** 原則強制執行 **] 設定**為 [**停用**]，然後按兩下 [**儲存**]。

6. 在 [ **Identity Protection \| 用戶風險原則** ] 刀鋒視窗上，按兩下 [ **登入風險原則**]。

7. 在 [**Identity Protection \| 登入風險原則**] 刀鋒視窗上，將 [原則強制執行 **] 設定**為 [**停用**]，然後按兩下 [**儲存**]。

按照下列步驟停止您先前在實驗室中佈建的 Azure VM。

1. 在 Azure 入口網站 中，將 **[目錄 + 訂**用帳戶] 篩選器設定為與您部署 **az500-04-vm1** Azure VM 之 Azure 訂用帳戶相關聯的 Azure AD 租使用者。

2. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件]**** 文字輸入框中輸入「虛擬機器」****，然後按下 **Enter** 鍵。

3. 在 [虛擬機器] 刀鋒視窗中按一下 **az500-04-vm1** 項目。**** 
 
4. 在 [az500-04-vm1****] 刀鋒視窗中按一下 [停止****]。出現確認提示後，按一下 [確定]**** 

>  請勿移除在此實驗室中佈建的任何資源，因為 Azure AD Privileged Identity Management 實驗室與這些資源有相依性。