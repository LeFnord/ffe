# frozen_string_literal: true

module Ffe
  class FfesController < ApplicationController
    before_action :set_ffe, only: %i[show edit update destroy]

    def index
      @ffes = ::Ffe::Ffe.order(created_at: :desc)
    end

    def show; end

    def new
      @ffe = ::Ffe::Ffe.new
    end

    def edit; end

    def create
      @ffe = ::Ffe::Ffe.new(ffe_params)

      if @ffe.save
        redirect_to ffe_path(@ffe), notice: 'FFE wurde erstellt.'
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @ffe.update(ffe_params)
        redirect_to ffe_path(@ffe), notice: 'FFE wurde aktualisiert.'
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @ffe.destroy
      redirect_to ffes_path, notice: 'FFE wurde gelöscht.'
    end

    private

    def set_ffe
      @ffe = ::Ffe::Ffe.find(params.expect(:id))
    end

    def ffe_params
      params.expect(ffe: [:name])
    end
  end
end
