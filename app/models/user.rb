class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  def full_name
    return "#{first_name} #{last_name}".strip if (first_name || last_name)
    "Anonymous"
  end

  def can_add_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_added(ticker_symbol)
  end

  def under_stock_limit?
    (user_stocks.count < 10 )
  end

  def stock_already_added(ticker_symbol)
    stock = Stock.find_by_ticker(ticker_symbol)
    return false unless stock
    UserStock.where(stock_id: stock.id).present?
  end

  def not_friends_with?(friend_id)
    friendships.where(friend_id: friend_id).count < 1
  end

  def except_current_user(users)
    users.reject {|user| user.id == self.id}
  end

  def self.search(params)
    return User.none if params.blank?
    params.strip!
    params.downcase!
    (first_name_matches(params) + last_name_matches(params) + email_matches(params))
  end

  def self.first_name_matches(params)
    matches('first_name', params)
  end

  def self.last_name_matches(params)
    matches('last_name', params)
  end

  def self.email_matches(params)
    matches('email', params)
  end

  def self.matches(field_name, params)
    where("lower(#{field_name}) like ?", "%#{params}%")
  end
end
