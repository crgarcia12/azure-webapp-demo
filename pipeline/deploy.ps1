param(
    [string] $ImageName = "crgarsofieacr.azurecr.io/app:v2",
    [switch] $RunLocally,
    [switch] $InContainer
)

if($RunLocally -and -not $InContainer) {
    uvicorn main:app --reload
    return
}

docker build -t $imageName .

if ($RunLocally) {
    docker run -p 9999:80 $imageName
} else {
    $RegistryName = $ImageName.Split('/')[0]
    az acr login --name $RegistryName
    docker push $imageName
}
