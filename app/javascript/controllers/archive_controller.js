import { Controller } from '@hotwired/stimulus'
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'

dayjs.extend(utc)

export default class extends Controller {
  static targets = [
    'timestamp',
    'captionContent',
    'captionToggler',
  ]

  static values = { captionCollapseMode: String }

  timestampTargetConnected(element) {
    const utcTime = element.getAttribute('datetime')
    const localTime = dayjs.utc(utcTime).local().format('D MMM YYYY [at] h:mm A')
    element.innerText = localTime
  }

  toggleCaption() {
    switch (this.captionCollapseModeValue) {
      case 'collapsed':
        this.captionCollapseModeValue = 'expanded'
        this.captionTogglerTarget.innerText = this.captionTogglerTarget.dataset.collapseLabel
        break
      case 'expanded':
        this.captionCollapseModeValue = 'collapsed'
        this.captionTogglerTarget.innerText = this.captionTogglerTarget.dataset.expandLabel
        break
      default:
        console.error('archive#toggleCaption called unexpectedly.')
    }
  }
}
