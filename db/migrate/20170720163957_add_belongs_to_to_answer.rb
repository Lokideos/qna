# frozen_string_literal: true

class AddBelongsToToAnswer < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :answers, :question, index: true
  end
end
