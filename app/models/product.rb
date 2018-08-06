class Product < ApplicationRecord
  STATES = %w[powder liquid solid].freeze
  BOOLEANS = [true, false].freeze

  belongs_to :brand

  enum state: STATES.map(&:to_sym)

  has_one :allergen, class_name: 'ProductAllergen', dependent: :destroy
  has_one :diet, class_name: 'ProductDiet', dependent: :destroy
  has_one :price, class_name: 'ProductPrice', dependent: :destroy
  has_one :shipment, class_name: 'ProductShipment', dependent: :destroy

  has_one_attached :image

  accepts_nested_attributes_for :allergen
  accepts_nested_attributes_for :diet
  accepts_nested_attributes_for :price

  validates :brand_id, presence: true
  validates :name, presence: true
  validates :kcal_per_serving, presence: true, numericality: true
  validates :protein_per_serving, presence: true, numericality: true
  validates :carbs_per_serving, presence: true, numericality: true
  validates :fat_per_serving, presence: true, numericality: true
  validates :subscription_available, inclusion: { in: BOOLEANS }
  validates :discount_for_subscription, inclusion: { in: BOOLEANS }
  validates :shaker_free_first_order, inclusion: { in: BOOLEANS }
  validates :sample_pack_available, inclusion: { in: BOOLEANS }
  validates :state, inclusion: { in: STATES }
  validates :active, inclusion: { in: BOOLEANS }

  validates_with ImageUploadValidator, attributes: [:image]

  scope :active, -> { where(active: true) }

  def protein_per_serving_ratio
    ratios[:protein_ratio]
  end

  def carbs_per_serving_ratio
    ratios[:carbs_ratio]
  end

  def fat_per_serving_ratio
    ratios[:fat_ratio]
  end

  private

    def ratios
      @ratios ||= ProductNutritionRatiosService.new({ product: self }).execute
    end
end