module ForemanProviders
  class HostsController < ::ApplicationController
    def index
      @hosts = ::ComputeResource.unscoped.find_by(id: params[:compute_resource_id]).virt_hosts
      render :partial => 'foreman_providers/hosts/list'
    end
  end
end
