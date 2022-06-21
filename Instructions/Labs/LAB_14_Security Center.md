---
lab:
  title: 14 - 適用於雲端的 Microsoft Defender
  module: Module 04 - Microsoft Defender for Cloud
ms.openlocfilehash: 6ec274b75692321577c8966e07349211209eaa02
ms.sourcegitcommit: a8470295248a6363987bd5ea47154fe39f8535c3
ms.translationtype: HT
ms.contentlocale: zh-TW
ms.lasthandoff: 03/09/2022
ms.locfileid: "145195867"
---
# <a name="lab-14-microsoft-defender-for-cloud"></a>實驗室 14：適用於雲端的 Microsoft Defender
# <a name="student-lab-manual"></a>學生實驗室手冊

## <a name="lab-scenario"></a>實驗案例

您收到要求，必須為適用於雲端的 Microsoft Defender 環境建立概念證明。 具體而言，您必須：

- 設定適用於雲端的 Microsoft Defender 以監視虛擬機器。
- 檢閱針對虛擬機器的適用於雲端的 Microsoft Defender 建議。
- 實作來賓設定和 Just-In-Time VM 存取的建議。 
- 檢閱如何使用安全分數來判斷改善基礎結構安全性的進度。

> 此實驗室中所有資源使用的都是 **美國東部** 區域。 請與講師確認這是課程中要使用的區域。 

## <a name="lab-objectives"></a>實驗室目標

在本實驗室中，您須完成下列練習：

- 練習 1：實作適用於雲端的 Microsoft Defender

## <a name="microsoft-defender-for-cloud-diagram"></a>適用於雲端的 Microsoft Defender 圖表

