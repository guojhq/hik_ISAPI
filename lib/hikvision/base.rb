module Hikvision
  class Base
    class << self
      private

      def add_xml(method, url_path)
        iv = :"@#{method}_xml"
        load_method = :"load_#{method}"
        define_method load_method do |options = {}|
          return instance_variable_get(iv) if options.fetch(:cache, true) && instance_variable_defined?(iv)

          url = url_path.respond_to?(:call) ? instance_exec(&url_path) : url_path
          instance_variable_set(iv, @isapi.get_xml(url, options))
        end

        reload_method = method == :base ? :reload : :"reload_#{method}"
        define_method reload_method do |options = {}|
          send(load_method, options.merge(cache: false))
        end
      end

      def add_getter(method, xml_method, path, opts = { cache: true }, &block)
        define_method method do
          v = send(:"load_#{xml_method}", opts).at_xpath(path).inner_html
          v = block.call(v) if block
          v
        end
      end

      def add_list_getter(method, xml_method, path, opts = { cache: true }, &block)
        define_method method do
          send(:"load_#{xml_method}", opts).xpath(path).map do |v|
            v = v.inner_html
            v = block.call(v) if block
            v
          end
        end
      end

      def add_opt_getter(method, xml_method, path, transform = nil, &block)
        define_method method do
          send(:"load_#{xml_method}", cache: true).at_xpath(path)[:opt].split(',').map do |v|
            v = v.send(transform) if transform
            v = block.call(v) if block
            v
          end
        end
      end

      def add_opt_range_getter(method, xml_method, path)
        define_method method do
          data = send(:"load_#{xml_method}", cache: true).at_xpath(path)
          data[:min].to_i..data[:max].to_i
        end
      end

      def add_bool_getter(method, xml_method, path)
        add_getter(method, xml_method, path) { |v| v == 'true' }
      end

      def add_setter(method, xml_method, path, *types, &block)
        update_method = xml_method == :base ? :update : :"update_#{xml_method}"

        if not respond_to? update_method
          define_method update_method do |options = {}|
            send(:"before_#{update_method}") if respond_to? :"before_#{update_method}"

            options[:body] = instance_variable_get(:"@#{xml_method}_xml").to_s
            @isapi.put_xml(respond_to?(:url) ? send(:url) : self.class.url, options)
          end
        end

        define_method method do |value|
          raise TypeError, "#{method}#{value} (#{value.class}) must be of type #{types}" unless types.any? { |k| value.is_a?(k) }

          value = block.call(value) if block
          send(:"load_#{xml_method}", cache: true).at_xpath(path).inner_html = value.to_s
        end
      end
    end
  end
end
