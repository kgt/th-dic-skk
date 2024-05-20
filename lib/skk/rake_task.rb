require "rake"
require "rake/tasklib"
require "rake/clean"

module SKK
  class RakeTask < Rake::TaskLib
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

      define_convert_task
      define_package_task
    end

    private

    def define_convert_task
      desc "Convert dictionaries"
      task :convert => "convert:#{format}"

      desc "Convert dictionaries for #{format}"
      task "convert:#{format}" => [concated_file_path, *dst_file_paths]

      directory dst_dir

      file concated_file_path => [dst_dir, *dst_file_paths] do
        concat dst_file_paths, concated_file_path
      end
      CLOBBER << concated_file_path

      dst_file_paths.zip(src_file_paths).each do |dst_file_path, src_file_path|
        file dst_file_path => [dst_dir, src_file_path] do
          convert src_file_path, dst_file_path
        end
        CLOBBER << dst_file_path
      end
    end

    def define_package_task
      desc "Package dictionaries"
      task :package => archive_path

      file archive_path do
        chdir(dst_dir) do
          sh "git archive -o #{archive_file} --prefix #{package_name}/ #{version} #{concated_file_name} #{dst_file_names.join(" ")}"
        end
      end
      CLOBBER << archive_path
    end

    def src_dir
      "th-dic-#{version}-google"
    end

    def src_file_names
      [
        "thdic-#{version}-1-作品名.txt",
        "thdic-#{version}-2-キャラクター名.txt",
        "thdic-#{version}-3-曲名.txt",
        "thdic-#{version}-4-用語.txt",
        "thdic-#{version}-5-スペルカード.txt"
      ]
    end

    def src_file_paths
      src_file_names.map do |file_name|
        File.join(src_dir, file_name)
      end
    end

    def dst_file_names
      [
        "product",
        "character",
        "music",
        "term",
        "spellcard"
      ].map do |suffix|
        "#{base_name}-#{suffix}.#{format}"
      end
    end

    def dst_file_paths
      dst_file_names.map do |file_name|
        File.join(dst_dir, file_name)
      end
    end

    def concated_file_name
      "#{base_name}.#{format}"
    end

    def concated_file_path
      File.join(dst_dir, concated_file_name)
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

    def convert(src_file_path, dst_file_path)
      command = "bin/convert"

      case format
      when "lisp", "aquaskk"
        command << " --escape=#{format}"
      when "unannotated"
        command << " --no-annotation"
      end

      command << " #{src_file_path} | skkdic-expr2 > #{dst_file_path}"

      sh command
    end

    def concat(src_file_paths, dst_file_path)
      sh "skkdic-expr2 #{src_file_paths.join(" + ")} > #{dst_file_path}"
    end
  end
end
