import { USE_MOCK } from '../config/index.js'
import { request, uploadFile } from '../utils/request.js'
import * as mock from '../mock/product.js'

export function fetchCategories() {
  return USE_MOCK ? mock.listCategories() : request({ url: '/categories' })
}

export function fetchProducts(params) {
  return USE_MOCK ? mock.listProducts(params) : request({ url: '/products', data: params })
}

export function fetchProductDetail(id) {
  return USE_MOCK ? mock.getProductDetail(id) : request({ url: `/products/${id}` })
}

export function publishProduct(data) {
  return USE_MOCK
    ? mock.createProduct(data)
    : request({ url: '/products', method: 'POST', data, showLoading: true })
}

export function uploadProductImage(filePath) {
  return USE_MOCK ? Promise.resolve({ imageUrl: filePath }) : uploadFile(filePath)
}

export function requestOptimizedTitles(data) {
  return USE_MOCK
    ? mock.optimizeTitle(data)
    : request({ url: '/ai/optimize-title', method: 'POST', data })
}

export function requestGeneratedDescription(data) {
  return USE_MOCK
    ? mock.generateDescription(data)
    : request({ url: '/ai/generate-description', method: 'POST', data })
}
