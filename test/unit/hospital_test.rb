require 'test_helper'

class HospitalTest < ActiveSupport::TestCase
  test "trending doctors list" do
    hospital = create :hospital_with_doctors, doctors_count: 8
    
    assert_equal 8, hospital.doctors.length
    assert_equal 5, hospital.doctors.trending(5).length

    # TODO - as the trending algorithm evolves, update this test
    # to check its accuracy.
  end

  test "delivered report set" do
    hospital = create :hospital_with_reports, doctors_count: 2, reports_count: 5
    delivery = create :delivery

    hospital.reports.sample(3).each do |r|
      r.delivery = delivery
      r.save
    end

    assert_equal 10, hospital.reports.length
    assert_equal 3, hospital.reports.delivered.length
    assert_equal 7, hospital.reports.undelivered.length
  end

end
