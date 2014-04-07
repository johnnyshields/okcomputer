module OKComputer
  class CacheCheck < Check

    ConnectionFailed = Class.new(StandardError)

    # Public: Check whether the cache is active
    def check
      mark_message "Cache is available (#{stats})"
    rescue ConnectionFailed => e
      mark_failure
      mark_message "Error: '#{e}'"
    end

    # Public: Outputs stats string for cache
    def stats
      stats    = Rails.cache.stats
      host     = stats.select{|k,v| k =~ Regexp.new(Socket.gethostname) }.values[0]
      mem_used = to_megabytes host['bytes']
      mem_max  = to_megabytes host['limit_maxbytes']
      return "#{mem_used} / #{mem_max} MB, #{stats.count - 1} peers"
    rescue => e
      raise ConnectionFailed, e
    end

    private

    # Private: Convert bytes to megabytes
    def to_megabytes(bytes)
      bytes.to_i / (1024 * 1024)
    end
  end
end
