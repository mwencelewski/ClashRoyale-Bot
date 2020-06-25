#   Custom Library to Fetch data from Clash Royale API
#   Creator: Mauro Wencelewski
#   

"""
    Custom Module to get Clan Tag Id and Data from the Clan Players
"""
from robot.api.deco import keyword, library
import os
import requests
import json
import csv


@library   
class ClashRoyaleAPI:
    def __init__(self):
        pass

    @keyword
    def get_teams(self,team_name,token,tag):
        #building request
        url = "https://api.clashroyale.com/v1/clans?name={0}".format(team_name)
        headers = {'Authorization': 'Bearer {t}'.format(t=token)}   
        try:
            response = requests.request("GET", url, headers=headers)
            #parsing json data
            teams = json.loads(response.text)
            for team in teams['items']:
                if(team['tag'].startswith(tag) and team['location']['name']=='Brazil'):
                    return team['tag']
                else:
                    pass
        except:
            raise Exception("Failed during request - Status code: {code} - Message: {message}".format(code=response.status_code, message = response.text))            
    
    @keyword    
    def get_players(self,tag,token,output_path):
        new_tag = tag.replace('#','%23')
        url = "https://api.clashroyale.com/v1/clans/{tag}/members".format(tag=new_tag)
        headers = {'Authorization': 'Bearer {t}'.format(t=token)}
        try:
            response = requests.request("GET", url, headers=headers)
        
            players = json.loads(response.text)
            #checks if the directory exists, otherwise it will create it.
            if not os.path.isdir(output_path):
                os.mkdir(output_path)
            with open('{0}output.csv'.format(output_path),'w+',newline='') as csvfile:
                fieldnames = ['Name','Level','Trophies','Role']
                writer = csv.DictWriter(csvfile,fieldnames=fieldnames)
                writer.writeheader()
                for player in players['items']:
                    writer.writerow({'Name':player['name'],'Level':player['expLevel'],'Trophies':player['trophies'],'Role':player['role']})
        except:
            raise Exception("Failed during request - Status code: {code} - Message: {message}".format(code=response.status_code, message = response.text))    
    
