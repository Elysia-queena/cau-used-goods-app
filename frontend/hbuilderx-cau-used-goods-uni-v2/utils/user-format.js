const statusOf = (value) => String(value || '').toUpperCase()

export const isBannedUserStatus = (status) => {
  const value = statusOf(status)
  return value === 'BANNED' || value === 'PERM_BANNED' || value === 'PERMANENT_BANNED'
}

export const isDisabledUserStatus = (status) => {
  const value = statusOf(status)
  return value === 'DISABLED'
}

export const isCanceledUserStatus = (status) => {
  const value = statusOf(status)
  return value === 'CANCELED' || value === 'CANCELLED'
}

export const accountStatusOf = (user = {}) => user.accountStatus || user.account_status || user.status || user.userStatus || user.user_status || ''

export const userTradeRestrictionMessage = (status, action = 'publish') => {
  const value = statusOf(status)
  const actionText = action === 'sale' ? '\u4e0a\u67b6' : '\u53d1\u5e03'
  if (isBannedUserStatus(value)) return `\u8d26\u53f7\u5df2\u5c01\u7981\uff0c\u65e0\u6cd5${actionText}\u5546\u54c1`
  if (isDisabledUserStatus(value)) return `\u8d26\u53f7\u5df2\u7981\u7528\uff0c\u65e0\u6cd5${actionText}\u5546\u54c1`
  if (isCanceledUserStatus(value)) return `\u8d26\u53f7\u5df2\u6ce8\u9500\uff0c\u65e0\u6cd5${actionText}\u5546\u54c1`
  return ''
}

export const displayUserName = (user = {}, fallback = '\u5fae\u4fe1\u7528\u6237') => {
  const status = accountStatusOf(user)
  if (isBannedUserStatus(status)) return '\u8fdd\u89c4\u8d26\u53f7'
  if (isCanceledUserStatus(status)) return '\u5df2\u6ce8\u9500\u7528\u6237'
  return user.nickname || user.realName || user.name || fallback
}

export const displayRelatedUserName = (record = {}, role = 'user', fallback = '\u5fae\u4fe1\u7528\u6237') => {
  const prefix = role ? `${role}` : ''
  const nickname = record[`${prefix}Nickname`] || record[`${prefix}_nickname`] || record[`${prefix}Name`] || record[`${prefix}_name`]
  const status = record[`${prefix}AccountStatus`] || record[`${prefix}_account_status`] || record[`${prefix}Status`] || record[`${prefix}_status`]
  return displayUserName({ nickname, status }, fallback)
}
