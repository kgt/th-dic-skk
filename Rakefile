CONVERT       = "bin/convert"
FORMATS       = [:lisp, :aquaskk, :unannotated]
SRC_BASEPATH  = "th-dic-r6-google"
DST_BASEPATH  = "dist"
CONCATED_NAME = "SKK-JISYO.th"
FILE_NAMES    = [
  ["thdic-r6-1-作品名.txt",       "SKK-JISYO.th-product"],
  ["thdic-r6-2-キャラクター.txt", "SKK-JISYO.th-character"],
  ["thdic-r6-3-曲名.txt",         "SKK-JISYO.th-music"],
  ["thdic-r6-4-用語.txt",         "SKK-JISYO.th-term"],
  ["thdic-r6-5-スペルカード.txt", "SKK-JISYO.th-spellcard"],
]

def convert_command(src, dst, annotation: true, escape: nil)
  command = CONVERT.dup

  unless annotation
    command << " --no-annotation"
  end

  if escape
    command << " --escape=#{escape}"
  end

  command << " #{src} | skkdic-expr2 > #{dst}"

  command
end

def concat_command(*srcs, dst)
  "skkdic-expr2 #{srcs.join(" + ")} > #{dst}"
end

def src_path(name)
  File.join(SRC_BASEPATH, name)
end

def src_files
  FILE_NAMES.collect {|src, dst| src_path(src) }
end

def dst_path(name, format)
  File.join(DST_BASEPATH, "#{name}.#{format}")
end

def dst_files(format)
  FILE_NAMES.collect {|src, dst| dst_path(dst, format) }
end

def concated_path(format)
  dst_path(CONCATED_NAME, format)
end

task :default => "convert:all"

namespace :convert do
  task :all => FORMATS.collect {|format| "convert:#{format}" }

  FORMATS.each do |format|
    task format => [concated_path(format), *dst_files(format)]
  end
end

FORMATS.each do |format|
  directory DST_BASEPATH

  file concated_path(format) => dst_files(format) do |t|
    sh concat_command(*t.prerequisites, t.name)
  end

  FILE_NAMES.each do |src, dst|
    file dst_path(dst, format) => [src_path(src), DST_BASEPATH] do |t|
      case format
      when :lisp, :aquaskk
        sh convert_command(t.source, t.name, escape: format)
      when :unannotated
        sh convert_command(t.source, t.name, annotation: false)
      else
        sh convert_command(t.source, t.name)
      end
    end
  end
end
