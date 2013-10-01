#
# Author:: Tobias Schmidt (<ts@soundcloud.com>)
# Copyright:: Copyright (c) 2013 SoundCloud, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/knife'

class Chef
  class Knife
    class ScrubAttributes < Knife
      banner 'knife scrub attributes [OPTIONS] PREFIX'

      DEFAULT_QUERY = '*:*'

      deps do
        require 'chef/search/query'
        require 'chef/knife/scrub/attribute_extractor'
      end

      option :query,
        :short => '-q QUERY',
        :long => '--query QUERY',
        :description => "Limit nodes with provided query. Default: #{DEFAULT_QUERY}",
        :default => DEFAULT_QUERY

      def run
        unless prefix = name_args.first
          show_usage
          ui.fatal 'You must specify a prefix of attributes to scrub'
          exit 1
        end

        search = Chef::Search::Query.new
        search.search('node', config[:query]) do |node|
          extractor = Scrub::AttributeExtractor.create(node)

          unless extractor.has_key?(prefix)
            ui.msg format(node, "unknown normal attribute #{prefix}")
            next
          end

          value = extractor.fetch(prefix)
          unless ui.confirm format(node, "Do you want to delete #{value.inspect}")
            next
          end

          if deleted = extractor.delete(prefix)
            node.save
            ui.msg format(node, "deleted normal attribute #{deleted.inspect}")
          else
            ui.msg format(node, "could not delete normal attribute #{prefix}")
          end
        end
      end

      protected

      def format(node, text)
        "#{ui.color(node.fqdn, :cyan)}: #{text}"
      end

    end
  end
end
