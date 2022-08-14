#!/bin/bash

# This script is for udev to run when something has blocked wifi.
# Could not figure out what is randomly running rfkill so this will have to do.

# Remember to create a udev rule to accompany this script:
# >sudo cat /etc/udev/rules.d/10-rfkill.rules
#  SUBSYSTEM=="rfkill", ACTION=="change", ATTR{type}=="wlan", RUN+="/home/<USERNAME>/.local/bin/rfkill-remove-softblock.sh"

# https://www.kernel.org/doc/Documentation/rfkill.txt
# https://www.kernel.org/doc/Documentation/ABI/stable/sysfs-class-rfkill

# 0: RFKILL_STATE_SOFT_BLOCKED		turned off by software
# 1: RFKILL_STATE_UNBLOCKED			(potentially) active
# 2: RFKILL_STATE_HARD_BLOCKED		forced off by something outside of the driver's control

if [ "${RFKILL_STATE}" = 0 ]; then
    (
    rfkill unblock all
    ) &
fi
