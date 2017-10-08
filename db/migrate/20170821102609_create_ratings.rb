# frozen_string_literal: true

class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings do |t|
      t.integer :value
      t.integer :ratable_id
      t.string :ratable_type

      t.timestamps
    end

    add_belongs_to :ratings, :user, index: true
    add_index :ratings, %i[ratable_id ratable_type]
  end
end
