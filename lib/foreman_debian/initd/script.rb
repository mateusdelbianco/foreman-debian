module ForemanDebian
  module Initd
   class Script < Template::Storage

      attr_reader :path, :name, :description, :user, :script, :arguments, :pidfile, :stop_signal, :dir_root

      def initialize(path, name, description, user, script, arguments, pidfile, stop_signal, dir_root)
        @path = path
        @name = name
        @description = description
        @user = user
        @script = script
        @arguments = arguments
        @pidfile = pidfile
        @stop_signal = stop_signal
        @dir_root = dir_root
      end

      def render
        super('initd_script')
      end
    end
  end
end
