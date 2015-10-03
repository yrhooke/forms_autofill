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

      it "raises an error" do
        expect{section.add_field_by_num input}.to raise_error(error_type)
      end

      it "adds nothing" do
        begin 
          section.add_field_by_num input
        rescue
          nil
        end
        expect(section.fields).to eq prev_fields
      end
    end
    
    it "returns added field" do
      expect(section.add_field_by_num(1)).to eq (home.fields[1])
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
    let (:input) {{}}
    let (:defaults) { {
      :pdf => double('PDF', :class => PdfForms::Pdf, :path => "./pdftk"),
      :name => nil,
      :meta => nil,
      :fields => nil
    } }
    let(:params) { defaults.merge(input) }
    let(:home) { params[:pdf] }
    let(:section) do
      section = PdfSection.new home, name: params[:name], meta: params[:meta]
      if params[:fields]
          params[:fields].each { |i| section.add_field_by_num(i) }
      end
      section
    end
    subject(:result) { JSON.parse(section.to_json) }

    shared_examples "json result" do
      # let (:defaults) { {
      #   :pdf => double('PDF', :class => PdfForms::Pdf),
      #   :name => nil,
      #   :meta => nil,
      #   :fields => nil
      # } }
      # let(:params) { defaults.merge(params) }
      # let(:home) { params[:pdf] }
      # let(:section) do
      #   section = PdfSection.new home, name: params[:name], meta: params[:meta]
      #   params[:fields].each do |i|
      #     section.add_field_by_num(i)
      #   end
      #   section
      # end
      # subject(:result) { section.to_json }

      it "returns a json" do
        expect(result).to be_instance_of(Hash)
      end

      it "name field matches object" do
        expect(result["name"]).to eq(section.name)
      end

      it "meta field matches object" do
        expect(result["meta"]).to eq(section.meta)
      end

      it "includes all field incides" do
        expect(result["fields"]).to eq(section.fields.keys)
      end
    end


    context "blank_json" do 
      it_behaves_like "json result"
    end

    context "name and meta but no fields" do
      let(:input) { {:name => "Jelly", :meta => "beans"} }
      it_behaves_like "json result"
    end

    context "with fields" do
      let(:input) {{:fields => [1, 3, 4], :pdf => sample_pdf}}
      it_behaves_like "json result"
    end
 
  end

  describe "::from_json" do
    it "creates PdfSection" 

    it "accepts result of to_json" 

  end

  describe "::from_hash" 

end