module SKK
  class Entry
    attr_reader :entry, :candidate, :part, :annotation

    def initialize(string)
      @entry, @candidate, @part, @annotation = string.split("\t")
    end

    def valid?
      !entry.match?(/[ａ-ｚ]/)
    end

    def verb?
      part.start_with?("動詞")
    end

    def ichidan_verb?
      part == "動詞一段"
    end

    def verb_gyo
      if ichidan_verb?
        entry[-1]
      else
        part =~ /^動詞(.)[行変]/ && Regexp.last_match[1]
      end
    end

    def adjective?
      part == "形容詞"
    end

    def annotation?
      annotation && annotation.length > 0
    end

    def to_skk(annotation: true, escape: :lisp)
      skk_entries.collect do |skk_entry|
        "#{skk_entry} /#{skk_candidate_with_annotation(annotation: annotation, escape: escape)}/"
      end
    end

    private

    def skk_entries
      fixed_entry = ichidan_verb? ? entry[0..-2] : entry
      fixed_entry = replace_invalid_entry_chars(entry)

      case
      when verb?
        ["#{fixed_entry}#{skk_okuri_alphabet(verb_gyo)}"]
      when adjective?
        ["#{fixed_entry}i", "#{fixed_entry}k"]
      else
        [fixed_entry]
      end
    end

    def replace_invalid_entry_chars(entry)
      entry = entry.dup

      {
        "ゔ" => "う゛",
        "０" => "0",
        "１" => "1",
        "２" => "2",
        "３" => "3",
        "４" => "4",
        "５" => "5",
        "６" => "6",
        "７" => "7",
        "８" => "8",
        "９" => "9"
      }.each do |pattern, replace|
        entry.gsub!(pattern, replace)
      end

      entry
    end

    def skk_okuri_alphabet(kana)
      {
        "カ" => "k",
        "ガ" => "g",
        "サ" => "s",
        "ザ" => "z",
        "タ" => "t",
        "ダ" => "d",
        "ナ" => "n",
        "ハ" => "h",
        "バ" => "b",
        "マ" => "m",
        "ヤ" => "y",
        "ラ" => "r",
        "ワ" => "w",
        "め" => "m"
      }[kana]
    end

    def skk_candidate_with_annotation(annotation: true, escape: :lisp)
      result = skk_candidate(escape: escape)

      if annotation && annotation?
        result << ";"
        result << skk_annotation(escape: escape)
      end

      result
    end

    def skk_candidate(escape: :lisp)
      fixed_candidate = ichidan_verb? ? candidate[0..-2] : candidate

      skk_candidate_escape(fixed_candidate, mode: escape)
    end

    def skk_annotation(escape: :lisp)
      skk_annotation_escape(annotation, mode: escape)
    end

    def skk_candidate_escape(string, mode: :lisp)
      if string.match?(/[\/;]/)
        case mode
        when :lisp
          escaped_string = string.gsub(/([\/;"])/) {|c| "\\%03o" % c.ord }

          "(concat \"#{escaped_string}\")"
        when :aquaskk
          string.gsub(/([\/;])/) {|c| "[%02x]" % c.ord }
        when String
          string.gsub(/[\/;]+/, mode)
        else
          string
        end
      else
        string
      end
    end

    def skk_annotation_escape(string, mode: :lisp)
      skk_candidate_escape(string, mode: mode == :aquaskk ? "," : mode)
    end
  end
end
