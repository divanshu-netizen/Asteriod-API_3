*** Settings ***
Documentation    Suite description
Library  String
Library  RequestsLibrary
Library  Collections
Library  JSONLibrary
Library  JsonValidator


*** Variables ***
${base_url}  https://ssd-api.jpl.nasa.gov
${date-min}  str



*** Test Cases ***
TestCase_StatusCode_Validation_Success
#    [Tags]    DEBUG
#    Provided precondition
#    When action
#    Then check expectations
    create session  mysession    ${base_url}
    ${response}  get request    mysession  /cad.api
    log to console  ${response}
    log to console  ${response.status_code}
    log to console  ${response.content}
    ${status_code}  convert to string  ${response.status_code}
    should be equal  ${status_code}  200
    status should be  OK  ${response}

TestCase_StatusCode_Validation_Errors
    create session  mysession    ${base_url}
    ${response}  head request  mysession  /cad.api
    log to console  ${response}
    log to console  ${response.status_code}
    ${status_code}  convert to string  ${response.status_code}
    should be equal  ${status_code}  405
    status should be  Method Not Allowed  ${response}


TC_Record_Validation
    create session  mysession    ${base_url}
    ${response}  get request  mysession  /cad.api

#    ${response_body}  convert to string  ${response.content}
#    should contain  ${response_body}  NASA/JPL SBDB Close Approach Data API

    ${json_object}  to json  ${response.content}
    log to console  ${response.content}

TC_Query_Restrictive
    create session  mysession    ${base_url}
    ${response}  get request  mysession  cad.api?des=141P

    ${response_body}  convert to string  ${response.content}
    should contain  ${response_body}  NASA/JPL SBDB Close Approach Data API

    ${json_object}  to json  ${response.content}
    log to console  ${response.content}

    ${count_no}  get value from json  ${json_object}  $.count
    log to console  ${count_no[0]}
    should be equal  ${count_no[0]}

TC_Query_2_Records
    create session  mysession    ${base_url}
    ${response}  get request  mysession  cad.api?des=433&date-min=now&date-max=2100-01-01&dist-max=0.2

    ${json_object}  to json  ${response.content}
    log to console  ${response.content}

    ${count_no}  get value from json  ${json_object}  $.count
    log to console  ${count_no[0]}
    should be equal  ${count_no[0]}  2

TC_Query_Records
    create session  mysession    ${base_url}
    ${response}  get request  mysession  cad.api?dist-max=10LD&date-min=2018-01-01&sort=dist

    ${json_object}  to json  ${response.content}
    log to console  ${response.content}

    ${count_no}  get value from json  ${json_object}  $.count
    log to console  ${count_no[0]}
    should be equal  ${count_no[0]}  1846








*** Keywords ***
#Provided precondition
#    Setup system under test