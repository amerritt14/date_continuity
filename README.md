# Date Continuity
This is a gem intended to handle start/end/duration

## Contents
  - [Installation](#installation)
    - [Standalone](#standalone)
    - [Bundler](#bundler)
  - [Usage](#usage)
    - [Example](#example)
    - [Start Method](#start-method)
    - [End Method](#end-method)
    - [Duration Method](#duration-method)
    - [Frequency Count Method](#frequency-count-method)
    - [Time Unit Method](#time-unit-method)
  - [Configuration](#configuration)
    - [Example](#example)

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
$ rails generate add_start_at_end_on_and_duration_to_contracts start_at:datetime:index end_on:datetime:index duration:integer
```
and migrate
```shell
$ rails db:migrate
```

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
$ contract = Contract.new(start_at: Date.new(2022, 2, 14), duration: 7)
$ contract.calc_end_at
 => Sun, 20 Feb 2022 00:00:00 +0000
```
Notice that this is not `Date.new(2022, 2, 14) + 7.days` The end on is the LAST time the event happens, which would be `Date.new(2022, 2, 14) + 7.days`
A duration of 1 and a frequency of 1 would mean that the start/end would be the same.

By changing the frequency, it adjusts the calculated end_at date.

```ruby
def frequency
  0.5 # Every Other day
end
```

```shell
$ contract.calc_end_at
 => Sat, 26 Feb 2022 00:00:00 +0000
```

The object including `DateContinuity::Model` needs to respond to a number of methods.

### Start
By default the `start_method` is `start_at`.

The `start_method` value represents the time or date of the first occurance.

It should return the same type as [End](#end). If this method returns a `Date` object, the Time Unit can be configured for anything from a `day` or larger, since a `Date` cannot represent changes in units smaller than a day. If this method returns a `Time`, or a `DateTime` object, the Time Unit can be configured for any of the available units.

### End
By default the `end_method` is `end_at`.

The `end_method` value represents the time or date of the last occurance.

It should return the same type as [Start](#start). If this method returns a `Date` object, the Time Unit can be configured for anything from a `day` or larger, since a `Date` cannot represent changes in units smaller than a day. If this method returns a `Time`, or a `DateTime` object, the Time Unit can be configured for any of the available units.

### Duration
By default the `duration_method` is `duration`.

The Duration is the number of times to repeat.

### Frequency Count
By default the `frequency_count_method` is `frequency`. This is optional, and will default to 1, if no other frequency is specified.

Frequency is best thought of in terms of a fraction.
```ruby
# A frequency of 1
1 == 1 / 1.0
"1 times per 1 time_unit"

# A frequency of 2
2 == 2 / 1.0
"2 times per 1 time_unit"

# A frequency of 0.5
0.5 == 0.5 / 1 == 1 / 2.0
"1 times per 2 time_units"
```
### Time Unit
By default the `time_unit_method` is `time_unit`

The time unit must be one of the following options `second minute hour day week month year`


## Configuration
Most everything is configurable. The methods don't even need to be database columns, so long as the object responds with the appropriate type and value.

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
