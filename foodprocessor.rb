#!/usr/bin/env ruby
require 'yaml'
require 'haml'
require 'rainbow'
require_relative 'recipe'

# todo: find a way to process measures and weights: i.e. 4 cups OR 200 g
# todo: possibly double/half quantities in the presentation layer

class FoodProcessor
  class << self
    def read file
      YAML.load(File.read file)
    end

    def process file_path
      r = Recipe.parse(read file_path)
      @recipes << r
      render "recipe", "recipes/#{r.name.gsub(' ','_').strip}.html", { recipe: r }
    end

    def render type, filename, vars={}
      html = haml(type, vars)
      check_and_make(@output + '/' + File.dirname(filename))
      File.write(@output + "/" + filename, html)
    end

    def haml type, vars
      Haml::Engine.new(File.read(@input + "/layouts/layout.haml")).render do
        Haml::Engine.new(File.read(@input + "/layouts/#{type}.haml")).render Object.new, vars
      end
    end

    def indexify
      puts Rainbow("Making index...").green
      render "index", "index.html", { recipes: @recipes.sort_by { |r| r.name } }
    end

    def go input, output
      @input = File.expand_path input rescue abort "Usage: foodProcessor INTPUT OUTPUT"
      @output = File.expand_path output rescue abort "Usage: foodProcessor INTPUT OUTPUT"
      # @input = File.expand_path(input || '.')
      # @output = File.expand_path(output || '.')
      @recipes = []

      puts Rainbow("Looking into ").blue + @input + Rainbow(" for recipes...").blue
      recipes = Dir.glob(@input + '**/*.recipe')
      recipes.each do |recipe|
        puts Rainbow("Processing: ").green + File.basename(recipe)
        process recipe
      end
      indexify
      puts Rainbow("Done!").blue
    end

    def check_and_make folder
      FileUtils.mkdir_p folder unless File.directory? folder
    end
  end
end

