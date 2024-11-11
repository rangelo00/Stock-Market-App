class Admin::DashboardController < ApplicationController
    before_action :authenticate_admin!
  
    def index
      # admin actions
    end
  end