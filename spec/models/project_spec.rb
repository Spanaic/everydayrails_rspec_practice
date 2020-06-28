require 'rails_helper'

RSpec.describe Project, type: :model do

  before do
    @user = FactoryBot.create(:user)
  end

  # プロジェクト名があれば有効な状態であること
  it "is valid with a name" do
    project = @user.projects.new(
      name: "Test Project",
    )
    project.valid?
    expect(project).to be_valid
  end

  # プロジェクト名がなければ無効な状態であること
  it "is invalid without a name" do
    project = @user.projects.new(
      name: nil,
    )
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id)}
  # it "does not allow duplicate project names per user" do
    # @user.projects.create(
    #   name: "Test Project"
    # )

    # new_project = @user.projects.build(
    #   name: "Test Project"
    # )

    # new_project.valid?
    # expect(new_project.errors[:name]).to include("has already been taken")
  # end

  # 二人のユーザーが同じ名前を使うことは許可すること
  it "allows two users to share a project name" do

    @user.projects.create(
      name: 'Test Project',
    )

    other_user = User.create(
      first_name: "Jane",
      last_name: "Tester",
      email: "janetester@example.com",
      password: "dottle-nouveau-pavilion-tights-furze",
    )

    other_project = other_user.projects.build(
      name: 'Test Project',
    )

    expect(other_project).to be_valid
  end

  describe "Late status" do
    # 締切日が過ぎていれば遅延していること
    it "is late when the due date is past today" do
      # project = FactoryBot.create(:project_due_yesterday)
      project = FactoryBot.create(:project, :due_yesterday) # trait Ver.
      expect(project).to be_late
    end

    # 締切日が今日ならスケジュール通りであること
    it "is on time when the due date is today" do
      # project = FactoryBot.create(:project_due_today)
      project = FactoryBot.create(:project, :due_today) # trait Ver.
      expect(project).to_not be_late
    end

    # 締切日が未来ならスケジュール通りであること
    it "is on time when due date is the future" do
      # project = FactoryBot.create(:project_due_tomorrow)
      project = FactoryBot.create(:project, :due_tomorrow) # trait Ver.
      expect(project).to_not be_late
    end
  end

  # たくさんのメモが付いていること
  it "can have many notes" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end
end
