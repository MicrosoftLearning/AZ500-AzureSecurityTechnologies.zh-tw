---
lab:
  title: 01 - 角色型存取控制
  module: Module 01 - Manage Identity and Access
---

# 實驗 01：角色型存取控制
# 學生實驗室手冊

## 實驗案例

系統要求您建立概念證明，顯示如何建立 Azure 使用者和群組。 此外，也顯示如何使用角色型存取控制將角色指派給群組。 具體而言，您需要：

- 建立一個資深管理員群組，其中包含 Joseph Price 的使用者帳戶作為其成員。
- 建立一個初級系統管理員群組，其中包含 Isabel Garcia 的使用者帳戶作為其成員。
- 建立一個服務台群組，其中包含 Dylan Williams 的使用者帳戶作為其成員。
- 將虛擬機器參與者角色指派給服務台群組。 

> 此實驗室中所有資源均使用**美國東部**區域。 請與講師驗證這是課程中要使用的區域。 

## 實驗室目標

在本實驗室中，您將完成下列練習：

- 練習 1：建立一個資深管理員群組，其中使用者帳戶 Joseph Price 作為其成員 (Azure 入口網站)。 
- 練習 2：建立一個資淺管理員群組，其中使用者帳戶 Isabel Garcia 作為其成員 (PowerShell)。
- 練習 3：建立一個服務台群組，其中使用者 Dylan Williams 作為其成員 (Azure CLI)。 
- 練習 4：將虛擬機器參與者角色指派給服務台群組。

## 角色型存取控制架構圖表

![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/506cde9c-5242-4438-a793-f88a5434a2b2)

## 指示

### 練習 1：建立一個資深系統管理員群組，其中 Joseph Price 的使用者帳戶作為其成員。 

#### 預估時間：10 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：使用 Azure 入口網站為 Joseph Price 建立使用者帳戶。
- 工作 2：使用 Azure 入口網站來建立資深系統管理員群組，並將 Joseph Price 的使用者帳戶新增至群組。

#### 工作 1：使用 Azure 入口網站為 Joseph Price 建立使用者帳戶 

在此工作中，您會為 Joseph Price 建立使用者帳戶。 

1. 啟動瀏覽器工作階段並登入 Azure 入口網站 **`https://portal.azure.com/`**。

    >**注意**：登入 Azure 入口網站時使用的帳戶，必須在您用於這個實驗室的 Azure 訂用帳戶中具有擁有者或參與者角色，並在與該訂用帳戶相關聯的 Microsoft Entra 租用戶中具有全域管理員角色。

2. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務和文件]**** 文字輸入框中，輸入 **Microsoft Entra ID**，然後按 **Enter** 鍵。

3. 在 Microsoft Entra ID 租用戶的 [概觀]**** 刀鋒視窗中，選取 [管理]**** 區段中的 [使用者]****，然後選取 [+ 新增使用者]****。

4. 在 [新增使用者]**** 刀鋒視窗上，確認已選取 [建立使用者]**** 選項並指定下列設定：

   |設定|值|
   |---|---|
   |使用者名稱|**Joseph**|
   |名稱|**Joseph Price**|

5. 按一下 [使用者名稱]**** 旁的複製圖示，以複製完整使用者。

6. 確認已選取 [自動產生密碼]****，選取 [顯示密碼]**** 核取方塊，以識別自動產生的密碼。 您必須向 Joseph 提供此密碼及使用者名稱。 

7. 按一下 [建立]****。

8. 重新整理 [使用者 \| 所有使用者]**** 刀鋒視窗，驗證是否已在 Microsoft Entra 租用戶中建立新的使用者。

#### 工作 2：使用 Azure 入口網站來建立資深系統管理員群組，並將 Joseph Price 的使用者帳戶新增至群組。

在此工作中，您會建立*資深系統管理員*群組、將 Joseph Price 的使用者帳戶新增至群組，並將其設定為群組擁有者。

1. 在 Azure 入口網站中，瀏覽回顯示 Microsoft Entra ID 租用戶的刀鋒視窗。 

2. 在 [管理]**** 區段中，按一下 [群組]****，然後選取 [+ 新增群組]****。
 
