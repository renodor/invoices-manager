# frozen_string_literal:true

class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def sign_in_demo_user
    sign_in(User.demo_user)
    redirect_to(root_path)
  end
end
