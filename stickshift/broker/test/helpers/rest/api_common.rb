class BaseObj
  def self.to_obj(hash)
    obj = self.new
    obj.attributes=hash
    obj
  end

  def attributes=(hash)
    return nil unless hash

    hash.each do |key,value|
      self.send("#{key}=",value)
    end
    self
  end
end

class RestApi < BaseObj
  attr_accessor :uri, :method, :request, :request_timeout, :response, :response_type, :response_status, :version

  def initialize(uri=nil, method="GET")
    self.uri = uri
    self.method = method
    self.request = {}
    self.request_timeout = 60  # 1 min

    self.response = nil
    self.response_type = nil
    self.response_status = 'ok'
    self.version = nil
  end

  def compare(obj)
    raise_ex("Sub-Classes must implement this method!")
  end
end

def raise_ex(msg, *kw)
  raise Exception.new(msg, *kw)
end

def gen_uuid
  File.open("/proc/sys/kernel/random/uuid", "r") do |file|
    file.gets.strip.gsub("-","")
  end
end

