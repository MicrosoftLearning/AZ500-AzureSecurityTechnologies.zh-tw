---
lab:
  title: 04 - 設定和保護 ACR 與 AKS
  module: 'Module 01 - Secure compute, storage, and databases'
---

# 實驗室 04：設定和保護 ACR 與 AKS
# 學生實驗室手冊

## 實驗案例

系統要求您使用 Azure Container Registry 和 Azure Kubernetes Service 部署概念證明。 具體而言，概念證明應示範：

- 使用 Dockerfile 組建映像。
- 使用 Azure Container Registry 儲存映像。
- 設定 Azure Kubernetes Service。
- 在內部和外部保護及存取容器應用程式。 

> 此實驗室中所有資源均使用**美國東部**區域。 請與講師驗證這是課程中要使用的區域。 

## 實驗室目標

在本實驗室中，您須完成下列練習：

- 練習 1：設定和保護 ACR 與 AKS

## 設定和保護 ACR 與 AKS 圖表

![顯示本實驗室中任務流程的圖表。](../media/configuring-and-securing-acr-and-aks-diagram.png)

## 指示

## 實驗室檔案：

- **\\Allfiles\\Labs\\09\\nginxexternal.yaml**
- **\\Allfiles\\Labs\\09\\nginxinternal.yaml**

### 練習 1：設定和保護 ACR 與 AKS

### 預估時間：45 分鐘

> 此實驗室中所有資源均使用**美國東部**區域。 請與講師確認這是課程中要使用的區域。 

在本練習中，您將會完成下列工作：

- 工作 1：建立 Azure 容器登錄
- 工作 2：建立 Dockerfile、組建容器，並將其推送至 Azure Container Registry
- 工作 3：建立 Azure Kubernetes Service 叢集
- 工作 4：將存取 ACR 的權限授與 AKS 叢集
- 工作 5：將外部服務部署至 AKS
- 工作 6：驗證您是否可以存取外部 AKS 託管服務
- 工作 7：將內部服務部署至 AKS
- 工作 8：驗證您是否可以存取內部 AKS 託管服務

#### 工作 1：建立 Azure 容器登錄

在此工作中，您會建立實驗室的資源群組和 Azure Container Registry。

1. 登入 Azure 入口網站：**`https://portal.azure.com/`**。

    >**注意**：登入 Azure 入口網站時使用的帳戶，必須在您用於這個實驗室的 Azure 訂用帳戶中具有擁有者或參與者角色，並在與該訂用帳戶相關聯的 Microsoft Entra 租用戶中具有全域管理員角色。

2. 在 Azure 入口網站中按一下右上方的第一個圖示，開啟 Cloud Shell。 如果出現提示，請按一下 [Bash]**** 和 [建立儲存體]****。

3. 確認在 [Cloud Shell] 窗格左上角的下拉式功能表中，已選取 [Bash]****。

4. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令為此實驗室建立新的資源群組：

    ```sh
    az group create --name AZ500LAB09 --location eastus
    ```

5. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令來確認已建立資源群組：

    ```
    az group list --query "[?name=='AZ500LAB09']" -o table
    ```

6. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令以建立新的 Azure Container Registry (ACR) 執行個體 (ACR 的名稱必須是全域唯一)： 

    ```sh
    az acr create --resource-group AZ500LAB09 --name az500$RANDOM$RANDOM --sku Basic
    ```
    > **附註** 註冊 Azure Container Registry 資源提供者。 如果您在執行 `az acr create`時遇到錯誤，可能是因為 **尚未為您的訂用帳戶註冊 Azure Container Registry** 服務。 若要修正此問題，您可以註冊服務，並在一個命令中建立登錄：
    
    > ```sh
    > az provider register --namespace Microsoft.ContainerRegistry
    > ```

7. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令來確認已建立新的 ACR：

    ```sh
    az acr list --resource-group AZ500LAB09
    ```

    >**注意**：記錄 ACR 的名稱。 您將在下一個工作中需要它。

#### 工作 2：建立 Dockerfile、組建容器，並將其推送至 Azure Container Registry

在此工作中，您將建立 Dockerfile、從 Dockerfile 組建映像，並將映像部署至 ACR。 

1. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令來建立 Dockerfile，進而建立 Nginx 型映像： 

    ```sh
    echo FROM nginx > Dockerfile
    ```

2. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令，從 Dockerfile 組建映像，並將映像推送至新的 ACR。 

    >**注意**：命令列結尾的後置句點是必要的。 這會將目前目錄指定為 Dockerfile 的位置。 

    ```sh
    ACRNAME=$(az acr list --resource-group AZ500LAB09 --query '[].{Name:name}' --output tsv)

    az acr build --resource-group AZ500LAB09 --image sample/nginx:v1 --registry $ACRNAME --file Dockerfile .
    ```

    >**注意**：等候命令成功完成。 這大約需要 2 分鐘。

3. 關閉 [Cloud Shell] 窗格。

4. 在 Azure 入口網站中，瀏覽至 **AZ500Lab09** 資源群組，然後在資源清單中，按一下代表您在上一個工作中佈建 Azure Container Registry 執行個體的項目。

5. 在 [容器登錄] 窗格的 [服務]**** 區段中，按一下 [存放庫]****。 

6. 確認存放庫清單包含名為 **sample/nginx** 的新容器映像。

7. 按一下 **sample/nginx** 項目，並確認可識別映像版本的 **v1** 標籤是否存在。

8. 按一下 **v1** 項目以檢視映像資訊清單。

    >**注意**：資訊清單包含 sha256 摘要、資訊清單建立日期和平台項目。 

#### 工作 3：建立 Azure Kubernetes Service 叢集

在此工作中，您會建立 Azure Kubernetes 服務，並檢閱已部署的資源。 

1. 在 Azure 入口網站中，在 Azure 入口網站頁面頂端的 [搜尋資源、服務和文件]**** 文字輸入框中，輸入 **Kubernetes 服務**，然後按下 **Enter** 鍵。

2. 在 [Kubernetes 服務]**** 刀鋒視窗上，按一下 [+ 建立]****，然後在下拉式功能表中，按一下 [+ 建立 Kubernetes 叢集]****

3. 在 [建立 Kubernetes 叢集]**** 刀鋒視窗的 [基本]**** 索引標籤上，依序選取 [叢集預設設定]**** 與 [開發/測試 ($)]****。 現在請指定下列設定 (將其他設定保留為預設值)：

    |設定|值|
    |----|----|
    |訂用帳戶|您要在此實驗室中使用的 Azure 訂用帳戶名稱|
    |資源群組|**AZ500LAB09**|
    |Kubernetes 叢集名稱|**MyKubernetesCluster**|
    |區域|**(美國) 美國東部**|
    |可用性區域 |**None**|
    |缩放方法|**手動**|
    |節點計數|**1**|

4. 按一下 [下一步：**節點集區] >** ，然後在 [建立 Kubernetes 叢集] 刀鋒視窗的 [節點集區] 索引標籤上，指定下列設定 (將其他設定保留為預設值)：

    |設定|值|
    |----|----|
    |啟用虛擬節點|已清除的核取方塊|
    
5. 按一下 [下一步：**存取] >**，在 [Create Kubernetes 叢集]**** 刀鋒視窗的 [存取]**** 索引標籤上，接受預設值並按 [下一步]**：網路 >]**。 

