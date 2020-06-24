*** Settings ***
Documentation    Reusable components for the Clash Royale Web Application
...    The keywords created here uses keywords provided by the SeleniumLibray, BuiltIn and a Custom Library to Log data.    
...    In the Variables session it is possible to change the values for the URL, Browser and Selenium Delay.
...                

Library  SeleniumLibrary
Library  BuiltIn
Library  logger.LogModule
Resource    get_ip_address.robot
*** Variables ***

${URL}    https://developer.clashroyale.com/
${BROWSER}    Chrome
${DELAY}    0

*** Keywords ***

Open Site
    log_info    -- Starting Browser --
    Open Browser    ${URL}    ${BROWSER}
    #Maximize Browser Window
    Set Selenium Speed     ${DELAY}
    Login Page Should Be Open
    log_info    -- Page Loaded -- 

Login Page Should Be Open
    #Checks the title of the page
    Title Should Be    Clash Royale API
    
Click Login
    #Navigates to the Login Page
    Wait Until Page Contains Element    //div[@class='login-menu']//a[contains(text(),'Log In')]
    log_debug    -- Clicking Log In Button --
    Click Link    partial link:Log

Input Username
    [Arguments]    ${username}
    log_debug    -- Inserting Username --
    Input Text   identifier:email    ${username}

Input Password
    [Arguments]    ${password}
    log_debug    -- Inserting Password --
    Input Text    id:password    ${password}

Click Login Button
    
    #Clicks on the login button and checks if the login was successful or not. In case of Failure, it will log
    #an error message and close the application

    Click Button    class:ladda-button.btn.btn-primary.btn-lg
    Sleep     1
    ${login_failed}=   Run Keyword and Return Status     Page Should Contain Element    class:alert.alert-danger
    log_debug    --- Login Result: ${login_failed} --- 

    Run Keyword If    '${login_failed}'=='True'   Close Failed Login Application

Click Account Button
    #Navigates to the Account Page
    Wait Until Page Contains Element    class:dropdown-toggle__text
    Click Element    class:dropdown-toggle__text
    Wait Until Page Contains Element    //ul[@class='dropdown-menu']//a[contains(text(),'My Account')]
    Click Link    link:My Account  

Click Create New Key
    #Navigates to the Create New Key Page
    [Arguments]    ${key_name}
    log_debug    -- Checking if exists a Key with the same name --
    Wait Until Page Contains Element    class:create-key-btn.btn.btn-icon.btn-primary.btn-lg
    #Validate if there are already a Key created with the same name
    Sleep    2
    ${created_keys} =    Get Element Count    xpath://h4[contains(text(),'${key_name}')]
    Run Keyword If    ${created_keys}>0    A Key With Name Already Exists    ${key_name}
    ...    ELSE    Click Element    class:create-key-btn.btn.btn-icon.btn-primary.btn-lg
    
A Key With Name Already Exists
    [Arguments]    ${key_name}
    log_error    -- A key with the name ${key_name} already exists. Please choose a unique name for the key. -- 
    Close Failed Application

Input New Key Information
    #Inserts the Key Name and Description (passed as arguments)
    #Makes an HTTP Request to retrieve dynamically the IP Address
    [Arguments]    ${key_name}    ${description}
    log_info    -- Inserting the API Key Data -- 
    Input Text    id:name    ${key_name}
    Input Text    id:description    ${description}
    ${IpAddress} =     Get Requests
    #Validates that's an actual ip address. At the moment it only validates if are 15 digits or less. 'xxx.xxx.xxx.xxx'
    ${length}=    Get Length    ${IpAddress}
    ${valid_ip}=    Run Keyword and Return Status    Should Be True    ${length}<=15
    Run Keyword If    '${valid_ip}'=='False'    Close Failed Application
    Input Text    id:range-0    ${IpAddress}
    Click Element    class:ladda-button.btn.btn-primary.btn-lg.btn-block
    Wait Until Page Contains Element    class:alert.alert-success

Extract API Key
    #Extracting API Key
    [Arguments]    ${key_name}
    Wait Until Page Contains Element    class:dev-site-icon-key.dev-site-icon
    Click Element    xpath://h4[contains(text(),'${key_name}')]
    Wait Until Page Contains Element    class:form-control.input-lg
    ${token} =     Get Text    class:form-control.input-lg
    log_debug    -- Key: ${token} -- 
    [return]   ${token}

Close Failed Login Application
    log_error     Login Failed
    [Teardown]    Close Browser
    Fatal Error    Ending Task
Close Failed Application
    log_error     Task Failed
    [Teardown]    Close Browser
    Fatal Error    Task Failed. Closing.