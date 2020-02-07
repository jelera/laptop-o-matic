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
      file_json = YAML.load_file(file_yml).to_json
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
      parse_config_yml[:supported_os]
    end

    def self.supported_install_methods
      supported_oses.map do |_k, v_hash|
        v_hash.keys
      end.flatten
    end

    #---------------------------------------------------------------#
    # => Linux-specific
    #---------------------------------------------------------------#
    def self.supported_linux_distros
      supported_oses[:LINUX].delete_if do |key|
        %i[SNAP FLATPAK].include? key
      end
    end

    #---------------------------------------------------------------#
    # => Ubuntu-specific
    #---------------------------------------------------------------#
    def self.supported_ubuntu_codenames
      supported_oses[:LINUX][:UBUNTU][:codenames]
    end
  end
end
