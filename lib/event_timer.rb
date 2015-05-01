require 'ready_pool'
require 'async_emitter'
####################################################################################
# An event timer with second granularity. It inherits from AsyncEmitter and events are 
# captured using the AsyncEmitter methods on and once.
# ==Example
# 
#    require 'event_timer'
#    
#    timer = EventTimer.new 4
#    
#    timer.on :one, lambda { |data| puts "#{data}" }
#    timer.on :two, lambda { |data| puts "#{data}" }
#    timer.on :three, lambda { |data| puts "#{data}" }
#    timer.on :four, lambda { |data| puts "#{data}" }
#    
#    timer.start :one, 1, 1
#    timer.start :two, 2, 2
#    timer.start :three, 3, 3
#    timer.start :four, 4, 4
#    timer.cancel :four
#    
#    gets
#    
# @author Greg Martin
###################################################################################
class EventTimer < AsyncEmitter

	###########################################################################
	# constructor - prepares a ReadyPool for the timers. Timers can be added as 
	# needed bu it is more efficient to add them in the constructor
	#
	# @param num_timers [FixedNum] the number of timers expected
	##########################################################################
	def initialize (num_timers)
		super()
		@pool = ReadyPool.new num_timers, lambda { |args| timer_proc args }
		@th_args = {}
	end

	##########################################################################
	# Start a timer running
	#
	# @param event [Object] the emitter event - and valid hash key
	# @param time [FixedNum] the number pf seconds until the event
	# @param data [Object] data passed to the timer function
	##########################################################################
	def start (event, time, data)
		args = {
			:event => event,
			:time => time,
			:data => data,
			:cancel => false,
			:mutex => Mutex.new,
			:thread => nil
		}
	
		@th_args[args[:event]] = args
			
		@th_args[args[:event]][:thread] = @pool.start args
	end

	##########################################################################
	# Cancel an event
	#
	# @param event [Object] the emitter event - and valid hash key
	##########################################################################
	def cancel (event)
		@th_args[event][:mutex].synchronize do
			@th_args[event][:cancel] = true
			@th_args[event][:thread].run
		end
	end

	protected
	def timer_proc (args)
		sleep args[:time]

		args[:mutex].synchronize do
			if args[:cancel]
				@th_args.delete args[:event] 
				return
			end
		end

		emit args[:event], args[:data]

		@th_args.delete args[:event] 
	end

end

