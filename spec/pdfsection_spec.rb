require 'spec_helper'
require 'pdfsection'
require 'pdf-forms'


describe PdfSection do 
  let(:sample_pdf) do
    # pdftk = "Users/rhooke/projects/forms_autofill/bin/pdftk"
    pdftk = PdfForms.new(File.realpath(__dir__) + "/../bin/pdftk")
    blank_path = File.realpath(__dir__) + "/../db/1010-blank.pdf"
    PdfForms::Pdf.new blank_path, pdftk
  end

  describe "#new" do

    context "home properly formatted" do 
      let(:home) {double('PDF', :class => PdfForms::Pdf)}

      it "creates an object" do
        section = PdfSection.new home
        expect(section.class).to be(FormsAutofill::PdfSection)
      end

      it "has a name" do
        section = PdfSection.new home, name: "Patricia"
        expect(section.name).to eq("Patricia")
      end

      it "holds a description" do
        section = PdfSection.new home, meta: "Patricia"
        expect(section.meta).to eq("Patricia") 
      end
      
      it "fields default to empty hash" do
        section = PdfSection.new home
        expect(section.fields).to eq({})
      end
    end

    context "home not properly formatted" do
      let(:home) {"home"}

      it "fails to create object" do
        expect{PdfSection.new(home)}.to raise_error(TypeError)
      end
    end

    context "no home parameter" do
      it "fails to create object" do
        expect {PdfSection.new}.to raise_error(ArgumentError)
      end
    end

  end

  # describe "#add_field" do
  #     context "field is PdfForms::Field object" do
  #         context "field is from @home" do
  #             it "adds field" do
  #             end
  #         end

  #         context "field is not from @home" do
  #         end
  #     end

  #     context "field is non field object" do

  #     end
  # end

  describe "#add_field_by_num" do
    let(:home) { sample_pdf } #home has 825 fields
    subject(:section) { PdfSection.new home }
    let(:prev_fields) {{}} # __ISSUE : depends on subject(:section) value

    shared_examples "wrong input" do |input, error_type|
      before(:each) { section.add_field_by_num(input) }

      it "raises an error" do
        expect{section.add_field_by_num input}.to raise_error(error_type)
      end

      it "adds nothing" do
        section.add_field_by_num input
        expect(section.fields).to eq prev_fields
      end
    end
    
    it "returns fields method" do
      expect { section.add_field_by_num(1) }.to eq {section.fields}
    end

    context "add sample_pdf's 10th field" do
      before(:each) { section.add_field_by_num(10) } 
      
      it "adds a field" do
        expect(section.fields.keys.length).to eq(1 + prev_fields.keys.length)
      end

      it "adds the right object" do
        expect(section.fields[10]).to be home.fields[10]
      end

    end

    context "field index too large" do
      
      it_behaves_like "wrong input", 900, RangeError
      # it "raises an error" do
      #     expect{section.add_field_by_num 900}.to raise_error(RangeError)
      # end

      # it "adds nothing" do
      #     section.add_field_by_num 900
      #     expect(section.fields).to eq prev_fields
      # end
    end

    context "index not a num" do 
      it_behaves_like "wrong input", "hi", TypeError
    end


    context "index is null" do
      it_behaves_like "wrong input", nil, TypeError 
    end
    
    context "home misdefined"

    context "overwrite existing field" 

  end

  describe "#to_json" do
    it "returns a json" 
  end

  describe "::from_json" do
    it "creates PdfSection" 

    it "accepts result of to_json" 

  end

  describe "::from_hash" 

end