class User < ApplicationRecord
  before_save { self.email = email.downcase }                 #オブジェクトが保存される時点でemail属性を小文字に変換
  validates :name,  presence: true, length: { maximum: 50 }   #validatesメソッド。指定された属性(name)が空でない、nameの長さは50以下でなければいけない。
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, #validatesメソッドでemailが空でない、つまり存在していなければいけない。emailの長さは255を超えてはいけない。
                    format: { with: VALID_EMAIL_REGEX },
                     uniqueness: { case_sensitive: false }     #uniquenessメソッドで保存されているemail内に同じメールアドレスがないことを確認。case_sensitiveで大文字、小文字を区別しないよう設定している。
has_secure_password                                            #has_secure_passwordにはpassword属性とconfirmation属性に対してバリデーションをする機能が強制的に追加されているのでuser.testの@user変数に値を追加する必要がある。
 validates :password, presence: true, length: { minimum: 6 }  # validatesメソッドで指定された属性（password）が空でないことと、長さが最低6つ以上あることを確認している。

end
