class ExpiringHash(KeyT, ValueT)
  # backing hash
  property hash : Hash(KeyT, Tuple(Time, ValueT))

  # hash properties
  property expiry_period : Time::Span
  property max_items : Int

  # create a new expiring hash
  def initialize(@max_items : Int, @expiry_period : Time::Span)
    @hash = Hash(KeyT, Tuple(Time, ValueT)).new
  end

  def []=(key : KeyT, value : ValueT)
    timestamp = Time.utc

    if hash.size >= @max_items
      freed = false

      @hash.each do |key, value|
        # try to fetch the key via the maybe-invalidate logic
        # and if the value got invalidated, we are sure that we have one entry
        # free in the hash to put things in
        unwrapped_value = maybe_value(key, value)
        if unwrapped_value.nil?
          freed = true
        end
      end

      if !freed
        raise "hash too full"
      end
    end

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
