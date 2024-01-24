import os
import json
from typing import Union, Annotated
from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

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

    return HTMLResponse(
        content=html_template.replace(
                '{{ headers }}',
                json.dumps(headers_dict))
            .replace(
                '{{ env_variables }}',
                json.dumps(env_variables)),
        status_code=200
    )