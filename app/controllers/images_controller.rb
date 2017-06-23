class ImagesController < ApplicationController

  def index
    @images = Image.limit(20)
  end

  def new 
    @image = Image.new
  end 

  def create
    upload_file = image_params[:file]
    image = {}
    if upload_file != nil 
      image[:filename] = upload_file.original_filename
      image[:file] = upload_file.read
    end 
    @image = Image.new(image)
    if @image.save
      flash[:success] = "画像を保存しました。"
      redirect_to controller: 'products',action: 'index'
    else
      flash[:error] = "保存できませんでした。"
    end 
  end

  def destroy
	Image.find_by(id: params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def show_image

    # send_dataはバイナリファイルをブラウザに表示するため
    # http://railsdoc.com/references/send_data

    @image = Image.find(params[:id])
    send_data @image.file, :type => 'image/jpeg', :disposition => 'inline'
  end

  private

    def image_params
      params.require(:image).permit(
        :filename,:file
      )   
    end
end
