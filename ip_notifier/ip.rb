#!/usr/bin/env ruby

require 'socket'
require 'timeout'
require 'fileutils'

PREVIOUS = '/home/user/.config/previous_ip'
ROUTER_IP = '192.168.1.1'

# This is the path to our notify-pushover executable
pushover = File.join(File.expand_path(File.dirname(__FILE__)),'notify-pushover')

# Get the current IP by opening a new UDP connection to the router and
# seeing what interface is used
def current_ip
  UDPSocket.open {|s| s.connect(ROUTER_IP, 1); s.addr.last}
end

# Get or set the previous IP
def previous_ip(ip=nil)
  FileUtils.mkdir_p File.dirname(PREVIOUS)
  if ip
    File.open(PREVIOUS,'w'){|f| f.write(ip)}
  else
    File.exists?(PREVIOUS) ? File.read(PREVIOUS) : nil
  end
end

# Run for a maximum of 4 minutes
Timeout::timeout(240) do
  # Keep trying until the interface comes up
  loop do
    # Since the Raspberry does not have a hardware clock, wait for NTP
    # to set the date.
    # This should give us a good idea the network is up
    if Time.now.year == '1970'
      puts "Time not set"
      sleep 10
    else
      if (current = current_ip) != previous_ip
        previous_ip(current)
        msg = "Raspberry's IP is: %s" % current
        # Send the message using pushover
        # Replace this line to use something else
        `#{pushover} "#{msg}"`
      end

      break
    end
  end
end
