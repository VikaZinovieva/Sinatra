class Company < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |location|
      location.string :name
      location.string :description
    end

    create_table :projects do |project|
      project.string :name
      project.string :description
    end

    create_table :employees do |employee|
      employee.string :name
      employee.string :surname
      employee.string :email
      employee.string :position
      employee.references  :id_location, foreign_key: { to_table: :locations }
      employee.references  :id_project, foreign_key: { to_table: :projects }
    end
  end
end
