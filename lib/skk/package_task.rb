require "rake"
require "rake/tasklib"

module SKK
  class PackageTask < Rake::TaskLib
    attr_accessor :version
    attr_accessor :format
    attr_accessor :dst_dir
    attr_accessor :base_name

    def initialize(version, format)
      @version   = version
      @format    = format
      @dst_dir   = "dist"
      @base_name = "SKK-JISYO.th"

      yield(self) if block_given?

      define
    end

    private

    def define
      desc "Package dictionaries"
      task :package => archive_path

      file archive_path do
        chdir(dst_dir) do
          sh "git archive -o #{archive_file} --prefix #{package_name}/ #{version} *.#{format}"
        end
      end
    end

    def package_name
      "#{base_name}.#{format}-#{version}"
    end

    def archive_file
      "#{package_name}.zip"
    end

    def archive_path
      File.join(dst_dir, archive_file)
    end
  end
end
