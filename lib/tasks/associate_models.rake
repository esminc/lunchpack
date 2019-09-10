namespace :associate_models do
  # 本番環境の既存データメンテナンス用のタスクで一度実行したらもう使わない
  desc 'DBのLunchモデルとQuarterモデルのデータを関連付ける'
  task associate_lunch_and_quarter: :environment do
    Lunch.where(quarter: nil).each do |lunch|
      quarter = Quarter.find_or_create_quarter(lunch.date)
      lunch.update!(quarter: quarter)
    end
  end
end
