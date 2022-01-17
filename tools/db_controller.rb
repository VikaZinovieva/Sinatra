class DBController
  class << self
    def locations
      Locations.all.to_json
    end

    def projects
      Projects.all.to_json
    end

    def employees
      Employees.all.to_json
    end

    def find_location_by(opt)
      location = Locations.find_by(opt)
      location.attributes.to_json
    end

    def find_project_by(opt)
      project = Projects.find_by(opt)
      project.attributes.to_json
    end

    def find_employee_by(opt)
      employee = Employees.find_by(opt)
      employee.attributes.to_json
    end

    def create_location(opts)
      Locations.create(opts)
    end

    def create_employee(opts)
      Employees.create(opts)
    end

    def create_project(opts)
      Projects.create(opts)
    end

    def edit_location(opts, opts_new)
      location = Locations.find_by(opts)
      location.update(opts_new)
    end

    def edit_project(opts, opts_new)
      project = Projects.find_by(opts)
      project.update(opts_new)
    end

    def edit_employee(opts, opts_new)
      employee = Employees.find_by(opts)
      employee.update(opts_new)
    end

    def delete_location(find_opts, new_opts = nil)
      location = Locations.find_by(find_opts)
      location_new = Locations.find_by(new_opts)
      self.update_employee(:id_location_id, location['id'], location_new['id'])
      self.delete_in(Locations, find_opts)
    end

    def delete_project(find_opts, new_opts = nil)
      project = Projects.find_by(find_opts)
      project_new = Projects.find_by(new_opts)
      self.update_employee(:id_project_id, project['id'], project_new['id'])
      self.delete_in(Projects, find_opts)
    end

    def delete_employee(opts)
      self.delete_in(Employees, opts)
    end

    private

    def delete_in(table, opts)
      data = table.where(opts)
      data.destroy_all
    end

    def update_employee(find_key, old_id, new_id)
      employeess = Employees.where(find_key => old_id)
      employeess.update_all(find_key => new_id)
    end
  end
end
