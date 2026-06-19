<template>
  <view class="page">
    <view class="page-title">标签管理</view>

    <view class="form-card">
      <view class="form-title">新增分类/标签</view>

      <view class="segmented">
        <view :class="['segment', form.level === 'PRIMARY' ? 'active' : '']" @click="setLevel('PRIMARY')">一级分类</view>
        <view :class="['segment', form.level === 'CHILD' ? 'active' : '']" @click="setLevel('CHILD')">二级分类</view>
      </view>

      <picker v-if="form.level === 'CHILD'" :range="primaryCategories" range-key="name" @change="changeParent">
        <view class="picker">{{ parentName || '请选择所属一级分类' }} ›</view>
      </picker>

      <input v-model.trim="form.name" class="input" placeholder="请输入分类/标签名称" maxlength="20" />
      <input v-model="form.sortOrder" class="input" placeholder="排序值，可不填" type="number" />
      <button class="submit-button" :loading="submitting" @click="submit">
        {{ form.level === 'CHILD' ? '添加二级分类' : '添加一级分类' }}
      </button>
    </view>

    <view class="section-title">已有分类</view>
    <view v-if="groupedCategories.length === 0" class="empty">暂无分类/标签</view>

    <view v-for="group in groupedCategories" :key="group.id" class="tag-card">
      <view class="tag-row">
        <view>
          <view class="tag-name">{{ group.name }}</view>
          <view class="tag-desc">一级分类 · 排序 {{ group.sortOrder || 0 }}</view>
        </view>
        <button
          class="tag-status"
          :class="group.status === 'ENABLED' ? 'enabled' : 'disabled'"
          :loading="updatingId === group.id"
          :disabled="updatingId === group.id"
          @click.stop="toggleStatus(group)"
        >
          {{ group.status === 'ENABLED' ? '停用' : '启用' }}
        </button>
      </view>

      <view v-if="group.children.length" class="children">
        <view v-for="child in group.children" :key="child.id" class="child-row">
          <view>
            <view class="child-name">{{ child.name }}</view>
            <view class="tag-desc">二级分类 · 排序 {{ child.sortOrder || 0 }}</view>
          </view>
          <button
            class="tag-status small"
            :class="child.status === 'ENABLED' ? 'enabled' : 'disabled'"
            :loading="updatingId === child.id"
            :disabled="updatingId === child.id"
            @click.stop="toggleStatus(child)"
          >
            {{ child.status === 'ENABLED' ? '停用' : '启用' }}
          </button>
        </view>
      </view>
      <view v-else class="no-child">暂无二级分类</view>
    </view>
  </view>
</template>

<script setup>
import { computed, ref } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { createAdminCategory, getAdminCategories, updateAdminCategoryStatus } from '../../api/admin'

const categories = ref([])
const submitting = ref(false)
const updatingId = ref(null)
const form = ref({
  level: 'PRIMARY',
  parentId: '',
  name: '',
  sortOrder: ''
})

const parentIdOf = (item) => Number(item?.parentId || item?.parent_id || 0)
const primaryCategories = computed(() => categories.value.filter((item) => parentIdOf(item) === 0))
const parentName = computed(() => primaryCategories.value.find((item) => Number(item.id) === Number(form.value.parentId))?.name || '')
const groupedCategories = computed(() => {
  return primaryCategories.value.map((item) => ({
    ...item,
    children: categories.value.filter((child) => parentIdOf(child) === Number(item.id))
  }))
})

const load = async () => {
  try {
    categories.value = await getAdminCategories()
  } catch (error) {
    uni.showToast({ title: error.message || '加载失败', icon: 'none' })
  }
}

onShow(load)

const setLevel = (level) => {
  form.value.level = level
  if (level === 'PRIMARY') form.value.parentId = ''
}

const changeParent = ({ detail }) => {
  const item = primaryCategories.value[detail.value]
  form.value.parentId = item?.id || ''
}

