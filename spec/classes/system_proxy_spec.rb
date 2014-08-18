require 'spec_helper'

describe 'system_proxy', :type=> :class do

  let :params do {
    :proxy_host => 'proxy.example.com',
    :unless_network => ['10.0.0.0'],
  } end

  describe 'on a non-RHEL system' do
    context 'that needs a proxy installed' do
      let :facts do {
        :operatingsystem => 'Ubuntu',
        :osfamily => 'Debian',
        :interfaces => 'eth0,lo',
        :network_eth0 => '192.168.1.0',
      } end

      it { should compile }
      it { should contain_class('system_proxy::params') }
      it { should contain_system_proxy__env_var('HTTP_PROXY').with_value('http://proxy.example.com:80')}
      it { should contain_system_proxy__env_var('http_proxy').with_value('http://proxy.example.com:80')}
      it { should contain_system_proxy__env_var('PIP_PROXY').with_value('http://proxy.example.com:80')}
      it { should contain_file('/etc/apt/apt.conf')}
    end

    context 'that doesn\'t need a proxy installed' do
      let :facts do {
        :operatingsystem => 'Ubuntu',
        :interfaces => 'eth0,lo',
        :network_eth0 => '10.0.0.0',
      } end

      it { should compile }
      it { should contain_class('system_proxy::params') }
      it { should_not contain_system_proxy__env_var('HTTP_PROXY')}
      it { should_not contain_system_proxy__env_var('http_proxy')}
      it { should_not contain_system_proxy__env_var('PIP_PROXY')}
      it { should_not contain_file('/etc/apt/apt.conf')}
    end
  end

  describe 'on a RHEL system' do
    context 'that needs a proxy installed' do
      let :facts do {
        :operatingsystem => 'RedHat',
        :interfaces => 'eth0,lo',
        :network_eth0 => '192.168.1.0',
      } end

      it { should compile }
      it { should contain_class('system_proxy::params') }
      it { should contain_system_proxy__env_var('HTTP_PROXY').with_value('http://proxy.example.com:80')}
      it { should contain_system_proxy__env_var('http_proxy').with_value('http://proxy.example.com:80')}
      it { should contain_system_proxy__env_var('PIP_PROXY').with_value('http://proxy.example.com:80')}
      it { should contain_class('system_proxy::redhat').with_proxy_uri('http://proxy.example.com:80')}
      it { should_not contain_file('/etc/apt/apt.conf')}
    end

    context 'that doesn\'t need a proxy installed' do
      let :facts do {
        :operatingsystem => 'RedHat',
        :interfaces => 'eth0,lo',
        :network_eth0 => '10.0.0.0',
      } end

      it { should compile }
      it { should contain_class('system_proxy::params') }
      it { should_not contain_system_proxy__env_var('HTTP_PROXY')}
      it { should_not contain_system_proxy__env_var('http_proxy')}
      it { should_not contain_system_proxy__env_var('PIP_PROXY')}
      it { should_not contain_class('system_proxy::redhat')}
      it { should_not contain_file('/etc/apt/apt.conf')}
    end
  end
end
