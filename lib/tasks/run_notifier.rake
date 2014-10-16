desc 'run a GerritNotifier instance'
task :run_notifier => :environment do |t|
  GerritNotifier.start!
end
