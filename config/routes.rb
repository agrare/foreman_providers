Rails.application.routes.draw do
  scope path: '/foreman_providers', as: :foreman_providers do
    get ':compute_resource_id/hosts', to: 'foreman_providers/hosts#index'

    get ':compute_resource_id/vms', to: 'foreman_providers/vms#index'
    get ':compute_resource_id/vms/:uuid', to: 'foreman_providers/vms#show'
  end
end
