class ReceiptMailer < ActionMailer::Base
  default from: "no-reply@housy.pouya.name"

  def send_receipt(from, to, cc, pdf_url, title, h, quittance_date, date_for_file)
    @quittance_date = quittance_date
    @h = h

    file_name = 'quittance_%s.pdf' % date_for_file
    attachments[file_name] = File.read(pdf_url)

    mail(from: from, to: to, cc: cc, subject: title)
  end
end
