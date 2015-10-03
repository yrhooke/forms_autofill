require 'spec_helper'
require 'formcontroller'

describe FormController do 

  describe "#new" 

  describe "#add_section" do

    shared_examples "sections added" do

      it "creates the right number of sections"

      it "formats sections correctly"

    end

    shared_examples "bad sections added" do
      #abstract pdfsection_spec's wrong input for this
    end

    context "section is object" do
      it_behaves_like "sections added"
    end

    context "section is hash" do
      it_behaves_like "sections added"
    end

    context "add multiple section array" do
      it_behaves_like "sections added"
    end

    context "section from different owner"

    context "section is string"

    context "section is hash of other items"

    context "section is array of other items"

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