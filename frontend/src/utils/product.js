export const PRODUCT_STATUS = {
  ON_SALE: { text: '在售', className: 'on-sale' },
  LOCKED: { text: '已被预约', className: 'locked' },
  SOLD: { text: '已售出', className: 'sold' },
  OFF_SHELF: { text: '已下架', className: 'off-shelf' },
  DELETED: { text: '已删除', className: 'deleted' }
}

export function getStatusMeta(status) {
  return PRODUCT_STATUS[status] || { text: status, className: 'unknown' }
}

export function getCategoryName(categories, categoryId) {
  if (!categoryId) return ''
  return categories.find((item) => item.id === Number(categoryId))?.name || '其他闲置'
}
