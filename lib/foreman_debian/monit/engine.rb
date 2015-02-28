module ForemanDebian
  module Monit
    class Engine

      include ForemanDebian::EngineHelper

      def initialize(app, export_path = nil)
        @app = app
        @export_path = Pathname.new(export_path || '/etc/monit/conf.d')
        setup
      end

      def install(name, script)
        name = "#{@app}-#{name}"

        FileUtils.mkdir_p(@export_path)
        template = Template.new('monit_config')
        output = template.render({
                                     :app => @app,
                                     :name => name,
                                     :script_pidfile => script.pidfile,
                                     :script_path => script.path,
                                 })
        config_path = @export_path.join(name + '.conf')
        File.open(config_path, 'w') do |file|
          file.puts(output)
          export_file(config_path)
        end
      end
    end
  end
end
