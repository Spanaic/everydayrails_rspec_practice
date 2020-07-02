require 'rails_helper'

describe User do
  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end
end

RSpec.describe User, type: :model do

  # 姓、名、メール、パスワードがあれば有効な状態であること
  it 'is valid with a first name, last name, email, and password' do
    user = User.new(
      first_name: 'Aaron',
      last_name: 'Summer',
      email: 'tester@example.com',
      password: 'dottle-nouveau-pavilion-tights-furze',
    )
    expect(user).to be_valid
  end
  # 名がなければ無効な状態であること
  it { is_expected.to validate_presence_of :first_name }
  # it 'is invalid without a first name' do
  #   user = FactoryBot.build(:user, first_name: nil)
  #   user.valid?
  #   expect(user.errors[:first_name]).to include("can't be blank")
  # end

  # 姓がなければ無効な状態であること
  it { is_expected.to validate_presence_of :last_name }
  # it 'is invalid without a last name' do
  #   user = FactoryBot.build(:user, last_name: nil)
  #   user.valid?
  #   expect(user.errors[:last_name]).to include("can't be blank")
  # end

  # メールがなければ無効な状態であること
  it { is_expected.to validate_presence_of :email }
  # it 'is invalid without a email address' do
  #   user = FactoryBot.build(:user, email: nil)
  #   user.valid?
  #   expect(user.errors[:email]).to include("can't be blank")
  # end

  # 重複したメールアドレスなら無効の状態であること
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  # it 'is invalid with a duplicate email address' do
  #   FactoryBot.create(:user, email: 'aaron@example.com')
  #   user = FactoryBot.build(:user, email: 'aaron@example.com')
  #   user.valid?
  #   expect(user.errors[:email]).to include("has already been taken")
  # end

  # ユーザーのフルネームを文字列として返すこと
  it "returns a user's fullname as a string" do
    user = FactoryBot.build(:user, first_name: 'John', last_name: 'Doe')
    expect(user.name).to eq "John Doe"
  end

  # アカウントが作成されたときにウェルカムメールを送信すること
  it "sends a welcome email on account creation" do
    allow(UserMailer).to \
      receive_message_chain(:welcome_email, :deliver_later)
    user = FactoryBot.create(:user)
    expect(UserMailer).to have_received(:welcome_email).with(user)
  end

end
