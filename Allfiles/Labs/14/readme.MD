這包含 bicep 檔案，用來部署實驗室中設定的資源

若要部署此範本： 

```
$date = Get-Date -Format "MM-dd-yyyy"
$rand = Get-Random -Maximum 1000
$deploymentName = "AzInsiderDeployment-"+"$date"+"-"+"$rand"
New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName AZ500LAB131415 -TemplateFile .\main.bicep -TemplateParameterFile .\azuredeploy.parameters.json -c
```
