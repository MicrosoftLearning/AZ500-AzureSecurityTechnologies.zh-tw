---
lab:
  title: 10 - Key Vault (透過設定 Always Encrypted 來實作安全資料)
  module: Module 03 - Secure Data and Applications
ms.openlocfilehash: c31dd6e930e0f1d1b82e7c6ea502bb6fa51a7dd7
ms.sourcegitcommit: 967cb50981ef07d731dd7548845a38385b3fb7fb
ms.translationtype: HT
ms.contentlocale: zh-TW
ms.lasthandoff: 05/31/2022
ms.locfileid: "145955379"
---
# <a name="lab-10-key-vault-implementing-secure-data-by-setting-up-always-encrypted"></a>實驗室 10：Key Vault (透過設定 Always Encrypted 來實作安全資料)
# <a name="student-lab-manual"></a>學生實驗室手冊

## <a name="lab-scenario"></a>實驗案例

系統要求您建立概念證明應用程式，該應用程式會運用 Azure SQL Database 對 Always Encrypted 功能的支援。 此案例中使用的所有秘密和金鑰都應儲存於 Key Vault 中。 應用程式須在 Azure Active Directory (Azure AD) 中註冊，以強化其安全性狀態。 若要達成這些目標，概念證明應包括：

- 建立 Azure Key Vault，並將金鑰和秘密儲存在保存庫中。
- 使用 Always Encrypted 建立資料庫資料表中資料行的 SQL Database 和加密內容。

>**注意**：此實驗室中所有資源均使用 **美國東部** 區域。 請與講師驗證這是課程中要使用的區域。 

若要專注在與建置此概念證明相關的 Azure 安全性層面，您會從自動化 ARM 範本部署開始，使用 Visual Studio 2019 和 SQL Server Management Studio 2018 設定虛擬機器。

## <a name="lab-objectives"></a>實驗室目標

在本實驗室中，您須完成下列練習：

- 練習 1：從 ARM 範本部署基本基礎結構
- 練習 2：使用金鑰和祕密設定 Key Vault 資源
- 練習 3：設定 Azure SQL 資料庫和資料驅動應用程式
- 練習 4：示範如何使用 Azure Key Vault 加密 Azure SQL 資料庫

## <a name="key-vault-diagram"></a>Key Vault 圖表

