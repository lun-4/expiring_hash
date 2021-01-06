class ExpiringHash(KeyT, ValueT)
  # backing hash
  property hash : Hash(KeyT, Tuple(Time, ValueT))

  # properties about the expiration of values inside the hash
  property expiry_period : Time::Span

  # Create a new expiring hash.
  def initialize(@expiry_period : Time::Span)
    @hash = Hash(KeyT, Tuple(Time, ValueT)).new
  end

  def []=(key : KeyT, value : ValueT)
    timestamp = Time.utc
    hash[key] = {timestamp, value}
  end

  private def maybe_value(key : KeyT, value : Tuple(Time, ValueT)) : ValueT?
    insertion_timestamp, unwrapped_value = value
    now = Time.utc

    # compare current time and the time of insertion, and see
    # if they are above @expiry_period, and if so, delete
    # the key, and return nil.
    span = now - insertion_timestamp
    if span >= @expiry_period
      @hash.delete(key)
      nil
    else
      unwrapped_value
    end
  end

  def []?(key : KeyT) : ValueT?
    value = hash[key]?
    if value.nil?
      return nil
    end

    maybe_value(key, value)
  end

  def [](key : KeyT) : ValueT
    value = hash[key]?
    if value.nil?
      raise KeyError.new "Missing hash key: #{key.inspect}"
    end

    unwrapped = maybe_value(key, value)
    if unwrapped.nil?
      raise KeyError.new "Missing hash key: #{key.inspect}"
    end

    unwrapped
  end
end
