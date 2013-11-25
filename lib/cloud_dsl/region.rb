module CloudDSL
  class Region
    def initialize(account, region)
      @account = account
      @region = region
    end

    def logger
      Logger.new(STDOUT).tap do |l|
        l.level = Logger::INFO
      end
    end

    def security_group(name, &block)
      begin
        sg = @region.security_groups.create(name)
      rescue AWS::EC2::Errors::InvalidGroup::Duplicate => e
        sg = @region.security_groups.find {|sg| sg.name == name}
        logger.debug "Already exists #{sg.id}"
      end
      SecurityGroup.new(self, sg).tap do |sg|
        sg.instance_exec &block if block_given?
      end
    end

    def key_pair(name)
      filename = "keys/#{@region.name}-#{name}.pem"
      begin
        key_pair = @region.key_pairs.create(name)
        File.open(filename, "w") do |f|
          f.write(key_pair.private_key)
        end
      rescue AWS::EC2::Errors::InvalidKeyPair::Duplicate => e
        key_pair = @region.key_pairs[name]
        unless File.exists? filename
          logger.debug "Key exists but can't find private key"
        else
          key_pair.instance_eval { @private_key = File.read(filename) }
        end
      end
      KeyPair.new(self, key_pair)
    end

    def xinstance(*args)
    end

    def instance(name, args = {}, &block)
      instance = nil
      AWS.memoize do
        @region.instances.each do |check_instance|
          instance = check_instance if check_instance.tags["Name"] == name
        end
      end
      unless instance
        logger.debug "Instance not found. Creating..."
        instance = @region.instances.create(args)
        instance.tags["Name"] = name
      else
        logger.debug "Found instance"
      end
      Instance.new(self, instance).tap do |instance|
        instance.instance_exec &block if block_given?
      end
    end
  end
end
