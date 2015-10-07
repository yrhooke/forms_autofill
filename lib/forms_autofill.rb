require "forms_autofill/version"
require "utils"
require "pdfsection"
require "default"
require "formcontroller"

module FormsAutofill

end

if __FILE__ == $0

  include FormsAutofill

  quickstart

  myform = FormController.new $blank_path
  firstname = Section.new $blank
  firstname.name = "firstname"
  firstname.add_field 7
  firstname.add_field 48

  lastname = Section.new $blank
  lastname.name = "firstname"
  lastname.add_field 9
  lastname.add_field 50

  def test_section name, values
    mysec = Section.new $blank
    mysec.name = name
    values.each {|num| mysec.add_field num}
  mysec
  end

  firstname = test_section "firstname", [7,48]
  lastname = test_section "lastname", [9,50]
  birthday = test_section "birthday", [687, 720]
  birthmonth = test_section "birthmonth", [688, 697]

  birthdate = MultiSection.new $blank
  birthdate.name = "date"
  birthdate.sections[0..1] = birthday
  birthdate.sections[-2..-1] = birthmonth


  myform.add_section firstname
  myform.add_section lastname
  myform.add_section birthdate

  puts myform.export

  myform.create_defaults

  myform.fill!({"firstname" => "Joe", "lastname" => "Biden", "date" => "01/31"})

  puts myform.export
  puts myform.make_hash
end






