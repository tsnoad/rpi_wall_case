#!/usr/bin/python

# Instructions for backlight control
#
# This script uses the Waveshare RPi USB Brightness library available at https://github.com/waveshare/RPi-USB-Brightness
# This library appears to work well with Raspbian Bookworm, running Wayland (instead of X), and controlling the 7 inch HDMI screen
#
# Download the library:
# git clone https://github.com/waveshare/RPi-USB-Brightness
# cd RPi-USB-Brightness/64/desktop/
# Install:
# chmod +x install.sh
# ./install.sh
# Test the library by setting brightness to 1 (10%), then to 10 (100%)
# cd ../lite/
# ./Raspi_USB_Backlight_nogui -B 1
# ./Raspi_USB_Backlight_nogui -b 10

import RPi.GPIO as GPIO
import time
import subprocess

#set up gpio
GPIO.setmode(GPIO.BOARD) #use GPIO numbers instead of pin numbers
GPIO.setup(7, GPIO.IN) #presence sensor

#we'll need to keep track of whether we've already turned the screen on or off
screen_on = True

#continuous loop
while True:
        #is someone present?
        presence_value = GPIO.input(7)
        print(presence_value)

        #if someone is present, but the screen is off, or vise-versa
        if screen_on ^ presence_value:
                #create a range which we'll use to slowly change the brightness of the screen
                if presence_value:
                        brightness_steps = range(0,10)
                else:
                        brightness_steps = reversed(range(0,10))

                #slowly change the brightness of the screen
                for i in brightness_steps:
                        subprocess.run(["./RPi-USB-Brightness/64/lite/Raspi_USB_Backlight_nogui", "-b", str(i)])
                        time.sleep(0.01)

                #remember if we've turned the screen on or off
                screen_on = presence_value

        #wait a bit before we run the loop again
        time.sleep(1)
