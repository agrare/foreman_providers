# Replace current vms pane.
#
# I couldn't get deface to just replace the tab contents, so I'm obliterating
# the whole thing and replacing it with a new tab called #vms-provider
spinner = '<p class="spinner-label"> Loading information ... </p><div id="" class="spinner spinner-xs spinner-inline "></div>'
data_url = "/foreman_providers/<%= @compute_resource.id %>"

Deface::Override.new(
  virtual_path: 'compute_resources/show',
  name:         'remove_compute_resources_vms_tab',
  remove:       'div#vms'
)

Deface::Override.new(
  virtual_path:   'compute_resources/show',
  name:           'reference_new_vms_tab',
  set_attributes: 'a[href^="#vms"]',
  attributes:     {href: "#vmsprovider"}
)

Deface::Override.new(
  virtual_path: 'compute_resources/show',
  name:         'add_compute_resources_vms_pane',
  insert_after: 'div#primary',
  text:         "<div id='vmsprovider' class='tab-pane' data-ajax-url='#{data_url}/vms' data-on-complete='tfm.tools.activateDatatables'>#{spinner}</div>"
)

# Delete images tab, TODO: show templates from MIQ provider
Deface::Override.new(
  virtual_path: 'compute_resources/show',
  name:         'remove_compute_resources_images_tab',
  remove:       'div#images'
)

# Add Hypervisors Tab
Deface::Override.new(
  virtual_path: 'compute_resources/show',
  name:         'add_compute_resources_hosts_tab',
  insert_after: 'li.active',
  text:         '<li><a href="#hosts" data-toggle="tab"><%= _("Hypervisors") %></a></li>'
)

Deface::Override.new(
  virtual_path: 'compute_resources/show',
  name:         'add_compute_resources_hosts_pane',
  insert_after: 'div#primary',
  text:         "<div id='hosts' class='tab-pane' data-ajax-url='#{data_url}/hosts' data-on-complete='tfm.tools.activateDatatables'>#{spinner}</div>"
)
