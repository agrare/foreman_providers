class Setting::Providers < ::Setting
  def self.load_defaults
    return unless ActiveRecord::Base.connection.table_exists?('settings')
    return unless super

    Setting.transaction do
      [
        self.set('providers_service_scheme', N_('HTTP or HTTPS for providers service'), 'http'),
        self.set('providers_service_host', N_('Hostname/IP for providers service'), 'localhost'),
        self.set('providers_service_port', N_('Port for providers service'), 4000),
        self.set('providers_service_user', N_('Port for providers service'), 'admin'),
        self.set('providers_service_password', N_('Port for providers service'), 'smartvm'),
      ].compact.each { |s| self.create s.update(:category => "Setting::Providers") }
    end

    true
  end

  def self.humaized_category
    N_('Providers')
  end
end
