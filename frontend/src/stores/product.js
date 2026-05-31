import { defineStore } from 'pinia'
import { fetchCategories, fetchProducts } from '../api/product.js'
import { PRODUCT_PAGE_SIZE } from '../config/index.js'

export const useProductStore = defineStore('product', {
  state: () => ({
    categories: [],
    products: [],
    total: 0,
    page: 1,
    pageSize: PRODUCT_PAGE_SIZE,
    loading: false,
    finished: false
  }),
  actions: {
    async loadCategories() {
      if (!this.categories.length) {
        this.categories = await fetchCategories()
      }
    },
    async loadProducts(params = {}, reset = false) {
      if (this.loading || (!reset && this.finished)) return
      this.loading = true
      try {
        const nextPage = reset ? 1 : this.page
        const result = await fetchProducts({ ...params, page: nextPage, pageSize: this.pageSize })
        this.products = reset ? result.list : [...this.products, ...result.list]
        this.total = result.total
        this.page = nextPage + 1
        this.finished = this.products.length >= this.total
      } finally {
        this.loading = false
      }
    },
    resetProducts() {
      this.products = []
      this.total = 0
      this.page = 1
      this.finished = false
    }
  }
})
