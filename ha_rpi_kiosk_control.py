#!/usr/bin/python

import RPi.GPIO as GPIO
import time
import subprocess
import logging
import json
import requests
from datetime import datetime

# Set up logging for monitoring
logging.basicConfig(filename='screen_control.log', level=logging.INFO,
                    format='%(asctime)s:%(levelname)s:%(message)s')

# Define API endpoint for remote monitoring
API_URL = "http://example.com/api/update"  # Replace with your actual endpoint

# Set up GPIO
GPIO.setmode(GPIO.BOARD)  # Use GPIO numbers instead of pin numbers
GPIO.setup(7, GPIO.IN)     # Presence sensor
GPIO.setup(19, GPIO.IN)    # Touch sensor

# Track whether the screen is on or off
screen_on = True

def change_brightness(level):
    """Change the screen brightness."""
    subprocess.run(["./RPi-USB-Brightness/64/lite/Raspi_USB_Backlight_nogui", "-b", str(level)])
    logging.info(f'Brightness set to {level}')

def send_status_update(presence_value, touch_value):
    """Send status update to a remote server."""
    payload = {
        'timestamp': datetime.now().isoformat(),
        'presence': presence_value,
        'touch': touch_value,
        'screen_on': screen_on
    }
    try:
        response = requests.post(API_URL, json=payload)
        if response.status_code == 200:
            logging.info('Status update sent successfully.')
        else:
            logging.warning(f'Failed to send status update: {response.status_code}')
    except Exception as e:
        logging.error(f'Error sending status update: {e}')

# Continuous loop
while True:
    # Read sensor values
    presence_value = GPIO.input(7)
    touch_value = GPIO.input(19)

    logging.debug(f'Presence: {presence_value}, Touch: {touch_value}')  # Log sensor readings

    # If the screen state needs to change based on presence
    if screen_on ^ presence_value:
        # Create a range to slowly change the brightness of the screen
        brightness_steps = range(0, 10) if presence_value else reversed(range(0, 10))

        # Slowly change the brightness
        for i in brightness_steps:
            change_brightness(i)
            time.sleep(0.01)

        # Update screen state
        screen_on = presence_value
        logging.info(f'Screen turned {"on" if screen_on else "off"}')

    # Send status update to remote server
    send_status_update(presence_value, touch_value)

    # Wait before the next loop iteration
    time.sleep(1)

# Clean up GPIO on exit
GPIO.cleanup()
