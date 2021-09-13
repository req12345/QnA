class UsersController < ApplicationController
  def rewards
    @rewards = current_user.rewards
  end
end
