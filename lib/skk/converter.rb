require_relative "entry"

module SKK
  class Converter
    attr_reader :annotation, :escape

    def initialize(annotation: true, escape: :lisp)
      @annotation = annotation
      @escape     = escape
    end

    def convert(dictionary)
      result = ""

      dictionary.each_line do |line|
        line = line.chomp

        next if line.empty?
        next if line.start_with?("#")

        entry = Entry.new(line)

        next unless entry.valid?

        result << entry.to_skk(annotation: annotation, escape: escape).join("\n") + "\n"
      end

      result
    end
  end
end
