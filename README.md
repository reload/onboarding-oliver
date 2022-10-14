# onboarding-oliver
Repo with a bunch (hopefully) of on-boarding projects for Oliver

# setup todo-app test project locally (the docker-way)
* Clone the repo
* Run `containers.sh` (bash) from the projects root
* Access the app through `http://localhost:3000`

# setup todo-app test project locally (docker-compose)
* Clone the repo
* Run `docker-compose up` from the projects root - use the `-d` flag to detach the process from foreground
* Access the app through http://localhost:3000

# Remove containers, volumes (data) & networks (docker)
* Run `gc.sh`
* Alternatively, remove manually using `docker rm` commands after retrieving container, volume and network ID's using `docker ps`, `docker volume/network ls`

# Down/remove containers, volumes (data) & networks (docker-compose)
* Run `docker-compose down` in the projects root to down containers, but persist data
* Run `docker compose down --remove-orphans` to terminate containers completely
* Run `docker-compose down && docker-compose up -V` to respawn containers AND their volumes

# Other notes
`gc.sh` is primarily used in github actions to test container script and cleaning up afterwards.
Locally you may want long-running processes depending on your usecase, hence containers.sh is best used here.
