#--
# Author:: Adam Jacob (<adam@opscode.com>)
# Author:: Daniel DeLeo (<dan@opscode.com>)
# Copyright:: Copyright (c) 2008, 2010 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/provider/file'
require 'chef/mixin/template'
require 'chef/mixin/checksum'
require 'chef/file_access_control'

class Chef
  class Provider

    class RemoteTemplate < Chef::Provider::Template

      def template_location
        source = @new_resource.source
        begin
          rest = Chef::REST.new(source, nil, nil, {})
          raw_file = rest.streaming_request(rest.create_url(source), {})
        rescue SocketError, Errno::ECONNREFUSED, Timeout::Error, Net::HTTPFatalError => e
          Chef::Log.debug("#{@new_resource} cannot be downloaded from #{source}")
          raise e
        end
        raw_file.path
      end
    end
  end
end


class Chef
  class Resource
    class RemoteTemplate < Chef::Resource::Template
      include Chef::Mixin::Securable

      provides :remote_template, :on_platforms => :all

      def initialize(name, run_context=nil)
        super
        @resource_name = :remote_template
        @action = "create"
        @source = "#{::File.basename(name)}.erb"
        @cookbook = nil
        @local = false
        @variables = Hash.new
        @provider = Chef::Provider::RemoteTemplate
      end

      def source(file=nil)
        set_or_return(
          :source,
          file,
          :kind_of => [ String ]
        )
      end

      def variables(args=nil)
        set_or_return(
          :variables,
          args,
          :kind_of => [ Hash ]
        )
      end

      def cookbook(args=nil)
        set_or_return(
          :cookbook,
          args,
          :kind_of => [ String ]
        )
      end

      def local(args=nil)
        set_or_return(
          :local,
          args,
          :kind_of => [ TrueClass, FalseClass ]
        )
      end

    end
  end
end

