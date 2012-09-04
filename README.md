This repo contains some useful scripts for the Raspberry Pi Fedora
Remix.

# notify-pushover
This script uses [Pushover][pushover] to send notifications about your
Raspberry.

You will need a Pushover account.
Then create a new application and generate an application key.

Replace `APP_TOKEN` and `USER_KEY` in the notify-pushover script and
move that script to somewhere in your `$PATH`.

# ip_notifier
This script will alert you if your Raspberry's eth0 IP address changes
when the interface comes back up.

## ip.rb
This script gets the current IP address for eth0 and compares it to
your previous IP address.
If they differ, it will send you a pushover notification.

To install:
* Modify the `PREVIOUS` variable to a location you want to
store the value.
* Make sure the script is executable
* If your router has a different address than `192.168.1.1`, adjust
the `ROUTER_IP` variable accordingly

## 90-pushover
This script gets run any time any of your interfaces come up.

To install:
* Put this file in `/etc/NetworkManager/dispatcher.d/`
* Make sure the script is executable
* Change the path of the script to wherever you installed the `ip.rb`
script

[pushover]: http://pushover.net "Pushover"
