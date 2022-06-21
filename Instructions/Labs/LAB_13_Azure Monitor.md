---
lab:
  title: 13 - Azure 監視器
  module: Module 04 - Manage security operations
ms.openlocfilehash: df6fbcf475fe0a5cefec130ab713f92997dcf206
ms.sourcegitcommit: 022221e69467f2fdccf2e02bb54e6ec395570668
ms.translationtype: HT
ms.contentlocale: zh-TW
ms.lasthandoff: 04/21/2022
ms.locfileid: "145195840"
---
# <a name="lab-13-azure-monitor"></a>實驗室 13：Azure 監視器
# <a name="student-lab-manual"></a>學生實驗室手冊

## <a name="lab-scenario"></a>實驗案例

您收到要求，必須建立監視虛擬機器效能的概念證明。 具體而言，您必須：

- 設定能夠收集遙測資料和記錄的虛擬機器。
- 顯示可收集哪些遙測資料和記錄。
- 示範資料的使用和查詢方法。 

> 此實驗室中所有資源均使用 **美國東部** 區域。 請與講師確認這是課程中要使用的區域。 

## <a name="lab-objectives"></a>實驗室目標

在本實驗室中，您須完成下列練習：

- 練習 1：使用 Azure 監視器從 Azure 虛擬機器收集資料

## <a name="azure-monitor"></a>Azure 監視器

