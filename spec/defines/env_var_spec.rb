require 'spec_helper'

describe 'system_proxy::env_var', :type => :define do
  let :title do
    'http_proxy'
  end

  let :params do {
    :value => 'http://proxy.example.com:80',
  } end

  context 'on all systems' do
    it { should contain_ini_setting('env-http_proxy').with(
      'value' => 'http://proxy.example.com:80',
    )}
  end

end
