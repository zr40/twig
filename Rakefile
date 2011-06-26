gemspec = eval(File.read(Dir["*.gemspec"].first))

desc 'Run tests'
task :test do
  puts 'No tests implemented yet'
  #require 'cutest'
  #$: << File.dirname(File.absolute_path __FILE__) + '/lib'
  
  #Cutest.run Dir['test/**/*.rb']
end

desc 'Validate the gemspec'
task :gemspec => :test do
  gemspec.validate
end

desc 'Build gem locally'
task :build => :gemspec do
  system "gem build #{gemspec.name}.gemspec"
  FileUtils.mkdir_p "pkg"
  FileUtils.mv "#{gemspec.name}-#{gemspec.version}-universal-rubinius.gem", 'pkg'
end

desc 'Install gem locally'
task :install => :build do
  system "gem install pkg/#{gemspec.name}-#{gemspec.version}"
end

desc 'Clean automatically generated files'
task :clean do
  FileUtils.rm_rf "pkg"
end
