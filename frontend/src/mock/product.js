import { categories, products } from './data.js'

const wait = (result, delay = 180) =>
  new Promise((resolve) => setTimeout(() => resolve(result), delay))

function sortProducts(list, sort) {
  const sorted = [...list]
  if (sort === 'price_asc') return sorted.sort((a, b) => a.price - b.price)
  if (sort === 'price_desc') return sorted.sort((a, b) => b.price - a.price)
  if (sort === 'popular') return sorted.sort((a, b) => b.favoriteCount - a.favoriteCount)
  return sorted.sort((a, b) => b.createTime.localeCompare(a.createTime))
}

export function listCategories() {
  return wait(categories)
}

export function listProducts(params = {}) {
  const {
    keyword = '',
    categoryId = 0,
    minPrice,
    maxPrice,
    conditionLevel = '',
    sort = 'newest',
    page = 1,
    pageSize = 6
  } = params

  const normalizedKeyword = keyword.trim().toLowerCase()
  const filtered = products.filter((product) => {
    const matchesKeyword =
      !normalizedKeyword ||
      `${product.title}${product.description}`.toLowerCase().includes(normalizedKeyword)
    const matchesCategory = !Number(categoryId) || product.categoryId === Number(categoryId)
    const matchesMinPrice = minPrice === '' || minPrice === undefined || product.price >= Number(minPrice)
    const matchesMaxPrice = maxPrice === '' || maxPrice === undefined || product.price <= Number(maxPrice)
    const matchesCondition = !conditionLevel || product.conditionLevel === conditionLevel
    const isVisible = ['ON_SALE', 'LOCKED'].includes(product.status)
    return matchesKeyword && matchesCategory && matchesMinPrice && matchesMaxPrice && matchesCondition && isVisible
  })

  const sorted = sortProducts(filtered, sort)
  const start = (Number(page) - 1) * Number(pageSize)
  const list = sorted.slice(start, start + Number(pageSize))
  return wait({ list, total: sorted.length, page: Number(page), pageSize: Number(pageSize) })
}

export function getProductDetail(id) {
  const product = products.find((item) => item.id === Number(id))
  if (!product) return Promise.reject(new Error('商品不存在或已下架'))
  return wait(product)
}

export function createProduct(form) {
  const id = Math.max(...products.map((item) => item.id)) + 1
  const product = {
    id,
    sellerId: 99,
    ...form,
    categoryId: Number(form.categoryId),
    originalPrice: Number(form.originalPrice || 0),
    price: Number(form.price),
    status: 'ON_SALE',
    viewCount: 0,
    favoriteCount: 0,
    createTime: new Date().toISOString().slice(0, 16).replace('T', ' '),
    seller: { nickname: '我', college: '中国农业大学', avatarUrl: '' }
  }
  products.unshift(product)
  return wait({ id, status: 'ON_SALE' }, 350)
}

export function optimizeTitle({ title, categoryName, conditionLevel }) {
  const base = title.trim() || `${categoryName || '校园闲置'}好物`
  const prefix = conditionLevel ? `${conditionLevel}` : '自用'
  return wait({
    titles: [
      `${prefix}${base}，校内方便面交`,
      `${base}转让，成色良好`,
      `校园闲置：${base}`
    ]
  }, 500)
}

export function generateDescription({ title, categoryName, conditionLevel, meetLocation }) {
  return wait({
    description: `${title || '这件闲置物品'}属于${categoryName || '校园闲置'}，整体${conditionLevel || '成色良好'}，功能和使用情况正常。建议在${meetLocation || '校内'}面交，具体时间可以预约后协商。有需要的同学欢迎联系。`
  }, 600)
}
