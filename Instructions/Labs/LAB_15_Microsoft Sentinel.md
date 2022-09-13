---
lab:
  title: 15 - Microsoft Sentinel
  module: Module 04 - Manage Security Operations
ms.openlocfilehash: 147bb0c8f6637393087c5a913f5c9bd8ca380866
ms.sourcegitcommit: 3c178de473f4f986a3a7ea1d03c9f5ce699a05a4
ms.translationtype: HT
ms.contentlocale: zh-TW
ms.lasthandoff: 09/09/2022
ms.locfileid: "147871961"
---
# <a name="lab-15-microsoft-sentinel"></a>實驗室 15：Microsoft Sentinel
# <a name="student-lab-manual"></a>學生實驗室手冊

## <a name="lab-scenario"></a>實驗案例

**注意：** **Azure Sentinel** 已重新命名為 **Microsoft Sentinel** 

您收到要求，必須建立 Microsoft Sentinel 式威脅偵測及回應的概念證明。 具體而言，您必須：

- 開始從 Azure 活動和適用於雲端的 Microsoft Defender 收集資料。
- 新增內建和自訂警示 
- 檢閱如何使用劇本將事件回應設為自動化。

> 此實驗室中所有資源均使用 **美國東部** 區域。 請與講師驗證這是課程中要使用的區域。 

## <a name="lab-objectives"></a>實驗室目標

在本實驗室中，您須完成下列練習：

- 練習 1：實作 Microsoft Sentinel

## <a name="microsoft-sentinel-diagram"></a>Microsoft Sentinel 圖表

