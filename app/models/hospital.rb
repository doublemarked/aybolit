class Hospital < ActiveRecord::Base
  has_many :doctors do
    def trending(max=5)
      order("latest_at DESC").limit(max)
    end
  end

  has_many :reports, :through => :doctors do
    def delivered
      where("delivery_id IS NOT NULL")
    end

    def undelivered
      where("delivery_id IS NULL")
    end
  end

  scope :best, order("rating DESC")

  attr_accessible :name, :director
  attr_accessible :address, :address2, :township, :district, :oblast, :postal, :country, :phone

  validates :name, :address, :township, :district, :oblast, :postal, :country, :presence => true

  geocoded_by :full_address

  # Auto-fetch coordinates
  after_validation :geocode
  after_update :create_location

  def full_address
    # NOTE: address2 is not a mapping component, it's used only for mail routing within an address.
    "#{address}, #{township}, #{district}, #{oblast}, #{country}, #{postal}"
  end

  def display_address
    "#{address}, #{township}, #{oblast}, #{country}"
  end

  def display_location
    "#{township}, #{oblast}, #{country}"
  end

  def create_location
    Location.find_or_create_by_name(display_location)
  end

end
