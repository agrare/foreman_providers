# ForemanProviders

Adds ManageIQ Providers and Inventory to Foreman

## Installation

The provider plugins are on GitHub here:

```bash
git clone https://github.com/agrare/foreman_providers.git -b link_compute_resources_and_providers
```

Add the provider plugins to your Foreman bundler.d/ directory:

```bash
gem "foreman_providers",      :path => "../foreman_providers"
```

Update your foreman gems and database

```bash
bundle update
```

Install minishift using the installation guide https://docs.openshift.org/latest/minishift/getting-started/installing.html
It is recommended to give at least 8GiB of RAM and 2-4 CPUs to the minishift appliance.

Clone the manageiq-pods repo and setup the dependent templates and user permissions

```bash
git clone https://github.com/ManageIQ/manageiq-pods

eval $(minishift oc-env)
eval $(minishift docker-env)

namespace='myproject'

oc login -u system:admin

oc adm policy add-scc-to-user anyuid system:serviceaccount:$namespace:miq-anyuid
oc adm policy add-scc-to-user anyuid system:serviceaccount:$namespace:miq-orchestrator
oc adm policy add-scc-to-user privileged system:serviceaccount:$namespace:miq-privileged
oc create -f manageiq-pods/templates/miq-scc-sysadmin.yaml
oc adm policy add-scc-to-user miq-sysadmin system:serviceaccount:$namespace:miq-httpd

oc create -f manageiq-pods/templates/miq-template.yaml

oc new-app --template=manageiq -p APPLICATION_CPU_REQ=500m -p APPLICATION_MEM_REQ=2Gi -p POSTGRESQL_CPU_REQ=250m -p POSTGRESQL_MEM_REQ=2Gi -p MEMCACHED_CPU_REQ=100m -p MEMCACHED_MEM_REQ=64Mi -p HTTPD_CPU_REQ=250m -p HTTPD_MEM_REQ=256Mi
```

## Usage

Go to the Settings/Providers tab and set the providers_service_scheme to `https`, the providers_service_host to the dns name of your manageiq app, e.g. `httpd-myproject.192.168.42.42.nip.io`, and the providers_service_port to 443.

Now add a new Ovirt ComputeResource and a new Provider will be automatically created for you and the API will be used to retrieve VMs and Hosts.

## Contributing

Fork and send a Pull Request. Thanks!

## Copyright

Copyright (c) 2018 Red Hat, Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

