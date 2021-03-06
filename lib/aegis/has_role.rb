module Aegis
  module HasRole

    def validates_role_name(options = {})
      validates_each :role_name do |record, attr, value|
        options[:message] ||= ActiveRecord::Errors.default_error_messages[:inclusion]
        role = ::Permissions.find_role_by_name(value)
        record.errors.add attr, options[:message] if role.nil?
      end
    end

    alias_method :validates_role, :validates_role_name

    def has_role(options = {})

      if options[:name_accessor]
        options[:name_reader] = "#{options[:name_accessor]}"
        options[:name_writer] = "#{options[:name_accessor]}="
        options.delete(:name_accessor)
      end

      self.class_eval do

        class_inheritable_accessor :aegis_role_name_reader, :aegis_role_name_writer

        self.aegis_role_name_reader = (options[:name_reader] || "role_name").to_sym
        self.aegis_role_name_writer = (options[:name_writer] || "role_name=").to_sym

        def aegis_role_name_reader
          self.class.class_eval{ aegis_role_name_reader }
        end

        def aegis_role_name_writer
          self.class.class_eval{ aegis_role_name_writer }
        end

        def aegis_role_name
          send(aegis_role_name_reader)
        end

        def aegis_role_name=(value)
          send(aegis_role_name_writer, value)
        end

        def role
          ::Permissions.find_role_by_name!(aegis_role_name)
        end

        def role=(role_or_name)
          self.aegis_role_name = if role_or_name.is_a?(Aegis::Role)
            role_or_name.name
          else
            role_or_name.to_s
          end
        end

        private

        # Delegate may_...? and may_...! methods to the user's role.
        def method_missing_with_aegis_permissions(symb, *args)
          method_name = symb.to_s
          if method_name =~ /^may_(.+?)[\!\?]$/
            role.send(symb, self, *args)
          elsif method_name =~ /^(.*?)\?$/ && queried_role = ::Permissions.find_role_by_name($1)
            role == queried_role
          else
            method_missing_without_aegis_permissions(symb, *args)
          end
        end

        alias_method_chain :method_missing, :aegis_permissions

        def respond_to_with_aegis_permissions?(symb, include_private = false)
          if symb.to_s =~ /^may_(.+?)[\!\?]$/
            true
          else
            respond_to_without_aegis_permissions?(symb, include_private)
          end
        end

        alias_method_chain :respond_to?, :aegis_permissions

        def set_default_aegis_role_name
          if new_record?
            self.aegis_role_name ||= self.class.aegis_default_role_name
          end
        end

      end

    end

  end

end
