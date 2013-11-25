module CloudDSL
  class Runner
    def aws(*args, &block)
      Aws.new(*args).tap do |aws|
        aws.instance_exec(&block) if block_given?
      end
    end
  end
end
