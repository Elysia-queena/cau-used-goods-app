<template>
  <view class="page search-page">
    <view class="search-line card">
      <input
        v-model="filters.keyword"
        class="search-input"
        confirm-type="search"
        placeholder="搜索商品标题或描述"
        @confirm="search"
      />
      <text class="search-button" @click="search">搜索</text>
    </view>

    <scroll-view scroll-x class="category-scroll" :show-scrollbar="false">
      <view class="category-row">
        <text
          v-for="category in categories"
          :key="category.id"
          class="category-pill"
          :class="{ active: filters.categoryId === category.id }"
          @click="selectCategory(category.id)"
        >
          {{ category.name }}
        </text>
      </view>
    </scroll-view>

    <view class="filter-card card">
      <view class="filter-row">
        <text class="filter-label">价格</text>
        <input v-model="filters.minPrice" type="digit" placeholder="最低价" />
        <text class="divider">-</text>
        <input v-model="filters.maxPrice" type="digit" placeholder="最高价" />
      </view>
      <view class="filter-row">
        <text class="filter-label">成色</text>
        <picker :range="conditionOptions" @change="changeCondition">
          <view class="picker-value">{{ filters.conditionLevel || '不限成色' }} ›</view>
        </picker>
      </view>
      <view class="filter-row">
        <text class="filter-label">排序</text>
        <picker :range="sortOptions.map((item) => item.label)" @change="changeSort">
          <view class="picker-value">{{ currentSortLabel }} ›</view>
        </picker>
      </view>
      <button class="apply-button" @click="search">应用筛选</button>
    </view>

    <view class="result-header">
      <text class="section-title">搜索结果</text>
      <text class="muted">共 {{ total }} 件商品</text>
    </view>

    <view v-if="products.length" class="product-grid">
      <ProductCard v-for="product in products" :key="product.id" :product="product" />
    </view>
    <view v-else-if="!loading" class="empty">
      <text class="empty-title">暂时没有找到合适的商品</text>
      <text class="muted">换个关键词或筛选条件试试看</text>
    </view>

    <view class="load-state muted">
      <text v-if="loading">正在加载...</text>
      <text v-else-if="finished && products.length">已经到底啦</text>
    </view>
  </view>
</template>

<script setup>
import { computed, reactive } from 'vue'
import { onLoad, onReachBottom } from '@dcloudio/uni-app'
import ProductCard from '../../components/ProductCard.vue'
import { useProductStore } from '../../stores/product.js'

const store = useProductStore()
const categories = computed(() => store.categories)
const products = computed(() => store.products)
const total = computed(() => store.total)
const loading = computed(() => store.loading)
const finished = computed(() => store.finished)

const conditionOptions = ['不限成色', '全新', '九成新', '八成新', '七成新']
const sortOptions = [
  { label: '最新发布', value: 'newest' },
  { label: '价格从低到高', value: 'price_asc' },
  { label: '价格从高到低', value: 'price_desc' },
  { label: '收藏最多', value: 'popular' }
]

const filters = reactive({
  keyword: '',
  categoryId: 0,
  minPrice: '',
  maxPrice: '',
  conditionLevel: '',
  sort: 'newest'
})

const currentSortLabel = computed(
  () => sortOptions.find((item) => item.value === filters.sort)?.label || '最新发布'
)

function search() {
  store.loadProducts(filters, true)
}

function selectCategory(categoryId) {
  filters.categoryId = categoryId
  search()
}

function changeCondition(event) {
  const value = conditionOptions[event.detail.value]
  filters.conditionLevel = value === '不限成色' ? '' : value
}

function changeSort(event) {
  filters.sort = sortOptions[event.detail.value].value
}

onLoad(async (options) => {
  filters.keyword = options.keyword || ''
  filters.categoryId = Number(options.categoryId || 0)
  await store.loadCategories()
  search()
})

onReachBottom(() => store.loadProducts(filters))
</script>

<style lang="scss" scoped>
.search-line {
  display: flex;
  align-items: center;
  height: 86rpx;
  padding: 0 24rpx;
}

.search-input {
  flex: 1;
  font-size: 28rpx;
}

.search-button,
.picker-value {
  color: #23734f;
}

.search-button {
  font-weight: 700;
}

.category-scroll {
  width: 100%;
  margin: 24rpx 0;
  white-space: nowrap;
}

.category-row {
  display: inline-flex;
  gap: 14rpx;
  padding-bottom: 4rpx;
}

.category-pill {
  padding: 14rpx 22rpx;
  border-radius: 999rpx;
  background: #ffffff;
  color: #65706c;
  font-size: 24rpx;
}

.category-pill.active {
  background: #23734f;
  color: #ffffff;
}

.filter-card {
  padding: 8rpx 22rpx 22rpx;
}

.filter-row {
  display: flex;
  align-items: center;
  min-height: 78rpx;
  border-bottom: 2rpx solid #f1f3f2;
}

.filter-label {
  width: 92rpx;
  color: #52605b;
}

.filter-row input {
  width: 160rpx;
  height: 58rpx;
  padding: 0 16rpx;
  border-radius: 14rpx;
  background: #f6f8f5;
  font-size: 25rpx;
  text-align: center;
}

.divider {
  margin: 0 16rpx;
  color: #a0aaa6;
}

.apply-button {
  height: 68rpx;
  margin-top: 20rpx;
  border-radius: 16rpx;
  background: #e9f5ed;
  color: #23734f;
  font-size: 27rpx;
  line-height: 68rpx;
}

.result-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin: 34rpx 0 20rpx;
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 20rpx;
}

.empty {
  padding: 110rpx 0;
  text-align: center;
}

.empty-title,
.empty .muted {
  display: block;
}

.empty-title {
  margin-bottom: 16rpx;
  color: #53605b;
  font-size: 29rpx;
}

.load-state {
  padding: 30rpx 0;
  text-align: center;
}
</style>
