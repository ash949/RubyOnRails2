class BranchesController < ApplicationController

  def get_coordinates 
    render json: Branch.all
  end

end