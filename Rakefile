require 'rake'
require 'rspec/core/rake_task'

spec = eval(File.read(Dir["*.gemspec"].first))

desc "Validate the gemspec"
task :gemspec do
  spec.validate
end

desc "Build gem locally"
task :build do
  Dir["*.gem"].each { |f| File.delete(f) }
  system "gem build #{spec.name}.gemspec"
end

desc "Install gem locally"
task :install => :build do
  system "gem install #{spec.name}-#{spec.version}"
end

desc "Run specs"
RSpec::Core::RakeTask.new(:test)
