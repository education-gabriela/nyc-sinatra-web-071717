class FiguresController < ApplicationController
  get "/figures/new" do
    @figures = Figure.all
    @titles = Title.all
    @landmarks = Landmark.all
    erb :"figures/new"
  end

  get "/figures/:id/edit" do
    @figure = Figure.find(params[:id].to_i)
    @titles = Title.all
    @landmarks = Landmark.all
    erb :"figures/edit"
  end

  patch "/figures/:id" do
    @figure = Figure.find(params[:id].to_i)
    @figure.titles.clear
    @figure.name = params[:figure][:name]

    title_ids = params[:figure][:title_ids]
    landmark_ids = params[:figure][:landmark_ids]
    title_name = params[:title][:name]
    landmark_name = params[:landmark][:name]

    title_ids.each do |title_id|
      @title = Title.find(title_id)
      @figure.titles << @title
    end if title_ids

    landmark_ids.each do |landmark_id|
      landmark = Landmark.find(landmark_id)
      @figure.landmarks << landmark
    end if landmark_ids

    if !title_name.empty?
      new_title = Title.create(name: title_name)
      @figure.titles << new_title
    end

    if !landmark_name.empty?
      new_landmark = Landmark.create(name: landmark_name)
      @figure.landmarks << new_landmark
    end

    @figure.save
    redirect "/figures/#{@figure.id}"
  end

  post "/figures" do
    @figure = Figure.create(name: params[:figure][:name])
    title_ids = params[:figure][:title_ids]
    landmark_ids = params[:figure][:landmark_ids]
    title_name = params[:title][:name]
    landmark_name = params[:landmark][:name]

    title_ids.each do |title_id|
      FigureTitle.create(title_id: title_id, figure_id: @figure.id)
    end if title_ids

    landmark_ids.each do |landmark_id|
      landmark = Landmark.find(landmark_id.to_i)
      landmark.figure = @figure
      landmark.save
    end if landmark_ids

    FigureTitle.create(title: Title.create(name: title_name), figure: @figure) if !title_name.empty?
    Landmark.create(name: landmark_name, figure: @figure) if !landmark_name.empty?
  end

  get "/figures" do
    @figures = Figure.all
    erb :"figures/index"
  end

  get "/figures/:id" do
    @figure = Figure.find(params[:id].to_i)
    erb :"figures/show"
  end
end