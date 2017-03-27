module SKK
  class Entry
    attr_reader :entry, :candidate, :part, :annotation

    def initialize(string)
      @entry, @candidate, @part, @annotation = string.split("\t")
    end

    def valid_entry?
      !(entry =~ /[a-z]/ && entry =~ /[!a-z]/)
    end

    def to_skk(annotation: true, escape: :lisp)
      skk_entries.collect do |skk_entry|
        if annotation
          "#{skk_entry} /#{skk_candidate_with_annotation(escape: escape)}/"
        else
          "#{skk_entry} /#{skk_candidate(escape: escape)}/"
        end
      end
    end

    private

    def skk_entries
      case part
      when /動詞(.)行/
        ["#{entry}#{skk_okuri_alphabet(Regexp.last_match[1])}"]
      when "動詞一段"
        ["#{entry[0..-2]}#{skk_okuri_alphabet(entry[-1])}"]
      when "形容詞"
        ["#{entry}i", "#{entry}k"]
      else
        [entry]
      end
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

    def skk_candidate(escape: :lisp)
      fixed_candidate = part == "動詞一段" ? candidate[0..-2] : candidate

      skk_escape(fixed_candidate, mode: escape)
    end

    def skk_annotation(escape: :lisp)
      skk_escape(annotation, mode: escape)
    end

    def skk_candidate_with_annotation(escape: :lisp)
      if annotation && annotation.length > 0
        "#{skk_candidate(escape: escape)};#{skk_annotation(escape: escape)}"
      else
        skk_candidate(escape: escape)
      end        
    end

    def skk_escape(string, mode: :lisp)
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
  end  
end
