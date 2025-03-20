# frozen_string_literal: true

class DescriptionBlocksController < ApplicationController
  def new
    @quote = current_user.quotes.find(params[:quote_id])
    @description_block = @quote.description_blocks.new(flavor: params[:flavor])
  end

  def create
    @quote = current_user.quotes.find(params[:quote_id])
    @description_block = @quote.description_blocks.build(description_block_params)
    @description_block.position = (@quote.description_blocks.ordered.last&.position || 0) + 1
    @description_block.text = @description_block.text.gsub('- ', '') if @description_block.flavor == 'list'

    if @description_block.save
      respond_to do |format|
        format.html { redirect_to quote_path(@quote), notice: 'Description block was successfully created.' }
        format.turbo_stream { flash.now[:notice] = 'Description block was successfully created.' }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def description_block_params
    params.require(:description_block).permit(:text, :flavor)
  end
end
