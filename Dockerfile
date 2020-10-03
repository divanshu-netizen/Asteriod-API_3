# FROM ubuntu:16.04 
# WORKDIR /usr/src/app
# COPY /asteriods_api/hello .
# RUN apt-get update
# RUN apt-get -y install curl
# RUN curl localhost:8080/Divanshu
#RUN curl https://www.google.com | wc -c > google-size

# FROM alpine 
# COPY --from=builder /google-size /google-size
# ENTRYPOINT echo google is this big; cat google-size

FROM python:3

RUN python3 -m pip install robotframework
RUN python3 -m pip install robotframework-jsonlibrary
RUN python3 -m pip install robotframework-requests


