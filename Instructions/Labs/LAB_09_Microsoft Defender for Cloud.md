---
lab:
  title: 09 - 適用於雲端的 Microsoft Defender
  module: Module 03 - Manage security posture by using Microsoft Defender for Cloud
---

# 實驗室 09：適用於雲端的 Microsoft Defender
# 學生實驗室手冊

## 實驗案例

您收到要求，必須為適用於雲端的 Microsoft Defender 環境建立概念證明。 具體而言，您必須：

- 設定適用於雲端的 Microsoft Defender 以監視虛擬機器。
- 檢閱針對虛擬機器的適用於雲端的 Microsoft Defender 建議。
- 實作針對來賓設定和 Just-In-Time VM 存取的建議。 
- 檢閱如何使用安全分數來判斷改善基礎結構安全性的進度。

> 此實驗室中所有資源均使用**美國東部**區域。 請與講師驗證這是課程中要使用的區域。 

## 實驗室目標

在本實驗室中，您須完成下列練習：

- 練習 1：實作適用於雲端的 Microsoft Defender

## 適用於雲端的 Microsoft Defender 圖表

![image](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/assets/91347931/c31055cc-de95-41f6-adef-f09d756a68eb)

## 指示

### 練習 1：實作適用於雲端的 Microsoft Defender

在本練習中，您將會完成下列工作：

- 工作 1：設定適用於雲端的 Microsoft Defender
- 工作 2：檢閱適用於雲端的 Microsoft Defender 建議
- 工作 3：實作適用於雲端的 Microsoft Defender 建議以啟用 Just-In-Time VM 存取

#### 工作 1：設定適用於雲端的 Microsoft Defender

在此工作中，您必須讓適用於雲端的 Microsoft Defender 上線並加以設定。

1. 登入 Azure 入口網站：**`https://portal.azure.com/`**。

    >**注意**：登入 Azure 入口網站時使用的帳戶，必須在您用於這個實驗室的 Azure 訂用帳戶中具有「擁有者」或「參與者」角色。

2. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入****「適用於雲端的 Microsoft Defender」****，然後按下 **Enter** 鍵。

3. 在左側導覽面板中，按一下 [使用者入門]****。 在 [適用於雲端的 Microsoft Defender \| 使用者入門]**** 刀鋒視窗上，按一下 [升級]****。
     
4. 在 [適用於雲端的 Microsoft Defender \| 使用者入門]**** 刀鋒視窗上，於 [安裝代理程式] 索引標籤上，向下捲動並按一下 [安裝代理程式]****。 

5. 在 [適用於雲端的 Microsoft Defender \| 使用者入門]**** 刀鋒視窗上，於 [升級]**** 索引標籤上 >> 向下捲動直到 [選取具有增強式安全性功能的工作區]**** 區段顯示為止 >> 選取您的 Log Analytics 工作區以開啟 [Microsoft Defender 方案]****，然後按一下大型藍色升級按鈕。  

    >**注意**：請檢閱 Microsoft Defender 方案中提供的所有功能。 

6. 瀏覽至 [適用於雲端的 Microsoft Defender]****，然後在左側導覽面板的 [設定] 區段下方，按一下 [環境設定]****。

7. 在 [適用於雲端的 Microsoft Defender \| 環境設定]**** 刀鋒視窗上，向下捲動、展開直到您的訂用帳戶出現，然後按一下相關的訂用帳戶。 

8. 在 [設定 \| Defender 方案]**** 刀鋒視窗上，選取 [啟用所有方案]****，然後視需要按一下 [儲存]****。

9. 瀏覽回 [適用於雲端的 Microsoft Defender \| 環境設定]**** 刀鋒視窗，展開直到您的訂用帳戶出現，然後按一下項目，其代表您在上一個實驗室中建立的 Log Analytics 工作區。

10. 在 [設定 \| Defender 方案]**** 刀鋒視窗上，確定所有選項都是「開啟」。 需要時，按一下 [啟用所有方案]****，然後按一下 [儲存]****。

11. 從 [設定 \| Defender 方案]**** 刀鋒視窗中選取 [資料收集]****。 按一下 [所有事件]**** 和 [儲存]****。

#### 工作 2：檢閱適用於雲端的 Microsoft Defender 建議

在此工作中，您必須檢閱適用於雲端的 Microsoft Defender 建議。 

1. 在 Azure 入口網站中，巡覽回 [適用於雲端的 Microsoft Defender \| 概觀]**** 刀鋒視窗。 

2. 在 [適用於雲端的 Microsoft Defender \| 概觀]**** 刀鋒視窗中檢閱 [安全分數] 圖格。****

    >**注意**：記錄目前的分數 (如果有的話)。

3. 瀏覽回 [適用於雲端的 Microsoft Defender \| 概觀]**** 刀鋒視窗，按一下 [已評定的資源]****。

4. 在 [詳細目錄]**** 刀鋒視窗上，按一下 [myVM]**** 項目。

    >**注意**：您可能必須等候幾分鐘並重新整理瀏覽器頁面，項目才會出現。
    
5. 在 [資源健康狀態]**** 刀鋒視窗的 [建議]**** 索引標籤上，檢閱 **myVM** 的建議清單。

#### 工作 3：實作適用於雲端的 Microsoft Defender 建議以啟用 Just-In-Time VM 存取

在此工作中，您將實作適用於雲端的 Microsoft Defender 建議，以在虛擬機器上啟用 Just-In-Time VM 存取。 

1. 在 Azure 入口網站中，瀏覽回 [適用於雲端的 Microsoft Defender \| 概觀]**** 刀鋒視窗，然後在左側導覽面板中按一下 [雲端安全性]**** 下的 [工作負載保護]****。

2. 在 [適用於雲端的 Microsoft Defender \| 工作負載保護]**** 刀鋒視窗上，向下捲動至 [進階防護]**** 區段，然後按一下 [Just-In-Time VM 存取]**** 圖格。

3. 在 [Just In-Time VM 存取]**** 刀鋒視窗上，於 [虛擬機器]**** 區段下，選取 [未設定]****，然後選取 [myVM]**** 項目的核取方塊。

    >**注意**：您可能必須等候幾分鐘、重新整理瀏覽器頁面，然後重新選取 [未設定]****，項目才會出現。

4. 按一下 [虛擬機器]**** 區段最右邊的 [在 1 部 VM 上啟用 JIT]**** 選項。

5. 在 [JIT VM 存取設定]**** 刀鋒視窗上，在參考連接埠 **22** 的資料列最右邊按一下省略符號按鈕，然後按一下 [刪除]****。

6. 在 [JIT VM 存取設定] 刀鋒視窗中按一下 [儲存]。********

    >**注意**：按一下工具列中的**通知**圖示並檢視 [通知****] 刀鋒視窗，藉此監視設定進度。 

    >**注意**：此實驗室中的建議實作可能需要一些時間，才能反映在安全分數上。 請定期查看安全分數，以判斷實作這些功能帶來的影響。 

> 結果：您已讓適用於雲端的 Microsoft Defender 上線並實作虛擬機器建議。 

    >**Note**: Do not remove the resources from this lab as they are needed for the Microsoft Sentinel lab.
