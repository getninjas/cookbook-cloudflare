require 'chef/log'
Chef::Log.level = :debug

class Chef::Provider

  # this needs to be done at run time, not compile time
  def load_cloudflare_cookbook_gems
    return if defined? @@cloudflare_cookbook_gems_loaded

    chef_gem 'cloudflare' do
      action :nothing
      source 'https://github.com/b4k3r/cloudflare.git'
    end.run_action(:install, :immediately)

    require 'resolv'
    require 'cloudflare'
    require 'date'

    @@cloudflare_cookbook_gems_loaded = true
  end

end
