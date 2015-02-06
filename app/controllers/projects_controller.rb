class ProjectsController < Application

  def index
    @projects = Project.all
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def find_params
    @user = User.find(params[:id])
  end

  def project_params
  end


end
