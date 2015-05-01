#EventTimer
##Ruby EventTimer Implementation 
###Example


```ruby

require 'event_timer'

timer = EventTimer.new 4

timer.on :one, lambda { |data| puts "#{data}" }
timer.on :two, lambda { |data| puts "#{data}" }
timer.on :three, lambda { |data| puts "#{data}" }
timer.on :four, lambda { |data| puts "#{data}" }

timer.start :one, 1, 1
timer.start :two, 2, 2
timer.start :three, 3, 3
timer.start :four, 4, 4
timer.cancel :four

# pause to let events occur
gets


```