3. 在 [新增群組]**** 刀鋒視窗上，指定下列設定 (將其他設定保留為預設值)：

   |設定|值|
   |---|---|
   |群組類型|**安全性**|
   |群組名稱|**資深系統管理員**|
   |成員資格類型|**已指派**|
    
4. 按一下 [未選取任何擁有者]**** 連結，在 [新增擁有者]**** 刀鋒視窗上，選取 [Joseph Price]****，然後按一下 [選取]****。

5. 按一下 [未選取任何成員]**** 連結，在 [新增成員]**** 刀鋒視窗上，選取 [Joseph Price]****，然後按一下 [選取]****。

6. 返回至 [新增群組] 刀鋒視窗，按一下 [建立]。

> 結果：您已使用 Azure 入口網站來建立使用者和群組，並將使用者指派給群組。 

### 練習 2：建立一個初級系統管理員群組，其中包含 Isabel Garcia 的使用者帳戶作為其成員。

#### 預估時間：10 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：使用 PowerShell 為 Isabel Garcia 建立使用者帳戶。
- 工作 2：使用 PowerShell 建立初級系統管理員群組，並將 Isabel Garcia 的使用者帳戶新增至群組。 

#### 工作 1：使用 PowerShell 為 Isabel Garcia 建立使用者帳戶。

在此工作中，您將使用 PowerShell 為 Isabel Garcia 建立使用者帳戶。

1. 按一下 Azure 入口網站右上方的第一個圖示，開啟 Cloud Shell。 如果出現提示，請選取 [PowerShell]**** 與 [建立儲存體]****。

2. 確認在 [Cloud Shell] 窗格左上角的下拉式功能表中，已選取 [PowerShell]****。

   >**注意**：若要將複製的文字貼到 Cloud Shell，請在窗格視窗中按一下滑鼠右鍵，然後選取 [貼上]****。 或者，您可以使用 **Shift+Insert** 按鍵組合。

3. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列命令以建立密碼設定檔物件：

    ```powershell
    $passwordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    ```

4. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列命令以在設定檔物件中設置密碼的值：
    ```powershell
    $PasswordProfile = @{
      Password = 'Helo123!'
      ForceChangePasswordNextSignIn = $true
      ForceChangePasswordNextSignInWithMfa = $true
    }
    ```

5. 在 Cloud Shell 窗格內的 PowerShell 工作階段中，執行下列命令以連線至 Microsoft Entra ID：

    ```powershell
    Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All", "AuditLog.Read.All", "RoleManagement.Read.Directory"
    ```
      
6. 在 Cloud Shell 窗格內的 PowerShell 工作階段中，執行下列命令以識別 Microsoft Entra 租用戶的名稱： 

    ```powershell
    $domainName = ((Get-MgOrganization).VerifiedDomains)[0].Name
    ```

7. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列命令為 Isabel Garcia 建立使用者帳戶： 

    ```powershell
    New-MgUser -DisplayName 'Isabel Garcia' -PasswordProfile $passwordProfile -UserPrincipalName "Isabel@$domainName" -MailNickName 'Isabel' -AccountEnabled
    ```

8. 在 Cloud Shell 窗格內的 PowerShell 工作階段中，執行下列命令以列出 Microsoft Entra ID 使用者 (Joseph 和 Isabel 的帳戶應出現在清單上)： 

    ```powershell
    Get-MgUser 
    ```

#### 工作 2：使用 PowerShell 建立初級系統管理員群組，並將 Isabel Garcia 的使用者帳戶新增至群組。

在此工作中，您會使用 PowerShell 建立初級系統管理員群組，並將 Isabel Garcia 的使用者帳戶新增至群組。

1. 在 Cloud Shell 窗格內的相同 PowerShell 工作階段中，執行下列命令以建立名為 Junior Admins 的新安全性群組****：
   
   ```powershell
   New-MgGroup -DisplayName "Junior Admins" -MailEnabled:$false -SecurityEnabled:$true -MailNickName JuniorAdmins
   ```
   
