require 'rspec-puppet'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')
end

def default_test_facts
  {
    :boxen_home => '/test/boxen',
    :boxen_user => 'testuser',
    :boxen_repodir   =>  File.join(File.dirname(__FILE__), 'fixtures'),
    :boxen_repo_url_template => "https://github.com/%s",
    :boxen_srcdir    => '~/src',
  }
end
