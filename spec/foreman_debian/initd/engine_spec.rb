require 'spec_helper'

describe ForemanDebian::Initd::Engine, :fakefs do

  module ForemanDebian::EngineHelper
    attr_reader :commands_run

    def exec_command(command)
      @commands_run ||= []
      @commands_run.push command
    end
  end

  let(:engine) { ForemanDebian::Initd::Engine.new('app') }

  it 'creates script' do
    script = engine.create_script('foo', 'foo arg1 arg2', 'app-user', 'QUIT')

    expect(script.path.to_s).to be == '/etc/init.d/app-foo'
    expect(script.name).to be == 'app-foo'
    expect(script.description).to be == 'app-foo'
    expect(script.user).to be == 'app-user'
    expect(script.arguments).to be == %w(arg1 arg2)
    expect(script.pidfile.to_s).to be == '/var/run/app-foo/app-foo.pid'
    expect(script.stop_signal).to be == 'QUIT'
  end

  it 'installs script' do
    script = engine.create_script('foo', 'bar arg1 arg2', 'app-user', 'TERM')
    engine.install(script)
    expect(File.read('/etc/init.d/app-foo')).to be == spec_resource('initd_script/app-foo')
  end

  it 'installs script with custom quit' do
    script = engine.create_script('foo', 'bar arg1 arg2', 'app-user', 'QUIT')
    engine.install(script)
    expect(File.read('/etc/init.d/app-foo')).to be == spec_resource('initd_script_with_custom_stop_signal/app-foo')
  end

  it 'starts script' do
    script_path = Pathname.new('/etc/init.d/foo')
    engine.start_file(script_path)
    expect(engine.commands_run).to be == ['/etc/init.d/foo start', 'update-rc.d foo defaults']
  end

  it 'stops script' do
    script_path = Pathname.new('/etc/init.d/foo')
    engine.stop_file(script_path)
    expect(engine.commands_run).to be == ['/etc/init.d/foo stop', 'update-rc.d -f foo remove']
  end
end
