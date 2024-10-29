require_relative "lib/skk/rake_task"

task :default => :convert

["lisp", "aquaskk", "unannotated"].each do |format|
  SKK::RakeTask.new("r13", format)
end
