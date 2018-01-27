#######################################
# BOOT-INITIAL
#
# This runs first at BNR startup.
# It does everything that is simplest
# if done in bash rather than needing
# careful process control.
########################################

#!/bin/bash

echo "Reset JACK log..."

rm ~/.log/jack/jackdbus.log
touch ~/.log/jack/jackdbus.log

# Reset any saved JACK configuration info
rm -f ~/.jackdrc
rm -f ~/.config/jack/conf.xml
rm -f ~/.config/rncbc.org/QjackCtl.conf

# Configure and start JACK hard server
echo "Configure and start JACK hard server ..."
jack_control ds alsa
jack_control dps device hw:O12,0
jack_control dps rate 96000
jack_control dps period 128
jack_control dps nperiods 3
jack_control dps midi-driver none
jack_control eps realtime True
jack_control eps realtime-priority 90
jack_control eps clock-source 0
jack_control eps sync false
jack_control start

# Make sure a2jmidid is stopped
a2j_control stop

# Configure and start JACK soft servers
# Using identical parameters as hard which may help;
# unclear thus far whether there may be advantageous
# changes

# The dummy driver works, but it shoots up DSP usage v. high
# when load rises
#
# /usr/bin/jackd -nSOFT1 -ddummy -r96000 -p128 > jackd-SOFT1.log &
# /usr/bin/jackd -nSOFT2 -ddummy -r96000 -p128 > jackd-SOFT2.log &
# /usr/bin/jackd -nSOFT3 -ddummy -r96000 -p128 > jackd-SOFT3.log &

/usr/bin/jackd -nSOFT1 -ddummy -r96000 -p256 -C 0 -P 0 > jackd-SOFT1.log &
/usr/bin/jackd -nSOFT2 -ddummy -r96000 -p256 -C 0 -P 0 > jackd-SOFT2.log &
/usr/bin/jackd -nSOFT3 -ddummy -r96000 -p256 -C 0 -P 0 > jackd-SOFT3.log &


# Can be useful to start JACK setup and connection GUIs in place of this
# block of comments during development.
#
# Not using qjackctl anymore, it can cause problems with what we are doing here.
#
# 'cadence' works well for hard JACK setup, and 'catia' for connections.
#
# 'patchage' may be helpful for soft server connections, to help keep visible
# the distinction between hard and soft.  It is unclear whether you will
# ever need a GUI configurator for soft servers.

if [ $1 ]; then
	echo Exiting BOOT-INITIAL due to command-line parameter.
	exit
fi

echo "Starting BOOT-GENERAL..."
/usr/bin/python ~/BNR/BOOT-GENERAL.py

read -rsp $'Press any key to continue...\n' -n1 key

