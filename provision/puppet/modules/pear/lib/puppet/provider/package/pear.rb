# Puppet PHP PEAR Package support
# Taken from https://raw.github.com/gist/1524864/fdd8fd047aa702587c0b7cce7a77d55dbd781f01/pear.rb

require 'puppet/provider/package'

# PHP PEAR support.
Puppet::Type.type(:package).provide :pear, :parent => Puppet::Provider::Package do
  desc "PHP PEAR support. By default uses the installed channels, but you
        can specify the path to a pear package via ``source``."

  has_feature :versionable
  has_feature :upgradeable

  commands :pearcmd => "pear"

  def self.pearlist(hash)
    # Work around PEAR's bold/italic output.
    old_term = ENV['TERM']
    ENV['TERM'] = 'puppet'
    command = [command(:pearcmd), "list", "-a"]

    begin
      list = execute(command).split("\n").collect do |set|
        if hash[:justme]
          if  set =~ /^hash[:justme]/
            if pearhash = pearsplit(set)
              pearhash[:provider] = :pear
              pearhash
            else
              nil
            end
          else
            nil
          end
        else
          if pearhash = pearsplit(set)
            pearhash[:provider] = :pear
            pearhash
          else
            nil
          end
        end

      end.reject { |p| p.nil? }
    rescue Puppet::ExecutionFailure => detail
      # Restore the old TERM value before bailing out.
      ENV['TERM'] = old_term

      raise Puppet::Error, "Could not list pears: %s" % detail
    end

    # Restore the old TERM value.
    ENV['TERM'] = old_term

    if hash[:justme]
      return list.shift
    else
      return list
    end
  end

  def self.pearsplit(desc)
    case desc
    when /^No entry for terminal/ then return nil
    when /^using dumb terminal/ then return nil
    when /^INSTALLED/ then return nil
    when /^=/ then return nil
    when /^PACKAGE/ then return nil
    when /^$/ then return nil
    when /^\(no packages installed\)$/ then return nil
    when /^(\S+)\s+([.\da-z]+)\s+\S+$/
      name = $1
      version = $2
      return {
        :name => name,
        :ensure => version
      }
    else
      Puppet.warning "Could not match %s" % desc
      nil
    end
  end

  def self.instances
    which('pear') or return []
    pearlist(:local => true).collect do |hash|
      new(hash)
    end
  end

  def self.channellist
    command = [command(:pearcmd), "list-channels"]
    list = execute(command).split("\n").collect do |set|
      if channelhash = channelsplit(set)
        channelhash
      else
        nil
      end
    end.reject { |p| p.nil? }
    list
  end

  def self.channelsplit(desc)
    case desc
    when /^Registered/ then return nil
    when /^=/ then return nil
    when /^Channel/ then return nil
    when /^\s+/ then return nil
    when /^(\S+)/
      $1
    else
      Puppet.warning "Could not match %s" % desc
      nil
    end
  end

  def self.channelaliaslist
    command = [command(:pearcmd), "list-channels"]
    list = execute(command).split("\n").collect do |set|
      if channelaliashash = channelaliassplit(set)
        channelaliashash
      else
        nil
      end
    end.reject { |p| p.nil? }
    list
  end

  def self.channelaliassplit(desc)
    case desc
    when /^Registered/ then return nil
    when /^=/ then return nil
    when /^Channel/ then return nil
    when /^\s+/ then return nil
    when /^(\S+)/
      $2
    else
      Puppet.warning "Could not match %s" % desc
      nil
    end
  end

  def install(useversion = true)

    command = ["upgrade", "--force"]

    # Channel provided
    if source = @resource[:source]

      match = source.match(/^([^|]+)(?:\|(.*))?$/)

      if match
        channel = match[1]
        package = match[2]
      end

      # Check if channel is available, if not, discover
      if match and (!self.class.channellist().include?(channel) and !self.class.channelaliaslist().include?(channel))
        execute([command(:pearcmd), "channel-discover", channel])
      end

      # Check if package is named in source, if not, use hash and append
      if match and (package.nil? or package.empty?) and (! @resource.should(:ensure).is_a? Symbol) and useversion
        source = source + "/#{@resource[:name]}-#{@resource.should(:ensure)}"
      end

      command << channel + '/' + package

    # Default channel
    else
      if (!@resource.should(:ensure).is_a? Symbol) and useversion
        command << "#{@resource[:name]}-#{@resource.should(:ensure)}"
      else
        command << @resource[:name]
      end
    end

    pearcmd(*command)
  end

  def latest
    command = [command(:pearcmd), "remote-info"]

    # Channel provided
    if source = @resource[:source]

      match = source.match(/^([^|]+)(?:\|(.*))?$/)

      if match
        channel = match[1]
        package = match[2]
      end

      # Check if channel is available, if not, discover
      if match and !self.class.channellist().include?(channel)
        execute([command(:pearcmd), "channel-discover", channel])
      end

      # Check if package is named in source, if not, append
      if match and (package.nil? or package.empty?)
        source = source + "/#{@resource[:name]}"
      end

      command << channel + '/' + package
    else
      command << @resource[:name]
    end

    version = ''
    list = execute(command).split("\n").collect do |set|
      if set =~ /^Latest/
        version = set.split[1]
      end
    end

    return version
  end

  def query
    self.class.pearlist(:justme => @resource[:name])
  end

  def uninstall
    output = pearcmd "uninstall", @resource[:name]
    if output =~ /^uninstall ok/
    else
      raise Puppet::Error, output
    end
  end

  def update
    self.install(false)
  end
end
