class Result < ActiveHash::Base
  self.data = [
    { id: 0, name: '--' },
    { id: 1, name: '〇成約' },
    { id: 2, name: '△検討中' },
    { id: 3, name: '□定期見積・価格調査' },
    { id: 4, name: '×価格' },
    { id: 5, name: '×納期' },
    { id: 6, name: '×形状' },
    { id: 7, name: '×その他' }
  ]

  include ActiveHash::Associations
  has_many :sales_quotation_items, class_name: 'SalesQuotationItem'
  has_many :purchase_quotation_items, class_name: 'PurchaseQuotationItem'

end
