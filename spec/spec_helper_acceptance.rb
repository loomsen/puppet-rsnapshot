require 'puppet'
require 'beaker-rspec'
require 'yaml'

install_puppet_agent_on hosts, {}

RSpec.configure do |c|
  # Module root and settings
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  module_name = module_root.split('/').last.sub('-', '_').split('_').last()

  c.formatter = :documentation
  c.max_displayed_failure_line_count = 5

  c.before :suite do
    puts 'Install module'
    puppet_module_install(source: module_root, module_name: module_name)

    hosts.each do |host|
      puts 'Install fixtures'
       on host, puppet('module','install','stahnma/epel')
       on host, puppet('module','install','puppetlabs/stdlib')
       on host, puppet('module','install','puppetlabs/concat')
    end
  end
end
