# ## a timer
def time(&block)
  t = Time.now
  result = block.call
  puts "\nCompleted in #{(Time.now - t)} seconds\n\n"
  result
end

desc "run tests"
task :test do
    tests = Dir['tests/test_*.rb']
    tests.each do |e|
      p e
      system("ruby -w #{e}")
    end
end

desc "help msg"
task :help do
  system('rake -T')
end

desc "generating docs"
task :doc do
  system("docco -l linear lib/*.rb")
end

desc "show stats of line of code "
task :loc do
  system("cloc *.rb")
end

desc "run robocop"
task :cop do
  system("rubocop **/*.rb")
end

task :default => [:test]
