module Spree
  module V2
    module Storefront
      class TaxonSerializer < BaseSerializer
        set_type   :taxon

        attributes :name, :pretty_name, :permalink, :seo_title, :meta_title, :meta_description,
                   :meta_keywords, :left, :right, :position, :depth, :updated_at, :public_metadata

        attribute :description do |taxon|
          taxon.description.to_plain_text
        end

        attribute :has_products do |taxon|
          taxon.active_products_with_descendants.exists?
        end

        attribute :header_url do |taxon|
          url_helpers.cdn_image_url(taxon.image.attachment) if taxon.image.present? && taxon.image.attached?
        end

        attribute :is_root do |taxon|
          taxon.root?
        end

        attribute :is_child do |taxon|
          taxon.child?
        end

        attribute :is_leaf do |taxon|
          taxon.leaf?
        end

        attribute :localized_slugs do |taxon, params|
          taxon.localized_slugs_for_store(params[:store])
        end

        belongs_to :parent,   record_type: :taxon, serializer: :taxon
        belongs_to :taxonomy, record_type: :taxonomy

        has_many   :children, record_type: :taxon, serializer: :taxon
        has_many   :products, record_type: :product,
                              if: proc { |_taxon, params| params && params[:include_products] == true }

        has_one    :image,
                   object_method_name: :icon,
                   id_method_name: :icon_id,
                   record_type: :taxon_image,
                   serializer: :taxon_image
      end
    end
  end
end
