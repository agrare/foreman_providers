module ForemanProviders
  module ComputeResource
    extend ActiveSupport::Concern

    included do
      has_one :ems, class_name: 'Providers::ExtManagementSystem', foreign_key: 'compute_resource_id'
      after_create :create_provider
      before_destroy :destroy_provider
    end

    def virt_hosts(opts = {})
      miq_connection.providers.get(:attributes => "hosts").find(miq_provider.id)
    end

    def vms(opts = {})
      miq_connection.providers.get(:attributes => "vms").find(miq_provider.id)
    end

    def find_vm_by_uuid(uuid)
      miq_connection.vms.find_by(:ems_id => miq_provider_id, :uid_ems => uuid)
    end

    def create_provider
      return unless miq_provider.nil?

      @provider = miq_connection.providers.create(
        :name                  => name,
        :hostname              => URI(url).host,
        :type                  => miq_provider_klass,
        :certificate_authority => self.public_key,
        :credentials           => {
          :userid   => user,
          :password => password,
        }
      )
    end

    def destroy_provider
      miq_provider.try(:delete)
    end

    def miq_connection
      @connection ||= miq_connect
    end

    def miq_connect(server: 'localhost', port: 4000, user: 'admin', password: 'smartvm')
      require 'manageiq/api/client'
      ManageIQ::API::Client.new(:url => "http://#{server}:#{port}", :user => user, :password => password)
    end

    def miq_provider_klass
      @provider_klass ||= foreman_type_to_provider_type
    end

    def miq_provider
      @provider ||= miq_connection.providers.find_by(:type => miq_provider_klass, :hostname => URI(url).host, :name => name)
    end

    def foreman_type_to_provider_type
      case type
      when "Foreman::Model::Ovirt"
        "ManageIQ::Providers::Redhat::InfraManager"
      when "Foreman::Model::Openstack"
        "ManageIQ::Providers::Openstack::CloudManager"
      end
    end
  end
end
