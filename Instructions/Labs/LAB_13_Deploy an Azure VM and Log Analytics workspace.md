---
lab:
  title: 13 - 部署 Azure VM 和 Log Analytics 工作區
  module: Module 04 - Manage security operations
---

# 實驗室 13：部署 Azure VM 和 Log Analytics 工作區

# 學生實驗室手冊

## 實驗案例

系統要求您建立 Azure 虛擬機器器和 Log Analytics 工作區。

- 部署 Azure 虛擬機器。
- 建立 Log Analytics 工作區。

> 此實驗室中所有資源均使用**美國東部**區域。 請與講師驗證這是課程中要使用的區域。 

## 實驗室目標

在本實驗室中，您須完成下列練習：

- 練習 1：建立 Azure 虛擬機器
  
## 指示

### 練習 1：部署 Azure 虛擬機器

### 練習時間：10 分鐘

在本練習中，您將會完成下列工作： 

- 工作 1：部署 Azure 虛擬機器 

#### 工作 1：部署 Azure 虛擬機器

1. 登入 Azure 入口網站：**`https://portal.azure.com/`**。

    >**注意 ** ：使用在您要用於此實驗室的 Azure 訂用帳戶中具有擁有者或參與者角色的帳戶登入Azure 入口網站。

2. 按一下 Azure 入口網站右上方的第一個圖示，開啟 Cloud Shell。 如果出現提示，請選取 [PowerShell]**** 與 [建立儲存體]****。

3. 確認在 [Cloud Shell] 窗格左上角的下拉式功能表中，已選取 [PowerShell]****。

4. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中執行下列指令，建立您要在此實驗室中使用的資源群組：
  
    ```powershell
    New-AzResourceGroup -Name AZ500LAB131415 -Location 'EastUS'
    ```

    >**注意 ** ：此資源群組將用於實驗室 13、14 和 15。 

5. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列命令以建立新的 Azure 虛擬機器。 

    ```powershell
    New-AzVm -ResourceGroupName "AZ500LAB131415" -Name "myVM" -Location 'EastUS' -VirtualNetworkName "myVnet" -SubnetName "mySubnet" -SecurityGroupName   "myNetworkSecurityGroup" -PublicIpAddressName "myPublicIpAddress" -PublicIpSku Standard -OpenPorts 80,3389 -Size Standard_DS1_v2 
    ```
    
6.  當系統提示您輸入認證時：

    |設定|值|
    |---|---|
    |User |**localadmin**|
    |密碼|**請使用您在實驗室 04 > 練習 1 > 工作 1 > 步驟 9 建立的個人密碼。**|

    >**注意**：等待部署完成。 

7. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中執行下列命令，確認名為 **myVM** 的虛擬機器已順利建立，且 **ProvisioningState** 為 **「已成功」**。

    ```powershell
    Get-AzVM -Name 'myVM' -ResourceGroupName 'AZ500LAB131415' | Format-Table
    ```

8. 關閉 [Cloud Shell] 窗格。 

#### 工作 2：建立 Log Analytics 工作區

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

> 結果：您已部署 Azure 虛擬機器並建立 Log Analytics 工作區。

>**注意 ** ：請勿視適用於雲端的 Microsoft Defender實驗室和 Microsoft Sentinel 實驗室所需的資源移除此實驗室的資源。
 
