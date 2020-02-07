# frozen_string_literal: true

# nodoc
module Laptop
  # nodoc
  module Print
    def self.print_package_message(message, color)
      puts ''
      puts ''
      print_horizontal_line('#', '=', color)
      puts '#'.colorize(color)
      puts "# => #{message}".colorize(color)
      puts '#'.colorize(color)
      print_horizontal_line('#', '=', color)
      puts ''
    end

    def self.print_success_message(color)
      puts ''
      puts '✔️  DONE, Successful install!'.colorize(color)
      puts ''
    end

    def self.print_horizontal_line(char1, char2 = '', color = :default)
      term_width = Readline.get_screen_size[1]
      char2 = char1 if char2.empty?
      print char1.colorize(color)
      (term_width - 2).times { print char2.colorize(color) }
      print char1.colorize(color)
    end

    def self.center_txt(text, decorative)
      term_width = Readline.get_screen_size[1]
      output = ''
      output += decorative
      ((term_width - text.size - (decorative.size * 2)) / 2).times { output += ' ' }
      output += text
      ((term_width - text.size - (decorative.size * 2)) / 2).times { output += ' ' }
      output += decorative
    end

    def self.final_msg
      print_horizontal_line('#', '#')
      puts '#'
      puts '#'
      puts center_txt('DONE WITH INSTALLING ALL PACKAGES', '#')
      puts '#'
      puts '#'
      print_horizontal_line('#', '#')
      puts
    end
  end
end
