require 'app_conf'
require 'json'

require 'ipecache/plugins'

module Ipecache
  module Runner
    module ClassMethods; end

    module InstanceMethods
      def ipecache_config
        return @ipecache_config unless @ipecache_config.nil?

        @ipecache_config = AppConf.new
        load_paths = [ File.expand_path('config/ipecache-config.yml'), '/etc/ipecache-config.yml', File.expand_path('~/.ipecache/ipecache-config.yml') ]
        load_paths.each do |load_path|
          if File.exists?(load_path)
            @ipecache_config.load(load_path)
          end
        end

        @ipecache_config
      end

      def run_plugins(hook)
        urls = @urls
        Ipecache::Plugins.run(
          :config => ipecache_config,
          :hook => hook.to_sym,
          :urls => urls
        )
      end

      def pretty_print_json(json)
        JSON.pretty_generate(json)
      end
    end

    def self.included(receiver)
      receiver.extend(ClassMethods)
      receiver.send(:include, InstanceMethods)
    end
  end
end
