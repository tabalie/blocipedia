class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :wikis

  PREMIUM = "premium"
  STANDARD = "standard"

  def premium?
    role == PREMIUM
  end

  def standard?
    role == STANDARD
  end

  def make_premium
    self.role = PREMIUM
    save
  end

  def make_standard
    self.role = STANDARD
    save
  end

end
