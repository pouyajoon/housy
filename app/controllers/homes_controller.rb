class HomesController < ApplicationController
  def index
  	WickedPdf.new.pdf_from_string('Hello')
  end
end
