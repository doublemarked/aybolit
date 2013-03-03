# encoding: utf-8

testuser = User.create({ :provider => "facebook", :uid => "tester", :name => "Ivan Ivanovich"  })

Hospital.create({
  :name => "Test Hospital",
  :director => "Mr. Master Director",
  :address => "Mykhaila Lomonosova street, 52/3",
  :address2 => "",
  :township => "Kiev",
  :district => "Kiev",
  :oblast => "Kyiv City",
  :country => "Ukraine",
  :postal => "03191"
})

Hospital.create({
  :name => "Secondary Test Hospital",
  :director => "Ms. Head Mistress",
  :address => "Zoolohichna street, 3",
  :address2 => "",
  :township => "Kiev",
  :district => "Kiev",
  :oblast => "Kyiv City",
  :country => "Ukraine",
  :postal => "03150"
})

Hospital.all.each do |h|
  Doctor.create({ :hospital => h, :name => "Hospital #{h.id} Doctor Kravets" })
  Doctor.create({ :hospital => h, :name => "Hospital #{h.id} Doctor Babich" })
  Doctor.create({ :hospital => h, :name => "Hospital #{h.id} Doctor Kifenko" })

  h.doctors.each do |d|
    Report.create({ :user => testuser, :doctor => d, 
                    :doctor_experience => "The doctor and his staff were really kind to me. I had a serious infection in my leg, preventing me from working. After visiting the doctor I thought I would not be able to afford treatment, and would lose my job. 

I was really surprised that he wasn't going to force me to pay him money that I don't have. The operation he performed on my leg was quick and painless, and I was back at work in less than a week. I cannot express my gratitude enough to Doctor Savchenko and his team. I am very thankful that we have such good doctors in Ukraine.",
                    :hospital_experience => "Very nice patterns on the walls, reminding me of the joys of my Soviet youth." })

    Report.create({ :user => testuser, :doctor => d,
                  :doctor_experience => "This guy rocked my herniated disk like it was New Year's Eve in Odessa. Who knew borsch could be used for medical purposes.",
                  :hospital_experience => "Met some lovely babushkas.",
                  :occurred => "2012-07-21" })
  end

end



