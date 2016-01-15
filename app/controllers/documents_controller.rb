class DocumentsController < ApplicationController

  def index
    @documents = Documents.all
  end

  def new
  end

  def create
    description = params[:description]
    document = params[:doc]
    if !description || !document
      flash[:notice] = "Params Error"
      redirect_to "/add"
    end
    name = File.basename(document.original_filename)
    dir = "public/documents/"
    Dir.mkdir(dir) unless File.exists?(dir)
    path = File.join(dir, name)
    begin
      Documents.new({:name => name, :description => description}).save
      begin
        File.open(path, "wb") { |f| f.write(document.read) }
        redirect_to "/documents"
      rescue
        flash[:notice]="Error uploading file"
        doc = Documents.where({:name => name})[0]
        Documents.delete(doc.id)
        redirect_to "/add"
      end
    rescue
      flash[:notice]="File with similar name already present"
      flash.alert
      redirect_to "/add"
    end
  end

  def delete
    begin
      @document = Documents.find(params[:id])
      begin
        File.delete("public/documents/"+@document.name)
        Documents.delete(params[:id])
      rescue
        flash[:notice]="Error deleting file"
      end
    rescue
      flash[:notice]="no such file"
    end
    redirect_to "/documents"
  end

end