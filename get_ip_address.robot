*** Settings ***
Documentation    This module is reponsible for making a request in an API to retrieve the IP Address
...    The keywords used here are mainly from the RequestsLibrary and Logger Custom module.

Library  RequestsLibrary
Library  logger.LogModule


*** Keywords *** 
Get Requests
    Create Session    ip    http://api.ipify.org/    
    ${resp} =    Get Request    ip    /
    log_debug    ---IP Address:${resp.text}---
    [Return]    ${resp.text}

