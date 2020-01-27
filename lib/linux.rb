# frozen_string_literal: true

# nodoc
module Laptop
  # nodoc
  module Linux
    #----------------------------------------------#
    # => GENERIC
    #----------------------------------------------#
    def self.os_release
      release_file = '/etc/os-release'

      output = {}

      File.read(release_file).each_line do |line|
        line2 = line.chomp.tr('"', '').split('=')
        output[line2[0].to_sym] = line2[1]
      end

      output
    end

    def self.distro_id
      os_release[:ID]
    end

    def self.distro_name
      os_release[:NAME]
    end

    def self.distro
      output = ''
      case
      when self.ubuntu?
        output = :ubuntu
      when self.arch?
        output = :arch
      when self.manjaro?
        output = :manjaro
      when self.fedora?
        output = :fedora
      end

      output
    end

    def self.version_id
      os_release[:VERSION_ID]
    end

    def self.pretty_name
      os_release[:PRETTY_NAME]
    end

    #----------------------------------------------#
    # => UBUNTU
    #----------------------------------------------#
    def self.ubuntu_codename
      os_release[:UBUNTU_CODENAME]
    end

    def self.ubuntu?
      !os_release[:UBUNTU_CODENAME].nil?
    end

    #----------------------------------------------#
    # => ARCH
    #----------------------------------------------#
    def self.arch?
      distro_id == 'arch'
    end

    #----------------------------------------------#
    # => MANJARO
    #----------------------------------------------#
    def self.manjaro?
      distro_id == 'manjaro'
    end

    #----------------------------------------------#
    # => FEDORA
    #----------------------------------------------#
    def self.fedora?
      distro_id == 'fedora'
    end
  end
end
