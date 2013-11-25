# CloudDSL

DSL for quickly creating test infrastructures.

## Installation

Install the gem using RubyGems:

    $ gem install cloud_dsl

Run a template using:

    $ cloud_dsl mytemplate.rb

## Usage

Creating a simple single instance with SSH access:

`````ruby
aws(access_key_id: "SECRET", secret_access_key: "sEcReT") do
  region "us-west-1" do
    security_group "ssh" do
      allow_cidr("1.2.3.4/32", :tcp, 22)
    end
    
    key_pair "mykey"
    
    instance "ssh-server", image_id: "ami-123456" do
      run "hostname"
    end
  end
end
`````

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
