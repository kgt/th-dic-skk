require_relative "lib/skk/convert_task"
require_relative "lib/skk/package_task"

task :default => :convert

SKK::ConvertTask.new("r7", "lisp")
SKK::ConvertTask.new("r7", "aquaskk")
SKK::ConvertTask.new("r7", "unannotated")
SKK::PackageTask.new("r7", "lisp")
SKK::PackageTask.new("r7", "aquaskk")
SKK::PackageTask.new("r7", "unannotated")
