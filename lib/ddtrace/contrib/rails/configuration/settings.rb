require 'ddtrace/contrib/configuration/settings'

module Datadog
  module Contrib
    module Rails
      module Configuration
        # Custom settings for the Rails integration
        class Settings < Contrib::Configuration::Settings
          option :analytics_enabled do |o|
            o.default { env_to_bool(Ext::ENV_ANALYTICS_ENABLED, nil) }
            o.lazy true
            o.setter do |value|
              value.tap do
                # Update ActionPack analytics too
                Datadog.configuration[:action_pack][:analytics_enabled] = value
              end
            end
          end

          option :analytics_sample_rate do |o|
            o.default { env_to_float(Ext::ENV_ANALYTICS_SAMPLE_RATE, 1.0) }
            o.lazy true
            o.setter do |value|
              value.tap do
                # Update ActionPack analytics too
                Datadog.configuration[:action_pack][:analytics_sample_rate] = value
              end
            end
          end

          option :cache_service do |o|
            o.setter do |value|
              value.tap do
                # Update ActiveSupport service name too
                Datadog.configuration[:active_support][:cache_service] = value
              end
            end
          end

          option :controller_service do |o|
            o.setter do |value|
              value.tap do
                # Update ActionPack service name too
                Datadog.configuration[:action_pack][:controller_service] = value
              end
            end
          end

          option :database_service do |o|
            o.depends_on :service_name
            o.setter do |value|
              value.tap do
                # Update ActiveRecord service name too
                Datadog.configuration[:active_record][:service_name] = value
              end
            end
          end

          option :distributed_tracing, default: true
          option :exception_controller do |o|
            o.setter do |value|
              value.tap do
                # Update ActionPack exception controller too
                Datadog.configuration[:action_pack][:exception_controller] = value
              end
            end
          end

          option :middleware, default: true
          option :middleware_names, default: false
          option :template_base_path do |o|
            o.default 'views/'
            o.setter do |value|
              # Update ActionView template base path too
              value.tap { Datadog.configuration[:action_view][:template_base_path] = value }
            end
          end

          option :tracer do |o|
            o.default Datadog.tracer
            o.setter do |value|
              value.tap do
                Datadog.configuration[:active_record][:tracer] = value
                Datadog.configuration[:active_support][:tracer] = value
                Datadog.configuration[:action_pack][:tracer] = value
                Datadog.configuration[:action_view][:tracer] = value
              end
            end
          end
        end
      end
    end
  end
end
