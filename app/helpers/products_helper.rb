# frozen_string_literal: true

module ProductsHelper
  def products_page?
    current_page?(products_path) || current_page?(created_products_path) || \
      current_page?(purchased_products_path) || current_page?(root_path)
  end
end
