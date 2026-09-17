# frozen_string_literal: true

module Ffe
  class FeatureFlagsController < ApplicationController
    before_action :set_ffe, only: %i[show edit update destroy]

    def index
      @feature_flags = Ffe::FeatureFlag.order(created_at: :desc)
    end

    def show; end

    def new
      @feature_flag = Ffe::FeatureFlag.new
    end

    def edit; end

    def create
      @feature_flag = Ffe::FeatureFlag.new(feature_flag_params.except(:milieus, :clear_expires_at))

      respond_to do |format|
        if @feature_flag.save
          format.html { redirect_to feature_flags_path, notice: 'FFE created.' }
          format.turbo_stream { render turbo_stream: turbo_stream.prepend(:feature_flags, partial: 'ffe/feature_flags/feature_flag', locals: { feature_flag: @feature_flag }) } # rubocop:disable Layout/LineLength
          format.json { render json: @feature_flag, status: :created }
        else
          format.html { render :new, status: :unprocessable_content }
          format.json { render json: @feature_flag.errors, status: :unprocessable_content }
        end
      end
    end

    def update
      respond_to do |format|
        if @feature_flag.update(feature_flag_params.except(:milieus, :clear_expires_at))
          format.html { redirect_to feature_flags_path, notice: 'FFE updated.' }
          format.turbo_stream { render turbo_stream: turbo_stream.replace(ActionView::RecordIdentifier.dom_id(@feature_flag), partial: 'ffe/feature_flags/feature_flag', locals: { feature_flag: @feature_flag }) }
          format.json { render json: @feature_flag, status: :ok }
        else
          format.html { render :edit, status: :unprocessable_content }
          format.json { render json: @feature_flag.errors, status: :unprocessable_content }
        end
      end
    end

    def destroy
      @feature_flag.destroy
      respond_to do |format|
        format.html { redirect_to feature_flags_path, notice: 'FFE destroyed.' }
        format.turbo_stream { render turbo_stream: turbo_stream.remove(ActionView::RecordIdentifier.dom_id(@feature_flag)) }
      end
    end

    def dump
      render json: Ffe::FeatureFlag.order(:name).map { |ff| ff.attributes.slice('name', 'description', 'enabled', 'milieu', 'expires_at') }
    end

    private

    def set_ffe
      @feature_flag = Ffe::FeatureFlag.find(params.expect(:id))
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
