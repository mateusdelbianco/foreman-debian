module ForemanDebian
  module Initd
   class Script < Template::Storage

      attr_reader :path, :name, :description, :user, :script, :arguments, :pidfile, :stop_signal

      def initialize(path, name, description, user, script, arguments, pidfile, stop_signal)
        @path = path
        @name = name
        @description = description
        @user = user
        @script = script
        @arguments = arguments
        @pidfile = pidfile
        @stop_signal = stop_signal
      end

      def render
        super('initd_script')
      end
    end
  end
end
