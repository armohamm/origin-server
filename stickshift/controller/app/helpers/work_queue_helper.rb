require 'beanstalk-client'

module WorkQueueHelper
  def self.beanstalk
    config_info = Rails.application.config.beanstalk
    @beanstalk_client = @beanstalk_client || Beanstalk::Pool.new(config_info[:beanstalkd_pool])
  end
  
  def self.enqueue_ops(ops, parent_object)
    begin
      beanstalk.yput({object: parent_object.class.name, id: parent_object._id.to_s, op_ids: ops.map{|o| o._id.to_s}})
    rescue Exception => e
      Rails.logger.error "Unable to push message to beanstald #{e.message} #{e.backtrace.join("\n")}"
    end
  end
  
  def self.enqueue_ops(ops, parent_object)
    begin
      beanstalk.yput({object: parent_object.class.name, id: parent_object._id.to_s, op_ids: ops.map{|o| o._id.to_s}})
    rescue Exception => e
      Rails.logger.error "Unable to push message to beanstald #{e.message} #{e.backtrace.join("\n")}"
    end
  end
  
  def self.run_jobs
    while true
      job = beanstalk.reserve
      job_data = job.ybody
      
      print "Picked up job #{job_data.pretty_inspect}\n"
      clazz = Kernel.const_get(job_data[:object])
      begin
        obj = clazz.find(job_data[:id])
        pending_ops = obj.pending_ops.where(:_id.in => job_data[:op_ids], :state.ne => :completed)
        if pending_ops.count > 0
          print "Found pending jobs\n"
          print "Run success? "
          print obj.run_jobs
        end
        if pending_ops.count > 0
          job.delete
        end
      rescue Mongoid::Errors::DocumentNotFound
        job.delete
      rescue Exception
        job.unreserve
      end
    end
  end
end