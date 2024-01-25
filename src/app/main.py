import os
import json
from typing import Union, Annotated
from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
import pymongo
import requests
from azure.core.pipeline.policies import BearerTokenCredentialPolicy
from azure.identity import ManagedIdentityCredential, ClientSecretCredential

app = FastAPI()
app.mount("/static", StaticFiles(directory="app/static"), name="static")
templates = Jinja2Templates(directory="app/templates")

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/environment")
def get_headers(request: Request):
    # Convert the dictionary to a list of key-value pairs
    all_env_variables = os.environ
    env_variables = "\n".join([f"{key}: {value}" for key, value in all_env_variables.items()])

    env_variables = dict(os.environ)
    headers = dict(request.headers.items())
    return templates.TemplateResponse(
        request=request, 
        name="environment.html", 
        context={
            "env_variables":env_variables, 
            "headers":headers, 
        }
    )

@app.get("/People")
def get_people(request: Request):
    endpoint = os.getenv('AZURE_COSMOS_RESOURCEENDPOINT')
    listConnectionStringUrl = os.getenv('AZURE_COSMOS_LISTCONNECTIONSTRINGURL')
    scope = os.getenv('AZURE_COSMOS_SCOPE')

    cred = ManagedIdentityCredential()
    session = requests.Session()
    session = BearerTokenCredentialPolicy(cred, scope).on_request(session)
    response = session.post(listConnectionStringUrl)
    keys_dict = response.json()
    conn_str = keys_dict["connectionStrings"][0]["connectionString"]

    # Connect to Azure Cosmos DB for MongoDB
    client = pymongo.MongoClient(conn_str)