###### Capstone Project
#### Capstone Project
# Udacity - Cloud DevOps Engineer

## Execution results

### Environment setup

#### CloudFormation setup

![CloudFormation setup](screenshots/01-cloudformation.png)

#### Kubernetes setup

![CloudFormation setup](screenshots/02-kubernetes-setup.png)

### CI/CD pipeline - failed linting

![CloudFormation setup](screenshots/03-broken-dockerfile-lint-status.png)
![CloudFormation setup](screenshots/04-broken-dockerfile-lint-detail.png)

### CI/CD pipeline - Docker build and publish

![CloudFormation setup](screenshots/05-docker-build.png)
![CloudFormation setup](screenshots/06-docker-publish.png)
![CloudFormation setup](screenshots/07-docker-image-for-initial-deployment.png)

### Successful initial deployment

> Green service configured on port 30001

#### Pipeline view
![CloudFormation setup](screenshots/08-successful-initial-deployment.png)
#### Kubernetes view
![CloudFormation setup](screenshots/09-successful-initial-kubernetes-view.png)
#### Browser view
![CloudFormation setup](screenshots/10-successful-initial-green-service.png)

### Successful blue/green deployment

> Green service configured on port 30001 (build ID: 87347cb)
> Blue service configured on port 30002 (build ID: cd60dc4)

#### Docker images
![CloudFormation setup](screenshots/11-docker-image-for-blue-green-deployment.png)
#### Pipeline view
![CloudFormation setup](screenshots/12-blue-green-before-promotion-pipeline.png)
#### Kubernetes view
![CloudFormation setup](screenshots/13-blue-green-before-promotion-kubernetes.png)
#### Browser view
![CloudFormation setup](screenshots/14-blue-green-before-promotion-browsers.png)

> Promote to production

![CloudFormation setup](screenshots/15-blue-green-promotion-approval.png)

> Green service repointed to deployment cd60dc4; old deployment 87347cb available for backout)
> Blue service configured on port 30002 (build ID: cd60dc4)

#### Pipeline view
![CloudFormation setup](screenshots/16-blue-green-after-promotion-pipeline.png)
#### Kubernetes view
![CloudFormation setup](screenshots/17-blue-green-after-promotion-kubernetes.png)
#### Browser view
![CloudFormation setup](screenshots/18-blue-green-after-promotion-browsers.png)
