# expiring_hash

Inspired by [expiringdict](https://github.com/mailgun/expiringdict)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     expiring_hash:
       github: lun-4/expiring_hash
   ```

2. Run `shards install`

## Usage

```crystal
require "expiring_hash"

alias MyCoolCache = ExpiringHash(String, String)

# hash entries can be kept inside the expiring hash for more than 5 minutes,
# trying to access those entires will mean their deletion, though.
#
# if the hash has more than 10 times, all entries that should be deleted will be.
# the insert operation will fail if no entries are invalidated
#
# set max_items to `nil` to remove this behavior
my_cool_cache = MyCoolCache.new(10, 5.minutes)

# use as any hash
my_cool_cache["a"] = "b"
```

## Contributing

1. Fork it (<https://github.com/lun-4/expiring_hash/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [lun-4](https://github.com/lun-4) - creator and maintainer
