class ProductSortFinder
  attr_reader :products, :params

  ALLOWED_PARAMS = [:sort].freeze
  ALLOWED_VALUES = Rails.configuration.sorters.map { |sorter| sorter[:value] }.freeze

  def initialize(products, params = {})
    @products = products
    @params = params.permit(ALLOWED_PARAMS)
  end

  def execute
    return @products unless @params[:sort].present?
    return @products if @params[:sort] == 'nothing'
    return @products unless ALLOWED_VALUES.include?(@params[:sort].to_sym)

    send(@params[:sort])
  end

    private

      # KCAL
      def kcal_per_serving_lowest
        @products.sort_by(&:kcal_per_serving)
      end

      def kcal_per_serving_most
        @products.sort_by(&:kcal_per_serving).reverse
      end

      # FAT
      def fat_per_serving_lowest
        @products.sort_by(&:fat_per_serving)
      end

      def fat_per_serving_most
        @products.sort_by(&:fat_per_serving).reverse
      end

      def fat_per_serving_ratio_lowest
        @products.sort_by(&:fat_per_serving_ratio)
      end

      def fat_per_serving_ratio_most
        @products.sort_by(&:fat_per_serving_ratio).reverse
      end

      # CARBS
      def carbs_per_serving_lowest
        @products.sort_by(&:carbs_per_serving)
      end

      def carbs_per_serving_most
        @products.sort_by(&:carbs_per_serving).reverse
      end

      def carbs_per_serving_ratio_lowest
        @products.sort_by(&:carbs_per_serving_ratio)
      end

      def carbs_per_serving_ratio_most
        @products.sort_by(&:carbs_per_serving_ratio).reverse
      end

      # PROTEIN
      def protein_per_serving_lowest
        @products.sort_by(&:protein_per_serving)
      end

      def protein_per_serving_most
        @products.sort_by(&:protein_per_serving).reverse
      end

      def protein_per_serving_ratio_lowest
        @products.sort_by(&:protein_per_serving_ratio)
      end

      def protein_per_serving_ratio_most
        @products.sort_by(&:protein_per_serving_ratio).reverse
      end

      # PRICE (serving)
      def price_per_serving_minimum_order_cheapest
        @products.sort_by { |product| product.price.per_serving_minimum_order_in_currency('USD') }
      end

      def price_per_serving_minimum_order_most_expensive
        @products.sort_by { |product| product.price.per_serving_minimum_order_in_currency('USD') }.reverse
      end

      def price_per_serving_bulk_order_cheapest
        @products.sort_by { |product| product.price.per_serving_bulk_order_in_currency('USD') }
      end

      def price_per_serving_bulk_order_most_expensive
        @products.sort_by { |product| product.price.per_serving_bulk_order_in_currency('USD') }.reverse
      end

      # PRICE (day)
      def price_per_day_minimum_order_cheapest
        @products.sort_by { |product| product.price.per_day_minimum_order_in_currency('USD') }
      end

      def price_per_day_minimum_order_most_expensive
        @products.sort_by { |product| product.price.per_day_minimum_order_in_currency('USD') }.reverse
      end

      def price_per_day_bulk_order_cheapest
        @products.sort_by { |product| product.price.per_day_bulk_order_in_currency('USD') }
      end

      def price_per_day_bulk_order_most_expensive
        @products.sort_by { |product| product.price.per_day_bulk_order_in_currency('USD') }.reverse
      end

end
