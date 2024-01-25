param prefix string
param location string = resourceGroup().location // Location for all resources
param containerName string


resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: '${prefix}-plan'
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: 'P2V3'
  }
  kind: 'linux'
}

resource webApp 'Microsoft.Web/sites@2021-01-01' = {
  name: '${prefix}-app'
  location: location
  tags: {}
  properties: {
    siteConfig: {
      appSettings: []
      linuxFxVersion: 'DOCKER|crgarsofieacr.azurecr.io/web:v306'
    }
    serverFarmId: appServicePlan.id
  }
}

resource webApp2 'Microsoft.Web/sites@2021-01-01' = {
  name: '${prefix}-app-2'
  location: location
  tags: {}
  properties: {
    siteConfig: {
      appSettings: []
      linuxFxVersion: 'DOCKER|crgarsofieacr.azurecr.io/web:v306'
    }
    serverFarmId: appServicePlan.id
  }
}
