module Paginable
  protected

  def current_page
    (params[:page] || 1).to_i
  end

  def size
    (params[:size] || 10).to_i
  end
end
