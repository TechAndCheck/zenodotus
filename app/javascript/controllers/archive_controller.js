import { Controller } from '@hotwired/stimulus'
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'

dayjs.extend(utc)

export default class extends Controller {
    static targets = [ "timestamp" ]

    timestampTargetConnected(element) {
        const utcTime = element.getAttribute('datetime')
        const localTime = dayjs.utc(utcTime).local().format('D MMM YYYY [at] h:mm A')
        element.innerText = localTime
    }
}