![image](https://user-images.githubusercontent.com/91347931/157532938-c724cc40-f64f-4d69-9e91-d75344c5e0a2.png)

## <a name="instructions"></a>指示

## <a name="lab-files"></a>實驗室檔案：

- **\\Allfiles\\Labs\\10\\az-500-10_azuredeploy.json**

- **\\Allfiles\\Labs\\10\\program.cs**

### <a name="total-lab-time-estimate-60-minutes"></a>預估總實驗時間：60 分鐘

### <a name="exercise-1-deploy-the-base-infrastructure-from-an-arm-template"></a>練習 1：從 ARM 範本部署基本基礎結構

在本練習中，您將會完成下列工作：

- 工作 1：部署 Azure VM 與 Azure SQL 資料庫

#### <a name="task-1-deploy-an-azure-vm-and-an-azure-sql-database"></a>工作 1：部署 Azure VM 與 Azure SQL 資料庫

在此工作中，您將部署 Azure VM，這會在部署過程中自動安裝 Visual Studio 2019 和 SQL Server Management Studio 2018。 

1. 登入 Azure 入口網站 **`https://portal.azure.com/`** 。

    >**注意**：登入 Azure 入口網站時使用的帳戶，必須在您用於這個實驗室的 Azure 訂用帳戶中具有「擁有者」或「參與者」角色。

2. 在 Azure 入口網站分頁頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入 **部署自訂範本**，然後按下 **Enter** 鍵。

3. 在 [自訂部署] 刀鋒視窗中按一下 [在編輯器中組建您自己的範本] 選項。

4. 在 [編輯範本] 刀鋒視窗中按一下 [載入檔案]，找出 **\\Allfiles\\Labs\\10\\az-500-10_azuredeploy.json** 檔案，然後按一下 [開啟]。

5. 在 [編輯範本] 刀鋒視窗中按一下 [儲存]。

6. 在 [自訂部署] 刀鋒視窗的 [部署範圍] 下，確認已指定下列設定 (將其他設定保留為預設值)：

   |設定|值|
   |---|---|
   |訂用帳戶|您要在此實驗室中使用的 Azure 訂用帳戶名稱|
   |資源群組|按一下 [新建]，然後輸入以下名稱：**AZ500LAB10**|
   |Location|**(美國) 美國東部**|
   |管理員使用者名稱|**Student**|
   |管理員密碼|**請使用您在實驗室 04 > 練習 1 > 工作 1 > 步驟 9 中建立的個人密碼。**|
   
    >**注意**：雖然您可以變更用於登入虛擬機器的系統管理認證，但您無須這麼做。

    >**注意**：若要找出可以佈建 Azure VM 的 Azure 區域，請參閱 [ **https://azure.microsoft.com/en-us/regions/offers/** ](https://azure.microsoft.com/en-us/regions/offers/)

7. 按一下 [檢閱和建立] 按鈕，然後按一下 [建立] 按鈕以確認部署。 

    >**注意**：這會起始此實驗室所需的 Azure VM 部署和 Azure SQL Database。 

    >**注意**：請勿等候 ARM 範本部署完成，而是繼續下一個練習。 部署可能需要 **20-25 分鐘**。 

### <a name="exercise-2-configure-the-key-vault-resource-with-a-key-and-a-secret"></a>練習 2：使用金鑰和祕密設定 Key Vault 資源

>**注意**：此實驗室中所有資源均使用 **美國東部** 區域。 請與講師確認這是課程中要使用的區域。 

在本練習中，您將會完成下列工作：

- 工作 1：建立及設定 Key Vault
- 工作 2：將金鑰新增到 Key Vault
- 工作 3：將祕密新增到 Key Vault

#### <a name="task-1-create-and-configure-a-key-vault"></a>工作 1：建立及設定 Key Vault

在此工作中，您將建立 Azure Key Vault 資源。 您也會設定 Azure Key Vault 權限。

1. 在 Azure 入口網站中，按一下右上方 (搜尋列旁) 的第一個圖示，開啟 [Cloud Shell]。 如果出現提示，請選取 [PowerShell] 與 [建立儲存體]。

2. 確認在 [Cloud Shell] 窗格左上角的下拉式功能表中，已選取 [PowerShell]。

3. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列命令，以便在資源群組 **AZ500LAB10** 中建立 Azure Key Vault。 (如果您在工作 1 中為此實驗室的資源群組選擇另一個名稱，則也請為此工作使用相同名稱)。 Key Vault 名稱必須是唯一的。 記住您選擇的名稱。 在此實驗室中，您會需要用到這個名稱。  

    ```powershell
    $kvName = 'az500kv' + $(Get-Random)

    $location = (Get-AzResourceGroup -ResourceGroupName 'AZ500LAB10').Location

    New-AzKeyVault -VaultName $kvName -ResourceGroupName 'AZ500LAB10' -Location $location
    ```

    >**注意**：最後一個命令的輸出會顯示保存庫名稱和保存庫 URI。 保存庫 URI 的格式為 `https://<vault_name>.vault.azure.net/`

4. 關閉 [Cloud Shell] 窗格。 

5. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入 **資源群組**，然後按下 **Enter** 鍵。

6. 在 [資源群組] 刀鋒視窗的資源群組清單中，按一下 **AZ500LAB10** (或您稍早為資源群組選擇的其他名稱) 項目。

7. 在 [資源群組] 刀鋒視窗上，按一下代表新建立 Key Vault 的項目。 

8. 在 [Key Vault] 刀鋒視窗的 [設定] 區段中，按一下 [存取原則]，然後按一下 [+ 新增存取原則]。

9. 在 [新增存取原則] 刀鋒視窗中指定下列設定 (將所有其他設定保留為預設值)： 

    |設定|值|
    |----|----|
    |從範本設定 (選用)|**金鑰、祕密及憑證管理**|
    |金鑰權限|按一下 [全選]，會產生 **17 個已選取** 的權限 (確認 **未選取** **輪替原則作業** 的權限) |
    |秘密權限|按一下 [全選]，總共會產生 **8 個已選取** 的權限|
    |認證權限|按一下 [全選]，總共會產生 **16 個已選取** 的權限|
    |選取主體|按一下 [未選取]，在 [主體] 刀鋒視窗上選取您的使用者帳戶，然後按一下 [選取]|

10. 回到 [新增存取原則] 窗格，按一下 [新增] 以新增存取原則，然後返回 Key Vault 的存取原則刀鋒視窗，按一下 [儲存] 來儲存變更。 

#### <a name="task-2-add-a-key-to-key-vault"></a>工作 2：將金鑰新增到 Key Vault

在此工作中，您會將金鑰新增至 Key Vault，並檢視金鑰的相關資訊。 

1. 在 Azure 入口網站中，在 [Cloud Shell] 窗格內開啟 PowerShell 工作階段。

2. 確保在 Cloud Shell 窗格的左上角下拉式功能表中選取了 **PowerShell**。

3. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列命令，將軟體保護的金鑰新增至 Key Vault： 

    ```powershell
    $kv = Get-AzKeyVault -ResourceGroupName 'AZ500LAB10'

    $key = Add-AZKeyVaultKey -VaultName $kv.VaultName -Name 'MyLabKey' -Destination 'Software'
    ```

    >**注意**：金鑰的名稱是 **MyLabKey**

4. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列命令來確認已建立金鑰：

    ```powershell
    Get-AZKeyVaultKey -VaultName $kv.VaultName
    ```

5. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列命令以顯示金鑰識別碼：

    ```powershell
    $key.key.kid
    ```

6. 將 [Cloud Shell] 窗格最小化。 

7. 返回 Azure 入口網站，在 [Key Vault] 刀鋒視窗的 [設定] 區段中，按一下 [金鑰]。

8. 在金鑰清單中，按一下 [MyLabKey] 項目，然後在 [MyLabKey] 刀鋒視窗上，按一下代表金鑰目前版本的項目。

    >**注意**：檢查有關您建立的金鑰資訊。

    >**注意**：您可以使用金鑰識別碼來參考任何金鑰。 若要取得目前最新版本，請參考 `https://<key_vault_name>.vault.azure.net/keys/MyLabKey` 或透過下列方式取得特定版本：`https://<key_vault_name>.vault.azure.net/keys/MyLabKey/<key_version>`


#### <a name="task-3-add-a-secret-to-key-vault"></a>工作 3：將祕密新增到 Key Vault

1. 切換回到 [Cloud Shell] 窗格。

2. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列命令以建立具有安全字串值的變數：

    ```powershell
    $secretvalue = ConvertTo-SecureString 'Pa55w.rd1234' -AsPlainText -Force
    ```

3.  在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列命令將秘密新增至保存庫：

    ```powershell
    $secret = Set-AZKeyVaultSecret -VaultName $kv.VaultName -Name 'SQLPassword' -SecretValue $secretvalue
    ```

    >**注意**：祕密的名稱是 SQLPassword。 

4.  在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列命令來確認已建立祕密。

    ```powershell
    Get-AZKeyVaultSecret -VaultName $kv.VaultName
    ```

5. 將 [Cloud Shell] 窗格最小化。 

6. 在 Azure 入口網站中，瀏覽回 [Key Vault] 刀鋒視窗，在 [設定] 區段中按一下 [秘密]。

7. 在秘密清單中，按一下 [SQLPassword] 項目，然後在 [SQLPassword] 刀鋒視窗上，按一下代表祕密目前版本的項目。

    >**注意**：檢查有關您建立的祕密資訊。

    >**注意**：若要取得祕密的目前最新版本，請參考 `https://<key_vault_name>.vault.azure.net/secrets/<secret_name>` 或參考 `https://<key_vault_name>.vault.azure.net/secrets/<secret_name>/<secret_version>` 取得特定版本


### <a name="exercise-3-configure-an-azure-sql-database-and-a-data-driven-application"></a>練習 3：設定 Azure SQL 資料庫和資料驅動應用程式

在本練習中，您將會完成下列工作：

- 工作 1：啟用用戶端應用程式，以存取 Azure SQL Database 服務。
- 工作 2：建立允許應用程式存取 Key Vault 的原則。
- 工作 3：擷取 SQL Azure 資料庫 ADO.NET 連接字符串 
- 工作 4：登入執行 Visual Studio 2019 和 SQL Management Studio 2018 的 Azure VM
- 工作 5：在 SQL Database 中建立資料表，然後選取要加密的資料行


#### <a name="task-1-enable-a-client-application-to-access-the-azure-sql-database-service"></a>工作 1：啟用用戶端應用程式，以存取 Azure SQL Database 服務。 

在此工作中，您會啟用用戶端應用程式，以存取 Azure SQL Database 服務。 透過設定必要的驗證，並取得您須用於驗證應用程式的應用程式識別碼和秘密，便能完成此操作。 T

1. 在 Azure 入口網站分頁頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入 **應用程式註冊**，然後按下 **Enter** 鍵。

2. 在 [應用程式註冊] 刀鋒視窗上，按一下 [+ 新增註冊]。 

3. 在 [註冊應用程式] 刀鋒視窗中，指定下列設定 (將所有其他設定保留為預設值)：

    |設定|值|
    |----|----|
    |名稱|**sqlApp**|
    |重新導向 URI (選用)|**Web** 和 **https://sqlapp**|

4. 在 [註冊應用程式] 刀鋒視窗上，按一下 [註冊]。 

    >**注意**：註冊完成後，瀏覽器會自動將您重新導向 [sqlApp] 刀鋒視窗。 

5. 在 [sqlApp] 刀鋒視窗上，識別 **應用程式 (用戶端) 識別碼** 的值。 

    >**注意**：記錄此值。 您將在下一個工作中需要它。

6. 在 [sqlApp] 刀鋒視窗的 [管理] 區段中，按一下 [憑證與秘密]。

7. 在 [sqlApp | 憑證與秘密] 刀鋒視窗/[用戶端密碼] 區段，按一下 [+ 新增用戶端密碼]

8. 在 [新增用戶端密碼] 窗格中，指定下列設定：

    |設定|值|
    |----|----|
    |描述|**Key1**|
    |到期|**12 個月**|
    
9. 按一下 [新增] 以更新應用程式認證。

10. 在 [sqlApp | 憑證與秘密] 刀鋒視窗上，識別 **Key1** 的值。

    >**注意**：記錄此值。 您將在下一個工作中需要它。 

    >**注意**：請務必 *先* 複製值，再從刀鋒視窗離開瀏覽。 離開後，便無法再擷取其純文字值。


#### <a name="task-2-create-a-policy-allowing-the-application-access-to-the-key-vault"></a>工作 2：建立允許應用程式存取 Key Vault 的原則。

在此工作中，您會授與新註冊的應用程式權限，以存取儲存在 Key Vault 中的秘密。

1. 在 Azure 入口網站中，在 [Cloud Shell] 窗格內開啟 PowerShell 工作階段。

2. 確保在 Cloud Shell 窗格的左上角下拉式功能表中選取了 **PowerShell**。

3. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列命令來建立變數，以儲存您在上一個工作中記錄的 **應用程式 (用戶端) 識別碼** (將 `<Azure_AD_Application_ID>` 預留位置取代為 **應用程式 (用戶端) 識別碼** 的值)：
   
    ```powershell
    $applicationId = '<Azure_AD_Application_ID>'
    ```
4. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列命令以儲存 Key Vault 名稱。
    ```
    $kvName = (Get-AzKeyVault -ResourceGroupName 'AZ500LAB10').VaultName

    $kvName
    ```

5. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列命令，將 Key Vault 的權限授與您在上一個工作中註冊的應用程式：

    ```powershell
    Set-AZKeyVaultAccessPolicy -VaultName $kvName -ResourceGroupName AZ500LAB10 -ServicePrincipalName $applicationId -PermissionsToKeys get,wrapKey,unwrapKey,sign,verify,list
    ```

6. 關閉 [Cloud Shell] 窗格。 


#### <a name="task-3-retrieve-sql-azure-database-adonet-connection-string"></a>工作 3：擷取 SQL Azure 資料庫 ADO.NET 連接字符串 

練習 1 中的 ARM 範本部署已佈建 Azure SQL Server 執行個體，以及名為 **醫學** 的 Azure SQL 資料庫。 您會使用新的資料表結構，來更新空白資料庫資源，並選取資料行進行加密

1. 在 Azure 入口網站分頁頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入 **SQL 資料庫**，然後按下 **Enter** 鍵。

2. 在 SQL 資料庫清單中，按一下 **醫學 (<randomsqlservername>)** 項目。

    >**注意**：如果找不到資料庫，這可能表示您在練習 1 中起始的部署尚未完成。 您可以瀏覽至 Azure 資源群組「AZ500LAB10」(或您選擇的名稱) 來驗證此問題，然後從 [設定] 窗格中選取 [部署]。  

3. 在 [SQL資料庫] 刀鋒視窗的 [設定] 區段中，按一下 [連接字串]。 

    >**注意**：介面包括適用於 ADO.NET、JDBC、ODBC、PHP 和 Go 的連接字串。 
   
4. 記錄 **ADO.NET 連接字串**。 稍後您將會用到此資訊。

    >**注意**：當您使用連接字串時，請務必將 `{your_password}` 預留位置取代為您在練習 1 中以部署設定的密碼。

#### <a name="task-4-log-on-to-the-azure-vm-running-visual-studio-2019-and-sql-management-studio-2018"></a>工作 4：登入執行 Visual Studio 2019 和 SQL Management Studio 2018 的 Azure VM

在此工作中，您會登入在練習 1 中起始部署的 Azure VM。 此 Azure VM 裝載 Visual Studio 2019 和 SQL Server Management Studio 2018。

    >**Note**: Before you proceed with this task, ensure that the deployment you initiated in the first exercise has completed successfully. You can validate this by navigating to the blade of the Azure resource group "Az500Lab10" (or other name you chose) and selecting **Deployments** from the Settings pane.  

1. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入 **虛擬機器**，然後按下 **Enter** 鍵。

2. 在顯示的虛擬機器清單中，選取 **az500-10-vm1** 項目。 在 [az500-10-vm1] 刀鋒視窗的 [基本資訊] 窗格上，記下 [公用 IP 位址]。 稍後您會用到此項目。 

#### <a name="task-5-create-a-table-in-the-sql-database-and-select-data-columns-for-encryption"></a>工作 5：在 SQL Database 中建立資料表，然後選取要加密的資料行

在此工作中，您會使用 SQL Server Management Studio 連線至 SQL Database，並建立資料表。 然後，您會使用 Azure Key Vault 自動產生的金鑰來加密兩個資料行。 

1. 在 Azure 入口網站中，瀏覽至 **醫學** SQL 資料庫的刀鋒視窗，在 [基本資訊] 區段中，識別 [伺服器名稱] (複製到剪貼簿)，然後在工具列中，按一下 [設定伺服器防火牆]。  

    >**注意**：記錄伺服器名稱。 稍後在此工作中，您會需要伺服器名稱。

2. 在 [防火牆設定] 刀鋒視窗上，向下捲動至 [規則名稱]，並指定下列設定： 

    |設定|值|
    |---|---|
    |規則名稱|**允許 Mgmt VM**|
    |起始 IP|az500-10-vm1 的公用 IP 位址|
    |結束 IP|az500-10-vm1 的公用 IP 位址|

3. 按一下 [儲存] 和 [確定] 以儲存變更，並關閉確認窗格。 

    >**注意**：這會修改伺服器防火牆設定，允許從您在此實驗室中部署的 Azure VM 公用 IP 位址連線至醫學資料庫。

4. 瀏覽回 [az500-10-vm1] 刀鋒視窗，按一下 [概觀]，接著按一下 [連線]，然後在下拉式功能表中按一下 [RDP]。 

5. 按一下 [下載 RDP 檔案]，然後使用該檔案透過遠端桌面連線至 **az500-10-vm1** Azure VM。 出現驗證提示時，請提供下列認證：

    |設定|值|
    |---|---|
    |使用者名稱|**Student**|
    |密碼|**請使用您在實驗室 04 > 練習 1 > 工作 1 > 步驟 9 中建立的個人密碼。**|

    >**注意**：等待遠端桌面工作階段和 **伺服器管理員** 載入。 關閉 [伺服器管理員]。 

    >**注意**：此實驗室中的其餘步驟會在 **az500-10-vm1** Azure VM 的遠端桌面工作階段中執行。 

6. 按一下 [開始]，在 [開始] 功能表中，展開 [Microsoft SQL Server Tools 18] 資料夾，然後按一下 [Micosoft SQL Server Management Studio] 功能表項目。

7. 在 [連接到伺服器] 對話方塊上，指定下列設定： 

    |設定|值|
    |---|---|
    |伺服器類型|**資料庫引擎**|
    |Server Name (伺服器名稱)|您稍早在此工作中識別的伺服器名稱|
    |驗證|**SQL Server 驗證**|
    |登入|**Student**|
    |密碼|**請使用您在實驗室 04 > 練習 1 > 工作 1 > 步驟 9 中建立的個人密碼。**|

8. 在 [連線至伺服器] 對話方塊中，按一下 [連線]。

9. 在 [SQL Server Management Studio] 主控台的 [物件總管] 窗格中，展開 [資料庫] 資料夾。

10. 在 [物件總管] 窗格中，以滑鼠右鍵按一下 **醫學** 資料庫，然後按一下 [新增查詢]。

11. 將下列程式碼貼入查詢視窗，並按一下 [執行]。 這會建立 **病患** 資料表。

     ```sql
     CREATE TABLE [dbo].[Patients](
        [PatientId] [int] IDENTITY(1,1),
        [SSN] [char](11) NOT NULL,
        [FirstName] [nvarchar](50) NULL,
        [LastName] [nvarchar](50) NULL,
        [MiddleName] [nvarchar](50) NULL,
        [StreetAddress] [nvarchar](50) NULL,
        [City] [nvarchar](50) NULL,
        [ZipCode] [char](5) NULL,
        [State] [char](2) NULL,
        [BirthDate] [date] NOT NULL 
     PRIMARY KEY CLUSTERED ([PatientId] ASC) ON [PRIMARY] );
     ```
12. 在成功建立資料表後，在 [物件總管] 窗格中，展開 **醫療** 資料庫節點、**資料表** 節點，以滑鼠右鍵按一下 **dbo.Patients** 節點，然後按一下 [加密資料行]。 

    >**注意**：這將會啟動 **Always Encrypted** 精靈。

13. 在 [簡介]  頁面上，按一下 [下一步] 。

14. 在 [資料行選取] 頁面上，選取 [SSN] 和 [Birthdate] 資料行，將 [SSN] 資料行的 [加密類型] 設定為 **確定性**，並將 [Birthdate] 資料行設定為 **隨機化**，然後按 [下一步]。

    >**注意**：在執行加密時，如果與 **Rotary (Microsoft.SQLServer.Management.ServiceManagement)** 相關的 **調用目標已擲回任何類似例外狀況** 的錯誤，則請確保 **未選取** **金鑰權限** 的 **輪替原則作業** 值，如果不在 Azure 入口網站中，請瀏覽至 [Key Vault] >>  [存取原則] >>  [金鑰權限] >> 取消選取 [輪替原則作業] 下的所有值 >> 在 [特殊權限金鑰作業] 下>> 取消選取 [發行] 。

15. 在 [主要金鑰設定] 頁面上，選取 [Azure Key Vault]，在出現提示時按一下 [登入]，使用您稍早在此實驗室中佈建 Azure Key Vault 執行個體的相同使用者帳戶進行驗證，確保 Key Vault 出現在 [選取 Azure Key Vault] 下拉式清單中，然後按 [下一步]。

16. 在 [回合設定] 頁面上，按 [下一步]。
    
17. 在 [摘要] 頁面上，按一下 [完成] 繼續進行加密。 當提示出現時，請使用您稍早在此實驗室中佈建 Azure Key Vault 執行個體的相同使用者帳戶再次登入。

18. 加密程序完成後，在 [結果] 頁面按一下 [關閉]。

19. 在 [SQL Server Management Studio] 主控台的 [物件總管] 窗格中，展開 **醫療** 節點下的 [安全性] 和 [Always Encrypted 金鑰] 子節點。 

    >**注意**：[Always Encrypted 金鑰] 子節點包含 [資料行主要金鑰] 和 [資料行加密金鑰] 子資料夾。


### <a name="exercise-4-demonstrate-the-use-of-azure-key-vault-in-encrypting-the-azure-sql-database"></a>練習 4：示範如何使用 Azure Key Vault 加密 Azure SQL 資料庫

在本練習中，您將會完成下列工作：

- 工作 1：執行資料驅動應用程式，示範如何使用 Azure Key Vault 加密 Azure SQL 資料庫

#### <a name="task-1-run-a-data-driven-application-to-demonstrate-the-use-of-azure-key-vault-in-encrypting-the-azure-sql-database"></a>工作 1：執行資料驅動應用程式，示範如何使用 Azure Key Vault 加密 Azure SQL 資料庫

您會使用 Visual Studio 建立主控台應用程式，將資料載入加密的資料行，然後使用存取 Key Vault 中金鑰的連接字串安全存取該資料。

1. 從 RDP 工作階段到 **az500-10-vm1**，從 [開始] 功能表啟動 **Visual Studio 2019**。

2. 切換至顯示 Visual Studio 2019 歡迎訊息的視窗，按一下 [登入] 按鈕，並在提示出現時，提供您用於驗證此實驗室中使用的 Azure 訂用帳戶的認證。

3. 在 [開始] 頁面上，按一下 [建立新專案]。 

4. 在專案範本清單中，搜尋 **主控台應用程式 (.NET Framework)** ，在結果清單中，按一下 **C#** 的 **主控台應用程式 (.NET Framework)** ，然後按 [下一步]。

5. 在 [設定新專案] 頁面上，指定下列設定 (將其他設定保留為預設值)，然後按一下 [建立]：

    |設定|值|
    |---|---|
    |專案名稱|**OpsEncrypt**|
    |方案名稱|**OpsEncrypt**|
    |Framework|**.NET Framework 4.7.2**|

6. 在 Visual Studio 主控台中，按一下 [工具] 功能表，在下拉式功能表中按一下 [NuGet 套件管理員]，然後在串聯功能表中按一下 [套件管理員主控台]。

7. 在 [套件管理員主控台] 窗格中，執行下列命令以安裝第一個必要的 **NuGet** 套件：

    ```powershell
    Install-Package Microsoft.SqlServer.Management.AlwaysEncrypted.AzureKeyVaultProvider
    ```

8. 在 [套件管理員主控台] 窗格中，執行下列命令以安裝第二個必要的 **NuGet** 套件：

    ```powershell
    Install-Package Microsoft.IdentityModel.Clients.ActiveDirectory
    ```
    
9. 將 RDP 工作階段最小化至您的 Azure 虛擬機器，然後瀏覽至 **\\Allfiles\\Labs\\10\\program.cs**，在記事本中開啟此檔案，並將其內容複寫到剪貼簿。

10. 返回 RDP 工作階段，然後在 Visual Studio 主控台的 [方案總管] 視窗中，按一下 [Program.cs]，並以您複製到剪貼簿的程式碼取代內容。

11. 在 [Visual Studio] 視窗 [Program.cs] 窗格的第 15 行中，用您稍早在實驗室中記錄的 Azure SQL 資料庫 **ADO.NET** 連接字串取代 `<connection string noted earlier>` 預留位置。 在連接字串中，將 `{your_password}` 預留位置取代為 `Pa55w.rd1234`。 如果您將字串儲存在實驗室電腦中，您可能需要離開 RDP 工作階段以複製 ADO 字串，然後返回 Azure 虛擬機器貼上字串。

12. 在 [Visual Studio] 視窗中，於 [Program.cs] 窗格的第 16 行，用您稍早在實驗室中記錄已註冊應用程式的 **應用程式 (用戶端) 識別碼** 值取代 `<client id noted earlier>` 預留位置。 

13. 在 [Visual Studio] 視窗中，於 [Program.cs] 窗格的第 17 行，用您稍早在實驗室中記錄已註冊應用程式的 **Key1** 值取代 `<key value noted earlier>` 預留位置。 

14. 在 Visual Studio 主控台中，按一下 [開始] 按鈕以起始組建主控台應用程式，並加以啟動。

15. 應用程式會啟動命令提示字元視窗。 當系統提示輸入密碼時，請輸入您在練習 1 部署中指定的密碼，以連線至 Azure SQL Database。 

16. 讓主控台應用程式保持執行狀態，並切換至 [SQL Management Studio] 主控台。 

17. 在 [物件總管] 窗格中，以滑鼠右鍵按一下 **醫學資料庫**，然後在滑鼠右鍵功能表中，按一下 [新增查詢]。

18. 從查詢視窗中執行下列查詢，確認從主控台應用程式載入資料庫的資料已加密。

    ```sql
    SELECT FirstName, LastName, SSN, BirthDate FROM Patients;
    ```

19. 切換回系統提示您輸入有效 SSN 的主控台應用程式。 這將會查詢資料的加密資料行。 在 [命令提示字元] 輸入下列命令，然後按下 Enter 鍵：

    ```cmd
    999-99-0003
    ```

    >**注意**：確認查詢傳回的資料並未加密。

20. 若要終止主控台應用程式，請按下 Enter 鍵

**清除資源**

> 請記得移除您不再使用的任何新建 Azure 資源。 移除未使用的資源可避免產生非預期的費用。

1. 在 Azure 入口網站中，按一下右上方的第一個圖示以開啟 [Cloud Shell]。 

2. 在 [Cloud Shell] 窗格左上角的下拉式功能表中，選取 [PowerShell]，並在提示出現時按一下 [確認]。

3. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列操作，移除您在此實驗室中建立的資源群組：
  
    ```powershell
    Remove-AzResourceGroup -Name "AZ500LAB10" -Force -AsJob
    ```

4.  關閉 [Cloud Shell] 窗格。 
