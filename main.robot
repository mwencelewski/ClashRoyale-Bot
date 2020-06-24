*** Settings ***

Resource    clash_royale_app.robot
Resource    clash_royale_api_resources.robot

*** Variables ***
${tag}=    \#9V2Y
${team_name}=    The Resistance
${output_path}=    ./output/
${key_name}=    RobotKey
${key_description}=    A key for for API usage.
${email} =     dummyemail@dummy.com
${password} =     [Put-Your-Password-Here]
*** Tasks ***
Start Application
    
    log_info    -- Starting Process --
    Open Site
    log_info    -- Preparing to log in to system --
    Click Login
    Input Username    ${email}
    Input Password    ${password}
    Click Login Button
    log_info    -- Navigating to the Account Menu --
    Click Account Button
    log_info    -- Navigating to the Create Key Page --
    Click Create New Key    ${key_name}
    Input New Key Information    ${key_name}    ${key_description}
    ${api_key}=    Extract API Key    ${key_name}
    log_info    -- Closing browser and starting API Requests -- 
    Close Browser
    Get Team Data    ${team_name}    ${api_key}    ${tag}    ${output_path}