6. 在 [建立 Kubernetes 叢集]**** 刀鋒視窗的 [網路]**** 索引標籤上，指定下列設定 (將其他設定保留為預設值)：

    |設定|值|
    |----|----|
    |網路組態|**Azure CNI 重疊**|
    |DNS 名稱首碼|**保留預設值**|

    >**注意**：AKS 可以設定為私人叢集。 這會將私人 IP 指派給 API 伺服器，以確保 API 伺服器與節點集區之間的網路流量僅會保留在私人網路上。 如需詳細資訊，請前往[建立私人 Azure Kubernetes Service 叢集](https://docs.microsoft.com/en-us/azure/aks/private-clusters)頁面。

7. 按一下 [下一步：**整合] >**，然後在 [建立 Kubernetes 叢集]**** 刀鋒視窗的 [整合]**** 索引標籤上，將 [容器監視]**** 設定為 [已停用]****。 

    >**注意**：在生產案例中，您會想要啟用監視。 在此情況下會停用監視，因為實驗室中未涵蓋監視。 

8. 按一下 [檢閱 + 建立]，然後按一下 [建立]。

    >**注意**：等待部署完成。 這大約需要 10 分鐘。

9. 當部署完成後，在 Azure 入口網站頁面頂端的 [搜尋資源、服務和文件]**** 文字輸入框中，輸入**資源群組**，然後按下 **Enter** 鍵。

10. 在 [資源群組]**** 刀鋒視窗的資源群組清單中，記下名為 **MC_AZ500LAB09_MyKubernetesCluster_eastus** 的新資源群組，其中包含 AKS 節點的元件。 檢閱此資源群組中的資源。 
    
11. 瀏覽回 [資源群組]**** 刀鋒視窗，然後按一下 **AZ500LAB09** 項目。 

    >**注意**：在資源清單中，記下 AKS 叢集和對應的虛擬網路。

12. 在 Azure 入口網站中，在 Cloud Shell 中開啟 Bash 工作階段。 

    >**注意**：確認在 [Cloud Shell] 窗格左上角的下拉式功能表中，已選取 [Bash]****。

13. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令以連線至 Kubernetes 叢集：

    ```sh
    az aks get-credentials --resource-group AZ500LAB09 --name MyKubernetesCluster
    ```

14. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令以列出 Kubernetes 叢集節點： 

    ```sh
    kubectl get nodes
    ```

    >**注意**：確認叢集節點的**狀態**已列為**就緒**。

#### 工作 4：將存取 ACR 和管理其虛擬網路的權限授與 AKS 叢集

在此工作中，您會將存取 ACR 和管理其虛擬網路的權限授與 AKS 叢集。 

1. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令來設定 AKS 叢集，以便使用您稍早在此實驗室中建立的 Azure Container Registry 執行個體。 

    ```sh
    ACRNAME=$(az acr list --resource-group AZ500LAB09 --query '[].{Name:name}' --output tsv)

    az aks update -n MyKubernetesCluster -g AZ500LAB09 --attach-acr $ACRNAME
    ```

    >**注意**：此命令會將「acrpull」角色指派授與 ACR。 

    >**注意**：完成此命令可能會需要幾分鐘的時間。 

2. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令，向 AKS 叢集授與對虛擬網路的參與者角色。 

    ```sh
    RG_AKS=AZ500LAB09

    RG_VNET=MC_AZ500LAB09_MyKubernetesCluster_eastus    

    AKS_VNET_NAME=aks-vnet-30198516
    
    AKS_CLUSTER_NAME=MyKubernetesCluster
    
    AKS_VNET_ID=$(az network vnet show --name $AKS_VNET_NAME --resource-group $RG_VNET --query id -o tsv)
    
    AKS_MANAGED_ID=$(az aks show --name $AKS_CLUSTER_NAME --resource-group $RG_AKS --query identity.principalId -o tsv)
    
    az role assignment create --assignee $AKS_MANAGED_ID --role "Contributor" --scope $AKS_VNET_ID
    ```

#### 工作 5：將外部服務部署至 AKS

在此工作中，您會下載資訊清單檔、編輯 YAML 檔案，並將變更套用至叢集。 

1. 在 [Cloud Shell] 窗格的 Bash 工作階段中，按一下 [上傳/下載檔案]**** 圖示，在下拉式功能表中按一下 [上傳]****，在 [開啟]**** 對話方塊中，瀏覽至您下載實驗室檔案的位置，選取 \\Allfiles\\Labs\\09\\nginxexternal.yaml**** 並按一下 [開啟]****。 接下來，選取 \\Allfiles\\Labs\\09\\nginxinternal.yaml****，然後按一下 [開啟]****。

2. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令以識別 Azure Container Registry 執行個體：

    ```sh
    echo $ACRNAME
    ```

    >**注意**：記錄 Azure Container Registry 執行個體名稱。 之後在此工作中會用到。

3. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令以開啟 nginxexternal.yaml 檔案，以便編輯其內容。 

    ```sh
    code ./nginxexternal.yaml
    ```

    >**注意**：這是*外部* yaml 檔案。

4. 在編輯器窗格中，向下捲動至**第 24 行**，並以 ACR 名稱取代 **`<ACRUniquename>`** 預留位置。

5. 在編輯器窗格中，依序按一下右上角的**省略號**圖示、[儲存]**** 以及 [關閉編輯器]****。 

6. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令將變更套用至叢集：

    ```sh
    kubectl apply -f nginxexternal.yaml
    ```

7. 在 [Cloud Shell] 窗格的 Bash 工作階段中，檢閱您在上一個工作中執行的命令輸出，確認已建立部署和對應的服務。 

    ```
    deployment.apps/nginxexternal created
    service/nginxexternal created
    ```

#### 工作 6：驗證您是否可以存取外部 AKS 託管服務

在此工作中，使用公用 IP 位址確認容器可從外部存取。

1. 在 [Cloud Shell] 窗格內的 Bash 工作階段中，執行下列命令來擷取 nginxexternal 服務的相關資訊，包括名稱、類型、IP 位址和連接埠。 

    ```sh
    kubectl get service nginxexternal
    ```

2. 在 [Cloud Shell] 窗格的 Bash 工作階段中，檢閱輸出並將值記錄於 [外部 IP] 資料行中。 您將在下一個步驟中需要它。 

3. 開啟新的瀏覽器索引標籤，並瀏覽至您在上一個步驟中識別的 IP 位址。

4. 確認會顯示**歡迎使用 nginx!** 頁面。 

#### 工作 7：將內部服務部署至 AKS

在此工作中，您會在 AKS 上部署內部對應服務。 

1. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令以開啟 nginxintenal.yaml 檔案，以便編輯其內容。 

    ```sh
    code ./nginxinternal.yaml
    ```

    >**注意**：這是*內部* yaml 檔案。

2. 在編輯器窗格中，向下捲動至包含容器映像參考的行，並以 ACR 名稱取代 **`<ACRUniquename>`** 預留位置。

3. 在編輯器窗格中，依序按一下右上角的**省略號**圖示、[儲存]**** 以及 [關閉編輯器]****。 

4. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令將變更套用至叢集：

    ```sh
    kubectl apply -f nginxinternal.yaml
    ```

5.  在 [Cloud Shell] 窗格的 Bash 工作階段中，檢閱輸出以確認已建立您的部署和服務：

    ```
    deployment.apps/nginxinternal created
    service/nginxinternal created
    ```

6. 在 [Cloud Shell] 窗格內的 Bash 工作階段中，執行下列命令來擷取 nginxinternal 服務的相關資訊，包括名稱、類型、IP 位址和連接埠。 

    ```sh
    kubectl get service nginxinternal
    ```

7. 在 [Cloud Shell] 窗格的 Bash 工作階段中，檢閱輸出。 在此案例中，外部 IP 為私人 IP 位址。 如果處於**擱置**狀態，請再次執行先前的命令。

    >**注意**：記錄此 IP 位址。 您將在下一個工作中需要它。 

    >**注意**：若要存取內部服務端點，您會以互動方式連線至叢集中執行的其中一個 Pod。 

    >**注意**：或者，您可以使用 叢集 IP 位址。

#### 工作 8：驗證您是否可以存取內部 AKS 託管服務

在此工作中，您會使用 AKS 叢集上執行的其中一個 Pod 來存取內部服務。 

1. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令來列出 AKS 叢集上預設命名空間中的 Pod：

    ```sh
    kubectl get pods
    ```

2. 在 Pod 清單中，複製 **NAME** 資料行中的第一個項目。

    >**注意**：這是您會在後續步驟中使用的 Pod。

3. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令以互動方式連線至第一個 Pod (以您在上一個步驟中複製的名稱取代 `<pod_name>` 預留位置)：

    ```sh
    kubectl exec -it <pod_name> -- /bin/bash
    ```

4. 在 [Cloud Shell] 窗格的 Bash 工作階段中，執行下列命令來確認 nginx 網站可透過服務的私人 IP 位址取得 (以您在上一個工作中記錄的 IP 位址取代 `<internal_IP>` 預留位置)：

    ```sh
    curl http://<internal_IP>
    ```

5. 關閉 [Cloud Shell] 窗格。

> 結果：您已設定並保護 ACR 和 AKS。


**清除資源**

> 請記得移除您不再使用的任何新建立的 Azure 資源。 移除未使用的資源可避免產生非預期的費用。

1. 在 Azure 入口網站中按一下右上方的第一個圖示，開啟 Cloud Shell。 

2. 在 [Cloud Shell] 窗格左上角的下拉式功能表中，選取 [PowerShell]****，並在提示出現時按一下 [確認]****。

3. 在 [Cloud Shell] 窗格的 PowerShell 工作階段中，執行下列操作，移除您在此實驗室中建立的資源群組：
  
    ```powershell
    Remove-AzResourceGroup -Name "AZ500LAB09" -Force -AsJob
    ```

4.  關閉 [Cloud Shell] 窗格。 
