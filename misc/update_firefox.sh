#!/bin/bash
#
# as root
#
# get latest firefox on Debian
#

mkdir -p /opt/firefox
wget -O /tmp/FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
tar xjf /tmp/FirefoxSetup.tar.bz2 -C /opt/firefox/
mv /usr/lib/firefox-esr/firefox-esr /usr/lib/firefox-esr/firefox-esr.old
ln -s /opt/firefox/firefox/firefox /usr/lib/firefox-esr/firefox-esr
