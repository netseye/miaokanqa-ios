class Device
  class << self
    def udid
      udid = `idevice_id -l`.split("\n")[0]
      return udid    
    end
    
    def name
      device_name = `instruments -s devices |grep #{Device.udid} |awk -F "(" '{print $1}'`
      return device_name    
    end
    
    def version
      device_version = `instruments -s devices |grep #{Device.udid} |awk -F "[()]" '{print $2}'`
      return device_version    
    end
  end
end