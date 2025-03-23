# frozen_string_literal: true

class DescriptionBlocksController < ApplicationController
  before_action :set_quote

  def new
    @description_block = @quote.description_blocks.new(flavor: params[:flavor])
  end

  def create
    @description_block = @quote.description_blocks.build(description_block_params)
    @description_block.position = (@quote.description_blocks.ordered.last&.position || 0) + 1

    if @description_block.save
      respond_to do |format|
        format.html { redirect_to quote_path(@quote), notice: 'Description block was successfully created.' }
        format.turbo_stream { flash.now[:notice] = 'Description block was successfully created.' }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @description_block = @quote.description_blocks.find(params[:id])
  end

  def update
    @description_block = @quote.description_blocks.find(params[:id])
    @description_block.text = description_block_params[:text]
    if @description_block.save
      respond_to do |format|
        format.html { redirect_to quote_path(@quote), notice: 'Description block was successfully updated.' }
        format.turbo_stream { flash.now[:notice] = 'Description block was successfully updated.' }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @description_block = @quote.description_blocks.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to quote_path(@quote), notice: 'Description block was successfully destroyed.' }
      format.turbo_stream { flash.now[:notice] = 'Description block was successfully destroyed.' }
    end
  end

  private

  def set_quote
    @quote = current_user.quotes.find(params[:quote_id])
  end

  def description_block_params
    params.require(:description_block).permit(:text, :flavor)
  end
end
