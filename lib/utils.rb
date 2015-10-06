module FormsAutofill
  require "pdf-forms"
  
  def quickstart
    $pdftk = PdfForms.new( File.realpath(__dir__) + "/../bin/pdftk")

    $blank_path = "./db/1010-blank.pdf"
    $indices_path = "./tmp/indices.pdf"

    $blank = PdfForms::Pdf.new $blank_path, $pdftk
  end
# Pdf forms commands are all based on SafeShell.execute which takes comma 
# sepearated arguments, and the pdftk binary  - docs here: 
# https://www.pdflabs.com/docs/pdftk-man-page/

# Commands used via command line to fill pdf:
# pdftk ./db/1010-filled-sample.pdf generate_fdf output ./tmp/sample2.fdf
# pdftk ./db/1010-blank.pdf fill_form ./tmp/sample2.fdf output ./tmp/filled2.pdf
# our pdftk instance has a call_pdftk method, which takes the same arguments as 
# pdftk, but as comma separated vaues
# i.e: 
# pdftk.call_pdftk("./db/1010-blank.pdf", "fill_form", "./tmp/sample2.fdf", \
#   "output", "./tmp/filled.pdf")
# will do the same thing as above

  # class PdfForms::DataFormat
  #   ## to fix format of fdf
  #   def to_pdf_data
  #     pdf_data = header
  #     @data.each do |form_part|
  #       pdf_data << field(form_part.name, form_part.value)
  #     end  
  #     pdf_data << footer
  #     return encode_data(pdf_data)
  #   end  
  # end  

  # class PdfForms::PdftkWrapper
  #   ## to write directly to files from ruby, without any manipulation

  #   def extract_fdf_bin input, output
  #     self.call_pdftk(input, "generate_fdf", "output", output)
  #   end

  #   def fill_form_bin params = {:input => "", :output => "", :fdf => ""}
  #     #params are input, output, fdf
  #     self.call_pdftk params[:input], "fill_form", params[:fdf], "output", params[:output]
  #   end
  
  # end

  class PdfForms::Field
    # to be able to note some info about fields
    attr_accessor :id, :value
  end



  #generate fdf with specific values for each key in existing pdf
  
  # def fill_with_index location, output, pdftk
  #   keys = pdftk.get_field_names location
  #   indices = Hash.new
  #   keys.each_with_index {|key, index| indices[key] = index}
  #   pdftk.fill_form location, output, indices
  # end
end