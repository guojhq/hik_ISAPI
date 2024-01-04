require 'hikvision'
require 'time'

# Syncs camera time with local time

cam = Hikvision::ISAPI.new('192.168.0.32', 'user', 'password')

if cam.system.time.mode == :manual
  now = Time.now

  cam.system.time.now = now
  cam.system.time.update
end