const submit = async () => {
  const name = form.value.name.trim()
  if (!name) {
    uni.showToast({ title: '请输入分类/标签名称', icon: 'none' })
    return
  }
  if (form.value.level === 'CHILD' && !form.value.parentId) {
    uni.showToast({ title: '请选择所属一级分类', icon: 'none' })
    return
  }
  if (submitting.value) return
  submitting.value = true
  try {
    await createAdminCategory({
      name,
      parentId: form.value.level === 'CHILD' ? Number(form.value.parentId) : 0,
      sortOrder: Number(form.value.sortOrder || 0),
      status: 'ENABLED'
    })
    uni.showToast({ title: '添加成功', icon: 'success' })
    form.value.name = ''
    form.value.sortOrder = ''
    await load()
  } catch (error) {
    uni.showToast({ title: error.message || '添加失败', icon: 'none' })
  } finally {
    submitting.value = false
  }
}

const toggleStatus = async (item) => {
  if (!item || updatingId.value) return
  const nextStatus = item.status === 'ENABLED' ? 'DISABLED' : 'ENABLED'
  updatingId.value = item.id
  try {
    await updateAdminCategoryStatus(item.id, nextStatus)
    uni.showToast({ title: nextStatus === 'ENABLED' ? '已启用' : '已停用', icon: 'success' })
    await load()
  } catch (error) {
    uni.showToast({ title: error.message || '操作失败', icon: 'none' })
  } finally {
    updatingId.value = null
  }
}
</script>

<style scoped>
.page { min-height: 100vh; padding: 28rpx 24rpx; background: #f5f6f8; box-sizing: border-box; }
.page-title { margin: 18rpx 0 24rpx; font-size: 38rpx; font-weight: 800; color: #1f2933; }
.form-card, .tag-card, .empty { padding: 28rpx; border-radius: 16rpx; background: #fff; box-sizing: border-box; }
.form-title, .section-title { font-size: 32rpx; font-weight: 800; color: #1f2933; }
.section-title { margin: 32rpx 0 18rpx; }
.segmented { display: flex; gap: 14rpx; margin-top: 22rpx; }
.segment { flex: 1; height: 68rpx; line-height: 68rpx; border-radius: 12rpx; background: #f1f5f9; color: #64748b; font-size: 26rpx; text-align: center; }
.segment.active { background: #dcfce7; color: #15803d; font-weight: 800; }
.input, .picker { height: 88rpx; margin-top: 22rpx; padding: 0 24rpx; border-radius: 12rpx; background: #f1f5f9; color: #1f2933; font-size: 28rpx; box-sizing: border-box; }
.picker { line-height: 88rpx; }
.submit-button { margin-top: 26rpx; height: 88rpx; line-height: 88rpx; border-radius: 12rpx; background: #17a84b; color: #fff; font-size: 30rpx; }
.tag-card { margin-bottom: 18rpx; }
.tag-row, .child-row { display: flex; align-items: center; justify-content: space-between; gap: 18rpx; }
.tag-name { font-size: 30rpx; font-weight: 800; color: #1f2933; }
.child-name { font-size: 27rpx; font-weight: 700; color: #344054; }
.tag-desc, .empty, .no-child { margin-top: 8rpx; font-size: 24rpx; color: #8a96a8; }
.children { margin-top: 18rpx; padding-top: 14rpx; border-top: 1rpx solid #eef2f7; }
.child-row { padding: 14rpx 0; }
.no-child { padding-top: 16rpx; }
.tag-status { min-width: 96rpx; margin: 0; padding: 8rpx 16rpx; border: 0; border-radius: 999rpx; font-size: 22rpx; line-height: 1.4; }
.tag-status.small { min-width: 86rpx; }
.tag-status::after { border: 0; }
.tag-status.enabled { background: #fee2e2; color: #ef4444; }
.tag-status.disabled { background: #dcfce7; color: #16a34a; }
</style>
