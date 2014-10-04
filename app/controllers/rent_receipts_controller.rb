class RentReceiptsController < ApplicationController
	def index
		respond_to do |format|
			format.html
			format.pdf do
				render :pdf => "file_name.pdf",
					:disposition => "inline",
					:template    => "rent_receipts/index.pdf.erb"
			end
		end
	end
end
