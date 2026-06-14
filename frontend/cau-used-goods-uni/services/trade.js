import { BASE_URL } from '../utils/request'
import * as api from '../api/trade'
import { REPORT_REASON, TARGET_TYPE } from '../utils/constants'
import { displayRelatedUserName } from '../utils/user-format'

function absoluteImage(url) {
  if (!url || /^https?:\/\//.test(url)) return url
  return `${BASE_URL}${url}`
}

function pad(value) {
  return String(value).padStart(2, '0')
}

function formatDateTime(value) {
  if (!value) return ''
  if (typeof value === 'string' && /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}/.test(value)) {
    return value.slice(0, 16)
  }
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return value
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}`
}

function normalizeProduct(item = {}) {
  return {
    ...item,
    image: absoluteImage(item.image || item.productImage || item.images?.[0]),
    meetLocation: item.meetLocation || '预约后协商'
  }
}

function normalizeOrder(item = {}) {
  const seller = item.seller || {}
  const buyer = item.buyer || {}
  const sellerId = item.sellerId || item.seller_id || seller.id || seller.userId || item.sellerUserId || item.seller_user_id
  const buyerId = item.buyerId || item.buyer_id || buyer.id || buyer.userId || item.buyerUserId || item.buyer_user_id
  return {
    ...item,
    id: String(item.id),
    sellerId,
    buyerId,
    sellerName: displayRelatedUserName({
      ...item,
      sellerNickname: item.sellerNickname || item.seller_nickname || seller.nickname || seller.realName || seller.name,
      sellerAccountStatus: item.sellerAccountStatus || item.seller_account_status || seller.accountStatus || seller.account_status || seller.status
    }, 'seller', '卖家'),
    buyerName: displayRelatedUserName({
      ...item,
      buyerNickname: item.buyerNickname || item.buyer_nickname || buyer.nickname || buyer.realName || buyer.name,
      buyerAccountStatus: item.buyerAccountStatus || item.buyer_account_status || buyer.accountStatus || buyer.account_status || buyer.status
    }, 'buyer', '买家'),
    sellerAvatarUrl: absoluteImage(item.sellerAvatarUrl || item.seller_avatar_url || seller.avatarUrl || seller.avatar_url),
    buyerAvatarUrl: absoluteImage(item.buyerAvatarUrl || item.buyer_avatar_url || buyer.avatarUrl || buyer.avatar_url),
    createdAt: formatDateTime(item.createdAt || item.createTime),
    meetTime: formatDateTime(item.meetTime),
    expireTime: formatDateTime(item.expireTime),
    confirmTime: formatDateTime(item.confirmTime),
    finishTime: formatDateTime(item.finishTime),
    closeTime: formatDateTime(item.closeTime),
    product: normalizeProduct(item.product || {
      id: item.productId,
      title: item.productTitleSnapshot,
      price: item.productPriceSnapshot,
      image: item.productImage,
      meetLocation: item.meetLocation
    })
  }
}

function normalizeMessage(item = {}) {
  return {
    ...item,
    id: String(item.id),
    type: item.type || item.messageType,
    targetType: item.targetType || item.relatedType,
    targetId: item.targetId || item.relatedId,
    createdAt: formatDateTime(item.createdAt || item.createTime),
    read: item.read ?? item.readStatus === 'READ'
  }
}

export const tradeService = {
  getProduct: async (id) => normalizeProduct(await api.getProduct(id)),
  createAppointment: async (data) => normalizeOrder(await api.createAppointment(data)),
  getOrders: async (role) => (await api.getOrders(role)).items.map(normalizeOrder),
  getOrder: async (id) => normalizeOrder(await api.getOrder(id)),
  changeOrderStatus: async (id, action, data) => normalizeOrder(await api.changeOrderStatus(id, action, data)),
  getFavorites: async () => (await api.getFavorites()).items.map((item) => normalizeProduct({
    id: item.productId,
    title: item.productTitle,
    price: item.productPrice,
    status: item.productStatus,
    image: item.productImage,
    sellerName: item.sellerNickname
  })),
  addFavorite: api.addFavorite,
  removeFavorite: api.removeFavorite,
  getMessages: async () => (await api.getMessages()).items.map(normalizeMessage),
  getMessage: async (id) => normalizeMessage(await api.getMessage(id)),
  markMessageRead: api.markMessageRead,
  createReview: api.createReview,
  createReport: api.createReport,
  getReports: async () => (await api.getReports()).items.map((item) => ({
    ...item,
    id: String(item.id),
    reason: item.reasonType,
    reasonLabel: REPORT_REASON[item.reasonType] || item.reasonType,
    detail: item.description,
    result: item.handleResult,
    targetTypeLabel: TARGET_TYPE[item.targetType] || item.targetType,
    createdAt: formatDateTime(item.createTime || item.createdAt)
  }))
}
