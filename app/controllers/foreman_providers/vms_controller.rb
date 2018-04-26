module ForemanProviders
  class VmsController < ::ApplicationController
    include ::ScopesPerAction

    def index
      @compute_resource = params[:compute_resource_id]
      @vms = ::ComputeResource.unscoped.find_by(id: params[:compute_resource_id]).vms
      render :partial => 'foreman_providers/vms/list'
    end

    def show
      @compute_resource = params[:compute_resource_id]
      @vm = ::ComputeResource.unscoped.find_by(id: params[:compute_resource_id]).vms.find(:guid => params[:uuid]).first
    end
  end
end
