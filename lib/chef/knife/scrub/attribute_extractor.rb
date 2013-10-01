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

class Chef
  class Knife
    module Scrub
      class AttributeExtractor

        class Base
          def initialize(node, precedence)
            @node = node
            @precedence = precedence
          end

          def has_key?(key)
            raise NotImplementedError
          end

          def fetch(key)
            raise NotImplementedError
          end

          def delete(key)
            raise NotImplementedError
          end

        protected

          def attributes
            @node.send(@precedence)
          end

          def extract(data, nested_value_spec)
            spec = nested_value_spec.split(".")
            key = spec.pop
            spec.each do |attr|
              if data.nil?
                nil # don't get no method error on nil
              elsif data.respond_to?(attr.to_sym)
                data = data.send(attr.to_sym)
              elsif data.respond_to?(:[])
                data = data[attr]
              else
                data = begin
                  data.send(attr.to_sym)
                rescue NoMethodError
                  nil
                end
              end
            end
            [data, key]
          end

        end

        class Simple < Base
          def has_key?(path)
            base, key = extract(attributes, path)
            !base.nil? && base.has_key?(key)
          end

          def fetch(path)
            base, key = extract(attributes, path)
            base.fetch(key)
          end

          def delete(path)
            base, key = extract(attributes, path)
            base.delete(key)
          end
        end

        class Weird < Base
          def has_key?(path)
            base, key = extract(attributes, path)
            !base.nil? && base.component_has_key?(base.send(@precedence), key)
          end

          def fetch(path)
            base, key = extract(attributes, path)
            base.value_at_current_nesting(base.send(@precedence), key).fetch(key)
          end

          def delete(path)
            base, key = extract(attributes, path)
            base.delete_from_component(base.send(@precedence), key)
          end
        end

        def self.create(node, precedence = :normal)
          if node.attribute.respond_to?(:component_has_key?)
            Weird.new(node, precedence)
          else
            Simple.new(node, precedence)
          end
        end

      end
    end
  end
end
