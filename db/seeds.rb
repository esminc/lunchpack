require "csv"

CSV.foreach('db/member.csv', headers: true) do |row|
  Member.create!(
    hundle_name: row['GitHub'],
    real_name: row['氏名 (本名)'].tr(' ', ''),
  )
end
