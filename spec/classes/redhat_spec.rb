require 'spec_helper'

describe 'system_proxy::redhat', :type=> :class do

  let :params do {
    :proxy_uri => 'http://proxy.example.com:80',
  } end

  context 'on a non-RHEL system' do
    let :facts do {
      :operatingsystem => 'Ubuntu',
    } end

    it { expect { should raise_error(Puppet::Error) } }
  end

  describe 'on a RHEL system' do
    let :facts do {
      :operatingsystem => 'RedHat',
    } end

    context 'without a username and password specified' do

      it { should contain_ini_setting('proxy_uri').with(
        'ensure'  => 'present',
        'path'    => '/etc/sysconfig/rhn/up2date',
        'setting' => 'httpProxy',
        'value'   => 'http://proxy.example.com:80',
      )}

      it { should contain_ini_setting('proxy_enable').with(
        'ensure'  => 'present',
        'path'    => '/etc/sysconfig/rhn/up2date',
        'setting' => 'enableProxy',
        'value'   => '1',
      )}

      it { should contain_ini_setting('proxy_auth_enable').with(
        'ensure'  => 'present',
        'path'    => '/etc/sysconfig/rhn/up2date',
        'setting' => 'enableProxyAuth',
        'value'   => '0',
      )}
      it { should_not contain_ini_setting('proxy_user')}
      it { should_not contain_ini_setting('proxy_password')}
    end

    context 'with a username and password specified' do
      let :params do {
        :proxy_uri => 'http://proxy.example.com:80',
        :username  => 'test-user',
        :password  => 'test-password'
      } end

      it { should contain_ini_setting('proxy_auth_enable').with(
        'ensure'  => 'present',
        'path'    => '/etc/sysconfig/rhn/up2date',
        'setting' => 'enableProxyAuth',
        'value'   => '1',
      )}
      it { should contain_ini_setting('proxy_password').with(
        'ensure'  => 'present',
        'path'    => '/etc/sysconfig/rhn/up2date',
        'setting' => 'proxyPassword',
        'value'   => 'test-password',
      )}
      it { should contain_ini_setting('proxy_user').with(
        'ensure'  => 'present',
        'path'    => '/etc/sysconfig/rhn/up2date',
        'setting' => 'proxyUser',
        'value'   => 'test-user',
      )}
    end
  end
end
