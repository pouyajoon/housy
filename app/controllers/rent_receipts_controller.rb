class RentReceiptsController < ApplicationController
	def show
		require 'active_support/core_ext/integer/inflections'
		@h = House.find_by_id(params[:id])
		@year = params[:year]
		@m = Time.local(@year, params[:month])
		@month = l(@m, :format=> '%B').upcase
		format = '%d/%m/%Y'
		@month_start = l(@m.at_beginning_of_month, :format=> format)
		@month_end = l(@m.at_end_of_month, :format=> format)
		@pay_day = l(Time.local(@year, params[:month], 3), :format=> format)		

		respond_to do |format|
			format.html
			format.pdf do
				render :pdf => "quittance_%d" % @h.id,
					:disposition => "inline"
					# :encoding => 'UTF-8',
					# :layout => 'pdf.html.erb',
					# :template => "rent_receipts/show.html.erb"
					# :margin => { :bottom => 30 },
					# :footer => { :html => {
					# 							:template => "rent_receipts/footer.html.erb",
					# 						 	:layout => 'empty.html'
					# 					 		}
					# 					 	}
			end
		end
	end
end
