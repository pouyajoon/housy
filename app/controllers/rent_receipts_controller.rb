class RentReceiptsController < ApplicationController



	def get_pdf(mode, action)
		require 'active_support/core_ext/integer/inflections'
		@h = House.find_by_id(params[:id])
		@year = params[:year]
		@m = Time.local(@year, params[:month])
		@month = l(@m, :format=> '%B').capitalize
		format = '%d/%m/%Y'
		@month_start = l(@m.at_beginning_of_month, :format=> format)
		@month_end = l(@m.at_end_of_month, :format=> format)
		@pay_day = l(Time.local(@year, params[:month], 3), :format=> format)

		# respond_to do |format|
		# 	format.html
		# 	format.pdf do


		case action
		when 'pdf'
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

		when 'file'
			pdf = render_to_string :pdf => file,
				:disposition => mode,
				:save_to_file => Rails.root.join('tmp', 'tmp3.pdf'),
				:save_only => false,
				:encoding => 'UTF-8',
				:layout => 'pdf.html.erb',
				:template => "rent_receipts/show.html.erb",
				:margin => { :bottom => 30 },
			:footer => { :html => {
										 :template => "rent_receipts/footer.html.erb",
										 :layout => 'empty.html'
									 }
									}
			save_path = Rails.root.join('tmp','quittance.pdf')
			File.open(save_path, 'wb') do |file|
				file << pdf
			end
			return save_path
		when 'html'

		end

	end


	def pdf
		render get_pdf("inline", 'pdf')
	end

	def show
		render get_pdf("inline", 'html')
	end


	def attachment
		# render get_pdf("attachment", 'true')
	end

	def email
		@h = House.find_by_id(params[:id])

		to = @h.owners_email.split(',')
		cc = @h.occupants_email.split(',')
		from = @h.send_from_email

		year = params[:year]
		m = params[:month]

		month_date = Time.local(year, m)
		quittance_date = l(month_date, :format=> '%B %Y').capitalize
				date_for_file = l(month_date, :format=> '%Y%m').capitalize

		title = "Quittance %s" % quittance_date

		pdf_url = get_pdf("inline", 'file')



		ReceiptMailer.send_receipt(from, to, cc, pdf_url, title, @h, quittance_date, date_for_file).deliver
		render :text => 'e-mail envoyé à %s en cc à %s' % [to.to_s, cc.to_s]
	end

end
