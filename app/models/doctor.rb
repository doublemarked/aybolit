class Doctor < ActiveRecord::Base
  belongs_to :hospital
  has_many :reports do
    def delivered
      where("delivery_id IS NOT NULL")
    end

    def undelivered
      where("delivery_id IS NULL")
    end
  end

  # TODO: Implement real trending algorithm
  scope :trending, order("latest_at DESC")

  attr_accessible :hospital, :name, :specialization

  validates :hospital, :name, :presence => true
end

