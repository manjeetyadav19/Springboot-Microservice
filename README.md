
######## Deploy microservice on  kubernetes

step 1: run terraform script 1st create ec2 instance and install minikube on it.
step 2: install maven on the ec2 instance.
step 3: run mvn cmd to build and push code to dockerhub.
 cmd: mvn clean package dockerfile:push
step 4: write kubernetes yml file.
step 5: run micro-service on kubernetes.
 cmd: kubectl apply -f . /
 
 