![image](https://user-images.githubusercontent.com/91347931/157536648-0a286514-a7e2-4058-9dea-e42da21eef76.png)

## <a name="instructions"></a>指示

### <a name="exercise-1-collect-data-from-an-azure-virtual-machine-with-azure-monitor"></a>練習 1：使用 Azure 監視器從 Azure 虛擬機器收集資料

### <a name="exercise-timing-20-minutes"></a>練習時間：20 分鐘

在本練習中，您將會完成下列工作： 

- 工作 1：部署 Azure 虛擬機器 
- 工作 2：建立 Log Analytics 工作區
- 工作 3：啟用 Log Analytics 虛擬機器擴充功能
- 工作 4：收集虛擬機器事件和效能資料
- 工作 5：檢視和查詢收集的資料 

#### <a name="task-1-deploy-an-azure-virtual-machine"></a>工作 1：部署 Azure 虛擬機器

1. 登入 Azure 入口網站： **`https://portal.azure.com/`** 。

    >**注意**：登入 Azure 入口網站時使用的帳戶，必須在您用於這個實驗室的 Azure 訂閱中具有「擁有者」或「參與者」角色。

2. 按一下 Azure 入口網站右上方的第一個圖示，開啟 Cloud Shell。 如果出現提示，請選取 [PowerShell] 與 [建立儲存體]。

3. 確定在 [Cloud Shell] 窗格左上角的下拉式功能表中，已選取 [PowerShell]。

4. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中執行下列指令，建立您要在此實驗室中使用的資源群組：
  
    ```powershell
    New-AzResourceGroup -Name AZ500LAB131415 -Location 'EastUS'
    ```

    >**注意**：實驗室 13、14 和 15 都會使用此資源群組。 

5. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列命令以建立新的 Azure 虛擬機器。 

    >**注意**：New-AzVm 命令無法在 Azure CLI 4.24 版中運作，Microsoft 目前正在調查解決方案。  此實驗室的因應措施是安裝並還原至 Az.Compute 4.23.0 版，因此不會受到這個問題影響。
   
    >**說明**：還原至 Az.Compute 4.23.0 版 
  
   #### <a name="step-1-download-the-working-version-of-the-module-4230-into-your-cloud-shell-session"></a>步驟 1：將此模組的可運作版本 (4.23.0) 下載到您的 Cloud Shell 工作階段 
   **類型**：Install-Module -Name Az.Compute -Force -RequiredVersion 4.23.0

   #### <a name="step-2-start-a-new-powershell-session-that-will-allow-the-azcompute-assembly-version-to-be-loaded"></a>步驟 2：啟動允許載入 Az.Compute 組件版本的新 PowerShell 工作階段 
   **類型**：pwsh

   #### <a name="step-3-verify-that-version-4230-is-loaded"></a>步驟 3：確認已載入 4.23.0 版
   **類型**：Get-Module -Name Az.Compute
   
    ```powershell
    New-AzVm -ResourceGroupName "AZ500LAB131415" -Name "myVM" -Location 'EastUS' -VirtualNetworkName "myVnet" -SubnetName "mySubnet" -SecurityGroupName   "myNetworkSecurityGroup" -PublicIpAddressName "myPublicIpAddress" -OpenPorts 80,3389
    ```

6.  出現憑據提示時：

    |設定|值|
    |---|---|
    |User |**localadmin**|
    |密碼|**請使用您在實驗室 04 > 練習 1 > 工作 1 > 步驟 9 中建立的個人密碼。**|

    >**注意**：等待部署完成。 

7. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中執行下列命令，確認名為 **myVM** 的虛擬機器已順利建立，且 **ProvisioningState** 為 **「已成功」** 。

    ```powershell
    Get-AzVM -Name 'myVM' -ResourceGroupName 'AZ500LAB131415' | Format-Table
    ```

8. 關閉 [Cloud Shell] 窗格。 

#### <a name="task-2-create-a-log-analytics-workspace"></a>工作 2：建立 Log Analytics 工作區

在此工作中，您必須建立 Log Analytics 工作區。 

1. 在 Azure 入口網站分頁頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入 **「Log Analytics 工作區」** ，然後按下 **Enter** 鍵。

2. 在 [Log Analytics 工作區] 刀鋒視窗上，按一下 [+ 建立]。

3. 在 [建立 Log Analytics 工作區] 刀鋒視窗的 [基本] 索引標籤上，指定下列設定 (其他設定請保留預設值)：

    |設定|值|
    |---|---|
    |訂用帳戶|您在此實驗中使用的 Azure 訂閱名稱|
    |資源群組|**AZ500LAB131415**|
    |名稱|任何有效的全域唯一名稱|
    |區域|**(美國) 美國東部**|

4. 選取 [檢閱 + 建立]。

5. 在 [建立 Log Analytics 工作區] 刀鋒視窗的 [檢閱 + 建立] 索引標籤上，選取 [建立]。

#### <a name="task-3-enable-the-log-analytics-virtual-machine-extension"></a>工作 3：啟用 Log Analytics 虛擬機器擴充功能

在此工作中，您必須啟用 Log Analytics 虛擬機器擴充功能。 此擴充功能會在 Windows 和 Linux 虛擬機器上安裝 Log Analytics 代理程式。 這個代理程式會從虛擬機器收集資料，並傳輸至您指定的 Log Analytics 工作區。 代理程式安裝完畢後會自動升級，確保隨時具備最新功能和修正程式。 

1. 在 Azure 入口網站中返回 [Log Analytics 工作區] 刀鋒視窗，在工作區清單中按一下代表您在上一個工作中所建立工作區的項目。

2. 在 [Log Analytics 工作區] 刀鋒視窗的 [概觀] 分頁上，按一下 [連線到資料來源] 區段中的 [Azure 虛擬機器 (VM)] 項目。

    >**注意**：虛擬機器必須處於執行中狀態，才能成功安裝代理程式。

3. 在虛擬機器清單中，找出代表您在本練習第一項工作中部署的 Azure VM [myVM] 的項目。請注意，該項目會顯示為 [未連線]。

4. 按一下 [myVM] 項目，然後在 [myVM] 刀鋒視窗中點選 [連線]。 

5. 等待虛擬機器連線至 Log Analytics 工作區。

    >**注意**：這可能需要幾分鐘的時間。 [myVM] 刀鋒視窗中顯示的 [狀態] 會從 [正在連線] 變更為 [此工作區]。 

#### <a name="task-4-collect-virtual-machine-event-and-performance-data"></a>工作 4：收集虛擬機器事件和效能資料

在此工作中，您必須設定 Windows 系統記錄檔集合和數個常見的效能計數器。 此外，您還須檢閱其他可用的來源。

1. 在 Azure 入口網站中，返回您先前在本練習建立的 Log Analytics 工作區。

2. 在 [Log Analytics 工作區] 刀鋒視窗的 [設定] 區段中，按一下 [代理程式設定]。

3. 在 [代理程式設定] 刀鋒視窗中檢閱可指定的設定，包括 Windows 事件記錄檔、Windows 效能計數器、Linux 效能計數器、IIS 記錄檔和 Syslog。 

4. 確定已選取 [Windows事件記錄檔]，接著按一下 [+ 新增 Windows 事件記錄檔]，然後在事件記錄檔型別清單中選取 [系統]。

    >**注意**：這是將事件記錄檔新增至工作區的方式。 其他選項包括 [硬體事件] 或 [金鑰管理服務]。  

5. 取消勾選 [資訊] 核取方塊，並選取 [錯誤] 和 [警告] 核取方塊。

6. 依序點選 [Windows 效能計數器] 與 [+ 新增效能計數器]，檢閱可用效能計數器的清單，然後新增下列效能計數器：

    - 記憶體 (\*)\可用記憶體 MB
    - 處理序 (\*)\%處理器時間
    - Windows 事件追蹤\總記憶體使用量 --- 非分頁集區
    - Windows 事件追蹤\總記憶體使用量 --- 分頁集區

    >**注意**：計數器會在 60 秒的集合取樣間隔內新增並進行設定。
  
7. 在 [代理程式設定] 刀鋒視窗中按一下 [套用]。

#### <a name="task-5-view-and-query-collected-data"></a>工作 5：檢視和查詢收集的資料

在此工作中，您必須在收集的資料上執行記錄搜尋。 

1. 在 Azure 入口網站中，返回您先前在本練習建立的 Log Analytics 工作區。

2. 在 [Log Analytics 工作區] 刀鋒視窗的 [一般] 區段按一下 [記錄]。

3. 如有需要，請關閉 [歡迎使用 Log Analysis] 視窗。 

4. 在 [查詢] 窗格的 [所有查詢] 資料行中，向下捲動至資源類型清單底部，然後按一下 [虛擬機器]
    
5. 檢閱預先定義查詢的清單，選取 [記憶體和 CPU 使用量]，然後按一下對應的 [執行] 按鈕。

    >**注意**：您可以從查詢 **虛擬機器的可用記憶體** 開始。 如果沒有查詢到任何結果，請確認範圍已設定為 [虛擬機器]

6. 查詢會自動在新的查詢索引標籤中開啟。 

    >**注意**：Log Analytics 使用的是 Kusto 查詢語言。 您可以自訂現有查詢，也可以建立自己專屬的查詢。 

    >**注意**：您選取的查詢結果會自動顯示在 [查詢] 窗格下方。 若要重新執行查詢，請按一下 [執行]。

    >**注意**：由於此虛擬機器才剛建立，因此可能還沒有任何資料。 

    >**注意**：您可以選擇以不同格式顯示資料， 也可以選擇根據查詢結果建立警示規則。

    >**注意**：您可以按照下列步驟，在先前於此實驗室中部署的 Azure VM 上產生一些其他負載：

    1. 前往 [Azure VM] 刀鋒視窗。
    2. 在 [Azure VM] 刀鋒視窗的 [作業] 區段選取 [執行命令]，然後在 [RunPowerShellScript] 刀鋒視窗中輸入以下指令碼，再按一下 [執行]：
    3. 
       ```cmd
       cmd
       :loop
       dir c:\ /s > SWAP
       goto loop
       ```
       
    4. 切換回 [Log Analytics] 刀鋒視窗，然後重新執行查詢。 您可能需要稍候片刻才能收集資料並重新執行查詢。

> 結果：您已使用 Log Analytics 工作區設定資料來源並查詢記錄。 

**清除資源**

>**注意**：請勿移除此實驗室中的資源，因為 Azure 資訊安全中心實驗室和 Microsoft Sentinel 實驗室都需要使用這些資源。
 
