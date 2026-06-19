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
  USER: '??'
}

export const MESSAGE_TYPE = {
  ORDER: '????',
  REPORT: '????',
  SYSTEM: '????'
}
