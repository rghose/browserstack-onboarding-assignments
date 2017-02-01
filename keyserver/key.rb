require 'securerandom'

class UniqueKey

  $UNBLOCK_TIMEOUT = 60
  $ACCESS_TIMEOUT = 60*5

  def initialize
    @all_keys = Hash.new
    @blocked_keys = Hash.new
    @deleted_keys = Hash.new
    super
  end

	def new
    key = SecureRandom.uuid
    while @deleted_keys.key?(key)
      key = SecureRandom.uuid
    end
    $LOG.info "Generated keys: #{key}"
		@all_keys[key] = {:access_time => Time.now }
    key
	end

	def get_available
    $LOG.info "Available keys: #{@all_keys}"
    selected_key = @all_keys.keys.sample
    time_now = Time.now

    $LOG.info @all_keys[selected_key]

    # Trying to access after timeout
    while @all_keys[selected_key] and @all_keys[selected_key][:access_time] + $ACCESS_TIMEOUT < time_now
      delete_key(selected_key)
      selected_key = @all_keys.keys.sample
    end
    return selected_key
	end

	def unblock_key(k)
		if @blocked_keys.key?(k)
      data = @blocked_keys[k]
      @blocked_keys.delete(k)

      time_now = Time.now

      # Trying to access after timeout
      if data[:access_time] + $ACCESS_TIMEOUT < time_now
        @deleted_keys[k] = data
        return false
      end

      data[:access_time] = time_now
      @all_keys[k] = data
			return true
		end
		false
	end

	def block_key(k)
		if @all_keys.key?(k)
      data = @all_keys[k]
      @all_keys.delete(k)

      time_now = Time.now

      # Trying to access after timeout
      if data[:access_time] + $ACCESS_TIMEOUT < time_now
        @deleted_keys[k] = data
        return false
      end

      data[:access_time] = time_now
      @blocked_keys[k] = data
			return true
		end
		false
	end

	def delete_key(k)
		if @all_keys.key?(k)
      @deleted_keys[k] = @all_keys[k]
			@all_keys.delete(k)
			return true
    elsif @blocked_keys.key?(k)
      @deleted_keys[k] = @blocked_keys[k]
      @blocked_keys.delete(k)
      return true
		end
		false
  end

  def update_time(k)
    time_now = Time.now
    if @all_keys.key?(k)
      data = @all_keys[k]
      @all_keys.delete(k)

      # Trying to access after timeout
      if data[:access_time] + $ACCESS_TIMEOUT < time_now
        @deleted_keys[k] = data
        return false
      end

      data[:access_time] = time_now
      @all_keys[k] = data
      return true
    elsif @blocked_keys.key?(k)
      data = @blocked_keys[k]
      @blocked_keys.delete(k)

      # Trying to access after timeout
      if data[:access_time] + $ACCESS_TIMEOUT < time_now
        @deleted_keys[k] = data
        return false
      end

      data[:access_time] = time_now
      @blocked_keys[k] = data
      return true
    end
  end
end
