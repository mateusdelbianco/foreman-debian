require 'spec_helper'

describe ForemanDebian::Initd::Engine, :fakefs do

  let(:engine) { ForemanDebian::Monit::Engine.new('app') }

  it 'install script' do
    initd_engine = ForemanDebian::Initd::Engine.new('initd-app')
    script = initd_engine.create_script('initd-foo', 'initd-bar arg1 arg2', 'initd-app-user', 'TERM')
    engine.install('foo', script)
    expect(File.read('/etc/monit/conf.d/app-foo')).to be == spec_resource('monit_config/app-foo')
  end
end
