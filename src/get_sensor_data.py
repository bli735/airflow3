import requests
import logging
import json
from datetime import datetime
import gzip



def get_sensor_data():
    # purpleair api endpoint
    # documentation @ https://docs.google.com/document/d/15ijz94dXJ-YAZLi9iZ_RaBwrZ4KtYeCy08goGBwnbCU/edit?usp=sharing
    url = 'https://www.purpleair.com/json'


    # logging.basicConfig(level=logging.INFO, 
    #                     format='%(asctime)s %(name)-12s %(levelname)-8s %(message)s',
    #                     handlers=[
    #                         logging.FileHandler("filename.log")
    #                     ])

    # initiate logger
    # logger = logging.getLogger(__name__)


    r = requests.get(url)


    #log error responses
    try: 
        r.raise_for_status()
        
        # set filename
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        fname = f'purpleair_{timestamp}'

        # write file to local storage
        with gzip.open(f'data/{fname}.gz', 'wt', encoding="utf-8") as zipfile:
            json.dump(r.json(), zipfile)

    except requests.exceptions.HTTPError as e:
        logger.info(f'Request failed: {e}')


if __name__ == "__main__":
    get_sensor_data()

    




