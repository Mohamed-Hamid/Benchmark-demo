class DebugUtils
  def self.run_in_sql_transaction
    ActiveRecord::Base.transaction do
      yield
    end
  end

  def self.time_some_code
    time = Benchmark.realtime do
      yield
    end
    puts "Time elapsed #{time*1000} milliseconds"
  end


  def self.run_without_ar_logs
    @@old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
    result = yield
    ActiveRecord::Base.logger = @@old_logger
    result
  end

  def self.run_without_sunspot_logs
    @@log_level = Sunspot::Rails::LogSubscriber.logger.level
    Sunspot::Rails::LogSubscriber.logger.level  = 4
    result = yield
    Sunspot::Rails::LogSubscriber.logger.level  = @@log_level
    result
  end

  def self.run_without_ar_and_sunspot_logs
    run_without_ar_logs do
      run_without_sunspot_logs do
        yield
      end
    end
  end

  def self.time_without_ar_logs
    time_some_code do
      run_without_ar_logs do
        yield
      end
    end
  end

  def self.time_without_logs
    time_some_code do
      run_without_ar_logs do
        run_without_sunspot_logs do
          yield
        end
      end
    end
  end
end