# Easiest solution for integration with Foreman today is if an API Client VM
# resource looks like Fog.  This should probably live somewhere else than just
# stomping all over the Resource class.  Or Foreman could not be so dependent
# on Fog's API.
class ManageIQ::API::Client::Resource
  def identity
    self.uid_ems
  end

  def ready?
    self.power_state == "on"
  end

  def status
    self.power_state
  end

  def state
    self.power_state
  end

  def reload
    self.refresh
  end

  def cores
  end

  def interfaces
    []
  end

  def memory
    self.memory_reserve
  end

  def display
    {}
  end

  def volumes
    []
  end
end
