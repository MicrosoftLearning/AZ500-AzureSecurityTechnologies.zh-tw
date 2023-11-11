---
lab:
  title: 03 - 為您的租使用者設定Microsoft Entra 驗證識別碼
  module: Module 01 - Manage Identity and Access
---
# 實驗室 03：為您的租使用者設定Microsoft Entra 驗證識別碼
# 學生實驗室手冊

## 實驗案例

# 設定 Microsoft Entra 已驗證的識別碼的租用戶

>[!Note] 
> Azure Active Directory 可驗證認證現在已Microsoft Entra 驗證識別碼和 Microsoft Entra 系列的一部分。 深入瞭解 [ Microsoft Entra 系列 ](https://aka.ms/EntraAnnouncement) 身分識別解決方案，並開始使用整合的 [ Microsoft Entra 系統管理中心 ](https://entra.microsoft.com) 。

Microsoft Entra 驗證識別碼是一種分散式身分識別解決方案，可協助您保護您的組織。 這項服務可讓您簽發和驗證認證。 簽發者可以使用已驗證的識別碼服務發出自己的自訂可驗證認證。 驗證程式可以使用服務的免費 REST API，輕鬆地在應用程式和服務中要求及接受可驗證的認證。 在這兩種情況下，您的 Azure AD 租使用者都必須設定為發出您自己的可驗證認證，或驗證協力廠商所發出的使用者可驗證認證簡報。 如果您是簽發者和驗證者，您可以使用單一 Azure AD 租使用者來發出您自己的可驗證認證，並驗證其他人的認證。

在本教學課程中，您將瞭解如何設定 Azure AD 租使用者以使用可驗證的認證服務。

具體來說，您會瞭解如何：

> - 建立 Azure 金鑰保存庫執行個體。
> - 設定已驗證的識別碼服務。
> - 在 Azure AD 中註冊應用程式。
> - 確認您分散式識別碼的網域擁有權 （DID）

下圖說明您設定的已驗證識別碼架構和元件。

![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/8d4d01c2-3110-421a-91a8-7b052bc8d793)


## 必要條件

- 請確定您具有您要設定之目錄的全域管理員或驗證原則管理員許可權。 如果您不是全域管理員，您需要應用程式管理員許可權才能完成應用程式註冊，包括授與管理員同意。
- 請確定您具有 Azure 訂用帳戶的參與者角色，或您要在其中部署 Azure 金鑰保存庫的資源群組。

## 建立金鑰保存庫

Azure 金鑰保存庫是雲端服務，可讓您安全地儲存和存取秘密和金鑰。 [已驗證的識別碼] 服務會將公用和私密金鑰儲存在 Azure 金鑰保存庫中。 這些金鑰可用來簽署和驗證認證。

### 使用Azure 入口網站建立 Azure 金鑰保存庫。

1. 啟動瀏覽器會話並登入 [ Azure 入口網站功能表。](https://portal.azure.com/)
   
2. 在 [Azure 入口網站搜尋] 方塊中，輸入 ** 金鑰保存庫。**

3. 從結果清單選擇 [Key Vault]。

4. 在 [金鑰保存庫] 區段上，選擇 [ ** 建立]。**

5. 在 [建立金鑰保存庫] 的 [ ** 基本] 索引 ** 標籤上， ** 輸入或選取 ** 此資訊：
   
   |設定|值|
   |---|---|
   |**專案詳細資料**|
   |訂用帳戶|選取您的訂用帳戶。|
   |資源群組|輸入 ** azure-rg-1。** 選取**確定**|
   |[執行個體詳細資料]****|
   |金鑰保存庫名稱|輸入 ** Contoso-vault2。**|
   |區域|選取 [美國東部]|
   |定價層|系統預設 ** 標準**|
   |保留已刪除保存庫的天數|系統預設 ** 90**|

6. 選取 [ ** 檢閱 + 建立] 索引標籤， ** 或選取頁面底部的藍色 [檢閱 + 建立] 按鈕。
  
7. 選取**建立**。

記下這兩個屬性：

* **保存庫名稱 ** ：在此範例中，這是 ** Contoso-Vault2 ** 。 您將針對其他步驟使用此名稱。
* **保存庫 URI ** ：在此範例中，保存庫 URI 為 `https://contoso-vault2.vault.azure.net/` 。 透過其 REST API 使用保存庫的應用程式必須使用此 URI。

此時，您的 Azure 帳戶是唯一有權在此新保存庫上執行作業的帳戶。

>[!NOTE]
>根據預設，建立保存庫的帳戶是唯一具有存取權的帳戶。 [已驗證的識別碼] 服務需要存取金鑰保存庫。 您必須使用存取原則來設定金鑰保存庫，以允許在設定期間用來建立和刪除金鑰的帳戶。 在設定期間使用的帳戶也需要許可權才能簽署，以便建立已驗證識別碼的網域系結。 如果您在測試時使用相同的帳戶，請修改預設原則以授與帳戶登入許可權，以及授與保存庫建立者的預設許可權。

### 設定金鑰保存庫的存取原則

金鑰保存庫定義指定的安全性主體是否可以在金鑰保存庫秘密和金鑰上執行作業。 在金鑰保存庫中設定已驗證識別碼服務系統管理員帳戶，以及您建立的要求服務 API 主體的存取原則。
建立金鑰保存庫之後，可驗證認證會產生一組用來提供訊息安全性的金鑰。 這些金鑰會儲存在金鑰保存庫中。 您可以使用金鑰集來簽署、更新及復原可驗證的認證。

### 設定已驗證識別碼管理員使用者的存取原則

1. 登入 [Azure 入口網站](https://portal.azure.com)。

2. 移至您在本教學課程中使用的金鑰保存庫。

3. 在 [設定] 下 ** ，選取 [ ** 存取原則 ** ]。 **

4. 在 [ ** 新增存取原則 ** ] 的 [使用者 ** ] 底下 ** ，選取您用來遵循本教學課程的帳戶。

5. 針對 [ ** 金鑰許可權 ** ]，確認已選取下列許可權： ** 取得、 ** 建立 ** ** 、 ** 刪除 ** 和 ** 簽署 ** 。 根據預設， ** [建立 ** ] 和 ** [刪除 ** ] 已啟用。 **簽署 ** 應該是您需要更新的唯一金鑰許可權。

      ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/7c8a92ea-24f1-41e6-9656-869e8486af72)


6. 若要儲存變更，請選取 [ ** 儲存 ** ]。

## 設定已驗證的識別碼

![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/b4b857a2-24b8-4c3f-9f5c-43d23b58427f)


若要設定已驗證的識別碼，請遵循下列步驟：

1. 登入 [Azure 入口網站](https://portal.azure.com)。

2. *搜尋已驗證的識別碼 * 。 然後，選取 [ ** 已驗證的識別碼 ** ]。

3. 從左側功能表中，選取 [ ** 設定 ** ]。

4. 從中間功能表中，選取 [ ** 定義組織設定]**

5. 提供下列資訊，以設定您的組織：

    1. **組織名稱 ** ：輸入名稱，以參考已驗證識別碼內的公司。 您的客戶看不到此名稱。

    1. **信任網域 ** ：輸入已新增至分散式身分識別 （DID） 檔中服務端點的網域。 網域可將您的 DID 繫結至使用者可能對您的公司有所了解的有形事物。 Microsoft Authenticator 和其他數位錢包會使用這項資訊來驗證您的 DID 是否已連結至您的網域。 如果錢包可以驗證 DID，則會顯示已驗證的符號。 如果錢包無法驗證 DID，則會通知使用者認證是由無法驗證的組織所簽發。

        >[!IMPORTANT]
        > 網域不能是重新導向。 否則，無法連結 DID 和網域。 請務必針對網域使用 HTTPS。 例如： `https://did.woodgrove.com` 。

    1. **金鑰保存庫 ** ：選取您稍早建立的金鑰保存庫。

    1. 在 [進階] 下 ** ，您可以選擇 ** 您要用於租使用者的信任系統 ** 。 ** 您可以從 Web ** 或 ** ION ** 中選擇 ** 。 Web 表示您的租使用者使用 [ did：web ](https://w3c-ccg.github.io/did-method-web/) ，因為 did 方法和 ION 表示它使用 [ did：ion ](https://identity.foundation/ion/) 。

        >[!IMPORTANT]
        > 變更信任系統的唯一方法是退出宣告已驗證的識別碼服務，並重做上線。

1. 選取 [儲存]。  

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/b191676e-03e3-423f-aa28-1e3d2887ea07)


### 設定已驗證識別碼服務主體的存取原則

當您在上一個步驟中設定已驗證的識別碼時，Azure 金鑰保存庫中的存取原則會自動更新，為已驗證識別碼提供所需的許可權。  
如果您曾經需要手動重設許可權，存取原則看起來應該如下所示。

| Service Principal | AppId | 金鑰權限 |
| -------- | -------- | -------- |
| 可驗證的認證服務 | bb2a64ee-5d29-4b07-a491-25806dc854d3 | 取得、簽署 |
| 可驗證的認證服務要求 | 3db474b9-6a0c-4840-96ac-1fceb342124f | 簽署 |



![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/896b8ea0-b88b-43b8-a93b-4771defedfde)


## 在 Azure AD 中註冊應用程式

當您的應用程式想要呼叫 Microsoft Entra 驗證識別碼時，需要取得存取權杖，才能發出或驗證認證。 若要取得存取權杖，您必須註冊應用程式，並授與已驗證識別碼要求服務的 API 許可權。 例如，針對 Web 應用程式使用下列步驟：

1. 使用您的系統管理帳戶登入 [ Azure 入口網站 ](https://portal.azure.com) 。

1. 如果您有多個租使用者的存取權，請選取 ** [目錄 + 訂用帳戶 ** ]。 然後，搜尋並選取您的 ** Azure Active Directory ** 。

1. 在 [管理]**** 底下，選取 [應用程式註冊]****  >  [新增註冊] ****。  

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/03ca3d13-5564-4ce2-b42c-f8333bc97fb5)


1. 輸入應用程式的顯示名稱。 例如： * verifiable-credentials-app * 。

1. 針對 ** [支援的帳戶類型 ** ]，選取 ** [僅限此組織目錄中的帳戶] （僅限預設目錄 - 單一租使用者）。 **

1. 選取 [暫存器]**** 以建立應用程式。

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/d0a15737-c8a9-4522-990d-1cf6bc12cc1e)


### 授與許可權以取得存取權杖

在此步驟中，您會將許可權授與可驗證認證 ** 服務要求 ** 服務主體。

若要新增必要的許可權，請遵循下列步驟：

1. **留在 verifiable-credentials-app ** 應用程式詳細資料頁面中。 選取 **API 權限** > **新增權限**。

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/adf97022-2081-4273-8d61-f2b53628e989)

1. 選取**我組織使用的 API**。

1. 搜尋可驗證認證 ** 服務要求 ** 服務主體，然後加以選取。

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/01691eb2-ab7f-4778-9911-342eb9350f99)

