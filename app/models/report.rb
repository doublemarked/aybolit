class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :doctor
  belongs_to :delivery

  has_many :endorsements

  scope :delivered, where("delivery_id IS NOT NULL")
  scope :recent, order("created_at DESC")
  scope :invisible, where(:visible => false)

  default_scope where(:visible => true)

  attr_accessible :user, :doctor, :doctor_experience, :hospital_experience, :occurred

  validates :user, :doctor, :doctor_experience, :presence => true
  
  after_create :update_stats

  def hospital
    doctor.hospital
  end

  def update_stats
    # TODO: Replace this crap with true counter cache columns (http://railscasts.com/episodes/23-counter-cache-column)
    Doctor.transaction do 
      doctor.reload(:lock => true)
      doctor.num_reports += 1
      doctor.latest_at = Time.now
      doctor.save(:validate => false)
    end
    
    Hospital.transaction do 
      hospital.reload(:lock => true)
      hospital.num_reports += 1
      hospital.latest_at = Time.now
      hospital.save(:validate => false)
    end
  end

end
