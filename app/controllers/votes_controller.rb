class VotesController < ApplicationController
  include Common
  layout        :select_layout
  before_action :logged_in_user, only: [:new, :create]
  before_action :set_projects, only: [:select_project, :new, :create]
  
  def new
    if params[:project_id].present?
      @project_id = params[:project_id].to_i
      @project_options = ProjectOption.where(project_id: params[:project_id]).map{|p| [p.name, p.id]}
      if @project_options.size == 1
        @project_options = [["賛成", @project_options.first[1]]]
      end
      @project_options << ["反対", 0]
    else
      flash.now[:danger] = "プロジェクトを選択してください"
      render 'select_project'
    end
    @vote = Vote.new
  end
  
  def select_project
  end
  
  def create
    vote = Vote.new(vote_params)
      if vote.save
        flash[:info] = "投票しました"
        redirect_to project_path(params[:vote][:project_id])
      else
        flash[:warning] = "#{Project.find(params[:vote][:project_id]).name}はすでに投票してます"
        render 'select_project'
      end
  end
  
  # def new2
  #   soukai_id = Soukai.narrow_year(Date.today.year).map(&:id)
  #   @project = Project.where(soukai_id: soukai_id).order("id desc").map{|project| [project.name, project.id]}
  #   @project_options = ProjectOption.where(project_id: @project.map{|p| p[1]})
  # end
  
  # def project_options_select
  # # ajax によるリクエストの場合のみ処理
  #   if request.xhr?
  #     if params[:vote_id].present? && params[:vote_id].to_s != 'votes'
  #       vote = vote.find(params[:vote_id])
  #     else
  #       vote = Vote.new
  #     end
  
  #     project_options = ProjectOption.select(:id, :name).where(project_id: params[:project_id])
  
  #     render partial: '/votes/form_project_options', locals: { vote: vote, project_options: project_options}
  #   end
  # end
  
  private
     # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        vote_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
     
    def set_projects
      soukai_id = Soukai.narrow_year(Date.today.year).map(&:id)
      @projects = Project.where(soukai_id: soukai_id).order("id desc").map{|project| [project.name, project.id]}
    end
    
    def vote_params
      params.require(:vote).permit(:project_id, :project_option_id, :user_id)
    end
      
end