![image](https://user-images.githubusercontent.com/91347931/157538440-4953be73-90be-4edd-bd23-b678326ba637.png)

## <a name="instructions"></a>指示

## <a name="lab-files"></a>實驗室檔案：

- **\\Allfiles\\Labs\\15\\changeincidentseverity.json**

### <a name="exercise-1-implement-microsoft-sentinel"></a>練習 1：實作 Microsoft Sentinel

### <a name="estimated-timing-30-minutes"></a>預估時間：30 分鐘

在本練習中，您將會完成下列工作：

- 工作 1：讓 Microsoft Sentinel 上線
- 工作 2：將 Azure 活動連線至 Sentinel
- 工作 3：建立使用 Azure 資料連接器的規則。 
- 工作 4：建立劇本
- 工作 5：建立自訂警示並將劇本設定為自動回應。
- 工作 6：叫用事件並檢閱相關聯的動作。

#### <a name="task-1-on-board-azure-sentinel"></a>工作 1：讓 Microsoft Sentinel 上線

在此工作中，您必須讓 Microsoft Sentinel 上線，並連線至 Log Analytics 工作區。 

1. 登入 Azure 入口網站 **`https://portal.azure.com/`** 。

    >**注意**：登入 Azure 入口網站時使用的帳戶，必須在您用於這個實驗室的 Azure 訂用帳戶中具有「擁有者」或「參與者」角色。

2. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入 **「Microsoft Sentinel」** ，然後按下 **Enter** 鍵。

    >**注意**：如果這是您首次嘗試在 Azure 儀表板中啟動 Microsoft Sentinel，請完成下列步驟：在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入 **「Microsoft Sentinel」** ，然後按下 **Enter** 鍵。 在 [服務] 檢視中選取 [Microsoft Sentinel]。
  
3. 在 [Microsoft Sentinel] 刀鋒視窗中按一下 [+ 建立]。

4. 在 [將 Microsoft Sentinel 新增到工作區] 刀鋒視窗中，選取您在 Azure 監視器實驗室裡建立的 Log Analytics 工作區，然後按一下 [新增]。

    >**注意**：Microsoft Sentinel 對工作區有非常明確的需求。 舉例來說，您無法使用適用於雲端的 Microsoft Defender 所建立的工作區。 如需詳細資訊請參閱[快速入門：使 Microsoft Sentinel 上線](https://docs.microsoft.com/en-us/azure/sentinel/quickstart-onboard)
    
#### <a name="task-2-configure-microsoft-sentinel-to-use-the-azure-activity-data-connector"></a>工作 2：將 Microsoft Sentinel 設定為使用 Azure 活動資料連接器。 

在此工作中，您必須將 Microsoft Sentinel 設定為使用 Azure 活動資料連接器。  

1. 在 Azure 入口網站的 [Microsoft Sentinel \| 概觀] 刀鋒視窗中，按一下 [設定] 區段的 [資料連接器]。 

2. 在 [Microsoft Sentinel \| 資料連接器] 刀鋒視窗中檢閱可用連接器的清單，然後在搜尋列中輸入 **「Azure」** ，選取代表 **Azure 活動** 連接器的項目 (如有需要，可使用 \<< 隱藏功能表列) 並檢閱其說明和狀態，最後再按一下 [開啟連接器頁面]。

3. [Azure 活動] 刀鋒視窗中的 [說明] 索引標籤應顯示為已選取。記下 [必要條件]，並向下捲動至 [設定]。 記下說明連接器更新的資訊。 您的 Azure Pass 訂閱帳戶絕不會使用舊版連線方法，因此您可以跳過步驟 1 ([全部中斷連線] 按鈕會呈現灰色)，直接進行步驟 2。

4. 在步驟 2 **透過診斷設定新管線連線您的訂閱帳戶** 中，檢閱「啟動 [Azure 原則指派精靈]，並遵循步驟執行」說明，然後按一下 [啟動 Azure 原則指派精靈\>]。

5. 在 [將 Azure 活動記錄設定為串流至指定 Log Analytics 工作區]([指派原則] 頁面) 的 [基本] 索引標籤上，按一下 [範圍省略符號 (...)] 按鈕。 在 [範圍] 頁面的下拉式訂閱帳戶清單中選擇您的 Azure Pass 訂閱帳戶，然後按一下頁面底部的 [選取] 按鈕。

    >**注意**：*請勿* 選擇資源群組

6. 按一下 [基本] 索引標籤底部的 [下一步] 按鈕以前往 [參數] 索引標籤。按一下 [參數] 索引標籤上的 [主要 Log Analytics 工作區省略符號 (...)] 按鈕。 在 [主要 Log Analytics 工作區] 頁面中確定已選取您的 Azure Pass 訂閱帳戶，並使用 [工作區] 下拉式清單選取您要用於 Microsoft Sentinel 的 Log Analytics 工作區。 完成後，按一下頁面底部的 [選取] 按鈕。

7. 按一下 [參數] 索引標籤底部的 [下一步] 按鈕，前往 [補救] 索引標籤。在 [補救] 索引標籤上勾選 [建立補救工作] 核取方塊。 這項操作會啟用 [要補救的原則] 下拉式清單中的 [將 Azure 活動記錄設定為串流至指定 Log Analytics 工作區]。 在 [系統指派的識別位置] 下拉式清單中，選取您先前為 Log Analytics 工作區選取的區域 (例如美國東部)。

8. 按一下 [補救] 索引標籤底部的 [下一步] 按鈕，前往 [不符合規範的訊息] 索引標籤。如有需要，您可以輸入一則不符合規範的訊息 (選擇性)，然後在 [不符合規範的訊息] 索引標籤底部按一下 [檢閱 + 建立] 按鈕。

9. 按一下 [ **建立** ] 按鈕。 您應該會看到三則表示已成功的狀態訊息：**建立原則指派成功、角色指派建立成功、補救工作建立成功**。

    >**注意**：您可以查看 [通知] (鈴鐺圖示) 以確認這三件工作是否成功。

10. 確認 [Azure 活動] 窗格中顯示出 [收到的資料] 圖表 (可能需要重新整理瀏覽器頁面)。  

    >**注意**：顯示「已連線」狀態和 [收到的資料] 圖表可能需要超過 15 分鐘。

#### <a name="task-3-create-a-rule-that-uses-the-azure-activity-data-connector"></a>工作 3：建立使用 Azure 資料連接器的規則。 

在此工作中，您必須檢閱並建立使用 Azure 活動資料連接器的規則。 

1. 在 [Microsoft Sentinel \| 設定] 刀鋒視窗中，按一下 [分析]。 

2. 在 [Microsoft Sentinel \| 分析] 刀鋒視窗中，按一下 [規則範本] 索引標籤。 

    >**注意**：檢閱您可以建立的規則類型。 每種規則都與特定的資料來源相關聯。

3. 在規則範本清單的搜尋列表單中輸入 **「可疑」** ，然後按一下與 **Azure 活動** 資料來源相關聯的 [可疑資源建立或部署數目] 項目。 接下來，在顯示規則範本屬性的窗格中按一下 [建立規則](視需要捲動到頁面右側)。

    >**注意**：此規則為中嚴重性。 

4. 在 [分析規則精靈 - 從範本建立新規則] 刀鋒視窗的 [一般] 索引標籤上接受預設設定，然後按一下 [下一步：設定規則邏輯 >]。

5. 在 [分析規則精靈 - 從範本建立新規則] 刀鋒視窗的 [設定規則邏輯] 索引標籤上接受預設設定，然後按一下 [下一步：事件設定 (預覽) >]。

6. 在 [分析規則精靈 - 從範本建立新規則] 刀鋒視窗的 [事件設定] 索引標籤上接受預設設定，然後按一下 [下一步：自動回應 >]。 

    >**注意**：您可以在此將實作為邏輯應用程式的劇本新增至規則，以便將問題的補救自動化。

7. 在 [分析規則精靈 - 從範本建立新規則] 刀鋒視窗的 [自動化回應] 索引標籤上接受預設設定，然後按一下 [下一步：檢閱 >]。 

8. 在 [分析規則精靈 - 從範本建立新規則] 刀鋒視窗的 [審核及建立] 索引標籤上按一下 [建立]。

    >**注意**：您現在有使用中的規則了。

#### <a name="task-4-create-a-playbook"></a>工作 4：建立劇本

在此工作中，您必須建立劇本。 安全性劇本是在回應警示時可從 Microsoft Sentinel 叫用的工作集合。 

1. 在 Azure 入口網站分頁頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入 **「部署自訂範本」** ，然後按下 **Enter** 鍵。

2. 在 [自訂部署] 刀鋒視窗中按一下 [在編輯器中組建您自己的範本] 選項。

3. 在 [編輯範本] 刀鋒視窗中按一下 [載入檔案]，找出 **\\Allfiles\\Labs\\15\\changeincidentseverity.json** 檔案，然後按一下 [開啟]。

    >**注意**：您可以在 [https://github.com/Azure/Azure-Sentinel/tree/master/Playbooks](https://github.com/Azure/Azure-Sentinel/tree/master/Playbooks) 找到劇本範例。

4. 在 [編輯範本] 刀鋒視窗中按一下 [儲存]。

5. 在 [自訂部署] 刀鋒視窗中，確認已指定下列設定 (其他設定請保留預設值)：

    |設定|值|
    |---|---|
    |訂用帳戶|您要在此實驗室中使用的 Azure 訂用帳戶名稱|
    |資源群組|**AZ500LAB131415**|
    |Location|**(美國) 美國東部**|
    |劇本名稱|**變更事件嚴重性**|
    |使用者名稱|您的電子郵件地址|

6. 按一下 [檢閱 + 建立]  ，然後按一下 [建立]  。

    >**注意**：等待部署完成。

7. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入「資源群組」，然後按下 **Enter** 鍵。

8. 在 [資源群組] 刀鋒視窗的資源群組清單中，按一下 [AZ500LAB131415] 項目。

9. 在 [AZ500LAB131415] 資源群組刀鋒視窗的資源清單中，按一下代表新建 [變更事件嚴重性] 邏輯應用程式的項目。

10. 在 [變更事件嚴重性] 刀鋒視窗中按一下 [編輯]。

    >**注意**：在 [Logic Apps 設計工具] 刀鋒視窗中，四個連線各自都會顯示警告。 這表示每個連線都需要檢閱和進行設定。

11. 在 [Logic Apps 設計工具] 刀鋒視窗中，點選第一個 **連線** 步驟。

12. 按一下 [新增]，確定 [租用戶] 下拉式清單中的項目包含您的 Azure AD 租用戶名稱，然後按一下 [登入]。

13. 出現提示時，請以使用者帳戶登入，其中您用於這個實驗室的 Azure 訂用帳戶中必須具有「擁有者」或「參與者」角色。

14. 點選第二個 **連線** 步驟，在連線清單中選取第二個項目；此項目代表您在前一個步驟中建立的連線。

15. 對其餘兩個 **連線** 步驟重複執行上述步驟。

    >**注意**：請確定執行上述步驟時均未顯示任何警告。

16. 在 [Logic Apps 設計工具] 刀鋒視窗中，按一下 [儲存] 以儲存變更。

#### <a name="task-5-create-a-custom-alert-and-configure-a-playbook-as-an-automated-response"></a>工作 5：建立自訂警示並將劇本設定為自動回應

1. 在 Azure 入口網站中返回 [Microsoft Sentinel \| 概觀] 刀鋒視窗。

2. 在 [Microsoft Sentinel \| 概觀] 刀鋒視窗的 [設定] 區段中按一下 [分析]。

3. 在 [Microsoft Sentinel \| 分析] 刀鋒視窗中按一下 [+ 建立]，然後在下拉式功能表中按一下 [已排程查詢規則]。 

4. 在 [分析規則精靈 - 建立新規則] 刀鋒視窗的 [一般] 索引標籤上，指定下列設定 (其他設定請保留預設值)：

    |設定|值|
    |---|---|
    |名稱|**劇本示範**|
    |戰略|**初始存取**|

5. 按一下 [下一步：設定規則邏輯 >]。

6. 在 [分析規則精靈 - 建立新規則] 刀鋒視窗的 [設定規則邏輯] 索引標籤上，於 [規則查詢] 文字方塊中貼上下列規則查詢。 

    ```
    AzureActivity
     | where ResourceProviderValue =~ "Microsoft.Security" 
     | where OperationNameValue =~ "Microsoft.Security/locations/jitNetworkAccessPolicies/delete" 
    ```

    >**注意**：此規則會識別移除 Just In-Time VM 存取原則。

    >**請注意**，如果您收到剖析錯誤，表示 Intellisense 可能已將值新增至您的查詢。 請確認查詢相符，否則請將查詢貼到記事本，然後再從記事本貼到規則查詢。 


7. 在 [分析規則精靈 - 建立新規則] 刀鋒視窗的 [設定規則邏輯] 索引標籤上，於 [查詢排程] 區段中將 [查詢執行間隔] 設為 [每 5 分鐘]。

8. 在 [分析規則精靈 - 建立新規則] 刀鋒視窗的 [設定規則邏輯] 索引標籤上接受剩餘設定的預設值，然後按一下 [下一步：事件設定 >]。

9. 在 [分析規則精靈 - 建立新規則] 刀鋒視窗的 [事件設定] 索引標籤上接受預設設定，然後按一下 [下一步：自動回應 >]。 

10. 在 [分析規則精靈 - 建立新規則] 刀鋒視窗的 [自動化回應] 索引標籤上，在 [警示自動化 (傳統)] 下拉式清單中選取 [變更事件嚴重性] 項目旁的核取方塊，然後按一下 [下一步: 檢閱 >]。 

11. 在 [分析規則精靈 - 建立新規則] 刀鋒視窗的 [審核及建立] 索引標籤上按一下 [建立]。

    >**注意**：您現在有稱為 **劇本示範** 的新使用中規則。 如果發生了規則邏輯所識別的事件，則會產生中嚴重性的警示，並產生相應的事件。

#### <a name="task-6-invoke-an-incident-and-review-the-associated-actions"></a>工作 6：叫用事件並檢閱相關聯的動作。

1. 在 Azure 入口網站中，瀏覽至 [適用於雲端的 Microsoft Defender \| 概觀] 刀鋒視窗。

    >**注意**：請檢查您的安全分數。 現在應該已更新完畢。 

2. 在 [適用於雲端的 Microsoft Defender \| 工作負載保護] 刀鋒視窗上，按一下 [進階保護] 底下的 [Just-In-Time VM 存取] 區段。

3. 在 [適用於雲端的 Microsoft Defender \| Just In-Time VM 存取] 刀鋒視窗上，在參考 **myVM** 虛擬機器的資料列右側按一下 [省略符號] 按鈕，按一下 [移除]，然後按一下 [是]。

    >**注意：** 如果 VM 未列在 [Just-In-Time VM] 中，請流覽至 [虛擬機器] 刀鋒視窗，然後按一下 [設定]，接著按一下 [存取 Just-In-Time VM] 下的 [啟用 Just-In-Time VM] 選項。 重複執行上述步驟以返回 **適用於雲端的 Microsoft Defender**，然後重新整理頁面，VM 便會出現。

4. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入 **「活動記錄」** ，然後按下 **Enter** 鍵。

5. 瀏覽至 [活動記錄] 刀鋒視窗，然後記下一個 [刪除 JIT 網路存取原則] 項目。 

    >**注意**：可能需要一分鐘才會顯示。 

6. 在 Azure 入口網站中返回 [Microsoft Sentinel \| 概觀] 刀鋒視窗。

7. 在 [Microsoft Sentinel \| 概觀] 刀鋒視窗上檢閱儀表板，並確認其顯示對應於刪除 Just In-Time VM 存取原則的警示。

    >**注意**：警示最多可能需要 5 分鐘才會出現在 [Microsoft Sentinel \| 概觀] 刀鋒視窗上。 如果您沒有在該時間點看到警示，請執行上一個工作中參考的查詢規則，以確認 Just In Time 存取原則刪除活動已傳播到與您 Microsoft Sentinel 執行個體相關聯的 Log Analytics 工作區。 如果沒有的話，請重新建立 Just-In-Time VM 存取原則，然後再次刪除。

8. 在 [Microsoft Sentinel \| 概觀] 刀鋒視窗的 [威脅管理] 區段中按一下 [事件]。

9. 確認刀鋒視窗中有顯示中或高嚴重性等級的事件。

    >**注意**：事件最多可能需要 5 分鐘才會出現在 [Microsoft Sentinel \| 事件] 刀鋒視窗上。 

    >**注意**：檢閱 [Microsoft Sentinel \| 劇本] 刀鋒視窗。 您會在該處找到執行成功和執行失敗的計數。

    >**注意**：您可以選擇為事件指派不同的嚴重性等級和狀態。

> 結果：您已建立 Microsoft Sentinel 工作區、將其連線至 Azure 活動記錄、建立劇本和由移除 Just-In-Time VM 存取原則觸發的自訂警示，並確認設定有效。

**清除資源**

> 請記得移除您不再使用的任何新建 Azure 資源。 移除未使用的資源可避免產生非預期的費用。 

1. 在 Azure 入口網站中按一下右上方的第一個圖示，開啟 Cloud Shell。 如果出現提示，請按一下 [PowerShell] 與 [建立儲存體]。

2. 確定在 [Cloud Shell] 窗格左上角的下拉式功能表中，已選取 [PowerShell]。

3. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列指令，移除您在此實驗室中建立的資源群組：
  
    ```powershell
    Remove-AzResourceGroup -Name "AZ500LAB131415" -Force -AsJob
    ```
4. 關閉 [Cloud Shell] 窗格。
