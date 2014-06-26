#
# has_ip_network_list
#

module Puppet::Parser::Functions
  newfunction(:has_ip_network_list, :type => :rvalue, :doc => <<-EOS
Returns true if the client has an IP address within any of the requested
networks.

This function iterates through the 'interfaces' fact and checks the
'network_IFACE' facts to determine if any of the given networks exist.
    EOS
  ) do |args|

    raise(Puppet::ParseError, "has_ip_network_list(): Wrong number of arguments " +
          "given (#{args.size} for 1)") if args.size != 1


    interfaces = lookupvar('interfaces')
    return false if (interfaces == :undefined)
    interfaces = interfaces.split(',')

    # Create an array of all the networks on the system
    networks = Array.new
    interfaces.each do |iface|
      networks.push(lookupvar("network_#{iface}"))
    end

    # Check to see if any of our test networks exist in the list of networks
    if (networks & args[0]).length > 0
      return true
    else
      return false
    end
  end
end

# vim:sts=2 sw=2
