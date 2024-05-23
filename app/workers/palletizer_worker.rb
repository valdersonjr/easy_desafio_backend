class PalletizerWorker
    include Sidekiq::Worker
  
    def perform(load_code)
      redis = Redis.new
      lock_key = "palletizer_lock_#{load_code}"
  
      if redis.setnx(lock_key, Time.now.to_i)
        begin
          palletizer(load_code)
        ensure
          redis.del(lock_key)
        end
      end
    end
end