require 'spec_helper'
require 'formcontroller'
require 'pdfsection'


# shared_examples "a PdfSection" do
#   it "is a hash" do
#     expect(hash.class).to eq(Hash)  
#   end

#   shared_examples "a field" do |field, type|
#     it "#{field} exists" do
#       expect(hash.keys).to include(field)
#     end

#     it "is #{type}" do
#       expect(hash.class).to eq(type).or(NilClass)
#     end
#   end

#   {"name" => String, 
#     "meta" => String, 
#     "role" => String, 
#     "pdf" => String,
#     "fields" => Array
#   }.each do |field, type|
#     describe "#{field}" do
#       it_behaves_like "a field", field, type
#     end
#   end
# end

describe FormController do
  let(:sample_pdf) do
    # pdftk = "Users/rhooke/projects/forms_autofill/bin/pdftk"
    pdftk = PdfForms.new(File.realpath(__dir__) + "/../bin/pdftk")
    blank_path = File.realpath(__dir__) + "/../db/1010-blank.pdf"
    PdfForms::Pdf.new blank_path, pdftk
  end 

  describe "#new" 

  describe "#add_section" do
    subject(:controller) {
      blank_path = File.realpath(__dir__) + "/../db/1010-blank.pdf"
      FormController.new blank_path
    }
    let(:sections) {controller.sections}

    shared_examples "sections added" do |length|
      it "creates the right number of sections" do
        expect(controller.sections.length).to eq(length)
      end

      describe "formats sections correctly" do
        it "contains PdfSections" do
          controller.sections.each do |section|
            expect(section.class).to eq(Hash)
            expect(section.keys).to include("name", "role", "meta", "fields")
          end
        end
      end
    end

    shared_examples "bad section added" do |action, error|
      it "raises an error" do
        expect{section.add_field_by_num input}.to raise_error(error)
      end

      it "adds nothing" do
        expect(sections).to eq([]) #__ISSUE: assumes sections was previously empty
      end
    end

    context "section is object" do
      let(:newsection) { PdfSection.new sample_pdf}
      before(:each) { controller.add_section(newsection) }
      include_examples "sections added", 1
    end

    context "section is hash" do
      let(:newsection) {{
        "pdf"=>"./db/1010-blank.pdf", 
        "name"=>"", 
        "role"=>nil, 
        "meta"=>"", 
        "fields"=>[1, 2]
      }}
      before(:each) { controller.add_section(newsection) }
      include_examples "sections added", 1
    end

    context "add array" do
      let(:newsection) {[
        {"pdf"=>"./db/1010-blank.pdf", 
        "name"=>"", 
        "role"=>nil, 
        "meta"=>"", 
        "fields"=>[1, 2]},
        {"pdf"=>"./db/1010-other.pdf", 
        "name"=>"Jerry", 
        "role"=>"Garcia", 
        "meta"=>"Grateful Dead section", 
        "fields"=>[1, 2, 5, 400]}
      ]}
      before(:each) { controller.add_section(newsection) }
      include_examples "sections added", 2
    end

    context "section from different owner"
    #raise - you know that's from a different owner, right?
    #change to right owner

    context "section is string" do
      let(:newsection) {
        "{\"pdf\":\"./db/1010-blank.pdf\",\"name\":\"\",\"role\":null,\"meta\":\"\",\"fields\":[1,2]}"
      }
      before(:each) { controller.add_section(newsection) }
      include_examples "bad section added"
    end

    context "section is hash of other items" do
      let(:newsection) {
        {:banana => 1,
          :orange => 2,
          :foo => "yes",
          :pdf => "./db/1010-blank.pdf"}
      }
      before(:each) { controller.add_section(newsection) }
      include_examples "bad section added"
    end

    context "section is nil" do
      let(:newsection) { nil }
      before(:each) { controller.add_section(newsection) }
      include_examples "bad section added"
    end

    context "section is array of other items" do
      let(:newsection) { [:banana, true, "yes", [1, 2, 3, 4]] }
      before(:each) { controller.add_section(newsection) }
      include_examples "bad section added"    
    end


  end 

  describe "#assign!"

    it "assigns all sections"

    it "assigns nothing else"

  describe "#fill!"

    it "fills all values"

    it "fills nothing else"

  describe "#write"

    it "creates new file"

    it "creates a pdf"

    it "matches example pdf"
  
end