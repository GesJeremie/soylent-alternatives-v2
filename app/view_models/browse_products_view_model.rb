class BrowseProductsViewModel < ApplicationViewModel
  def cache_key
    [
      'products',
      Product.maximum(:updated_at)&.to_s(:number),
      options_cache_key
    ].join('/')
  end

  def products
    @products ||= begin
      products = BrowseProductsFinder.new(options).perform
      products = ProductViewModel.wrap(products, options)

      PagedArray.new(
        products,
        page: options[:page],
        per_page: CompleteFoods.config.browse_products_per_page
      )
    end
  end
end
