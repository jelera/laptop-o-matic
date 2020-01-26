require 'pry'

# nodoc
module Settings
  #---------------------------------------------------------------#
  # => HELPERS
  #---------------------------------------------------------------#
  def self.parse_yml(file_yml)
    # This returns a all-keys-as-symbols hash from YAML file
    file_yml_path = file_yml
    file_json = YAML.load_file(file_yml_path).to_json
    JSON.parse(file_json, symbolize_names: true)
  end

  #---------------------------------------------------------------#
  # => Parsers
  #---------------------------------------------------------------#
  def self.parse_config_yml
    parse_yml 'config.yml'
  end

  def self.parse_linux_yml
    parse_yml 'linux.yml'
  end

  def self.supported_oses
    parse_config_yml[:supported_os].keys
  end

  def self.supported_install_methods
    parse_config_yml[:supported_os].map do |_k, v_hash|
      v_hash.keys
    end.flatten
  end

  #---------------------------------------------------------------#
  # => Utilities
  #---------------------------------------------------------------#
  def self.install_package(package_name, install_method)
    output = nil

    # Command constructor
    parse_config_yml[:supported_os].each do |_k, im_hash|
      im_hash.each do |im_name, im_options|
        next unless im_name.to_s.downcase == install_method.to_s.downcase
        output = "#{im_options[:install_command]} #{package_name}"
        output = "sudo #{output}" if im_options[:sudo]
        break
      end
    end

    system output unless output.nil?

  end

  #---------------------------------------------------------------#
  # => Linux-specific
  #---------------------------------------------------------------#
  def self.supported_linux_distros
    parse_config_yml[:supported_os][:LINUX].delete_if do |key|
      %i[SNAP FLATPAK].include? key
    end
  end

  #---------------------------------------------------------------#
  # => Ubuntu-specific
  #---------------------------------------------------------------#
  def self.supported_ubuntu_codenames
    parse_config_yml[:supported_os][:LINUX][:UBUNTU][:codenames]
  end
end
