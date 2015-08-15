require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/librarian'

unless ENV['RS_PROVISION'] == 'no' or ENV['BEAKER_provision'] == 'no'
  hosts.each do |host|
    on hosts, "mkdir -p #{host['distmoduledir']}"
    if host['platform'] =~ /osx/i
      on host, 'gem update --system --verbose'
      on host, 'gem install boxen --no-ri --no-rdoc'
    else
      fail("These tests are OSX only")
    end
  end
end

PUPPETFILE = <<-EOM
mod 'boxen', '3.10.3', :github_tarball => 'boxen/puppet-boxen'
EOM

HIERAFILE = <<-EOM
---
boxen::config::home:        "%{::boxen_home}"
boxen::config::bindir:      "%{::boxen_home}/bin"
boxen::config::cachedir:    "%{::boxen_home}/cache"
boxen::config::configdir:   "%{::boxen_home}/config"
boxen::config::datadir:     "%{::boxen_home}/data"
boxen::config::envdir:      "%{::boxen_home}/env.d"
boxen::config::homebrewdir: "%{::homebrew_root}"
boxen::config::logdir:      "%{::boxen_home}/log"
boxen::config::repodir:     "%{::boxen_repodir}"
boxen::config::reponame:    "%{::boxen_reponame}"
boxen::config::socketdir:   "%{::boxen_home}/data/project-sockets"
boxen::config::srcdir:      "%{::boxen_srcdir}"
boxen::config::login:       "%{::github_login}"
boxen::config::repo_url_template: "%{::boxen_repo_url_template}"
boxen::config::download_url_base: "%{::boxen_download_url_base}"
EOM

RSpec.configure do |c|

  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    hosts.each do |host|
      create_remote_file(host, '/tmp/Puppetfile', PUPPETFILE)
      on host, "cd /tmp/ && librarian-puppet install --clean --verbose --path #{host['distmoduledir']}"
      on host, "puppet module install puppetlabs-stdlib"
      write_hiera_config_on(host, [ 'common' ])
      on host, "mkdir -p /etc/puppet/hieradata/"
      create_remote_file(host, '/etc/puppet/hieradata/common.yaml', HIERAFILE)
      copy_module_to(host, :source => proj_root, :module_name => 'java')
    end
  end

  c.treat_symbols_as_metadata_keys_with_true_values = true
end
