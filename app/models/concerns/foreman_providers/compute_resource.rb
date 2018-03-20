module ForemanProviders
  module ComputeResource
    extend ActiveSupport::Concern

    included do
      has_one :ems, class_name: 'Providers::ExtManagementSystem', foreign_key: 'compute_resource_id'
      after_create :create_provider
      before_destroy :destroy_provider
    end

    def vms(opts = {})
      miq_connection.vms
    end

    def create_provider
      provider = miq_connection.providers.find_by(:type => provider_klass, :hostname => hostname, :name => name)
      return unless provider.nil?

      miq_connection.providers.create(
        :name        => name,
        :hostname    => hostname,
        :type        => provider_klass,
        :credentials => {
          :userid   => user,
          :password => password,
        }
      )
    end

    def destroy_provider
      provider = miq_connection.providers.find_by(:type => provider_klass, :hostname => hostname, :name => name)
      provider.try(:delete)
    end

    def miq_connection
      @connection ||= miq_connect
    end

    def miq_connect(server: 'localhost', port: 4000, user: 'admin', password: 'smartvm')
      require 'manageiq/api/client'
      ManageIQ::API::Client.new(:url => "http://#{server}:#{port}", :user => user, :password => password)
    end

    def provider_klass
      @provider_klass ||= foreman_type_to_provider_type
    end

    def foreman_type_to_provider_type
      case type
      when "Foreman::Model::Ovirt"
        "ManageIQ::Providers::Redhat::InfraManager"
      when "Foreman::Model::Openstack"
        "ManageIQ::Providers::Openstack::CloudManager"
      end
    end

    def hostname
      @hostname ||= URI(url).host
    end
  end
end
