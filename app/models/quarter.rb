class Quarter < ApplicationRecord
  has_many :lunches, dependent: :nullify

  class << self
    def current_quarter
      find_or_create_quarter(Date.current)
    end

    def find_or_create_quarter(date)
      quarter = Quarter.where('start_date <= ?', date).find_by('end_date >= ?', date)
      if quarter.blank?
        quarter = QuarterCreater.new(date).create_quarter!
      end
      quarter
    end
  end

  def cover_today?
    Date.current.between?(start_date, end_date)
  end
end
