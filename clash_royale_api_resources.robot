*** Settings ***
Documentation    Reusable component to access the custom library to make the API Requests
...    The Keywords used in this file are from the clash_royale_api module

Library  clash_royale_api.ClashRoyaleAPI
Library  logger.LogModule

*** Keywords ***

Get Team Data
    # Get team full tag from the API
    [Arguments]    ${team}    ${tk}    ${tg}    ${output_path}
    log_info    -- Fetching data from the API --
    log_debug   -- Team Name: ${team} - Tag: ${tg} - Token: ${tk} -- 
    ${full_tag}=    Get Teams    team_name=${team}    token=${tk}    tag=${tg}
    log_debug   -- Full tag: ${full_tag} --
    ${valid_tag}=   Run Keyword and Return Status    Should Be True    '${full_tag}' != 'None'
    Run Keyword If    ${valid_tag}     Get Players Data    ${full_tag}    ${output_path}    ${tk}
    ...    ELSE    Kill Task
    
Get Players Data
    # Get the players data and create the csv file
    [Arguments]    ${full_tag}    ${out_path}     ${apitk}
    log_info    -- Fetching Player Information and Generating File -- 
    Get Players    tag=${full_tag}    token=${apitk}    output_path=${out_path}   

Kill Task
    log_error    -- Failed during request -- 
    clash_royale_app.Close Failed Application