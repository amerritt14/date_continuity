# Date Continuity
This is a gem intended to handle start/end/duration

## Installation
### Standalone
`gem install date_continuity`

### Bundler
Add the gem to the Gemfile
```ruby
source "https://rubygems.org"

gem "date_continuity"
```

And execute:
```shell
$ bundle
```

## Usage
Include the `DateContinuity::Model` in the model that you would like to use it with.

```ruby
class Contract < ActiveRecord::Base
  include DateContinuity::Model
end
```

Generate a migration to add the expected columns
```shell
$ rails generate add_start_on_end_on_and_duration_to_contracts start_on:datetime:index end_on:datetime:index duration:integer
```
and migrate
```shell
$ rails db:migrate
```

In addition to `start_on`, `end_on`, and `duration` the model must respond to `time_unit`
The time unit must be one of the following options `second minute hour day week month year`

An optional `frequency` method is used. If not defined, it defaults to 1. This pairs with the time unit to express how many times per time unit the event happens.

### Example

```ruby
class Contract < ActiveRecord::Base
  include DateContinuity::Model

  private

  def time_unit
    "day"
  end
end
```

```shell
$ contract = Contract.new(start_on: Date.new(2022, 2, 14), duration: 7)
$ contract.calc_end_on
 => Sun, 20 Feb 2022 00:00:00 +0000
```
Notice that this is not `Date.new(2022, 2, 14) + 7.days` The end on is the LAST time the event happens, which would be `Date.new(2022, 2, 14) + 7.days`
A duration of 1 and a frequency of 1 would mean that the start/end would be the same.

By changing the frequency, it adjusts the calculated end_on date.

```ruby
def frequency
  0.5 # Every Other day
end
```

```shell
$ contract.calc_end_on
 => Sat, 26 Feb 2022 00:00:00 +0000
```

## Configuration
Most everything is configurable. You can change the names of your start/end/duration columns. In fact, they don't even need to be database columns, so long as the model responds with the appropriate object type.

### Example
This example configuration file contains all the _currently_ configurable settings and their defaults.

```ruby
# config/initializers/date_continuity_initializer.rb

DateContinuity.configure do |config|
  config.duration_method = :duration
  config.end_method = :end_at
  config.frequency_count_method = :frequency
  config.start_method = :start_at
  config.time_unit_method = :time_unit
end
```
