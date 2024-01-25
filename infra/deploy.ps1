param(
    [string] $Prefix = "crgar-sofie",
    [string] $ImageName = "crgarsofieacr.azurecr.io/web",
    [string] $Tag,
    [switch] $RunLocally,
    [switch] $InContainer
)

$FullImageName = "$($ImageName):$Tag"
$ResourceGroupName = "$Prefix-rg"
Write-Verbose "FullImageName: $FullImageName" -Verbose
Write-Verbose "ResourceGroupName: $ResourceGroupName" -Verbose

if($RunLocally -and -not $InContainer) {
    uvicorn main:app --reload
    return
}

pushd
cd ../src
docker build -t $FullImageName .
popd

if ($RunLocally) {
    docker run -p 9999:80 $FullImageName
    return
} 

if($DeploymentName -eq "") {
    Write-Error "DeploymentName parameter is required" -ErrorAction Stop
}

$RegistryName = $ImageName.Split('/')[0]
az acr login --name $RegistryName
docker push $FullImageName

$paramsFileName = ".\appsvc.$Tag.bicepparam"
Copy-Item -Path .\appsvc.bicepparam -Destination $paramsFileName
(Get-Content $paramsFileName) -replace "{FullImageName}", $FullImageName | Set-Content $paramsFileName

az deployment group create -n $Tag -g $ResourceGroupName --template-file "appsvc.bicep" --parameters $paramsFileName

Remove-Item $paramsFileName

start-sleep -s 3
$deployment = ConvertFrom-Json (-join (az deployment group show -g $ResourceGroupName --name $Tag))
Write-Verbose "Deployment Status: $($deployment.properties.ProvisioningState)" -Verbose