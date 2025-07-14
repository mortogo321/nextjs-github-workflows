# Github Runner

## Settings
set execute mode
``` bash
cd docker/github-runner
chmod +x *.sh
./start.sh
```

## Validate
``` bash
docker ps
docker logs -f github-runner
```