2. 在 Cloud Shell 窗格內的 PowerShell 工作階段中，執行下列命令以列出 Microsoft Entra 租用戶中的群組**** (清單應包含 Senior Admins 和 Junior Admins 群組)
   
   ```powershell
   Get-MgGroup
   ```

3. 在 Cloud Shell 窗格內的 PowerShell 工作階段中，執行下列命令以取得對 Isabel Garcia 使用者帳戶的參考****：

   ```powershell
   $user =Get-MgUser -Filter "MailNickName eq 'Isabel'"
   ```

4. 在 Cloud Shell 窗格內的 PowerShell 工作階段中，執行下列命令以取得對 Junior Admins 群組的參考****：
   ```powershell
   $targetGroup = Get-MgGroup -ConsistencyLevel eventual -Search '"DisplayName:Junior Admins"'
   ```

5. 在 Cloud Shell 窗格內的 PowerShell 工作階段中，執行下列命令以將 Isabel 的使用者帳戶**** 新增至 Junior Admins 群組：
   
   ```powershell
    New-MgGroupMember -DirectoryObjectId $user.id -GroupId $targetGroup.id
    ```
   
5. 在 Cloud Shell 窗格內的 PowerShell 工作階段中，執行下列命令以驗證**** Junior Admins 群組是否包含 Isabel 的使用者帳戶：
   
    ```powershell
    Get-MgGroupMember -GroupId $targetGroup.id
    ```
 
> 結果：您使用 PowerShell 建立使用者和群組帳戶，並將使用者帳戶新增至群組帳戶。 

### 練習 3：建立服務台群組，其中包含 Dylan Williams 的使用者帳戶作為其成員。

#### 預估時間：10 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：使用 Azure CLI 為 Dylan Williams 建立使用者帳戶。
- 工作 2：使用 Azure CLI 建立服務台群組，並將 Dylan 的使用者帳戶新增至群組。 

#### 工作 1：使用 Azure CLI 為 Dylan Williams 建立使用者帳戶。

在此工作中，您會為 Dylan Williams 建立使用者帳戶。

1. 在 [Cloud Shell] 窗格左上角的下拉式功能表中，選取 [Bash]****，並在提示出現時按一下 [確認]****。 

2. 在 Cloud Shell 窗格內的 Bash 工作階段中，執行下列命令以識別 Microsoft Entra 租用戶的名稱：

    ```cli
    DOMAINNAME=$(az ad signed-in-user show --query 'userPrincipalName' | cut -d '@' -f 2 | sed 's/\"//')
    ```

3. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令以建立使用者 Dylan Williams。 使用*您的網域*。
 
    ```cli
    az ad user create --display-name "Dylan Williams" --password "Pa55w.rd1234" --user-principal-name Dylan@$DOMAINNAME
    ```
      
4. 在 Cloud Shell 窗格內的 Bash 工作階段中，執行下列命令以列出 Microsoft Entra ID 使用者帳戶 (清單應包含 Joseph、Isabel 和 Dylan 的使用者帳戶)
    
    ```cli
    az ad user list --output table
    ```

#### 工作 2：使用 Azure CLI 建立服務台群組，並將 Dylan 的使用者帳戶新增至群組。 

在此工作中，您會建立服務台群組，並將 Dylan 指派給群組。 

1. 在 [Cloud Shell] 窗格的相同 Bash 工作階段中，執行下列命令以建立名為「服務台」的新安全性群組。

    ```cli
    az ad group create --display-name "Service Desk" --mail-nickname "ServiceDesk"
    ```
 
2. 在 Cloud Shell 窗格內的 Bash 工作階段中，執行下列命令以列出 Microsoft Entra ID 群組 (清單應包含 Service Desk、Senior Admins, 和 Junior Admins 群組)：

    ```cli
    az ad group list -o table
    ```

3. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令以取得對 Dylan Williams 使用者帳戶的參考： 

    ```cli
    USER=$(az ad user list --filter "displayname eq 'Dylan Williams'")
    ```

4. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令以取得 Dylan Williams 使用者帳戶的 objectId 屬性： 

    ```cli
    OBJECTID=$(echo $USER | jq '.[].id' | tr -d '"')
    ```

5. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令以將 Dylan 的使用者帳戶新增至服務台群組： 

    ```cli
    az ad group member add --group "Service Desk" --member-id $OBJECTID
    ```

6. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令以列出服務台群組的成員，並確認其中包含 Dylan 的使用者帳戶：

    ```cli
    az ad group member list --group "Service Desk"
    ```

7. 關閉 [Cloud Shell] 窗格。

> 結果：使用 Azure CLI 建立使用者和群組帳戶，並將使用者帳戶新增至群組。 


### 練習 4：將虛擬機器參與者角色指派給服務台群組。

#### 預估時間：10 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：建立資源群組。 
- 工作 2：將服務台虛擬機器參與者權限指派給資源群組。  

#### 工作 1：建立資源群組

1. 在 Azure 入口網站分頁頂端的 [搜尋資源、服務及文件]**** 文字輸入框中輸入 **「資源群組」**，然後按下 **Enter** 鍵。

2. 在 [資源群組]**** 窗格上，按一下 [+ 建立]****，並指定下列設定：

   |設定|值|
   |---|---|
   |訂用帳戶名稱|您的 Azure 訂用帳戶的名稱|
   |資源群組名稱|**AZ500Lab01**|
   |Location|**美國東部**|

3. 按一下 [檢閱 + 建立]****，然後按一下 [建立]****。

   >**注意**：等候資源群組部署。 使用 [通知]**** 圖示 (右上方) 追蹤部署狀態的進度。

4. 回到 [資源群組]**** 刀鋒視窗，重新整理頁面，並確認新的資源群組出現在資源群組清單中。


#### 工作 2：指派服務台虛擬機器參與者權限。 

1. 在 [資源群組]**** 刀鋒視窗中，按一下 [AZ500LAB01]**** 資源群組項目。

2. 在 [AZ500Lab01]**** 刀鋒視窗上，按一下中間窗格的 [存取控制 (IAM)]****。

3. 在 [AZ500Lab01 \| 存取控制 (IAM)]**** 刀鋒視窗上，按一下 [+ 新增]****，然後在下拉式功能表中按一下 [新增角色指派]****。

4. 在 [新增角色指派]**** 刀鋒視窗上，指定下列設定，並在每個步驟後按一下 [下一步]****：

   |設定|值|
   |---|---|
   |搜尋索引標籤中的角色|**虛擬機器參與者**|
   |存取權指派對象 (在成員窗格下)|**使用者、群組或服務主體**|
   |選取 (+選取成員)|**服務台**|

5. 按兩下 [檢閱 + 指派]**** 以建立角色指派。

6. 從 [存取控制 (IAM) ]**** 刀鋒視窗中，選取 [角色指派]****。

7. 在 [AZ500Lab01 \| 存取控制 (IAM)]**** 刀鋒視窗的 [檢查存取權]**** 索引標籤上，在 [依名稱或電子郵件地址搜尋]**** 文字輸入框中，輸入 **Dylan Williams**。

8. 在搜尋結果清單中，選取 Dylan Williams 的使用者帳戶，然後在 [Dylan Williams 指派 - AZ500Lab01]**** 刀鋒視窗上，檢視新建立的指派。

9. 關閉 [Dylan Williams 指派 - AZ500Lab01]**** 刀鋒視窗。

10. 重複相同的最後兩個步驟，以檢查 **Joseph Price** 的存取權。 

> 結果：您已指派並檢查 RBAC 權限。 

**清除資源**

> 請記得移除您不再使用的任何新建立的 Azure 資源。 移除未使用的資源可避免產生非預期的費用。

1. 在 Azure 入口網站中按一下右上方的第一個圖示，開啟 Cloud Shell。 

2. 在 [Cloud Shell] 窗格左上角的下拉式功能表中選取 [PowerShell]****，並在提示出現時按一下 [確認]****。 

3. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列操作，移除您在此實驗室中建立的資源群組：
  
    ```
    Remove-AzResourceGroup -Name "AZ500LAB01" -Force -AsJob
    ```

4.  關閉 [Cloud Shell] 窗格。 
