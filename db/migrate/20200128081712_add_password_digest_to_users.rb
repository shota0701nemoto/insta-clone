class AddPasswordDigestToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :password_digest, :string   #add_columnメソッドによってusersテーブルにpassword_digestカラムを追加している。
  end
end
