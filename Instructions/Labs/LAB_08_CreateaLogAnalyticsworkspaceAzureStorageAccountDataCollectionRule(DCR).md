---
lab:
  title: 08 - 建立 Log Analytics 工作區、Azure 儲存體 帳戶和數據收集規則 （DCR）
  module: Module 03 - Configure and manage threat protection by using Microsoft Defender for Cloud
---

# 實驗室 08：建立 Log Analytics 工作區、Azure 儲存體 帳戶和數據收集規則 （DCR）

# 學生實驗室手冊

## 實驗案例

身為金融技術公司的 Azure 安全性工程師，您負責加強用於處理財務交易及管理機密客戶數據之所有 Azure 虛擬機 （VM） 的監視和安全性可見度。 安全性小組需要來自這些 VM 的詳細記錄和效能計量，以偵測潛在的威脅並優化系統效能。 資訊安全官（CISO）要求您實作一個解決方案，以收集安全性事件、系統記錄和性能計數器。 您已獲派您設定 Azure 監視器代理程式 （AMA） 以及資料收集規則 （DCR） 以集中收集記錄和效能監視。



> 此實驗室中所有資源均使用**美國東部**區域。 請與講師驗證這是課程中要使用的區域。 

## 實驗室目標

在本實驗室中，您將完成下列練習：

- 練習 1：部署 Azure 虛擬機器
- 練習 2：建立 Log Analytics 工作區
- 練習 3：建立 Azure 儲存體帳戶
- 練習 4：建立數據整理規則
  
## 指示

### 練習 1：部署 Azure 虛擬機器

### 練習時間：10 分鐘

在本練習中，您將會完成下列工作： 

- 工作 1：部署 Azure 虛擬機器。 

#### 工作 1：部署 Azure 虛擬機器

1. 登入 Azure 入口網站：**`https://portal.azure.com/`**。

    >**注意**：登入 Azure 入口網站時使用的帳戶，必須在您用於這個實驗室的 Azure 訂用帳戶中具有「擁有者」或「參與者」角色。

2. 按一下 Azure 入口網站右上方的第一個圖示，開啟 Cloud Shell。 如果出現提示，請選取 [PowerShell]**** 與 [建立儲存體]****。

3. 確認在 [Cloud Shell] 窗格左上角的下拉式功能表中，已選取 [PowerShell]****。

4. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中執行下列指令，建立您要在此實驗室中使用的資源群組：
  
    ```powershell
    New-AzResourceGroup -Name AZ500LAB131415 -Location 'EastUS'
    ```

    >**注意**：此資源群組將用於實驗室 8、9 和 10。

5. 在 Cloud Shell 窗格內的 PowerShell 工作階段中，執行下列命令以在主機上啟用加密 ((EAH))
   
   ```powershell
    Register-AzProviderFeature -FeatureName "EncryptionAtHost" -ProviderNamespace Microsoft.Compute 
    ```

5. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列命令以建立新的 Azure 虛擬機器。 

    ```powershell
    New-AzVm -ResourceGroupName "AZ500LAB131415" -Name "myVM" -Location 'EastUS' -VirtualNetworkName "myVnet" -SubnetName "mySubnet" -SecurityGroupName   "myNetworkSecurityGroup" -PublicIpAddressName "myPublicIpAddress" -PublicIpSku Standard -OpenPorts 80,3389 -Size Standard_D2s_v3 
    ```
    
6.  出現憑據提示時：

    |設定|值|
    |---|---|
    |User |**localadmin**|
    |密碼|**請使用您在實驗室 02 > 練習 2 > 工作 1 > 步驟 3 中建立的個人密碼。**|

    >**注意**：等待部署完成。 

7. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中執行下列命令，確認名為 **myVM** 的虛擬機器已順利建立，且 **ProvisioningState** 為 **「已成功」**。

    ```powershell
    Get-AzVM -Name 'myVM' -ResourceGroupName 'AZ500LAB131415' | Format-Table
    ```

8. 關閉 [Cloud Shell] 窗格。 

### 練習 2：建立 Log Analytics 工作區

### 練習時間：10 分鐘

在本練習中，您將會完成下列工作： 

- 工作 1：建立 Log Analytics 工作區。

#### 工作 1：建立 Log Analytics 工作區

在此工作中，您必須建立 Log Analytics 工作區。 

1. 在 Azure 入口網站分頁頂端的 [搜尋資源、服務及文件] **** 文字輸入框中輸入 **「Log Analytics 工作區」**，然後按下 **Enter** 鍵。

2. 在 [Log Analytics 工作區]**** 刀鋒視窗上，按一下 [+ 建立] ****。

3. 在 [建立 Log Analytics 工作區]**** 刀鋒視窗的 [基本]**** 索引標籤上，指定下列設定 (其他設定請保留預設值)：

    |設定|值|
    |---|---|
    |訂用帳戶|您要在此實驗室中使用的 Azure 訂用帳戶名稱|
    |資源群組|**AZ500LAB131415**|
    |名稱|任何有效的全域唯一名稱|
    |區域|**美國東部**|

4. 選取 [**檢閱 + 建立**]。

5. 在 [建立 Log Analytics 工作區]**** 刀鋒視窗的 [檢閱 + 建立]**** 索引標籤上，選取 [建立]****。

