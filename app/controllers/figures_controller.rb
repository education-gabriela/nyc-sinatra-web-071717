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
    @figure = Figure.find(params[:id])
    @figure.update(params[:figure])

    title_name = params[:title][:name]
    landmark_name = params[:landmark][:name]

    @figure.titles << Title.create(name: title_name) if !title_name.empty?
    @figure.landmarks << Landmark.create(name: landmark_name) if !landmark_name.empty?
    @figure.save

    redirect "/figures/#{@figure.id}"
  end

  post "/figures" do
    @figure = Figure.create(params[:figure])

    title_name = params[:title][:name]
    landmark_name = params[:landmark][:name]

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