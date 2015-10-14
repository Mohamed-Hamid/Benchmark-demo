class SampleWorker
	include Sidekiq::Worker
	def perform
	end
	# @queue = :sample_queue

 #   def self.perform
 #   end
end