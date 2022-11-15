# onboarding-oliver
Repo with a bunch (hopefully) of on-boarding projects for Oliver

## Docker project
### setup todo-app test project locally (the docker-way)
* Run `create_containers.sh` (bash) from the projects root
* Access the app through `http://localhost:3000`

### setup todo-app test project locally (docker-compose)
* Run `docker-compose up` from the projects root - use the `-d` flag to detach the process from foreground
* Access the app through http://localhost:3000

### Remove containers, volumes (data) & networks (docker)
* Run `gc.sh`
* Alternatively, remove manually using `docker rm` commands after retrieving container, volume and network ID's using `docker ps`, `docker volume/network ls`

### Down/remove containers, volumes (data) & networks (docker-compose)
* Run `docker-compose down` in the projects root to down containers, but persist data
* Run `docker compose down --remove-orphans` to terminate containers completely
* Run `docker-compose down && docker-compose up -V` to respawn containers AND their volumes

### Other notes
`gc.sh` is primarily used in github actions to clean up started containers in the same pipeline.

## GCP project
### Create GKE cluster
* Authenticate to GCP using `gcloud auth login`
* Edit vars in `google_vars.sh` to fit your usecase
* Run `create_gke_cluster.sh` and wait for cluster to become availble
* Optional: Follow the on-screen instructions to configure kubectl locally and start playing with your cluster

### Delete GKE cluster
* Authenticate to GCP using `gcloud auth login` if TTL expired
* Verify vars in `google_vars.sh` to delete the correct cluster
* Run `delete_gke_cluster.sh`

## Helm stuff
### If you for some reason wish to upgrade helm manually
* Make sure that your local kubectl context is configured to the correct environment
* Execute: `helm upgrade todo-list ./helm-chart/ --atomic --cleanup-on-fail --install --set images.app.tag=${YourTagHere}`
