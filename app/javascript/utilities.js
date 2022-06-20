import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'

dayjs.extend(utc)

export function humanizeUtcToLocalTime(utcTime) {
  const localTime = dayjs.utc(utcTime).local()
  return localTime.format('D MMM YYYY [at] h:mm A')
}

export function humanizeTimeElement(element) {
  const utcTime = element.getAttribute('datetime')
  element.innerText = humanizeUtcToLocalTime(utcTime)
}
