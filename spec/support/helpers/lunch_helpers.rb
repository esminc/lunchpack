module LunchHelpers
  def build_lunch(members, user, date: Date.current)
    quarter = Quarter.find_or_create_quarter(date)
    build(:lunch, members: members, date: date, quarter: quarter, created_by: user)
  end

  def create_lunch(members, user, date: Date.current)
    quarter = Quarter.find_or_create_quarter(date)
    create(:lunch, members: members, date: date, quarter: quarter, created_by: user)
  end
end
