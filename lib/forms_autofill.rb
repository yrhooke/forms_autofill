# $LOAD_PATH << File.realpath(__dir__)

require_relative "forms_autofill/version"
require_relative "utils"
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


end

if __FILE__ == $0

  include FormsAutofill
  
  main
end






