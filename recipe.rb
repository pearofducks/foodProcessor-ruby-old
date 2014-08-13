require 'slim'
require 'kramdown'

class Recipe
  attr_accessor :name

  def self.parse hash
    r = Recipe.new
    r.name = hash.delete "name"
    r.process hash, 0
    return r
  end

  def html
    Slim::Template.new { @lines.join("\n") }.render()
  end

  def process hash, depth
    @lines ||= []
    id = indent depth
    hd = depth + 3
    begin
    hash.each do |k,v|
      if v.class == String
        amount, type = /(\d.*\d*)\s(.*)/.match(v).captures
        amount = amount.to_f
        amount = amount.to_i if amount == amount.to_i
        measure = case type
                  when "t"
                    amount == 1 || amount < 1 ? "teaspoon" : "teaspoons"
                  when "T"
                    amount == 1 || amount < 1 ? "tablespoon" : "tablespoons"
                  when "c"
                    amount == 1 || amount < 1 ? "cup" : "cups"
                  when "ml"
                    amount == 1 || amount < 1 ? "milliliter" : "milliliters"
                  when "g"
                    amount == 1 || amount < 1 ? "gram" : "grams"
                  when "p"
                    ""
                  else
                    type
                  end
        if k.split(' - ').length == 2
          i = k.split(' - ').map(&:strip)
          k = "<strong>#{i.first}</strong> <em>#{i.last}</em>"
        else
          k = "<strong>#{k}</strong>"
        end
        @lines << "#{id}<li>#{amount} #{measure} #{k}</li>"
      # a "string : !" was encountered in the recipe
      elsif v.nil?
        @lines << "#{id}<li>#{markdown(k).gsub('<p>','').gsub('</p>','')}</li>"
      elsif v.class == Array
        # v.first.split('##').map(&:strip).join("\n1.")
        @lines << "#{id}<h#{hd} class='recipe-header'>#{k}</h#{hd}>"
        @lines << "#{v.map { |line| "#{id}#{markdown line}" }.join("\n") }"
      elsif v.class == Hash
        @lines << "#{id}<h#{hd} class='recipe-header'>#{k}</h#{hd}>"
        @lines << "#{id}ul"
        process v, depth.next
      end
    end
    rescue
      puts Rainbow("ERROR PARSING: ").red + @name
    end
  end

  def markdown line
    Kramdown::Document.new(line).to_html.strip
  end

  def indent depth
    ' ' * 2 * depth
  end
end
