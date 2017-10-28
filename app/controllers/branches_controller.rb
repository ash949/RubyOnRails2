class BranchesController < ApplicationController

  def get_coordinates
    branch = Branch.find_by name: params[:branch].to_s 
    render json: {lat: branch.lat, lng: branch.lng}
  end

end