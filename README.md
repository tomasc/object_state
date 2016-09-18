# Object State

[![Build Status](https://travis-ci.org/tomasc/object_state.svg)](https://travis-ci.org/tomasc/object_state) [![Gem Version](https://badge.fury.io/rb/object_state.svg)](http://badge.fury.io/rb/object_state) [![Coverage Status](https://img.shields.io/coveralls/tomasc/object_state.svg)](https://coveralls.io/r/tomasc/object_state)

This gem helps to encapsulate state of objects of (typically) Ruby on Rails applications.

* The state becomes easy to identify in the source code.
* There is a standard method for converting the state to and from query params.
* The state can be expressed in the form of a `cache_key`.
* It is possible to additionally typecast and/or validate its attributes.

Useful for pagination, filtering etc.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'object_state'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install object_state
```

## Usage

### Encapsulate object's state

```ruby
class MyObj
  include ObjectState::Owner

  object_state do
    attr_accessor :current_date
  end
end
```

### Export state hash

```ruby
my_obj.to_object_state_hash # => { my_obj => { id: "123", current_date: "2016-08-27" } }
```

This hash can be easily used as query params, for example:

```ruby
my_obj_path(my_obj, my_obj.to_object_state_hash)
```

An attribute can be easily overridden:

```ruby
my_obj_path(my_obj, my_obj.to_object_state_hash(current_date: Date.tomorow))
```

### Assign values from state hash

```ruby
my_obj.assign_attributes_from_object_state_hash(…)
```

The attributes will be assigned only if the id in the state hash matches the id of your object. This is helpful for example when used in controllers.

## Supported attribute definitions

* PoRo (`attr_accessor`)
* Mongoid fields
* Virtus attributes

## Advanced usage

Optionally the state can be processed by a custom class. This is useful when the values need to be typecast, validated, or transformed. The `ObjectState::State` includes `ActiveModel::Model` and `Virtus` so you can use [Virtus' attribute definition](https://github.com/solnic/virtus) and [ActiveModel validations](http://api.rubyonrails.org/classes/ActiveModel/Validations.html). For example:

```ruby
class MyObj::State < ObjectState::State
  attribute :current_date, Date

  validates :current_date, inclusion: { in: Date.today..Date.tomorrow }, presence: true
end
```

Only valid values will be assigned to your object.

```ruby
class MyObj
  include ObjectState::Owner

  object_state class_name: 'MyObj::State' do
    attr_accessor :current_date
  end
end
```

## Cache

Often values or views associated with the object need to be cached (and the cache expired) depending on its state. The `:object_state_cache_key` generates a cache key based on the state's values. For example the `MyObj` from the above example:

```ruby
my_obj.object_state_cache_key # => '2016-08-27'
```

In fact the `object_state` method automatically merges the state object's cache key with the object's cache_key:

```ruby
my_obj.cache_key # => '<object-cache-key>/2016-08-27'
```

This can be disabled as follows:

```ruby
class MyObj
  include ObjectState::Owner

  object_state merge_cache_key: false do
    attr_accessor :current_date
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/tomasc/object_state>.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
