import { Controller } from '@hotwired/stimulus'
import { humanizeTimeElement } from 'utilities'

export default class extends Controller {
  static targets = [
    'timestamp',
    'captionContent',
    'captionToggler',
    'organizationFilter',
  ]

  static values = { captionCollapseMode: String }

  timestampTargetConnected(element) {
    humanizeTimeElement(element)
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
        // This doesn't break anything for users, but we developers would want to know.
        // eslint-disable-next-line no-console
        console.error('media-vault--archive#toggleCaption called unexpectedly.')
    }
  }

  filterResultsByOrganization() {
    let orgValue = this.organizationFilterTarget.value
    console.log('filterResultsByOrganization called for ' + orgValue)

    window.location = '/dashboard?organization_id=' + orgValue
  }
}
