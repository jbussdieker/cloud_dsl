require "cloud_dsl/version"
require "cloud_dsl/runner"
require "cloud_dsl/aws"
require "cloud_dsl/region"
require "cloud_dsl/key_pair"
require "cloud_dsl/security_group"
require "cloud_dsl/instance"

module CloudDSL
  def self.logger
    Logger.new(STDOUT).tap do |l|
      l.level = Logger::DEBUG
    end
  end
end
