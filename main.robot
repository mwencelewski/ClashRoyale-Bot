*** Settings ***
Documentation    ### The main workflow for the execution of the automation ###
...    Some parameters can be changed in the Variables session.
...    This automation will do the following steps:
...        - Log in to Clash Royalle Web Site
...        - Create a New API Key
...        - Extract the relevant data from the API
...        - Create a CSV file with the information required.

Resource    clash_royale_app.robot
Resource    clash_royale_api_resources.robot

*** Variables ***
${tag}=    \#9V2Y
${team_name}=    The Resistance
${output_path}=    ./output/
${key_name}=    RobotKey
${key_description}=    A key for for API usage.
${email} =     dummyemail@email.com
${password} =     Your-Password-Here
*** Tasks ***
Start Application
    
    log_info    -- Starting Process --
    Open Site
    #login to the application
    log_info    -- Preparing to log in to system --
    Click Login
    Input Username    ${email}
    Input Password    ${password}
    Click Login Button
    
    log_info    -- Navigating to the Account Menu --
    Click Account Button
    # Creating the API Key
    log_info    -- Navigating to the Create Key Page --
    Click Create New Key    ${key_name}
    Input New Key Information    ${key_name}    ${key_description}
    ${api_key}=    Extract API Key    ${key_name}
    # Closing the Browser and extracting data from the API.
    log_info    -- Closing browser and starting API Requests -- 
    Close Browser
    Get Team Data    ${team_name}    ${api_key}    ${tag}    ${output_path}