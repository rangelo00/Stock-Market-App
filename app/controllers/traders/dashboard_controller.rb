class Traders::DashboardController < ApplicationController
    before_action :authenticate_trader!
    
    def index
     #trader actions
    end
end
