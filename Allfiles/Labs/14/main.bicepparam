using './main.bicep'

param rgName = 'AZ500LAB131415'
param defenderAutoProvision = 'On'
param defenderAppServicesPricingTier = 'Standard'
param defenderVirtualMachinesPricingTier = 'Standard'
param defenderSqlServersPricingTier = 'Standard'
param defenderStorageAccountsPricingTier = 'Standard'
param defenderDnsPricingTier = 'Standard'
param defenderArmPricingTier = 'Standard'
param adminUsername = 'localadmin'
param adminPassword = 'AzureTest01!!'
param publicIpName = 'myPublicIpAddress'
param publicIPAllocationMethod = 'Static'
param publicIpSku = 'Standard'
param OSVersion = '2022-datacenter-azure-edition-core'
param vmSize = 'Standard_D2s_v5'
param location = 'eastus'
param vmName = 'myVM'
