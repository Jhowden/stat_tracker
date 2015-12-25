require 'logger'

module EASHLStatTracker
  class DistortedFormatter
    FORMAT = "%s, [%s#%d] %5s : %s\n"

    def call( severity, time, progname, msg )
      FORMAT % [
        severity[0..0], format_datetime(time), $$, severity, msg
      ]
    end

    def format_datetime( time )
      time.strftime("%Y-%m-%dT%H:%M:%S.") << "%06d " % time.usec
    end
  end

  class DistortedLogger < Logger
    def initialize( environment )
      super File.expand_path( File.join(
        File.dirname(__FILE__), "..", "..", "..", "log", "#{environment}.log"
        ) )
      self.formatter = DistortedFormatter.new
    end
  end
end