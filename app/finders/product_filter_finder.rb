class ProductFilterFinder
  ALLOWED_PARAMS = [
    :subscription_available,
    :discount_for_subscription,

    # States
    :powder,
    :bottle,
    :snack,

    # Diet
    :vegetarian,
    :vegan,
    :ketogenic,

    # Allergens
    :gluten_free,
    :lactose_free,
    :nut_free,
    :ogm_free,
    :soy_free,

    # Shipment
    :united_states,
    :canada,
    :europe,
    :rest_of_world
  ].freeze

  def initialize(products, params = {})
    @products = products
    @params = params.permit(ALLOWED_PARAMS)
  end

  def execute
    by_state

    by(:subscription_available)
    by(:discount_for_subscription)

    by_diet(:vegetarian)
    by_diet(:vegan)
    by_diet(:ketogenic)

    by_shipment(:united_states)
    by_shipment(:canada)
    by_shipment(:europe)
    by_shipment(:rest_of_world)

    by_allergen(:gluten)
    by_allergen(:lactose)

    @products
  end

  private
    def by_state
      query = []

      # Can be more DRY via Product.states.keys.each
      # but we are losing in readability, let's keep it
      # as-is right now.
      if @params[:powder].present?
        query.push("state = #{Product.states[:powder]}")
      end

      if @params[:bottle].present?
        query.push("state = #{Product.states[:bottle]}")
      end

      if @params[:snack].present?
        query.push("state = #{Product.states[:snack]}")
      end

      unless query.empty?
        @products = @products.where(query.join(' or '))
      end
    end

    def by(column)
      return unless @params[column].present?

      @products = @products.where(column => true)
    end

    def by_diet(column)
      by_relation(:diet, :product_diets, column)
    end

    def by_shipment(column)
      by_relation(:shipment, :product_shipments, column)
    end

    def by_allergen(column)
      column_as_param = "#{column}_free".to_sym # :gluten becomes :gluten_free

      return unless @params[column_as_param].present?

      @products = @products.joins(:allergen).where(product_allergens: { column => false })
    end

    private

      def by_relation(relation, relation_scope, column)
        return unless @params[column].present?

        @products = @products.joins(relation).where(relation_scope => { column => true })
      end
end
