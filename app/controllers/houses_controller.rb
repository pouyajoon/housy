
class Receipt< ApplicationController
  attr_accessor :link, :date, :name

  def initialize(h, y, m)
    @house = h
    @link = link = "/rent_receipts/%d/%d/%d" % [y, m, h.id]
    @date = Time.local(y, m)
    @name = l(@date, :format=> '%B %Y').capitalize
  end
end


class HousesController < ApplicationController
  def index
    @houses = House.all
  end


  def show
    @h = House.find_by_id(params[:id])
    @time = Time.now

    @months = []
    year = @time.year
    for y in 2013..2016
      for m in 1..12
        @months.push(Receipt.new(@h, y, m))
      end
    end

  end
end
