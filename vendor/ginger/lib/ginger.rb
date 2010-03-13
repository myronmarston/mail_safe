require 'rubygems'
require 'ginger/configuration'
require 'ginger/scenario'
require 'ginger/kernel'

module Ginger
  def self.configure(&block)
    yield Ginger::Configuration.instance
  end
end

Kernel.send(:include, Ginger::Kernel)

Ginger::Configuration.detect_scenario_file
