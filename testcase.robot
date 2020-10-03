*** Settings ***
Library  OperatingSystem
Library  csv
Resource  ../Resources/data_resources.robot
#Library  DataDriver  ../TestData/data.csv
Library  RequestsLibrary
Library  Collections
Library  JSONLibrary
Library  JsonValidator


*** Variables ***
${base_url}  https://ssd-api.jpl.nasa.gov


*** Test Cases ***

TC001
    Validating API with No Query Params  200

TC002
    Fetch and Validate Status Code  date-min=now date-max=+60 dist-max=0.05  200
    Fetch and Validate Status Code  dist-max=10LD date-min=2018-01-01 sort=dist  200
    Fetch and Validate Status Code  des=141P  200

TC003
    Verify when query too restrictive  des=141P  0
    Verify when query too restrictive  des=141P v-inf-min=18.5  0
    Verify when query too restrictive  date-min=now&date-max=now&dist-max=0.05  0
    Verify when query too restrictive  date-min=2021-10-10  0
    Verify when query too restrictive  date-max=2018-10-10  0
    Verify when query too restrictive  date-max=now  0
    Verify when query too restrictive  spk=2000433  0

TC004
    Verify Bad request  sort=TestSort  400
    Verify Bad Request  date-min=now&date-max=+60&dist-max=0.05  400
    Verify Bad Request  pha  400

TC005
    Method Not Allowed  Invalid HTTP method: must be GET or POST

#TC006
#    Querying With No Matching Data



#Get_Request_Query_Parameters using ${date-min} ${date-max} and ${dist-max}

#
#*** Keywords ***
#Verifying_Status_Code
#    [Arguments]  ${params}
#    create session  Get_Param  ${base_url}
#    &{params}  create dictionary  date-min=now  date-max=+60  dist-max=0.05
#    ${response}  get request  Get_Param  /cad.api  params=&{params}
#    log to console  ${response}
#    log to console  ${response.status_code}
#    ${status_code}  convert to string  ${response.status_code}
#    should be equal  ${status_code}  200
#Read and display
#    [Arguments]    ${filename}
#    ${value} =   read csv as single list  ${filename}
#    Set Test Variable    ${value}
#    log   ${value}
#
#Send GET requests to /endpoint
#   #[Arguments]  ${base_url}  ${filename}
#   [Arguments]  ${date-min}  ${date-max}  ${dist-max}
#   create session  mysession    ${base_url}
#   ${response}  get request    mysession  /date-min=${date-min}/date-max=${date-max}/dist-max=${dist-max}
#   log to console  ${response}
#   log to console  ${response.status_code}
#   ${status_code}  convert to string  ${response.status_code}
#   should be equal  ${status_code}  200


