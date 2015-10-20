# FormsAutofill

FormsAutofill is an app designed to autofill Pdf forms. It sits on the [Pdf Toolkit](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) and the [Pdf-Forms](https://github.com/jkraemer/pdf-forms) gem. 

At the moment the app is in demo stage. Further developments include a Sinatra front-end, integration with Excel documents, testing on forms other than the Texas 1010 form, and other additional functionality. 

## Installation

To install on windows please follow the Windows install instructions. 

On Unix like system, clone the repo 

    $ git clone https://github.com/yrhooke/forms_autofill.git

And then run:

    $ bash ./forms_autofill/bin/setup

## Usage

To fill a 1010 form, first fill out the correct user data in the db/user_info.yml and the db/defaults.yml files.

Then on windows, just tap the main.bat file in the apps home directory. On Unix, run 

    $ ruby lib/forms_autofill.rb


The result will be created in the tmp folder.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

