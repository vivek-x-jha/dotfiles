#!/usr/bin/env python3.11

import os
import yaml

STD_PATH = os.path.join(os.getenv('HOME'), '.config')
chatgpt_config_path = os.path.join(os.getenv('XDG_CONFIG_HOME', STD_PATH), 'chatgpt-cli', 'secret.yaml')

try:
    with open(chatgpt_config_path, 'r') as cnf:
        api_key = yaml.safe_load(cnf)['api-key']
    print(api_key)
except FileNotFoundError:
    print("secret.yaml file not found - need it to contain property 'api-key'")

