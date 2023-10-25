---
lab:
  title: 14 - 適用於雲端的 Microsoft Defender
  module: Module 04 - Microsoft Defender for Cloud
---

# 實驗室 14：適用於雲端的 Microsoft Defender
# 學生實驗手冊

## 實驗案例

您收到要求，必須為適用於雲端的 Microsoft Defender 環境建立概念證明。 具體而言，您必須：

- 設定適用於雲端的 Microsoft Defender 以監視虛擬機器。
- 檢閱針對虛擬機器的適用於雲端的 Microsoft Defender 建議。
- 實作客體設定和 Just-In-Time VM 存取的建議。 
- 檢閱如何使用安全分數判斷更安全的基礎結構的建立進度。

> 此實驗室中所有資源使用的都是**美國東部**區域。 請與講師確認這是課程中要使用的區域。 

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
- 工作 3：實作雲端建議的Microsoft Defender，以啟用 Just-In-Time VM 存取

#### 工作 1：設定適用於雲端的 Microsoft Defender

在此工作中，您必須讓適用於雲端的 Microsoft Defender 上線並加以設定。

1. 登入 Azure 入口網站： **`https://portal.azure.com/`** 。

    >**注意**：登入 Azure 入口網站時使用的帳戶，必須在您用於這個實驗室的 Azure 訂用帳戶中具有「擁有者」或「參與者」角色。

2. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入「適用於雲端的 Microsoft Defender」，然後按下 **Enter** 鍵。

3. 在左側導覽面板中，按一下 **[開始使用**]。 在 **[雲端 \| 使用者入門] 刀鋒視窗的 [Microsoft Defender**] 上，按一下 [**升級**]。
     
4. 在 **[雲端 \| 使用者入門] 刀鋒視窗的 [Microsoft Defender**] 上，于 [安裝代理程式] 索引標籤中向下捲動，然後按一下 [**安裝代理程式**]。 

5. 在 **[雲端 \| 使用者入門] 刀鋒視窗的 [Microsoft Defender**] 上，于 [**升級**] 索引標籤上 >> 向下捲動，直到 [**選取具有增強安全性功能的工作區**] 區段， >> 選取 Log Analytics 工作區來開啟**Microsoft Defender方案**，然後按一下大型藍色升級按鈕。  

    >**注意**：請檢閱 Microsoft Defender 方案中提供的所有功能。 

6. 流覽至 **[雲端Microsoft Defender**]，然後在 [管理] 區段下的左側流覽面板中，按一下 [**環境設定**]。

7. 在 [雲端環境設定] 刀鋒視窗的 [Microsoft Defender] 上，向下捲動，展開直到您的訂**用 \| **帳戶出現為止，然後按一下相關的訂用帳戶。 

8. 在 [ **設定 \| Defender 方案]** 刀鋒視窗中，選取 [ **啟用所有方案** ]，並視需要按一下 [ **儲存**]。

9. 流覽回到 **[雲端 \| 環境設定] 刀鋒視窗的 [Microsoft Defender**]，展開直到您的訂用帳戶出現為止，然後按一下代表您在上一個實驗室中建立之 Log Analytics 工作區的專案。

10. 在 [ **設定 \| Defender 方案]** 刀鋒視窗上，確定所有選項都是 「開啟」。 如有需要，請按一下 **[啟用所有方案** ]，然後按一下 [ **儲存**]。

11. 從 [**設定 \| Defender 方案**] 刀鋒視窗中選取 **[資料收集**]。 按一下 **[所有事件** ] 並 **[儲存**]。

#### 工作 2：檢閱適用於雲端的 Microsoft Defender 建議

在此工作中，您必須檢閱適用於雲端的 Microsoft Defender 建議。 

1. 在 Azure 入口網站中，巡覽回 [適用於雲端的 Microsoft Defender \| 概觀] 刀鋒視窗。 

2. 在 [適用於雲端的 Microsoft Defender \| 概觀] 刀鋒視窗中檢閱 [安全分數] 圖格。

    >**注意**：記錄目前的分數 (如果有的話)。

3. 流覽回 **[雲端概 \| 觀] 刀鋒視窗的 [Microsoft Defender**]，按一下 **[評估的資源**]。

4. 在 [ **清查]** 刀鋒視窗上，按一下 **myVM** 專案。

    >**注意**：您可能必須等候幾分鐘並重新整理瀏覽器頁面，項目才會出現。
    
5. 在 [資源健康狀態] 刀鋒視窗的 [建議] 索引標籤上，檢閱 **myVM** 的建議清單。

#### 工作 3：實作雲端建議的Microsoft Defender，以啟用 Just-In-Time VM 存取

在這項工作中，您將實作雲端建議的Microsoft Defender，以在虛擬機器上啟用 Just-In-Time VM 存取。 

1. 在Azure 入口網站中，流覽回 [**雲端 \| 概觀**] 刀鋒視窗的 [Microsoft Defender]，然後按一下左側流覽面板中 [**雲端安全性**] 底下的 [**工作負載保護**]。

2. 在 **[雲端 \| 工作負載保護的Microsoft Defender**] 刀鋒視窗上，向下捲動至 [**進階保護**] 區段，然後按一下 [**Just-In-Time VM 存取**] 圖格。

3. 在 [ **Just-In-Time VM 存取]** 刀鋒視窗的 [ **虛擬機器** ] 區段下，選取 [ **未** 設定]，然後選取 **myVM** 專案的核取方塊。

    >**注意**：您可能必須等候幾分鐘，重新整理瀏覽器頁面，然後再次選取 [ **未設定** ]，讓專案出現。

4. 按一下 [虛擬機器] 區段最右邊的 [在 1 部 VM 上啟用 JIT] 選項。

5. 在 [JIT VM 存取設定] 刀鋒視窗上，在參考連接埠 **22** 的資料列最右邊按一下省略符號按鈕，然後按一下 [刪除]。

6. 在 [JIT VM 存取設定] 刀鋒視窗中按一下 [儲存]。

    >**注意**：按一下工具列中的 [通知] 圖示並檢視 [通知] 刀鋒視窗，藉此監視設定進度。 

    >**注意**：此實驗室中的建議實作可能需要一些時間，才能反映在安全分數上。 定期檢查安全分數以判斷實作這些功能的影響。 

> 結果：您已讓適用於雲端的 Microsoft Defender 上線並實作虛擬機器建議。 

    >**Note**: Do not remove the resources from this lab as they are needed for the Microsoft Sentinel lab.
