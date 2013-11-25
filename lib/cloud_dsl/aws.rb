require 'aws'

module CloudDSL
  class Aws
    def initialize(args)
      @args = args
    end

    def client
      AWS::EC2.new(@args)
    end

    def region(name, &block)
      Region.new(self, client.regions[name]).instance_exec &block
    end

    def logger
      Logger.new(STDOUT)
    end
  end
end