![image](https://user-images.githubusercontent.com/91347931/157537800-94a64b6e-026c-41b2-970e-f8554ce1e0ab.png)

## <a name="instructions"></a>指示

### <a name="exercise-1-implement-microsoft-defender-for-cloud"></a>練習 1：實作適用於雲端的 Microsoft Defender

在本練習中，您將會完成下列工作：

- 工作 1：設定適用於雲端的 Microsoft Defender
- 工作 2：檢閱適用於雲端的 Microsoft Defender 建議
- 工作 3：實作適用於雲端的 Microsoft Defender 建議以啟用 Just-In-Time VM 存取

#### <a name="task-1-configure-microsoft-defender-for-cloud"></a>工作 1：設定適用於雲端的 Microsoft Defender

在此工作中，您必須讓適用於雲端的 Microsoft Defender 上線並加以設定。

1. 登入 Azure 入口網站： **`https://portal.azure.com/`** 。

    >**注意**：登入 Azure 入口網站時使用的帳戶，必須在您用於這個實驗室的 Azure 訂用帳戶中具有「擁有者」或「參與者」角色。

2. 在 Azure 入口網站頁面頂端的 [搜尋資源、服務及文件] 文字輸入框中輸入「適用於雲端的 Microsoft Defender」，然後按下 **Enter** 鍵。

3. 如果先前尚未完成，請在 [適用於雲端的 Microsoft Defender \| 使用者入門] 刀鋒視窗中按一下 [升級]。
     
4. 如果先前尚未完成，請在 [適用於雲端的 Microsoft Defender \| 使用者入門] 刀鋒視窗的 [安裝代理程式] 索引標籤上向下捲動，然後按一下 [安裝代理程式]。 

5. [適用於雲端的 Microsoft Defender \| 使用者入門] 刀鋒視窗的 [升級] 索引標籤 >> [選取具有增強式安全性功能的工作區] 區段 >> 選取您的 Log Analytics 工作區以開啟   **Microsoft Defender 方案**。 

    >**注意**：請檢閱 Microsoft Defender 方案中提供的所有功能。 

6. 在 [Defender 方案] 刀鋒視窗中選取 [啟用所有適用於雲端的 Microsoft Defender 方案]，然後按一下 [儲存]。

7. 巡覽至 **適用於雲端的 Microsoft Defender**，然後按一下左側垂直功能表列中 [管理設定] 下方的 [環境設定]。

8. 在 [適用於雲端的 Microsoft Defender | 環境設定] 刀鋒視窗中，按一下相關的訂用帳戶。 

9. 在 [設定 | Defender 方案] 刀鋒視窗左側的垂直功能表中，按一下 [自動佈建]。

10. 在 [設定 | 自動佈建] 刀鋒視窗中，確認第一個項目 [適用於 Azure VM 的 Log Analytics 代理程式] 的 [自動佈建] 已設定為 [開啟]。

11. 在 [設定 \| 工作流程自動化] 刀鋒視窗中，按一下 [+ 新增工作流程自動化]。

12. 在 [新增工作流程自動化] 刀鋒視窗中檢閱可用的設定。 

    >**注意**：您可以觸發動作型威脅偵測警示和適用於雲端的 Microsoft Defender 建議。 此外，您也可以根據邏輯應用程式設定動作。 

13. 在 [新增工作流程自動化] 刀鋒視窗中按一下 [取消]。

    >**注意**：適用於雲端的 Microsoft Defender 提供虛擬機器的許多深入解析，包括系統更新狀態、OS 安全性設定和端點保護。

14. 巡覽回 [適用於雲端的 Microsoft Defender \| 環境設定] 刀鋒視窗，展開您的訂用帳戶，然後按一下您在上一個實驗室中建立的 Log Analytics 工作區項目。

15. 在 [設定 \| Defender 方案] 刀鋒視窗中，確認已選取 [啟用所有適用於雲端的 Microsoft Defender 方案]，然後按一下 [儲存]。

16. 在 [適用於雲端的 Microsoft Defender \| 設定] 刀鋒視窗中選取 [資料收集]。 選取 [所有事件] 和 [儲存]。


#### <a name="task-2-review-the-microsoft-defender-for-cloud-recommendation"></a>工作 2：檢閱適用於雲端的 Microsoft Defender 建議

在此工作中，您必須檢閱適用於雲端的 Microsoft Defender 建議。 

1. 在 Azure 入口網站中，巡覽回 [適用於雲端的 Microsoft Defender \| 概觀] 刀鋒視窗。 

2. 在 [適用於雲端的 Microsoft Defender \| 概觀] 刀鋒視窗中檢閱 [安全分數] 圖格。

    >**注意**：記錄目前的分數 (如果有的話)。

3. 巡覽回 [適用於雲端的 Microsoft Defender \| 概觀] 刀鋒視窗，選取 [已評定的資源]。

4. 在 [詳細目錄] 刀鋒視窗中選取 [myVM] 項目。

    >**注意**：您可能必須等候幾分鐘並重新整理瀏覽器頁面，項目才會出現。
    
5. 在 [資源健康狀態] 刀鋒視窗的 [建議] 索引標籤上，檢閱 **myVM** 的建議清單。


#### <a name="task-3-implement-the-microsoft-defender-for-cloud-recommendation-to-enable-just-in-time-vm-access"></a>工作 3：實作適用於雲端的 Microsoft Defender 建議以啟用 Just-In-Time VM 存取

在此工作中，您將實作適用於雲端的 Microsoft Defender 建議，以在虛擬機器上啟用 Just-In-Time VM 存取。 

1. 在 Azure 入口網站中，巡覽回 [適用於雲端的 Microsoft Defender \| 概觀] 刀鋒視窗，然後選取 [雲端安全性] 圖格底下的 [工作負載保護]。 

2. 在 [工作負載保護] 刀鋒視窗的 [進階保護] 區段中，按一下 [Just-In-Time VM 存取] 圖格，然後在 [Just-In-Time VM 存取] 刀鋒視窗上按一下 [試用 Just-In-Time VM 存取]。

    >**注意**：如果未列出 VM，請巡覽至 [虛擬機器] 刀鋒視窗，按一下 [設定]，再按一下 [Just-In-Time VM 存取] 下方的 [啟用 Just-In-Time VM] 選項。    重複執行上述步驟以巡覽回 **適用於雲端的 Microsoft Defender**，然後重新整理頁面，VM 便會出現。

3. 在 [Just In-Time VM 存取] 上，選取 [未設定]，然後按一下 [myVM] 項目。

    >**注意**：您可能需要等候幾分鐘才能點選 [myVM] 項目。

4. 選擇 [在 1 部 VM 上啟用 JIT]。

5. 在 [JIT VM 存取設定] 刀鋒視窗上，在參考連接埠 **22** 的資料列最右邊按一下省略符號按鈕，然後按一下 [刪除]。

6. 在 [JIT VM 存取設定] 刀鋒視窗中按一下 [儲存]。 

    >**注意**：按一下工具列中的 **通知** 圖示並檢視 [通知] 刀鋒視窗，藉此監視設定進度。 

    >**注意**：此實驗室中的建議實作安全分數可能需要稍加等候才會更新。 請定期查看安全分數，以判斷實作這些功能帶來的影響。 

> 結果：您已讓適用於雲端的 Microsoft Defender 上線並實作虛擬機器建議。 

    >**Note**: Do not remove the resources from this lab as they are needed for the Azure Sentinel lab.
