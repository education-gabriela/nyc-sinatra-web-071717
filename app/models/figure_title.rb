class FigureTitle < ActiveRecord::Base
  belongs_to :figure
  belongs_to :title

  def self.add_figure_title_from_figure_id_and_title_id(params)
    FigureTitle.create(params)
  end
end