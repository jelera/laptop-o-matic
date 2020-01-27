# frozen_string_literal: true

# nodoc
module Laptop
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
      parse_yml 'config/config.yml'
    end

    def self.parse_linux_yml
      parse_yml 'config/linux.yml'
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
end
