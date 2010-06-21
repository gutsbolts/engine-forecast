require 'rake'
require 'bundler'
begin
  Bundler.setup(:runtime, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift('lib')

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "jeweler"
  gem.summary = "Forecast your Car Engine's Efficiency"
  gem.email = "theo@gutsbolts.com"
  gem.homepage = "http://github.com/gutsbolts/engine-forecast"
  gem.description = "Forecast your car engine's relative horsepower (and other calculations) by supplying a set of latitude and longitude coordinates."
  gem.authors = ["Theo Mills"]
  gem.files.include %w(lib/jeweler/templates/.document lib/jeweler/templates/.gitignore)

  # dependencies defined in Gemfile
end

Jeweler::GemcutterTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.test_files = FileList.new('test/**/test_*.rb') do |list|
    list.exclude 'test/test_helper.rb'
  end
  test.libs << 'test'
  test.verbose = true
end

namespace :test do
  task :gemspec_dup do
    gemspec = Rake.application.jeweler.gemspec
    dupped_gemspec = gemspec.dup
    cloned_gemspec = gemspec.clone
    puts gemspec.to_ruby
    puts dupped_gemspec.to_ruby
  end
end

require 'rcov/rcovtask'
Rcov::RcovTask.new(:rcov => :check_dependencies) do |rcov|
  rcov.libs << 'test'
  rcov.pattern = 'test/**/test_*.rb'
end

task :default => :test