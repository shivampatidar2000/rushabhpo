*** Settings ***
Library         REST        url=%{TEST_ENDPOINT}

*** Variables ***
${Healthcheck_URI}  /healthcheck


*** Test Cases ***
Get the backend healthcheck response
  Log to console    \nUsing endpoint %{TEST_ENDPOINT}${Healthcheck_URI}
  HEAD           ${Healthcheck_URI}
  Integer               response status             200
