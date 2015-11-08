class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :wikis

  before_create :make_member

  def admin?
    role == 'admin'
  end

  def moderator?
    role == 'moderator'
  end

  private

  def make_member
    self.role = "member" unless self.role
  end
end
