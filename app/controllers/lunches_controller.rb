class LunchesController < ApplicationController
  def new
    @members = Member.all
  end
end
