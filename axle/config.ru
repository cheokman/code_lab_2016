$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "lib")))
puts File.expand_path(File.join(File.dirname(__FILE__), "lib"))
require "axle"

run Axle::Service