### 練習 3：建立 Azure 儲存體帳戶

### 預計時間：10 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：建立 Azure 儲存體帳戶。

#### 工作 1：建立 Azure 儲存體帳戶

在此工作中，您將建立儲存體帳戶。

1. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] **** 文字輸入框中輸入**儲存體帳戶**，然後按下 **Enter** 鍵。

2. 在 Azure 入口網站的 [儲存體帳戶]**** 刀鋒視窗中，按一下 [+ 建立]**** 按鈕來建立新的儲存體帳戶。

    ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/73eb9241-d642-455a-a1ff-b504670395c0)

3. 在 [建立儲存體帳戶] 窗格的 [基本] 索引標籤上，指定下列設定 (將其他設定保留為預設值)：

    |設定|值|
    |---|---|
    |訂用帳戶|您要在此實驗室中使用的 Azure 訂用帳戶名稱|
    |資源群組|**AZ500LAB131415**|
    |儲存體帳戶名稱|長度介於 3 到 24 個字元之間，由字母和數字組成的任何全域唯一名稱|
    |Location|**(美國) 美國東部**|
    |效能|**標準 (一般用途 v2 帳戶)**|
    |異地備援|**本機備援儲存體 (LRS)**|

4. 在 [建立儲存體帳戶]**** 刀鋒視窗的 [基本]**** 索引標籤上，按一下 [檢閱]****、等候驗證流程完成，然後按一下 [建立]****。

     ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/d443821c-2ddf-4794-87fa-bfc092980eba)

    >**注意**：等候儲存體帳戶建立完成。 這應該大約需要 2 分鐘的時間。

### 練習 4：建立數據收集規則

### 預計時間：15 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：建立資料收集規則。

#### 工作 1：建立資料收集規則。

在此工作中，您將建立資料收集規則。

1. 在 Azure 入口網站中，於 Azure 入口網站頁面頂端的 [搜尋資源、服務和文件]**** 文字輸入框中，輸入 [監視器]****，然後按 **Enter** 鍵。

2. 在 [監視器設定]**** 刀鋒視窗上，按一下 [資料收集規則] ****。

  ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/d43e8f94-efb2-4255-9320-210c976fd45e)


3. 按兩下 [ **+ 建立** ] 按鈕以建立新的資料收集規則。

4. 在 [建立資料收集規則]**** 刀鋒視窗的 [基本]**** 索引標籤上，指定下列設定：
  
    |設定|值|
    |---|---|
    |**規則詳細資料**|
    |規則名稱|**DCR1**|
    |訂用帳戶|您要在此實驗室中使用的 Azure 訂用帳戶名稱|
    |資源群組|**AZ500LAB131415**|
    |區域|**美國東部**|
    |平台類型|**Windows**|
    |資料收集端點|*保留空白*|

    ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/9b58c4ce-b7a8-4acf-8289-d95b270a6083)


4. 按一下標記為 [下一步:**** 資源 >] 的按鈕以繼續進行。
   
6. 在 [資源] 索引標籤上，選取 [+ 新增資源]****，然後核取 [啟用資料收集端點]****。 在 [選取範圍] 範本中，核取 [AZ500LAB131415]****，並按一下 [套用]****。

    ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/d4191115-11bc-43ec-9bee-e84b9b95a821)

10. 按一下標記為 [下一步:**** 收集並傳遞 >] 的按鈕以繼續進行。

    ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/8294d300-f910-4757-ad52-43c7594ac822)

11. 按一下 [+ 新增資料來源]****，然後在 [新增資料來源]**** 頁面上，變更 [資料來源類型]**** 下拉式功能表，以顯示 [效能計數器]****。 保留下列預設設定：

    |設定|值|
    |---|---|
    |**效能計數器**|**採樣速率 (秒)**|
    |CPU|60|
    |記憶體|60|
    |磁碟|60|
    |網路|60|

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/a24e44ad-1d10-4533-80e2-bae1b3f6564d)

11. 按一下標記為 [下一步:**** 目的地 >] 的按鈕以繼續進行。
  
12. 單擊 **[+ 新增目的地**]，變更 **[目的地類型** ] 下拉功能表以顯示 **Azure 監視器記錄。** 在 [訂用帳戶]**** 視窗中，確定已顯示您的 [訂用帳戶]**，然後變更 [帳戶或命名空間]**** 下拉式功能表，以反映您先前建立的 Log Analytics 工作區。

   ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/481843f5-94c4-4a8f-bf51-a10d49130bf8)

11. 按一下頁面底部的 [新增資料來源]****。
    
    ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/964091e7-bbbc-4ca8-8383-bb2871a1e7f0)

13. 按一下 [檢閱 + 建立]  。

    ![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/50dd8407-a106-4540-9e14-ae40a3c04830)

14. 按一下 [建立]****。

> 結果：您已部署 Azure 虛擬機器、Log Analytics 工作區、Azure 儲存體帳戶和資料收集規則，以使用 Azure 監視器代理程式，從虛擬機器收集事件和效能計數器。

>**注意**：請勿從此實驗室中移除資源，因為 適用於雲端的 Microsoft Defender 實驗室需要這些資源、在 VM 上啟用 Just-In-Time 存取」實驗室，以及Microsoft Sentinel 實驗室
 
