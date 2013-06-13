# encoding: utf-8
class BackersController < InheritedResources::Base
  before_filter :authenticate_user!

  def index
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  def new
    @backer = current_user.backers.build
    @project = Project.find(params[:project_id])
    @rewards = @project.rewards
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @backer = current_user.backers.build(params[:backer])
    @user = current_user
    respond_to do |format|
      if @backer.save
        @user.change_points({ points: 70, type: 1 })
        format.html { redirect_to root_path, notice: 'Obrigado por nos ajudar, estamos avaliando suas doações!' }
        format.json { render json: @backer, status: :created, location: @backer }
      else
        format.html { render action: "new" }
        format.json { render json: @backer.errors, status: :unprocessable_entity }
      end
    end
  end

end
