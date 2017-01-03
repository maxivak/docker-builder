module DockerBuilder
  class Command

    def self.cmd(s)
      puts "running: #{s}"

      res = nil
      Bundler.with_clean_env do
        res = `#{s}`
      end

      puts "#{res}"
    end

  end
end
