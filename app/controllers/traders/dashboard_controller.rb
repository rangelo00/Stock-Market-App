class Traders::DashboardController < ApplicationController
    before_action :authenticate_trader!
    
    def_index
     #trader actions
    end
end