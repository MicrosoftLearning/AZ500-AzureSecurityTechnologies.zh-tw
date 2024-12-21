---
lab:
  title: 09 - 適用於雲端的 Microsoft Defender
  module: Module 03 - Manage security posture by using Microsoft Defender for Cloud
---

# 實驗室 09：適用於雲端的 Microsoft Defender
# 學生實驗室手冊

## 實驗案例

您收到要求，必須為適用於雲端的 Microsoft Defender 環境建立概念證明。 具體而言，您必須：

- 為伺服器設定 適用於雲端的 Microsoft Defender 增強的安全性功能，以監視虛擬機。
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

#### 工作 1：設定伺服器 適用於雲端的 Microsoft Defender 增強式安全性功能

在這項工作中，您將上線並設定 適用於雲端的 Microsoft Defender 伺服器的增強式安全性功能。

1. 啟動瀏覽器會話並登入  [Azure 訂用帳戶。](https://azure.microsoft.com/en-us/free/?azure-portal=true) 您有系統管理存取權。

2. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入「適用於雲端的 Microsoft Defender」，然後按下 Enter 鍵。

3. 在 [適用於雲端的 Microsoft Defender] 的 [管理] 刀鋒視窗上，移至 [環境設定]。 展開 [環境設定] 資料夾，直到顯示訂用帳戶區段為止，然後按兩下訂用帳戶以檢視詳細數據。

4. 在 [設定] 刀鋒視窗的 [Defender 方案] 底下，展開 [雲端工作負載保護] （CWP）。
  
5. 從 [雲端工作負載保護][CWP] 方案清單中，選取 [伺服器]。 在頁面右側，將 [狀態] 從 [關閉] 變更為 [開啟]，然後按兩下 [儲存]。
  
6. 若要檢閱適用於伺服器方案 2 Microsoft Defender 的詳細數據，請選取 [變更方案] >。

>**注意**：啟用雲端工作負載保護 （CWP） 伺服器計劃從關閉到開啟，可啟用適用於伺服器方案的 Microsoft Defender 方案 2。

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
