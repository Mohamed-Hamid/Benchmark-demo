class HomeController < ApplicationController
  require 'benchmark'

  def index
    ActiveRecord::Base.logger = nil
    Benchmark.bm do |x|
      # Configure the number of seconds used during
      # the warmup phase (default 2) and calculation phase (default 5)
      # x.config(:time => 5, :warmup => 2)

      # These parameters can also be configured this way
      # x.time = 5
      # x.warmup = 2
      x.report("delayed_job enqueue") do
        1000.times do 
          # Resque.enqueue_in(2.minutes, SampleWorker)
          # Resque.enqueue SampleWorker
          # SampleWorker.perform_at (1.minutes.from_now)
          SampleWorker.perform_async
          # Delayed::Job.enqueue CounterWorker.new, run_at: 3.minutes.from_now
        end
      end

      # Typical mode, runs the block as many times as it can
      # x.report("sidekiq") { perform_job }
    end
    # sleep (Delayed::Job.first.run_at - Time.now)
    # sleep (Time.at(Sidekiq::ScheduledSet.new.first.score) - Time.now)
    Benchmark.bm do |x|
      x.report("delayed_job") { perform_job }
    end
  end

  def perform_job
    # while Resque.size('sample_queue') !=0
    while Sidekiq::Queue.new.size != 0 && Sidekiq::ScheduledSet.new.size !=0
    # while ActiveRecord::Base.uncached {Delayed::Job.count} != 0
    end
  end
end
