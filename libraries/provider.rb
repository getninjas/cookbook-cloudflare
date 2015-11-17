class Chef::Provider

  # this needs to be done at run time, not compile time
  def load_cloudflare_cookbook_gems
    return if defined? @@cloudflare_cookbook_gems_loaded

    chef_gem 'cloudflare' do
      action :nothing
      provider Chef::Provider::Package::Rubygems::SpecificInstall
      options "-l #{node['cloudflare']['gem']['repo_url']} -b #{node['cloudflare']['gem']['revision']}"
    end.run_action(:install, :immediately)

    require 'resolv'
    require 'cloudflare'
    require 'date'

    @@cloudflare_cookbook_gems_loaded = true
  end

end
