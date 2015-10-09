$LOAD_PATH << File.realpath(__dir__)

require "forms_autofill/version"
require "utils"
require "pdfsection"
require "default"
require "formcontroller"

module FormsAutofill
  require "yaml"
  # general functions for end use here.

  def yamlread file
    YAML.load(File.read(file))
  end

  $defaults_path = File.expand_path "./db/defaults.yml"
  $user_path = File.expand_path "./db/user_info.yml"
  $template_path = File.expand_path "./db/template_hash.yaml"

  def read_info
    default_info = yamlread $defaults_path
    user_info = yamlread $user_path
    default_info.merge(user_info)
  end

  def setup template_pdf
    # set up a form with special sections as defined by user/office hashes,
    # and with rest of fields lifted from template_pdf
    user_hash = yamlread File.expand_path("./tmp/user_info_hash.yaml")
    office_hash = yamlread File.expand_path("./tmp/office_info_hash.yaml")
    user_hash[:sections] += office_hash[:sections] 
    user_hash[:form_path] = template_pdf
    controller = FormController.import user_hash
    controller.create_defaults
    controller
  end


  def main
    info_hash = yamlread $template_path
    user_info = YAML.load(File.read($user_path))
    office_info = YAML.load(File.read($defaults_path))
    controller = FormController.import info_hash
    controller.fill! office_info
    controller.fill! user_info
    controller.write File.expand_path "./tmp/1010.pdf"
  end

end

if __FILE__ == $0

  include FormsAutofill
  
  main
end






