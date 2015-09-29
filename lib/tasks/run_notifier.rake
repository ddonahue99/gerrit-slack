desc 'run a GerritNotifier instance'
task :run_notifier => :environment do |t|
  $stdout.reopen(ENV["LOG_OUTPUT"], "w")
  $stdout.sync = true
  GerritNotifier.start!
  $stdout = STDOUT
end