1. 選擇 ** [應用程式許可權 ** ]，然後展開 ** [VerifiableCredential.Create.All ** ]。

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/3c5e008e-2ba5-417a-90ff-22e8f622ad34)


1. 選取**新增權限**。

1. 選取 ** [授與管理員同意]。 \<your tenant name\> **

如果您想要將範圍區隔到不同的應用程式，您可以選擇個別授與發行和簡報許可權。

![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/640def45-e666-423e-bf69-598e8980b125)

## 註冊分散式識別碼並驗證網域擁有權

在設定 Azure 金鑰保存庫且服務具有簽署金鑰之後，您必須完成設定中的步驟 2 和 3。

![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/40e10177-b025-4d10-b16a-d66c06762c3f)

1. 流覽至Azure 入口網站中的 [已驗證識別碼] 服務。  
1. 從左側功能表中，選取 [ ** 設定 ** ]。
1. 從中間功能表中，選取 [ ** 驗證網域擁有權 ** ]。

# 確認您分散式識別碼的網域擁有權 （DID）

## 確認網域擁有權並散發 did-configuration.json 檔案

網域必須是您控制項下的網域，且其格式 `https://www.example.com/` 應為 。 

1. 從Azure 入口網站，流覽至 [驗證識別碼] 頁面。

1. 選取 [設定 ** ]，然後 ** 選取 [ ** 驗證網域擁有權 ** ]，然後選擇 [ ** 驗證 ** 網域]

1. 複製或下載 `did-configuration.json` 檔案。

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/342fa12f-2d0d-40cf-a2f9-8796a86f0824)

1. 將 `did-configuration.json` 檔案裝載在指定的位置。 範例：如果您指定網域 `https://www.example.com` ，檔案必須裝載在此 URL `https://www.example.com/.well-known/did-configuration.json` 上。
   除了名稱之外 `.well-known path` ，URL 中沒有其他路徑。

1. `did-configuration.json`在 .well-known/did-configuration.json URL 公開提供 時，按下 [ ** 重新整理驗證狀態 ** ] 按鈕加以驗證。

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/49a06251-af56-49b2-9059-0bd4ca678da6)

> 結果：您已成功建立 Azure 金鑰保存庫 實例、設定已驗證識別碼服務、在 Azure AD 中註冊應用程式，以及已驗證分散式識別碼的網域擁有權（DID）。

**清除資源**

> 請記得移除您不再使用的任何新建立的 Azure 資源。 移除未使用的資源可避免產生非預期的費用。 
