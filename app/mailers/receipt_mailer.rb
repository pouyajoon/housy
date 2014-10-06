class ReceiptMailer < ActionMailer::Base
  default from: "no-reply@housy.pouya.name"

  def send_receipt(from, to, cc, pdf_url, title, h, quittance_date)
    @quittance_date = quittance_date
    @h = h

    attachments['quittance.pdf'] = File.read(pdf_url)

    mail(from: from, to: to, cc: cc, subject: title)
  end
end
