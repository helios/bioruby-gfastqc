# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "bio-gfastqc"
  gem.homepage = "http://github.com/helios/bioruby-gfastqc"
  gem.license = "MIT"
  gem.summary = %Q{Aggregate FastQC (quality control for Next Generation Sequencing -NGS-)}
  gem.description = %Q{Bioinformatics. Aggregate FastQC (quality control for Next Generation Sequencing -NGS-) results from many different samples in a single web page, with charts and tables organized and simplified. The main goal is to speed up the communication process with colleagues (PIs, Biologists, BioInformaticians).}
  gem.email = "ilpuccio.febo@gmail.com"
  gem.authors = ["Raoul Jean Pierre Bonnal"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['test'].execute
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "bio-gfastqc #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
