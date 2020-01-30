require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name:  "Example User",
      email: "user@example.com",
      password: "foobar",
      password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

   test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?                                                    #244文字の長すぎるメールアドレスを入力されているのでfalseを返す。成功。
  end

  test "email validation should accept valid addresses" do                     #メールの入力チェックは有効なアドレスによって同意されるべき
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]                   #有効なメールアドレスを入力することによってわざとミスする。
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"          #inspectメソッドによってどのアドレスで失敗したのかを確認する。
    end
  end

  test "email validation should reject invalid addresses" do                   #メールの入力チェックは無効なアドレスによって拒否されるべき
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]                    #無効なメールアドレスを入力することによってわざとミスする。
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"  #inspectメソッドによってどのアドレスで失敗したのかを確認する。
    end
  end

  test "email addresses should be unique" do                #メールアドレスはオリジナルであるべき
    duplicate_user = @user.dup                              #Userオブジェクトを複製する。→わざと間違える。
    duplicate_user.email = @user.email.upcase               #複製したUserオブジェクトのメールアドレスは小文字にする。
    @user.save                                              #userオブジェクトをセーブする。
    assert_not duplicate_user.valid?                        #Userオブジェクト（@user）は複製されていて2つ以上ある。falseを返すので成功。
  end

  test "password should be present (nonblank)" do           #パスワードは何かしら入力されるべき
    @user.password = @user.password_confirmation = " " * 6  #0を入れることによってわざと間違える。
    assert_not @user.valid?                                 #Userオブジェクト（@user）は0。falseを返すので成功。
  end

  test "password should have a minimum length" do           #パスワードは最低限の長さを持つべき
    @user.password = @user.password_confirmation = "a" * 5  #aaaaaにすることによってわざと間違える
    assert_not @user.valid?                                 #Userオブジェクト（@user）はaaaaa。falseを返すので成功。
  end

  

end
