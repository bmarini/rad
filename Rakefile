require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/clean'
require 'rake/testtask'

task :default => [:test]

task :test do
  Rake::TestTask.new do |t|
    t.libs << "spec"
    t.pattern = 'spec/*_spec.rb'
    t.verbose = true
  end
end

desc 'Measures test coverage'
task :coverage do
  rm_f "coverage"
  rm_f "coverage.data"
  system "rcov -x /Users -Ilib:spec spec/*_spec.rb"
  system "open coverage/index.html" if PLATFORM['darwin']
end