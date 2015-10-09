require "forms_autofill/version"
require "utils"
require "pdfsection"
require "default"
require "formcontroller"

module FormsAutofill
  require "yaml"

  def yamlread file
    YAML.load(File.read(file))
  end

  $defaults_path = "../db/defaults.yml"
  $user_path = "../db/user_info.yml"
  $template_path = "../db/template_hash.yaml"
  
  def read_info
    default_info = yamlread $defaults_path
    user_info = yamlread $user_path
    default_info.merge(user_info)
  end

  def setup template_pdf
    # set up a form with special sections as defined by user/office hashes,
    # and with rest of fields lifted from template_pdf
    user_hash = yamlread "../tmp/user_info_hash.yaml"
    office_hash = yamlread "../tmp/office_info_hash.yaml"
    user_hash[:sections] += office_hash[:sections] 
    user_hash[:form_path] = template_pdf
    controller = FormController.import user_hash
    controller.create_defaults
    controller
  end


  def main
    info_hash = yamlread $template_path
    controller = FormController.import info_hash
    controller.fill! $default_info
    controller.fill! $user_info
    controller.write "./tmp/1010.pdf"
  end

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






