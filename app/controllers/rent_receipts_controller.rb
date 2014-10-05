class RentReceiptsController < ApplicationController



	def get_pdf(mode, create_pdf)
		require 'active_support/core_ext/integer/inflections'
		@h = House.find_by_id(params[:id])
		@year = params[:year]
		@m = Time.local(@year, params[:month])
		@month = l(@m, :format=> '%B').upcase
		format = '%d/%m/%Y'
		@month_start = l(@m.at_beginning_of_month, :format=> format)
		@month_end = l(@m.at_end_of_month, :format=> format)
		@pay_day = l(Time.local(@year, params[:month], 3), :format=> format)

		# respond_to do |format|
		# 	format.html
		# 	format.pdf do


		if create_pdf
			file = "quittance_%d" % @h.id
			return :pdf => file,
				:disposition => mode,
				:save_to_file => Rails.root.join('public', 'tmp.pdf'),

				:encoding => 'UTF-8',
				:layout => 'pdf.html.erb',
				:template => "rent_receipts/show.html.erb",
				:margin => { :bottom => 30 },
			:footer => { :html => {
										 :template => "rent_receipts/footer.html.erb",
										 :layout => 'empty.html'
									 }
									 }
			# 	end
			# end
		else

			file = WickedPdf.new.pdf_from_string(
				:pdf => file,
				:disposition => mode,
				:save_to_file => Rails.root.join('public', 'tmp.pdf'),

				:encoding => 'UTF-8',
				:layout => 'pdf.html.erb',
				:template => "rent_receipts/show.html.erb",
				:margin => { :bottom => 30 },
				:footer => { :html => {
											 :template => "rent_receipts/footer.html.erb",
											 :layout => 'empty.html'
										 }
										 })
		end

	end


	def pdf
		render get_pdf("inline", true)
	end

	def show
		render get_pdf("inline", false)
	end


	def attachment
		render get_pdf("attachment", true)
	end

	def email
		@h = House.find_by_id(params[:id])

		to = @h.owners_email.split(',')
		cc = @h.occupants_email.split(',')
		from = @h.send_from_email

		year = params[:year]
		m = params[:month]

		month_date = Time.local(year, m)
		title = "Quittance %s" % l(month_date, :format=> '%B %Y').capitalize

		content = get_pdf("inline", false)

		pdf_url = Rails.root.join('tmp', 'quittance.pdf')

		File.open(pdf_url, 'wb') do |file|
			file << content
		end

		ReceiptMailer.send_receipt(from, to, cc, pdf_url, title, @h).deliver
		render :text => 'e-mail envoyé à %s en cc à %s' % [to.to_s, cc.to_s]
	end

end
