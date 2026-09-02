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
      @feature_flag = ::Ffe::FeatureFlag.new(feature_flag_params.except(:milieus, :clear_expires_at))

      if @feature_flag.save
        redirect_to feature_flag_path(@feature_flag), notice: 'FFE wurde erstellt.'
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @feature_flag.update(feature_flag_params.except(:milieus, :clear_expires_at))
        redirect_to feature_flag_path(@feature_flag), notice: 'FFE wurde aktualisiert.'
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @feature_flag.destroy
      redirect_to feature_flags_path, notice: 'FFE wurde gelöscht.'
    end

    def dump
      render json: Ffe::FeatureFlag.order(:name).map { |ff| ff.attributes.slice('name', 'description', 'enabled', 'milieu', 'expires_at', 'percentage') }
    end

    private

    def set_ffe
      @feature_flag = ::Ffe::FeatureFlag.find(params.expect(:id))
    end

    def feature_flag_params
      params.expect(
        feature_flag: [:name, :description, :enabled, :expires_at, :clear_expires_at, { user_ids: [], milieus: {} }]
      ).tap do |params|
        params[:milieu] = params[:milieus].values.join.ljust(Ffe.config.bitlength, '0') if params[:milieus].present?
        params[:expires_at] = nil if params[:clear_expires_at] == '1'
        params[:user_ids]&.delete_if(&:blank?)
      end
    end
  end
end
