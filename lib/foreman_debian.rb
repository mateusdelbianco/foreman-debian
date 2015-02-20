module ForemanDebian
  require 'clamp'
  require 'io/console'
  require 'json'
  require 'pathname'
  require 'shellwords'
  require 'erb'
  require 'ostruct'
  require 'fileutils'
  require 'logger'
  require 'open3'
  require 'thwait'
  require 'foreman_debian/template'
  require 'foreman_debian/engine'
  require 'foreman_debian/engine_helper'
  require 'foreman_debian/initd/engine'
  require 'foreman_debian/initd/script'
  require 'foreman_debian/monit/engine'
  require 'foreman_debian/command'
  require 'foreman_debian/command/install'
  require 'foreman_debian/command/uninstall'
  require 'foreman_debian/command/start'
  require 'foreman_debian/command/stop'
  require 'foreman_debian/command_manager'

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.logger=(logger)
    @logger = logger
  end

  Thread.abort_on_exception = true
end
