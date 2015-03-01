module ForemanDebian
  class Command::Install < Command

    option %w(-f --procfile), '<path>', 'alternative Procfile',
           :attribute_name => :procfile_path_relative

    option %w(-u --user), '<user>', 'Specify the user the application should be run as',
           :attribute_name => :user,
           :default => 'root'

    option %w(-c --concurrency), '<encoded_hash>', 'concurrency (job1=0,job2=1)',
           :attribute_name => :concurrency_encoded,
           :default => 'all=1'

    option %w(-s --stop-signals), '<encoded_hash>', 'stop-signals (job1=QUIT,job2=TERM)',
           :attribute_name => :stop_signals_encoded,
           :default => 'all=TERM'

    option %w(-d --root), '<path>', 'working dir',
           :attribute_name => :working_dir,
           :default => Dir.getwd

    def execute
      jobs = {}
      procfile.entries do |name, command|
        jobs[name] = expand_procfile_command(command)
      end
      concurrency = decode_concurrency(concurrency_encoded)
      stop_signals = decode_stop_signals(stop_signals_encoded)
      get_engine.install(jobs, concurrency, user, stop_signals, dir_root)
    end

    def expand_procfile_command(command)
      args = Shellwords.split(command)
      args[0] = Pathname.new(args[0]).expand_path(dir_root).to_s
      Shellwords.join(args)
    end

    # @return [Pathname]
    def procfile_path
      path_relative = procfile_path_relative || "#{working_dir}/Procfile"
      Pathname.new(path_relative).expand_path(Dir.getwd)
    end

    # @return [Foreman::Procfile]
    def procfile
      raise "Procfile `#{procfile_path.to_s}` does not exist" unless procfile_path.file?
      Foreman::Procfile.new(procfile_path)
    end

    # @return [Pathname]
    def dir_root
      Pathname.new(working_dir)
    end

    def decode_concurrency(concurrency_encoded)
      concurrency_hash = {}
      concurrency_encoded.split(',').each do |entry|
        parts = entry.split('=')
        raise 'Invalid concurrency option' unless parts.size == 2
        name, concurrency = parts
        concurrency_hash[name] = concurrency.to_i
      end
      concurrency_hash
    end

    def decode_stop_signals(stop_signals_encoded)
      stop_signals_hash = {}
      stop_signals_encoded.split(',').each do |entry|
        parts = entry.split('=')
        raise 'Invalid stop_signals option' unless parts.size == 2
        name, stop_signals = parts
        stop_signals_hash[name] = stop_signals
      end
      stop_signals_hash
    end

  end
end
