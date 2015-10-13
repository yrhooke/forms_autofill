# $LOAD_PATH << File.realpath(__dir__)

require_relative "forms_autofill/version"
require_relative "utils"
require_relative "pdfsection"
require_relative "default"
require_relative "formcontroller"

module FormsAutofill
  require "yaml"
  # general functions for end use here.


  def init_defaults
    $defaults_path = path_in_proj "../db/defaults.yml" 
    $user_path = path_in_proj "../db/user_info.yml"
    $template_path = path_in_proj "../db/template_hash.yaml"
    $output_destination = path_in_proj "../tmp/1010.pdf"
    $blank_path = path_in_proj "../db/1010-blank.pdf"
  end

  def read_info
    default_info = yamlread $defaults_path
    user_info = yamlread $user_path
    default_info.merge(user_info)
  end

  # def setup template_pdf
  #   # set up a form with special sections as defined by user/office hashes,
  #   # and with rest of fields lifted from template_pdf
  #   user_hash = yamlread File.expand_path("./tmp/user_info_hash.yaml")
  #   office_hash = yamlread File.expand_path("./tmp/office_info_hash.yaml")
  #   user_hash[:sections] += office_hash[:sections] 
  #   user_hash[:form_path] = template_pdf
  #   controller = FormController.import user_hash
  #   controller.create_defaults
  #   controller
  # end


  def main
    init_defaults
    info_hash = yamlread $template_path
    user_info = YAML.load(File.read($user_path))
    office_info = YAML.load(File.read($defaults_path))
    controller = FormController.import info_hash
    controller.fill! office_info
    controller.fill! user_info
    controller.write $output_destination
  end

  def main_show
    init_defaults
    info_hash = yamlread $template_path
    user_info = YAML.load(File.read($user_path))
    office_info = YAML.load(File.read($defaults_path))
    controller = FormController.import info_hash
    controller.fill! office_info
    controller.fill! user_info
    controller
  end

  def to_fdf
    init_defaults
    info_hash = yamlread $template_path
    user_info = YAML.load(File.read($user_path))
    office_info = YAML.load(File.read($defaults_path))
    controller = FormController.import info_hash
    controller.fill! office_info
    controller.fill! user_info
    output = PdfForms::Fdf.new controller.make_hash
    output.save_to path_in_proj "../tmp/tmpfdf.fdf"
  end


  def main_blank
    init_defaults
    info_hash = yamlread $template_path
    user_info = YAML.load(File.read($user_path))
    office_info = YAML.load(File.read($defaults_path))
    # info_hash[:form_path] = $blank_path
    controller = FormController.import info_hash
    controller.fill! office_info
    controller.fill! user_info
    controller.write $output_destination
  end

end

if __FILE__ == $0

  include FormsAutofill
  
  # main_blank
  main
end






