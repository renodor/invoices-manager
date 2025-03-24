# frozen_string_literal: true

class DescriptionBlocksController < ApplicationController
  before_action :set_quote
  before_action :set_description_block, only: %i[edit update update_position destroy]

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

  def edit; end

  def update
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

  def update_position
    @description_block = @quote.description_blocks.find(params[:id])

    if params[:move] == 'up'
      other_block = @quote.description_blocks.where('position < ?', @description_block.position).ordered.last
    elsif params[:move] == 'down'
      other_block = @quote.description_blocks.where('position > ?', @description_block.position).ordered.first
    end

    if other_block
      other_position = other_block.position
      other_block.update!(position: @description_block.position)
      @description_block.update!(position: other_position)
    end

    @description_blocks = @quote.description_blocks.ordered
  end

  def destroy
    @description_block.destroy

    respond_to do |format|
      format.html { redirect_to quote_path(@quote), notice: 'Description block was successfully destroyed.' }
      format.turbo_stream { flash.now[:notice] = 'Description block was successfully destroyed.' }
    end
  end

  private

  def set_quote
    @quote = current_user.quotes.find(params[:quote_id])
  end

  def set_description_block
    @description_block = @quote.description_blocks.find(params[:id])
  end

  def description_block_params
    params.require(:description_block).permit(:text, :flavor)
  end
end
