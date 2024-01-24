$imageName = "crgarsofieacr.azurecr.io/app:v2"
docker build -t $imageName .
docker push $imageName
docker run -p 9999:80 $imageName