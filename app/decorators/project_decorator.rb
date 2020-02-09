module ProjectDecorator
  def delete_confirm
    if members.present?
      "#{name}には#{members.pluck(:real_name).join('、')}が所属しています。#{name}を削除しますか？"
    else
      "#{name}を削除しますか？"
    end
  end
end
