# frozen_string_literal: true

module Ffe
  class FeatureFlagsController < ApplicationController
    before_action :set_ffe, only: %i[show edit update destroy]

    def index
      @feature_flags = ::Ffe::FeatureFlag.order(created_at: :desc)
    end

    def show; end

    def new
      @feature_flag = ::Ffe::FeatureFlag.new
    end

    def edit; end

    def create
      @feature_flag = ::Ffe::FeatureFlag.new(ffe_params)

      if @feature_flag.save
        redirect_to feature_flag_path(@feature_flag), notice: 'FFE wurde erstellt.'
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @feature_flag.update(ffe_params)
        redirect_to feature_flag_path(@feature_flag), notice: 'FFE wurde aktualisiert.'
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @feature_flag.destroy
      redirect_to feature_flags_path, notice: 'FFE wurde gelöscht.'
    end

    private

    def set_ffe
      @feature_flag = ::Ffe::FeatureFlag.find(params.expect(:id))
    end

    def ffe_params
      params.expect(feature_flag: %i[name description enabled])
    end
  end
end
