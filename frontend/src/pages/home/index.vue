<template>
  <view class="home-page">
    <view class="hero">
      <view class="hero-top">
        <view>
          <text class="eyebrow">CAU CAMPUS MARKET</text>
          <text class="headline">让闲置，在校园里重新发光</text>
        </view>
        <view class="campus-tag">校内面交</view>
      </view>
      <view class="search-box" @click="openSearch">
        <text class="search-icon">⌕</text>
        <text class="placeholder">搜索教材、数码、生活用品</text>
      </view>
    </view>

    <view class="section">
      <view class="section-header">
        <text class="section-title">逛分类</text>
        <text class="muted">快速找到需要的好物</text>
      </view>
      <scroll-view scroll-x class="category-scroll" :show-scrollbar="false">
        <view class="category-row">
          <view
            v-for="category in categories.filter((item) => item.id !== 0)"
            :key="category.id"
            class="category-item"
            @click="openCategory(category.id)"
          >
            <view class="category-icon">{{ category.icon }}</view>
            <text>{{ category.name }}</text>
          </view>
        </view>
      </scroll-view>
    </view>

    <view class="section products-section">
      <view class="section-header">
        <text class="section-title">新鲜发布</text>
        <text class="more" @click="openSearch">筛选排序 ›</text>
      </view>
      <view class="product-grid">
        <ProductCard v-for="product in products" :key="product.id" :product="product" />
      </view>
      <view class="load-state muted">
        <text v-if="loading">正在加载...</text>
        <text v-else-if="finished">已经到底啦</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { computed } from 'vue'
import { onPullDownRefresh, onReachBottom, onShow } from '@dcloudio/uni-app'
import ProductCard from '../../components/ProductCard.vue'
import { useProductStore } from '../../stores/product.js'

const store = useProductStore()
const categories = computed(() => store.categories)
const products = computed(() => store.products)
const loading = computed(() => store.loading)
const finished = computed(() => store.finished)

async function refresh() {
  await store.loadCategories()
  await store.loadProducts({}, true)
}

function openSearch() {
  uni.navigateTo({ url: '/pages/search/index' })
}

function openCategory(categoryId) {
  uni.navigateTo({ url: `/pages/search/index?categoryId=${categoryId}` })
}

onShow(() => {
  if (!store.products.length) refresh()
})
onReachBottom(() => store.loadProducts())
onPullDownRefresh(async () => {
  await refresh()
  uni.stopPullDownRefresh()
})
</script>

<style lang="scss" scoped>
.home-page {
  min-height: 100vh;
  padding-bottom: 40rpx;
}

.hero {
  padding: 98rpx 30rpx 34rpx;
  border-radius: 0 0 46rpx 46rpx;
  background: linear-gradient(145deg, #1f6a49, #328660);
  color: #ffffff;
}

.hero-top,
.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.eyebrow,
.headline {
  display: block;
}

.eyebrow {
  color: rgba(255, 255, 255, 0.7);
  font-size: 20rpx;
  letter-spacing: 3rpx;
}

.headline {
  margin-top: 14rpx;
  font-size: 36rpx;
  font-weight: 700;
}

.campus-tag {
  padding: 10rpx 16rpx;
  border: 2rpx solid rgba(255, 255, 255, 0.4);
  border-radius: 999rpx;
  font-size: 22rpx;
}

.search-box {
  display: flex;
  align-items: center;
  height: 86rpx;
  margin-top: 34rpx;
  padding: 0 24rpx;
  border-radius: 24rpx;
  background: #ffffff;
}

.search-icon {
  color: #23734f;
  font-size: 48rpx;
  line-height: 1;
}

.placeholder {
  margin-left: 14rpx;
  color: #9ca7a3;
  font-size: 27rpx;
}

.section {
  margin-top: 34rpx;
  padding: 0 28rpx;
}

.section-header {
  margin-bottom: 22rpx;
}

.section-header .muted {
  font-size: 23rpx;
}

.category-scroll {
  width: 100%;
  white-space: nowrap;
}

.category-row {
  display: inline-flex;
  gap: 18rpx;
  padding: 4rpx 4rpx 12rpx;
}

.category-item {
  width: 126rpx;
  color: #55605c;
  font-size: 23rpx;
  text-align: center;
}

.category-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100rpx;
  height: 100rpx;
  margin: 0 auto 12rpx;
  border-radius: 32rpx;
  background: #eaf5ee;
  color: #23734f;
  font-size: 25rpx;
  font-weight: 700;
}

.more {
  color: #23734f;
  font-size: 25rpx;
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 20rpx;
}

.load-state {
  padding: 28rpx 0 12rpx;
  font-size: 24rpx;
  text-align: center;
}
</style>
