# branches controller
class BranchesController < ApplicationController
  def coordinates
    render json: Branch.all
  end
end
