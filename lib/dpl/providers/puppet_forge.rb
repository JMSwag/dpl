module Dpl
  module Providers
    class PuppetForge < Provider
      gem 'puppet', '~> 5.5.14', require: 'puppet/face'
      gem 'puppet-blacksmith', '~> 3.3.1', require: 'puppet_blacksmith'

      full_name 'Puppet Forge'

      description sq(<<-str)
        tbd
      str

      opt '--user NAME', 'Puppet Forge user name', required: true
      opt '--password PASS', 'Puppet Forge password', required: true
      opt '--url URL', 'Puppet Forge URL to deploy to', default: 'https://forgeapi.puppetlabs.com/'

      msgs upload: 'Uploading to Puppet Forge %s/%s'

      def validate
        file.metadata
      end

      def deploy
        build
        info :upload, forge.username, file.name
        forge.push!(file.name)
      end

      def file
        @file ||= Blacksmith::Modulefile.new
      end

      def build
        Puppet::Face['module', :current].build('./')
      end

      def forge
        @forge ||= Blacksmith::Forge.new(user, password, url)
      end
    end
  end
end