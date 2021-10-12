import base64
from datetime import datetime
from os import environ
import re
import sys
import google.api_core.exceptions
import google.cloud.logging
from google.cloud import bigquery
from pytz import utc

from flask import Flask, request
import json

import logging

logging.basicConfig(format='%(asctime)s %(message)s',level=logging.INFO)
logger = logging.getLogger(__name__)


########################################################################################
# FLASK WEB SERVICE - TO USE WITH CLOUD RUN/DOCKER


app = Flask(__name__)

@app.route("/", methods=['GET','POST'])    
def index():
    '''Main function called by Pub/Sub subscription'''

    logger.info("****** ROUTE FUNCTION RUNNING********")
    if request.method=='GET':
        logger.info("****** GET METHOD TRIGGERED ********")      
        print ('GET method request!')
        return "Hello, Route!"

    if request.method=='POST':      
        logger.info("****** POST METHOD TRIGGERED ********")        
        envelope = request.get_json()
        if not envelope:
            msg = "no Pub/Sub message received"
            print(f"error: {msg}")
            logger.error("*** ERROR:%s",msg)

            return f"Bad Request: {msg}", 400

        if not isinstance(envelope, dict) or "message" not in envelope:
            msg = "invalid Pub/Sub message format"
            print(f"error: {msg}")
            logger.info("*** ERROR:%s",msg)            
            return f"Bad Request: {msg}", 400

        try:
            pubsub_message = envelope["message"]
            name = "World"
            if isinstance(pubsub_message, dict) and "data" in pubsub_message:
                name = base64.b64decode(pubsub_message["data"]).decode("utf-8").strip()

            print(f"Hello {name}!")
            logger.info("HELLO: %s",name)
        except Exception as e:
            error_message = 'data element not a valid json'
            logger.error('error: %s', error_message)
            return f'Bad Request: {error_message}', 400

        logger.info("########## BYE BYE FROM PYTHON ############")
        return ("", 204)



#--------------------------------------------------------------------------------------------------
# When running locally, check for service account and then call function entry point
if __name__ == '__main__':

    test_envelope = {
        "message": {
            "data": base64.b64encode(json.dumps({"mytext":"lalala"}).encode('utf8')).decode('utf8'),
            "messageId": "1674180286850309",
            "message_id": "1674180286850309",
            "publishTime": "2020-10-29T17:27:46.178Z",
            "publish_time": "2020-10-29T17:27:46.178Z"
        }
    }

    with app.test_client() as c:
        rv = c.post('/', json=test_envelope)
        print(rv)
        print(rv.get_json())
        
    print('Test completed')

