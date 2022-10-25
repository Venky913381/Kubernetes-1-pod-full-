
# multistage docker file

# 1 >

FROM golang:alpine AS Builder
WORKDIR /helloworld
COPY helloworld.go .
RUN GOOS=linux go build -a -installsuffix cgo -o helloworld .
#ENTRYPOINT ["./helloworld"]

FROM alpine:latest
WORKDIR /root
COPY --from=Builder /helloworld/helloworld .
ENTRYPOINT ["./helloworld"]


#alpine is the smallest of all version for any image.
#alpine:latest, will not have any runtime , or libraries, it is simple bash shell.

#once executable is available from previous build, we did not need the code or runtime, so 
#it is ok to delete it, and we do this by adding another stage.

#COPY --from=Builder /helloworld/helloworld  : copying from builder stage, a helloworld build from /helloworld dir 
# to pwd.

#need only one entrypoint/cmd , to later stage.

#--------------------------------------------------------------------------------------------------------------

# 2 >

FROM maven AS Builder1
RUN mkdir /usr/src/mymaven
WORKDIR /usr/src/mymaven
COPY ./ ./
RUN mvn install -DskipTests

FROM tomcat:alpine
WORKDIR webapps
COPY --from=Builder1 /usr/src/mymaven/target/java-tomcat-maven-example.war .
RUN rm -rf ROOT && mv java-tomcat-maven-example.war ROOT.war
CMD ["java","-jar","/usr/src/mymaven/target/ROOT.war"]


#--------------------------------------------------------------------------------------------------------------

>1.containers rae increasingly became popular, but it do present some security risk to the 
> application as well as data

>2.containerization is one of the core stages in devops process where security must be looked on a serious note.

>3.container image can have many bugs and security vulnerabilitiues, which gives a good opportunity for the
> hackers to bet access to the application and data present in the containers.

>4.hence it is crucial to scan and audit the images and containers regularly.

>5.DevSecOps plays an important role in adding security to the devops processes, including scanning images
> and containers for bugs and vulnerabilities.

>6.while building docker images , mainly we are concerned for two things_
  a)Size of the image
  b)security of the image 

>7.the container images are comprised of several layers. so scanning each and every layer is very crucial in 
   devsecops, the smaller the image is, lesser is the possibility of it to get exposed to potential vulnerabilities

>8.SMALLER DOCKER IMAGES_ 

  1) container images should be small and lightweight as much as possible   
  2) they should pack only the application code and its dependancies. rest everything to be scrapped off
     to bring down its size including the build dependancies.
  3) smaller the images lesser is the attack surface area to the container and morever are easy to 
     distribute and deploy   
  4) larger images can have more software vulnerabilities in the form of dependancies including 
     potential security holes
  5) better to use alpine images like, FROM golang:alpine or FROM node:alpine 
  6) Alpine images are small and light weighted as they have many  files and programms removed, leaving 
     only the dependancies just enough to run the application 


>9.WHY SMALLER DOCKER IMAGES_

    1)they pack very few system utilities
    2)smaller container can be moved much easier and faster
    3)it makes pull-push operation faster and improves performance
    4)samller images are efficient in utilizing disk space and memory due to less running processes.


>10.HOW TO BUILD SMALLER IMAGES_

    1)follow the dockerfile best practices , while building the images. the overhead of scanning the docker images 
      for detecting vulnerabilities, investigating the security issues,and reporting and fixing them after the 
      deployment, can prevented by folloing best practices to build docker images_ 

    2)Do not run the container as ROOT.
    3)avoid copying unnecessary file, use .dockerignore
    4)merge layers 
    5)use alpine or distroless images as base image
    6)use multistage build 
    7)perform health checks
    8)avoid exposing unnecessary ports
    9)hardcoding the credentials
   10)dockerhub host up to 7 miilion repositories, base base must be selected wisely, not all images are secure.
   11)use tool like ancore image scanner to scan the images for vulnereabilities.


>11.What if multistage images , do not reduces the size of image, then_

    1)remove unwanted binaries like apt, yum, npm, bash, sh leaving only required dependancies
    2)pack only bare minimum dependancies needed to run container.
    3)use alpine images as a base image becouse  it is much easier to use standard debugging tools
      ans install dependancies 
    4)use distroless images, is a project from google (java user can use jib)  

>12.Alpin Linux_
    Alpin Linux is a linux distribution build around musl libc and busybox. it is only 5MB in size.
    which makes great base image for utilities and even production applications.
    by using alpin linux as base image, and adding only required dependancies/artifacts on top of it, 
    result in smaller and cleaner docker images. 


>13.Distroless Images_ 
    Distroless containers images are language focussed docker images, sans the operating system distribution. 
    it contains only application and its runtime dependancies, not other usual os package managers, linux shells
    or any such programm which we usually expect in a standard linux distribution.

    this approch creates a smaller attack surface, reduces complience scop and result in a smaller , lean and
    clean image and thius increases security.

    it is pioneered by GOOGLE. google have published the set of distroless images for different languages.
    distroless images do not have shell for dubugging. 

>14.Container Security Tools_
    
    1)it scans the containers for all the vulnerabilituies and monitor them regularly against any attack, issue 
      or new bugs.
    2)they mostaly work by scanning installed os packages and compairing versions to CVE 
      (comman vulnerabilities and exposures) database.

    3)some of the container scanners are _ ANCHORE ENGINE, CLAIR, TWISTLOCK, QUALYS, BLACKDUG, CILIUM,
      SYSDIG FALCO, AQUASECURITY/ TRIVY. 

15> USING Anchore CLI_

    1)adding container image to analyse_ 
        anchore-cli image add <image_name>

    2)waiting for image to complate the analysis_ (to check if analysis is complete or not)
        anchore-cli image wait <image>

    3)list images analysed by anchore_ 
        anchore-cli image list 

    4)veiw the scan result and list out all of the known vulnerabilities_
        anchore-cli image <image>  

    5)to run policy check 
        anchore-cli evaluate check <image> --detail








#--------------------------------------------------------------------------------------------------------------            