module OKComputer
  class MongoidCheck < Check
    # Public: Return the status of the mongodb
    def check
      mark_message "Connected to mongodb #{mongodb_name}"
    rescue ConnectionFailed => e
      mark_failure
      mark_message "Error: '#{e}'"
    end

    # Public: The stats for the app's mongodb
    #
    # Returns a hash with the status of the db
    def mongodb_stats
      if Mongoid.respond_to?(:default_session)
        Mongoid.default_session.command(dbStats: 1) # Mongoid 3+
      else
        Mongoid.database.stats # Mongoid 2
      end
    rescue => e
      raise ConnectionFailed, e
    end

    # Public: The name of the app's mongodb
    #
    # Returns a string with the mongdb name
    def mongodb_name
      mongodb_stats["db"]
    end

    ConnectionFailed = Class.new(StandardError)
  end
end
