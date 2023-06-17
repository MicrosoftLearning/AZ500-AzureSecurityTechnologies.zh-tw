---
lab:
  title: 03 - Resource Manager 鎖定
  module: Module 01 - Manage Identity and Access
---

# 實驗 03：Resource Manager 鎖定
# 學生實驗室手冊

## 實驗案例 

您收到要求，必須建立概念證明以顯示如何使用資源鎖定防止意外刪除或變更的情況發生。 具體而言，您需要：

- 建立 ReadOnly 鎖定

- 建立刪除鎖定

> 此實驗室中所有資源使用的都是**美國東部**區域。 請與講師確認這是課程中要使用的區域。 
 
## 實驗室目標

在本實驗室中，您須完成下列練習：

- 練習 1：Resource Manager 鎖定

## Resource Manager 鎖定圖表

![image](https://user-images.githubusercontent.com/91347931/157514986-1bf6a9ea-4c7f-4487-bcd7-542648f8dc95.png)

## 指示

### 練習 1：Resource Manager 鎖定

#### 預估時間：20 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：建立資源群組和儲存體帳戶。
- 工作 2：在儲存體帳戶上新增 ReadOnly 鎖定。 
- 工作 3：測試 ReadOnly 鎖定。 
- 工作 4：移除 ReadOnly 鎖定並建立刪除鎖定。
- 工作 5：測試刪除鎖定。

#### 工作 1：建立資源群組和儲存體帳戶。

在此工作中，您必須為本實驗室建立資源群組和儲存體帳戶。 

1. 登入 Azure 入口網站： **`https://portal.azure.com/`** 。

    >**注意**：登入 Azure 入口網站時使用的帳戶，必須在您用於這個實驗室的 Azure 訂用帳戶中具有「擁有者」或「參與者」角色。

1. 按一下 Azure 入口網站右上方的第一個圖示，開啟 Cloud Shell。 如果出現提示，請選取 [PowerShell] 和 [建立儲存體]。

1. 確定在 [Cloud Shell] 窗格左上角的下拉式功能表中，已選取 [PowerShell]。

1. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中執行下列命令，以建立資源群組 (請與講師確認位置參數的值)：

    ```powershell
    New-AzResourceGroup -Name AZ500LAB03 -Location 'EastUS'
    
    Confirm
    Provided resource group already exists. Are you sure you want to update it?
    [Y] Yes [N] No [S] Suspend [?] Help (default is "Y"): Y
    ```
1. 在 [Cloud Shell] 窗格內的 PowerShell 工作階段中，輸入 **Y**，然後按 Enter 鍵。

1. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中執行下列命令，以便在新建的資源群組中建立儲存體帳戶：
    
    ```powershell
    New-AzStorageAccount -ResourceGroupName AZ500LAB03 -Name (Get-Random -Maximum 999999999999999) -Location  EastUS -SkuName Standard_LRS -Kind StorageV2 
    ```

   >**注意**：請等待儲存體帳戶建立完畢。 這可能需要幾分鐘。 

1. 關閉 [Cloud Shell] 窗格。

#### 工作 2：在儲存體帳戶上新增 ReadOnly 鎖定。 

在此工作中，您必須為儲存體帳戶新增唯讀鎖定。 這項操作可避免資源意外遭到刪除或修改。 

1. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入「資源群組」，然後按下 **Enter** 鍵。

1. 在 [資源群組] 刀鋒視窗中，選取 [AZ500LAB03] 資源群組項目。

1. 在 [AZ500LAB03] 資源群組刀鋒視窗的資源清單中，選取新的儲存體帳戶。 

1. 在 [設定] 區段中，按一下「鎖定」圖示。

1. 按一下 [+ 新增]，然後指定下列設定：

   |設定|值|
   |---|---|
   |鎖定名稱|**ReadOnly 鎖定**|
   |鎖定類型|**唯讀**|

1. 按一下 [確定]。 

   >**注意**：儲存體帳戶現在已受到保護，可避免意外遭到刪除和修改。

#### 工作 3：測試 ReadOnly 鎖定 

1. 在 [儲存體帳戶] 刀鋒視窗的 [設定] 區段中，按一下 [設定]。

1. 將 [需要安全傳輸] 選項設定為 [停用]，然後按一下 [儲存]。

1. 您應該會看到「無法更新儲存體帳戶」的通知。

1. 在 Azure 入口網站頂端的工具列中按一下**通知**圖示以檢閱通知，內容應類似於下列文字： 

    > **「無法更新儲存體帳戶 'xxxxxxxx'。錯誤：因為下列範圍已鎖定，所以範圍 'xxxxxxxx' 無法執行寫入作業：'/subscriptions/xxxxx-xxx-xxxx-xxxx-xxxxxxxx/resourceGroups/AZ500LAB03/providers/Microsoft.Storage/storageAccounts/xxxxxxx'。請移除鎖定，然後再試一次。」**

1. 返回儲存體帳戶的 [設定] 刀鋒視窗，然後按一下 [捨棄]。 

1. 在 [儲存體帳戶] 刀鋒視窗中選取 [概觀]，然後在 [概觀] 刀鋒視窗中按一下 [刪除]。

1. 在 [刪除儲存體帳戶] 刀鋒視窗中輸入儲存體帳戶的名稱，確認您要繼續操作，然後按一下 [刪除]。

1. 檢閱新產生的通知，內容應類似於下列文字： 

    > **「無法刪除儲存體帳戶 'xxxxxxx'。錯誤：因為下列範圍已鎖定，所以範圍 'xxxxxxxx' 無法執行刪除作業：'/subscriptions/xxxx-xxxx-xxxx-xxxx-xxxxxx/resourceGroups/AZ500LAB03/providers/Microsoft.Storage/storageAccounts/xxxxxxx'。請移除鎖定，然後再試一次。」**

   >**注意**：您現在已確認 ReadOnly 鎖定可防止資源意外遭到刪除和修改。

#### 工作 4：移除 ReadOnly 鎖定並建立刪除鎖定。

在此工作中，您必須從儲存體帳戶中移除 ReadOnly 鎖定，並建立刪除鎖定。 

1. 在 Azure 入口網站中返回顯示新建儲存體帳戶屬性的刀鋒視窗。

1. 在 [設定] 區段中選取 [鎖定]。  

1. 在 [鎖定] 刀鋒視窗中按一下 **ReadOnly 鎖定**項目最右邊的**刪除**圖示。

1. 按一下 [+ 新增]，然後指定下列設定：

   |設定|值|
   |---|---|
   |鎖定名稱|**刪除鎖定**|
   |鎖定類型|**刪除**|

1. 按一下 [確定]。 

#### 工作 5：測試刪除鎖定。

在此工作中，您必須測試刪除鎖定。 您應該要能夠修改儲存體帳戶，但不能將其刪除。 

1. 在 [儲存體帳戶] 刀鋒視窗的 [設定] 區段中，按一下 [設定]。

1. 將 [需要安全傳輸] 選項設定為 [停用]，然後按一下 [儲存]。

   >**注意**：這次應該可順利進行變更。

1. 在 [儲存體帳戶] 刀鋒視窗中選取 [概觀]，然後在 [概觀] 刀鋒視窗中按一下 [刪除]。

1. 檢閱類似於下列文字的通知內容： 

    > **「因為 'xxxxxx' 或其父代有刪除鎖定，所以無法刪除此資源。必須先移除鎖定，才可刪除此資源。」**

   >**注意**：您現在已確認**刪除**鎖定允許變更設定，但可防止資源意外遭到刪除。

   >**注意**：使用資源鎖定可以實作額外的防線，防止最重要的資源遭到意外或惡意變更和/或刪除。 具備「擁有者」角色的所有使用者都可以移除資源鎖定，但必須在充分了解情況的條件下才能這麼做。 鎖定可以彌補角色型存取控制的不足。 

> 結果：在此練習中，您已了解如何使用 Resource Manager 鎖定防止資源遭到修改和意外刪除。

**清除資源**

> 請記得移除您不再使用的任何新建 Azure 資源。 移除未使用的資源可避免產生非預期的費用。

1. 在 Azure 入口網站中按一下右上方的第一個圖示，開啟 [Cloud Shell]。 出現提示後，按一下 [重新連線]。

1. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中執行下列命令，以移除刪除鎖定：

    ```powershell
    $storageaccountname = (Get-AzStorageAccount -ResourceGroupName AZ500LAB03).StorageAccountName

    $lockName = (Get-AzResourceLock -ResourceGroupName AZ500LAB03 -ResourceName $storageAccountName -ResourceType Microsoft.Storage/storageAccounts).Name

    Remove-AzResourceLock -LockName $lockName -ResourceName $storageAccountName  -ResourceGroupName AZ500LAB03 -ResourceType Microsoft.Storage/storageAccounts -Force
    ```

1.  在 [Cloud Shell] 窗格的 PowerShell 工作階段中執行下列命令，以移除資源群組：

    ```powershell
    Remove-AzResourceGroup -Name "AZ500LAB03" -Force -AsJob
    ```

1.  關閉 [Cloud Shell] 窗格。 
