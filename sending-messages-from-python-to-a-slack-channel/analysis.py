# Import libraries
import sense

import os

!pip install slacker
from slacker import Slacker

token = os.environ["SLACK_API_TOKEN"]

### Do some amazing data science here
message = 'The amazing data science in Python has finished, the result was 42'

slack = Slacker(token)

# Send a message to #sense channel
slack.chat.post_message('#sense', message)
