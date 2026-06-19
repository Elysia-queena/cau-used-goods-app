export const ORDER_STATUS = {
  PENDING_CONFIRM: { label: '?????', tone: 'warning' },
  WAIT_MEET: { label: '?????', tone: 'primary' },
  COMPLETED: { label: '???', tone: 'success' },
  CANCELED: { label: '???', tone: 'muted' },
  CANCELLED: { label: '???', tone: 'muted' },
  EXCEPTION_CLOSED: { label: '????', tone: 'danger' }
}

export const REPORT_STATUS = {
  PENDING: { label: '???', tone: 'warning' },
  PROCESSING: { label: '???', tone: 'primary' },
  RESOLVED: { label: '???', tone: 'success' },
  REJECTED: { label: '???', tone: 'muted' },
  CLOSED: { label: '???', tone: 'muted' }
}

export const APPEAL_STATUS = {
  PENDING: { label: '\u5f85\u5904\u7406', tone: 'warning' },
  PROCESSING: { label: '\u5904\u7406\u4e2d', tone: 'primary' },
  APPROVED: { label: '\u5df2\u901a\u8fc7', tone: 'success' },
  REJECTED: { label: '\u5df2\u9a73\u56de', tone: 'muted' },
  CLOSED: { label: '\u5df2\u64a4\u56de', tone: 'muted' }
}

export const REPORT_REASON = {
  FAKE_PRODUCT: '??????',
  INAPPROPRIATE_CONTENT: '????',
  SCAM: '????',
  TRADE_DISPUTE: '????',
  OTHER: '????'
}

export const TARGET_TYPE = {
  PRODUCT: '??',
  ORDER: '????',
  USER: '??',
  REPORT: '\u4e3e\u62a5'
}

export const MESSAGE_TYPE = {
  ORDER: '????',
  REPORT: '????',
  SYSTEM: '????'
}
