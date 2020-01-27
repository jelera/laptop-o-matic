# frozen_string_literal: true

# nodoc
module Laptop
  # nodoc
  module Utilities
    #--------------------------------------------------------------------------#
    # => HELPERS
    #--------------------------------------------------------------------------#
    def self.install_package(package_name, install_method)
      output = nil

      # Command constructor
      Laptop::Settings.parse_config_yml[:supported_os].each do |_k, im_hash|
        im_hash.each do |im_name, im_options|
          next unless im_name.to_s.downcase == install_method.to_s.downcase

          output = "#{im_options[:install_command]} #{package_name}"
          output = "sudo #{output}" if im_options[:sudo]
          break
        end
      end

      # TODO: make execute with system
      puts output unless output.nil?
    end

    def self.add_ppa(ppa_address)
      puts ''
      puts 'Adding PPAs!'.colorize(:light_blue)
      # TODO: make execute with system
      puts "sudo add-apt-repository -y ppa:#{ppa_address}"
      puts 'sudo apt update'
    end

    def self.install_packages_from_list(package_hash)
      distro = Laptop::Linux.distro
      snaps = package_hash[:snap]
      flatpaks = package_hash[:flatpak]
      gems = package_hash[:gem]
      npms = package_hash[:npm]
      pips = package_hash[:pip]

      if snaps
        puts ''
        puts 'Install Snaps!'.colorize(:light_blue)
        snaps.each { |snap| install_package snap, :SNAP }
      end

      if flatpaks
        puts ''
        puts 'Install Flatpaks!'.colorize(:light_blue)
        flatpaks.each { |flatpak| install_package flatpak, :FLATPAK }
      end

      if npms
        puts ''
        puts 'Install NPM packages!'.colorize(:light_blue)
        # TODO: make execute with system
        puts "sudo npm install -g #{npms.join(' ')}"
      end

      if gems
        puts ''
        puts 'Install Ruby gems!'.colorize(:light_blue)
        # TODO: make execute with system
        puts "sudo gem install #{gems.join(' ')}"
      end

      if pips
        pip_command = "pip"
        pip_command += "3" if Laptop::Linux.ubuntu?
        puts ''
        puts 'Install Python Pip packages!'.colorize(:light_blue)
        # TODO: make execute with system
        puts "sudo #{pip_command} install #{pips.join(' ')}"
      end

      puts ''
      puts 'Installing Packages!'.colorize(:light_blue)
      package_hash.each do |install_method, packages|
        next unless install_method == distro

        install_package packages.join(' '), install_method
      end
    end

    def self.install_custom_command_from_list(list)
      distro = Laptop::Linux.distro
      # TODO: make execute with system
      list[distro].each { |cmd| puts cmd } if list[distro]
      list[:snap].each { |cmd| puts cmd } if list[:snap]
      list[:flatpak].each { |cmd| puts cmd } if list[:flatpak]
    end

    #--------------------------------------------------------------------------#
    # => PRINTING METHODS
    #--------------------------------------------------------------------------#
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
      ((term_width - text.size - (decorative.size * 2)) / 2 ).times { output += ' ' }
      output += text
      ((term_width - text.size - (decorative.size * 2)) / 2 ).times { output += ' ' }
      output += decorative
    end

    def self.final_msg
      term_width = Readline.get_screen_size[1]
      print_horizontal_line('#', '#')
      puts '#'
      puts '#'
      puts center_txt('DONE WITH INSTALLING ALL PACKAGES', '#')
      puts '#'
      puts '#'
      print_horizontal_line('#', '#')
      puts
    end

    #--------------------------------------------------------------------------#
    # => MAIN
    #--------------------------------------------------------------------------#

    def self.process_package_list(package_list)
      package_list.each do |package_set|
        print_package_message(package_set[:message], :light_green)

        if package_set[:ppa]
          package_set[:ppa].each { |ppa_address| add_ppa ppa_address }
        end

        if package_set[:pre_custom_commands]
          puts ''
          puts 'Running pre-install commands'.colorize(:light_blue)
          install_custom_command_from_list package_set[:pre_custom_commands]
        end

        install_packages_from_list package_set[:packages]

        if package_set[:post_custom_commands]
          puts ''
          puts 'Running post-install commands'.colorize(:light_blue)
          install_custom_command_from_list package_set[:post_custom_commands]
        end

        print_success_message :green
      end

      final_msg
    end

  end
end
