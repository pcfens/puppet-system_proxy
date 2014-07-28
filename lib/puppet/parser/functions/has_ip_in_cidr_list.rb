#
# has_ip_in_cidr_list
#

module Puppet::Parser::Functions
  newfunction(:has_ip_in_cidr_list, :type => :rvalue, :doc => <<-EOS
Returns true if the client has an IP address within any of the given ranges.
    EOS
  ) do |args|

    raise(Puppet::ParseError, "has_ip_in_cidr_list(): Wrong number of arguments " +
          "given (#{args.size} for 1)") if args.size != 1


    interfaces = lookupvar('interfaces')
    return false if (interfaces == :undefined)
    interfaces = interfaces.split(',')

    args[0].each do |cidr|
      network = IPAddr.new(cidr)
      interfaces.each do |iface|
        address = lookupvar("ipaddress_#{iface}")
        unless address == ''
          ip = IPAddr.new(address)
          if network.include?(ip)
            return true
          end
        end
      end
    end

    return false
  end
end

# vim:sts=2 sw=2
