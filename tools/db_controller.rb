class DBController

  def self.locations
    Locations.all.to_json
  end

  def self.projects
    Projects.all.to_json
  end

  def self.employees
    Employees.all.to_json
  end

  def self.find_location_by(opt)
    location = Locations.find_by(opt)
    location.attributes.to_json
  end

  def self.find_project_by(opt)
    project = Projects.find_by(opt)
    project.attributes.to_json
  end

  def self.find_employee_by(opt)
    employee = Employees.find_by(opt)
    employee.attributes.to_json
  end

  def self.create_location(opts)
    Locations.create(opts)
  end

  def self.create_employee(opts)
    Employees.create(opts)
  end

  def self.create_project(opts)
    Projects.create(opts)
  end

  def self.edit_location(opts, opts_new)
    location = Locations.find_by(opts)
    location.update(opts_new)
  end

  def self.edit_project(opts, opts_new)
    project = Projects.find_by(opts)
    project.update(opts_new)
  end

  def self.edit_employee_by(opts, opts_new)
    employee = Employees.find_by(opts)
    employee.update(opts_new)
  end

  def self.delete_location(opts_to_find, opts_new_location)
    location = Locations.find_by(opts_to_find)
    location_new = Locations.find_by(opts_new_location)
    employeess = Employees.where(id_location_id: location['id'])
    employeess.update_all(id_location_id: location_new['id'])
    location = Locations.where(opts_to_find)
    location.destroy_all
  end

  def self.delete_project(opts_to_find, opts_new_location)
    project = Projects.find_by(opts_to_find)
    project_new = Projects.find_by(opts_new_location)
    employeess = Employees.where(id_project_id: project['id'])
    employeess.update_all(id_project_id: project_new['id'])
    project = Projects.where(opts_to_find)
    project.destroy_all
  end

  def self.delete_employee(opts)
    employee = Employees.where(opts)
    employee.destroy_all
  end
end



