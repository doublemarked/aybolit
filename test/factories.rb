FactoryGirl.define do
  factory :user

  factory :hospital do
    name "Test Hospital"
    #director "Mr. Hospital Director"
    address "123 Hospital Lane"
    township "Kiev"
    district "Kiev"
    oblast "Kiev Oblast"
    postal "03191"

    factory :hospital_with_doctors do
      ignore do
        doctors_count 5
      end

      after(:create) do |hospital, evaluator|
        FactoryGirl.create_list(:doctor, evaluator.doctors_count, hospital: hospital)
      end
      
      factory :hospital_with_doctors_with_reports do
        ignore do
          doctors_count 2
          reports_count 5
        end

        after(:create) do |hospital, evaluator|
          FactoryGirl.create_list(:doctor, evaluator.doctors_count, hospital: hospital)

          hospital.doctors.each do |doctor| 
            FactoryGirl.create_list(:report, evaluator.reports_count, doctor: doctor)
          end
        end
      end

    end
  end

  factory :doctor do
    hospital
    name "Dr. Ivan Ivanovich"

    factory :doctor_with_reports do
      ignore do
        reports_count 5
      end

      after(:create) do |doctor, evaluator|
        FactoryGirl.create_list(:report, evaluator.reports_count, doctor: doctor)
      end
    end
  end

  factory :report do
    user
    doctor
    doctor_experience "DOC XP"
  end

  factory :delivery 

end

