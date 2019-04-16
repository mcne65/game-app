class Player < ApplicationRecord
  validates :handle, presence: true, uniqueness: true

  def percent_complete
    fields_to_complete = %i[handle email]
    complete_count = fields_to_complete.map do |field|
      send(field)&.empty?
    end.count(false).to_f
    ((complete_count / fields_to_complete.length.to_f) * 100.0).to_i
  end
end
