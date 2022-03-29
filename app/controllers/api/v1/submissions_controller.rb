module Api
  module V1
    class SubmissionsController < BaseController

      def index
        submissions_scope ||= dates_present? ? scope_with_dates : scope
        
        unsorted_sites.each do |id|
          submissions_scope = submissions_scope.exclude_unsorted(id)
        end

        paginate json: submissions_scope.order(record_taken: :desc), per_page: page_size
      end

      def data
        # TODO - add some specs you lazy sod.
        date = (Date.today - 1.year).beginning_of_month

        submissions ||= scope_without_images(date)
        submissions_data = SubmissionsDataCreateService.new(submissions, Date.today - 1.year).create
        render json: submissions_data
      end

      private

        def scope
          Submission.with_attached_image
                    .includes([:site, :taggings, image_attachment: :blob])
                    .search_site(site_filter)
                    .type_search(type_filter)
                    .with_tags(tag_filter)
        end

        def scope_with_dates
          Submission.with_attached_image
                    .where(:record_taken => start_date..end_date.to_time)
                    .includes([:site, :taggings, image_attachment: :blob])
                    .search_site(site_filter)
                    .type_search(type_filter)
                    .with_tags(tag_filter)
        end

        def scope_without_images(date)
          Submission.where('record_taken >= ?', date).search_site(site_filter).type_search(type_filter).with_tags(tag_filter)
        end

        def permitted_params
          params.permit(:reliable, 
                        :site_id,
                        :site_filter,
                        :type_filter,
                        :tags,
                        :bespoke_size,
                        :page,
                        :start_date,
                        :end_date)
        end

        def page_size
          params[:bespoke_size] || (params[:page] && params[:page][:size]) || 10
        end
       
        def dates_present?
          permitted_params[:start_date].present? && permitted_params[:end_date].present?
        end
        
        def start_date
          permitted_params[:start_date].to_date
        end

        def end_date
          permitted_params[:end_date].to_date
        end

        def site_filter
          Site.find_by(name: permitted_params[:site_filter]).id if permitted_params[:site_filter].present?
        end

        def type_filter
          permitted_params[:type_filter]
        end

        def tag_filter
          permitted_params[:tags]
        end
        
        def unsorted_sites
          @unsorted_sites||= Site::UNSORTED_SITES.map {|name| Site.find_by(name: name).try(:id) }
        end
    end
  end
end