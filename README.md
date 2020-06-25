# ClashRoyale-Bot

An automation to extract data from the Clash Royale API using Robot-Framework.

<hr/>

**Pre-requisites:**
* RobotFramework
* RobotFramework SeleniumLibrary
* RobotFramework Requests
* Python 3.7

**Parameters**
Some configuration can be done in the ***Variables*** session of the "main.robot" file:

        *** Variables ***
        ${tag}=    \#9V2Y
        ${team_name}=    The Resistance
        ${output_path}=    ./output/
        ${key_name}=    RobotKey
        ${key_description}=    A key for for API usage.
        ${email} =     dummyemail@email.com
        ${password} =     Your-Password-Here

* ${tag} - The beginning of the tag the robot must check in the API.
* ${team_name} - The name of the team to be searched in the API
* ${output_path} - The path where the output.csv file will be created
* ${key_name} - The key name to used when creating the api key, it must be unique.
* ${email} - The email to log in to the Clash Royale website
* ${password} - The Password for the email

**Usage:**
                
                robot --pythonpath libs main.robot


**Output**
An output file named "output.csv" will be created in the root folder:
                
                ./output/output.csv


