*** Settings ***
Documentation    Suite description
Library  RequestsLibrary
Library  JSONLibrary
Library  Collections



*** Variables ***
${base_url}  https://ssd-api.jpl.nasa.gov/cad.api


*** Keywords ***
Validating API with No Query Params
    [Arguments]  ${expectedStatusCode}
    create session  SName  ${base_url}
    ${response}  get request  SName  /cad.api
    ${statusC}  convert to string  ${response.status_code}
    should be equal  ${expectedStatusCode}  ${statusC}
    ${responsebody}  convert to string  ${response.content}
    should contain  ${responsebody}  signature

Fetch and Validate Status Code
    [Arguments]  ${params}  ${expectedStatusCode}
    create session  SName  ${base_url}
    &{params}  create dictionary  date-min=now  date-max=+60  dist-max=0.05
    ${response}  get request  SName  /cad.api  params=&{params}
    ${statusC}  convert to string  ${response.status_code}
    should be equal  ${expectedStatusCode}  ${statusC}

Verify when query too restrictive
    [Arguments]  ${params}  ${expectedcountno}
    create session  SName  ${base_url}
    &{params}  create dictionary  des=141P  v-inf-min=18.5
    ${response}  get request  SName  /cad.api  params=&{params}
    ${expectedcount}  convert to string  ${response.content}
    should be equal  ${expectedcountno}  0

Querying With No Matching Data
    [Arguments]  ${params}  ${expectedStatusCode}
    create session  SName  ${base_url}
    #&{params}  create dictionary  des=141P  v-inf-min=18.5
    ${response}  get request  SName  /cad.api  params=${params}
    ${statusC}  convert to string  ${response.status_code}
    should be equal  ${expectedStatusCode}  ${statusC}


Verify Bad Request
    [Arguments]  ${params}  ${expectedStatusCode}
    create session  SName  ${base_url}
    &{params}  create dictionary  sort=TestSort
    ${response}  get request  SName  /cad.api  params=&{params}
    ${statusC}  convert to string  ${response.status_code}
    should be equal  ${expectedStatusCode}  ${statusC}

Method Not Allowed
    [Arguments]  ${responsebodyvalue}
    create session  SName  ${base_url}
    ${response}  head request  SName  /cad.api
    log to console  ${response.status_code}
    ${responsebody}  convert to string  ${response.content}
    should be equal  ${responsebodyvalue}  Invalid HTTP method: must be GET or POST



#    log to console  ${response.content}
 #   ${response_body}  convert to string  ${response.content}
#    should contain  ${response.content}  NASA/JPL SBDB Close Approach Data API
#    ${json_object}  to json  ${response.content}
#    log to console  ${json_object}
##
#    ${expectedcountno}  get   ${json_object}  $.count
#    log to console  ${expectedcount[0]}
#     should be equal as strings  ${expectedcount}  ${expectedcountno}







